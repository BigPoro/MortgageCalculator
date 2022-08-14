//
//  LHHousePurchasCalcController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import UIKit
import SVProgressHUD

class LHHousePurchasCalcController: LHTableViewController {
    private lazy var viewModel = LHHouseToolViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "购房能力评估计算"
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
        
        let calcButton = UIButton.init(type: .custom)
        calcButton.configGradientButtonUI()
        calcButton.setTitle("立即计算", for: .normal)
        footerView.addSubview(calcButton)
        calcButton.onTap { [unowned self]  in
            
            for cell in tableView.visibleCells {
                let textFieldCell = cell as! LHTextFieldCell
                if textFieldCell.index.row != 3 {
                    var checkResult = true
                    if let content = Double(textFieldCell.textField.text!) {
                        if content == 0 {
                            checkResult = false
                        } else {
                            switch textFieldCell.index.row {
                            case 0:
                                viewModel.housePurchasCalcModel.houseMoney = content
                            case 1:
                                viewModel.housePurchasCalcModel.monthIncome = content
                            case 2:
                                viewModel.housePurchasCalcModel.monthHouseExpenditure = content
                            case 4:
                                viewModel.housePurchasCalcModel.area = content
                            default:
                                break
                            }
                        }
                        viewModel.propertyTaxCalcModel.unitPrice = content
                    } else {
                        checkResult = false
                    }
                    if checkResult == false {
                        switch textFieldCell.index.row {
                        case 0:
                            SVProgressHUD.showError(withStatus: "请输入购房资金")
                        case 1:
                            SVProgressHUD.showError(withStatus: "请输入现家庭月收入")
                        case 2:
                            SVProgressHUD.showError(withStatus: "请输入家庭每月用于购房支出")
                        case 4:
                            SVProgressHUD.showError(withStatus: "请输入计划购买房屋的面积")
                        default:
                            break
                        }
                        return
                    }
                }
            }
            let result = viewModel.housePurchasCalcModel.calculateHousePurchasAssessment()
            let vc = LHHousePurchasCalcResultController()
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

extension LHHousePurchasCalcController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHTextFieldCell"
        var cell:LHTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTextFieldCell
        if cell == nil {
            cell = LHTextFieldCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.textField.isHidden = false
        cell.textField.placeholder = "请输入"
        cell.unitLabel.isHidden = false
        cell.index = indexPath
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "可用于购房的资金"
            cell.unitLabel.text = "万元"
        case 1:
            cell.titleLabel.text = "现家庭收入"
            cell.unitLabel.text = "元"
        case 2:
            cell.titleLabel.text = "家庭每月用于购房支出"
            cell.unitLabel.text = "元/月"
        case 3:
            cell.titleLabel.text = "期望偿还贷款的期限"
            cell.unitLabel.isHidden = true
            cell.textField.isHidden = true
            cell.arrowButton.isHidden = false
            cell.arrowButton.setTitleColor(kGray_35, for: .normal)
            cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: "15年(180期)", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)

        case 4:
            cell.titleLabel.text = "计划购买房屋的面积"
            cell.unitLabel.text = "平方米"

        default:
            break
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LHTextFieldCell
        switch indexPath.row {
        case 3:
            
            viewModel.showPaymentYearsPicker { title in
                cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: title, titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
            }

        default:
            break
        }
    }
}
