//
//  LHHousePurchasCalcResultController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/13.
//

import UIKit
import SVProgressHUD

class LHHousePurchasCalcResultController: LHTableViewController {
    var resultModel:LHHousePurchasCalcResultModel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "计算结果"
        view.backgroundColor = .white
        
        let shareButton = UIButton.init(type: UIButton.ButtonType.custom)
        shareButton.setImage(.init(named: "icon_share_white"), for: .normal)
        shareButton.setImage(.init(named: "icon_share_white"), for: .highlighted)
        shareButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        shareButton.contentHorizontalAlignment = .right
        shareButton.onTap { [unowned self]  in
            let image = view.snapshot()
            self.nativeShareWithImage(image: image!) { result in
                if result == true {
                    SVProgressHUD.showSuccess(withStatus: "分享成功")
                }
            }
        }
        navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: shareButton)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 180.zoom())
        headerView.backgroundColor = .white
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_house_purchas_assessment_bg")
        headerView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(20.zoom())
            make.centerX.equalToSuperview()
        }
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 90.zoom())
        
        
        let saveButton = UIButton.init(type: .custom)
        saveButton.configGradientButtonUI()
        saveButton.setTitle("保存照片", for: .normal)
        footerView.addSubview(saveButton)
        saveButton.onTap { [unowned self]  in
            let screenshot = view.snapshot()
            LHSaveImageHelper.saveImageToPhotoLibrary(image: screenshot)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(44.zoom())
            make.width.equalTo(300.zoom())
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(kNavigationBarHeight)
            make.leading.bottom.trailing.equalToSuperview()
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10.zoom() + kBottomSafeHeight, right: 0)
    }
}

extension LHHousePurchasCalcResultController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 2
        }
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "LHCommonSectionView"
        var headerView:LHCommonSectionView! = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? LHCommonSectionView
        if (headerView == nil) {
            headerView = LHCommonSectionView(reuseIdentifier: identifier)
        }
        switch section {
        case 1:
            headerView.titleLabel.text = "购买相关税费"
        case 2:
            headerView.titleLabel.text = "银行贷款需支付费用"
        default:
            break
        }
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 60.zoom()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHTextFieldCell"
        var cell:LHTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTextFieldCell
        if cell == nil {
            cell = LHTextFieldCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.textField.isHidden = false
        cell.unitLabel.isHidden = false
        cell.textField.isUserInteractionEnabled = false
        
        if indexPath.row == 1 {
            cell.unitLabel.text = "元/平方米"
        } else {
            cell.unitLabel.text = "元"
        }
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "可购买的房屋总价"
                cell.textField.text = String(format: "%@", NSNumber(value: resultModel.houseTotalPrice.rounded(2)))

            case 1:
                cell.titleLabel.text = "可购买的房屋单价"
                cell.textField.text = String(format: "%@", NSNumber(value: resultModel.houseUnitPrice.rounded(2)))

            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "契税"
                cell.textField.text = String(format: "%@", NSNumber(value: resultModel.deedTaxPrice.rounded(2)))

            case 1:
                cell.titleLabel.text = "公共维修基金"
                cell.textField.text = String(format: "%@", NSNumber(value: resultModel.publicMaintenanceFund.rounded(2)))

            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "首付款"
                cell.textField.text = String(format: "%@", NSNumber(value: resultModel.firstPayment.rounded(2)))

            case 1:
                cell.titleLabel.text = "保险费"
                cell.textField.text = String(format: "%@", NSNumber(value: resultModel.insurance.rounded(2)))

            case 2:
                cell.titleLabel.text = "律师费"
                cell.textField.text = String(format: "%@", NSNumber(value: resultModel.lawyerFee.rounded(2)))

            case 3:
                cell.titleLabel.text = "保抵押登记费"
                cell.textField.text = resultModel.registrationFee
                
            default:
                break
            }
        default:
            break
        }
        
        return cell
    }
    
}
