//
//  LHLookHouseRecordController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/17.
//

import UIKit
import AttributedString
import JXPhotoBrowser
class LHLookHouseRecordController: LHTableViewController {
    var recordModel: LHLookHouseRecordModel!
    
    private let titles = ["小区名称","看房公司","带看人员","带看时间","房间面积","单位价格","看房意向","拍照记录"]
    var agencyButtons = [UIButton]()
    var intentionButtons = [UIButton]()
    var imageButtons = [UIButton]()
    var deleteButtons = [UIButton]()
    
    private let agencyButtonsView = UIView()
    private let imageButtonsView = UIStackView()
    private let intentionButtonsView = UIView()
    private var imageDic:Dictionary = [Int:UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
            
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "看房记录"
        
        // 中介公司
        for i in 0..<LHHouseAgencyCompany.allValues.count {
            let agency = LHHouseAgencyCompany.allValues[i]
            let button = UIButton.init(type: .custom)
            button.titleLabel?.font = FontRegularHeiti(fontSize: 11)
            button.setTitleColor(kGray_184, for: .normal)
            button.layer.borderColor = kGray_184.cgColor
            button.layer.borderWidth = 1
            button.setTitle(agency.rawValue, for: .normal)
            if recordModel.agencyCompany == agency {
                button.backgroundColor = kPurple_135
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(kGray_184, for: .normal)
            }
            agencyButtonsView.addSubview(button)
            agencyButtons.append(button)
        }
        agencyButtons.snp.distributeSudokuViews(fixedItemWidth: 70.zoom(), fixedItemHeight: 22.zoom(), warpCount: 3)
        
        
        // 意向
        for i in 0..<3 {
            let button = UIButton.init(type: .custom)
            button.setImage(.init(named: "icon_intention_normal_\(i)"), for: .normal)
            button.setImage(.init(named: "icon_intention_selected_\(i)"), for: .selected)
            if i == LHHouseIntention.allValues.firstIndex(of: recordModel.intention) {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
            intentionButtonsView.addSubview(button)
            intentionButtons.append(button)
        }
        intentionButtons.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 44.zoom(), leadSpacing: 0, tailSpacing: 0)
        intentionButtons.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        // 图片
        for i in 0..<recordModel.photos.count {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage(data: recordModel.photos[i]), for: .normal)
            imageButtonsView.addArrangedSubview(button)
            button.tag = i
            button.addTarget(self, action: #selector(imagesButtonsClicked), for: .touchUpInside)
            imageButtons.append(button)
        }
        imageButtons.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100.zoom(), height: 78.zoom()))
        }
        imageButtonsView.spacing = 10.zoom()
        imageButtonsView.axis = .horizontal
        imageButtonsView.distribution = .equalSpacing
        imageButtonsView.alignment = .trailing
        
        tableView.frame = CGRect(x: 0, y: kNavigationBarHeight, width: view.width, height: view.height - kNavigationBarHeight)
    }
    
// MARK: 按钮事件

    @objc private func imagesButtonsClicked(sender:UIButton) {
        let browser = JXPhotoBrowser()
        browser.numberOfItems = {
            self.recordModel.photos.count
        }
        browser.pageIndex = sender.tag
        browser.reloadCellAtIndex = { context in
            let browserCell = context.cell as? JXPhotoBrowserImageCell
            let indexPath = IndexPath(item: context.index, section: 0)
            browserCell?.imageView.image = UIImage(data: self.recordModel.photos[indexPath.item])
        }
        browser.show()
    }
}

extension LHLookHouseRecordController {
    
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
                        make.bottom.equalTo(-10.zoom())
                        make.height.equalTo(80.zoom())
                    })
                }
            }
        }
        cell.index = indexPath
        cell.titleLabel.text = titles[indexPath.row]
        cell.textField.isUserInteractionEnabled = false
        switch indexPath.row {
        case 0:
            cell.textField.isHidden = false
            cell.textField.text = recordModel.communityName
        case 2:
            cell.textField.isHidden = false
            cell.textField.text = recordModel.agency
        case 3:
            cell.arrowButton.isHidden = false
            cell.arrowButton.set(image: nil, title: recordModel.date.toString(.custom("yyyy-MM-dd")), titlePosition: .left, additionalSpacing: 0, state: .normal)
        case 4:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "/平米"
            cell.textField.isHidden = false
            cell.textField.text = String(format: "%@", NSNumber(value: recordModel.area.rounded(2)))

        case 5:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "/元"
            cell.textField.isHidden = false
            cell.textField.text = String(format: "%@", NSNumber(value: recordModel.unitPrice.rounded(2)))

        default:
            break
        }
        
        return cell
    }
}
