//
//  LHAddLookHouseRecordController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/17.
//

import UIKit
import ZLPhotoBrowser
import SVProgressHUD
import Photos

class LHAddLookHouseRecordController: LHTableViewController {
    lazy var viewModel = LHLookHouseViewModel()

    private let titles = ["小区名称","看房公司","带看人员","带看时间","房间面积","单位价格","看房意向","拍照记录"]
    var agencyButtons = [UIButton]()
    var intentionButtons = [UIButton]()
    var imageButtons = [UIButton]()
    var deleteButtons = [UIButton]()
    var addRecordBlock : (() -> Void)?

    private let agencyButtonsView = UIView()
    private let imageButtonsView = UIView()
    private let intentionButtonsView = UIView()
    private var imageDic:Dictionary = [Int:UIImage]()
    private var assetDic:Dictionary = [Int:PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
            
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "增加看房记录"
        
        // 中介公司
        for i in 0..<LHHouseAgencyCompany.allValues.count {
            let agency = LHHouseAgencyCompany.allValues[i]
            let button = UIButton.init(type: .custom)
            button.titleLabel?.font = FontRegularHeiti(fontSize: 11)
            button.layer.borderColor = kGray_184.cgColor
            button.layer.borderWidth = 1
            button.setTitle(agency.rawValue, for: .normal)
            if viewModel.newRecord.agencyCompany == agency {
                button.backgroundColor = kPurple_135
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(kGray_184, for: .normal)
            }
            agencyButtonsView.addSubview(button)
            button.tag = i
            button.addTarget(self, action: #selector(agencyButtonsClicked), for: .touchUpInside)
            agencyButtons.append(button)
        }
        agencyButtons.snp.distributeSudokuViews(fixedItemWidth: 70.zoom(), fixedItemHeight: 22.zoom(), warpCount: 3)
        
        
        // 意向
        for i in 0..<3 {
            let button = UIButton.init(type: .custom)
            button.setImage(.init(named: "icon_intention_normal_\(i)"), for: .normal)
            button.setImage(.init(named: "icon_intention_selected_\(i)"), for: .selected)
            button.addTarget(self, action: #selector(intentionButtonsClicked), for: .touchUpInside)
            button.tag = i
            intentionButtonsView.addSubview(button)
            intentionButtons.append(button)
        }
        intentionButtons.first?.isSelected = true // 默认选中第一个
        intentionButtons.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 44.zoom(), leadSpacing: 0, tailSpacing: 0)
        intentionButtons.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        // 图片
        for i in 0..<3 {
            let button = UIButton.init(type: .custom)
            button.setImage(.init(named: "icon_add_image"), for: .normal)
            imageButtonsView.addSubview(button)
            button.tag = i
            button.addTarget(self, action: #selector(imagesButtonsClicked), for: .touchUpInside)
            imageButtons.append(button)
        }
        imageButtons.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 100.zoom(), leadSpacing: 0, tailSpacing: 0)
        imageButtons.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 100.zoom(), height: 78.zoom()))
        }
        
        for i in 0..<3 {
            let button = UIButton.init(type: .custom)
            button.setImage(.init(named: "icon_delete_red"), for: .normal)
            imageButtons[i].addSubview(button)
            button.snp.makeConstraints { make in
                make.trailing.equalTo(-5.zoom())
                make.top.equalTo(5.zoom())
            }
            button.tag = i
            button.isHidden = true
            button.addTarget(self, action: #selector(deleteButtonsClicked), for: .touchUpInside)
            deleteButtons.append(button)
        }
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 90.zoom())
        
        let saveButton = UIButton.init(type: .custom)
        saveButton.configGradientButtonUI()
        saveButton.setTitle("保存", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonsClicked), for: .touchUpInside)

        footerView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(44.zoom())
            make.width.equalTo(300.zoom())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20.zoom())
        }
        tableView.tableFooterView = footerView
        
        tableView.frame = CGRect(x: 0, y: kNavigationBarHeight, width: view.width, height: view.height - kNavigationBarHeight)
    }
    
