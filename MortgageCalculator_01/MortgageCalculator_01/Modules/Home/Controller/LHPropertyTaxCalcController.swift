//
//  LHPropertyTaxCalcController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import UIKit
import SVProgressHUD

class LHPropertyTaxCalcController: LHTableViewController {
    private lazy var viewModel = LHHouseToolViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "房产税计算器"
        view.backgroundColor = .white
        
        let shareButton = UIButton.init(type: UIButton.ButtonType.custom)
        shareButton.setImage(.init(named: "icon_share_white"), for: .normal)
        shareButton.setImage(.init(named: "icon_share_white"), for: .highlighted)
        shareButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        shareButton.contentHorizontalAlignment = .right
        shareButton.onTap { [unowned self] in
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
        
        let calcButton = UIButton.init(type: .custom)
        calcButton.configGradientButtonUI()
        calcButton.setTitle("立即计算", for: .normal)
        footerView.addSubview(calcButton)
        calcButton.onTap { [unowned self]  in
            // 立即计算
            let unitPriceCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))! as! LHTextFieldCell
            if let unitPrice = Double(unitPriceCell.textField.text!) {
                if unitPrice == 0 {
                    SVProgressHUD.showError(withStatus: "请输入房屋单价")
                    return
                }
                viewModel.propertyTaxCalcModel.unitPrice = unitPrice
            } else {
                SVProgressHUD.showError(withStatus: "请输入房屋单价")
                return
            }
            
            let areaCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))! as! LHTextFieldCell
            if let area = Double(areaCell.textField.text!) {
                if area == 0 {
                    SVProgressHUD.showError(withStatus: "请输入房屋面积")
                    return
                }
                viewModel.propertyTaxCalcModel.area = area
            } else {
                SVProgressHUD.showError(withStatus: "请输入房屋面积")
                return
            }
            let result = viewModel.propertyTaxCalcModel.calculatePropertyTax()
            let vc = LHPropertyTaxCalcResultController()
            vc.resultModel = result
            navigationController?.pushViewController(vc, animated: true)
        }
        
        calcButton.snp.makeConstraints { make in
            make.height.equalTo(44.zoom())
            make.width.equalTo(300.zoom())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(kNavigationBarHeight)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
    }
}

extension LHPropertyTaxCalcController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHTextFieldCell"
        var cell:LHTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTextFieldCell
        if cell == nil {
            cell = LHTextFieldCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.textField.isHidden = false
        cell.unitLabel.isHidden = false
        if indexPath.row == 0 {
            cell.titleLabel.text = "单价"
            cell.unitLabel.text = "元/平米"
            cell.textField.placeholder = "请输入单价"
        }
        if indexPath.row == 1 {
            cell.titleLabel.text = "面积"
            cell.unitLabel.text = "平方米"
            cell.textField.placeholder = "请输入面积"
        }
        return cell
    }
    
}
