//
//  LHPropertyTaxCalcResultController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import UIKit
import SVProgressHUD

class LHPropertyTaxCalcResultController: LHTableViewController {
    var resultModel:LHPropertyTaxCalcResultModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "结算结果"
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
        bgView.image = .init(named: "img_property_tax_bg")
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
    }
}

extension LHPropertyTaxCalcResultController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHTextFieldCell"
        var cell:LHTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTextFieldCell
        if cell == nil {
            cell = LHTextFieldCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.textField.isHidden = false
        cell.unitLabel.isHidden = false
        cell.unitLabel.text = "元"
        cell.textField.isUserInteractionEnabled = false
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "房款总价"
            cell.textField.text = String(format: "%@", NSNumber(value: resultModel.houseTotalPrice.rounded(2)))

        case 1:
            cell.titleLabel.text = "印花税"
            cell.textField.text = String(format: "%@", NSNumber(value: resultModel.stampDutyPrice.rounded(2)))

        case 2:
            cell.titleLabel.text = "公证费"
            cell.textField.text = String(format: "%@", NSNumber(value: resultModel.notaryFee.rounded(2)))

        case 3:
            cell.titleLabel.text = "契税"
            cell.textField.text = String(format: "%@", NSNumber(value: resultModel.deedTaxFee.rounded(2)))

        case 4:
            cell.titleLabel.text = "委托办理产权手续费"
            cell.textField.text = String(format: "%@", NSNumber(value: resultModel.commissionFee.rounded(2)))

        case 5:
            cell.titleLabel.text = "房屋买卖手续费"
            cell.textField.text = String(format: "%@", NSNumber(value: resultModel.transactionFee.rounded(2)))

        default:
            break
        }
        return cell
    }
    
}