// MARK: 按钮事件
    @objc private func agencyButtonsClicked(sender:UIButton) {
        agencyButtons.forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(kGray_184, for: .normal)
        }
        
        sender.backgroundColor = kPurple_135
        sender.setTitleColor(.white, for: .normal)
        viewModel.newRecord.agencyCompany = LHHouseAgencyCompany.allValues[sender.tag]
    }
    @objc private func intentionButtonsClicked(sender:UIButton) {
        intentionButtons.forEach { button in
            button.isSelected = false
        }
        sender.isSelected = true
        viewModel.newRecord.intention = LHHouseIntention.allValues[sender.tag]
    }
    @objc private func imagesButtonsClicked(sender:UIButton) {
        let ps = ZLPhotoPreviewSheet()
        if self.assetDic[sender.tag] != nil { // 已经有图片 点击预览
            ps.previewAssets(sender: self, assets: [self.assetDic[sender.tag]!], index: 0, isOriginal: true, showBottomViewAndSelectBtn: false)
            return
        }
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.allowSelectVideo = false
        config.allowRecordVideo = false
        ps.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            sender.setImage(images.first, for: .normal)
            self?.imageDic[sender.tag] = images.first
            self?.assetDic[sender.tag] = assets.first
            self?.deleteButtons[sender.tag].isHidden = false
        }
        ps.showPhotoLibrary(sender: self)
    }
    @objc private func deleteButtonsClicked(sender:UIButton) {
        let imageButton = sender.superview as! UIButton
        imageButton.setImage(.init(named: "icon_add_image"), for: .normal)
        imageDic[imageButton.tag] = nil
        assetDic[imageButton.tag] = nil
        sender.isHidden = true
    }
    
    @objc private func saveButtonsClicked(sender:UIButton) {
        let communityCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! LHTextFieldCell
        if communityCell.textField.text?.isBlank == false  {
            viewModel.newRecord.communityName = communityCell.textField.text!
        } else {
            SVProgressHUD.showError(withStatus: "请输入小区名称")
            return
        }
        
        let agencyCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! LHTextFieldCell
        if agencyCell.textField.text?.isBlank == false  {
            viewModel.newRecord.agency = agencyCell.textField.text!
        } else {
            SVProgressHUD.showError(withStatus: "请输入带看人")
            return
        }
        
        let areaCell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0))! as! LHTextFieldCell
        if let area = Double(areaCell.textField.text!) {
            if area <= 0 {
                SVProgressHUD.showError(withStatus: "请输入房屋面积")
                return
            }
            viewModel.newRecord.area = area
        } else {
            SVProgressHUD.showError(withStatus: "请输入房屋面积")
            return
        }
        
        let unitPriceCell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0))! as! LHTextFieldCell
        if let unitPrice = Double(unitPriceCell.textField.text!) {
            if unitPrice <= 0 {
                SVProgressHUD.showError(withStatus: "请输入房屋单价")
                return
            }
            viewModel.newRecord.unitPrice = unitPrice
        } else {
            SVProgressHUD.showError(withStatus: "请输入房屋单价")
            return
        }
        if imageDic.isEmpty {
            SVProgressHUD.showError(withStatus: "至少上传一张照片")
            return
        }
        for (_,image) in imageDic {
            viewModel.newRecord.photos.append(image.convertToData()!)
        }
        // 保存记录
        viewModel.saveCurrentNewRecord { [unowned self] result in
            if result == true {
                SVProgressHUD.showSuccess(withStatus: "保存成功")
                self.addRecordBlock?()
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                    navigationController?.popViewController(animated: true)
                })
            } else {
                SVProgressHUD.showSuccess(withStatus: "保存失败")
            }
        }
    }
}

extension LHAddLookHouseRecordController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 80.zoom()
        }
        if indexPath.row == 7 {
            return 140.zoom()
        }
        return 50.zoom()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHTextFieldCell\(indexPath.section)\(indexPath.row)"
        var cell:LHTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTextFieldCell
        if cell == nil {

            cell = LHTextFieldCell.init(style: .subtitle, reuseIdentifier: identifier)
            cell.textField.delegate = nil // 关闭代理设置
            cell.textField.keyboardType = .default
            cell.titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(26.zoom())
                make.top.equalTo(15.zoom())
            }
            if indexPath.row == 1 {
                if agencyButtonsView.superview == nil {
                    cell.contentView.addSubview(agencyButtonsView)
                    agencyButtonsView.snp.makeConstraints({ make in
                        make.trailing.equalTo(-26.zoom())
                        make.top.equalTo(15.zoom())
                        make.size.equalTo(CGSize(width: 250.zoom(), height: 50.zoom()))
                    })
                }
            }
            if indexPath.row == 6 {
                if intentionButtonsView.superview == nil {
                    cell.contentView.addSubview(intentionButtonsView)
                    intentionButtonsView.snp.makeConstraints({ make in
                        make.trailing.equalTo(-26.zoom())
                        make.centerY.equalToSuperview()
                        make.size.equalTo(CGSize(width: 160.zoom(), height: 30.zoom()))
                    })
                }
            }
            
            if indexPath.row == 7 {
                if imageButtonsView.superview == nil {
                    cell.contentView.addSubview(imageButtonsView)
                    imageButtonsView.snp.makeConstraints({ make in
                        make.trailing.equalTo(-26.zoom())
                        make.leading.equalTo(cell.titleLabel)
                        make.bottom.equalTo(-10.zoom())
                        make.height.equalTo(80.zoom())
                    })
                }
            }
        }
        cell.index = indexPath
        cell.titleLabel.text = titles[indexPath.row]
        cell.textField.placeholder = "请输入"
        switch indexPath.row {
        case 0,2:
            cell.textField.isHidden = false
        case 3:
            cell.arrowButton.isHidden = false
            cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: Date().toString(.custom("yyyy-MM-dd")), titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
        case 4:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "/平米"
            cell.textField.isHidden = false
        case 5:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "/元"
            cell.textField.isHidden = false
        default:
            break
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            viewModel.showLookHouseDatePicker { date in
                let cell = tableView.cellForRow(at: indexPath) as! LHTextFieldCell
                cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: date.toString(.custom("yyyy-MM-dd")), titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)

            }
        }
    }

}
