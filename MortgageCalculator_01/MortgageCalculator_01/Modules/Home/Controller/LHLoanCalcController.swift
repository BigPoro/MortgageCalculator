//
//  LHMortgageCalcController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/5.
//

import UIKit
import SVProgressHUD

class LHLoanCalcController: LHTableViewController {
    /// 0商业贷款 1公积金贷款 2混合贷
    var index = 0
    private var buttons = Array<UIButton>()
    private lazy var viewModel = LHLoanCalcViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        navigation.bar.isHidden = true
        view.backgroundColor = kGray_244
        //MARK: TopView
        let bgView = UIImageView()
        bgView.image = .init(named: "img_mortgage_bg")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        let backButton = UIButton.init(type: UIButton.ButtonType.custom)
        backButton.setImage(.init(named: "icon_arrow_white_left"), for: .normal)
        backButton.addTarget(self, action: #selector(barBackButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(kStatusBarHeight)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontMediumHeiti(fontSize: 18)
        titleLabel.text = "房贷计算器"
        titleLabel.textColor = UIColor.white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        let shareButton = UIButton.init(type: UIButton.ButtonType.custom)
        shareButton.setImage(.init(named: "icon_share_white"), for: .normal)
        shareButton.setImage(.init(named: "icon_share_white"), for: .highlighted)
        shareButton.onTap { [unowned self] in
            let image = view.snapshot()
            self.nativeShareWithImage(image: image!) { result in
                if result == true {
                    SVProgressHUD.showSuccess(withStatus: "分享成功")
                }
            }
        }
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(kStatusBarHeight)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        //MARK: 顶部按钮
        let imageArr = ["icon_mortgage_01_normal","icon_mortgage_02_normal","icon_mortgage_03_normal"]
        let selectedImageArr = ["icon_mortgage_01_selected","icon_mortgage_02_selected","icon_mortgage_03_selected"]
        for index in 0..<3 {
            let button = UIButton.init(type: UIButton.ButtonType.custom)
            button.setImage(UIImage(named: imageArr[index]), for: .normal)
            button.setImage(UIImage(named: selectedImageArr[index]), for: .selected)
            button.addTarget(self, action: #selector(buttonsClicked), for: .touchUpInside)
            button.tag = index
            view.addSubview(button)
            buttons.append(button)
        }
        buttons.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 60.zoom(), leadSpacing: 60.zoom(), tailSpacing: 60.zoom())
        buttons.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60.zoom(), height: 60.zoom()))
            make.top.equalTo(titleLabel.snp.bottom).offset(20.zoom())
        }
        buttonsClicked(currentButton: buttons[index]) // 设置默认选中
        
        //MARK: 编辑区域
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(buttons.first!.snp.bottom).offset(30.zoom())
            make.leading.equalTo(16.zoom())
            make.trailing.equalTo(-16.zoom())
        }
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 70.zoom())
        
        let submitButton = UIButton.init(type: .custom)
        submitButton.setTitle("立即计算", for: .normal)
        submitButton.configGradientButtonUI()
        submitButton.addTarget(self, action: #selector(calcAction), for: .touchUpInside)
        footerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.leading.equalTo(20.zoom())
            make.trailing.equalTo(-20.zoom())
            make.bottom.equalTo(-20.zoom())
            make.height.equalTo(44.zoom())
        }
        tableView.tableFooterView = footerView
        
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(containerView)
        }
        view.bringSubviewToFront(tableView)
    }
    
    /// 切换贷款方式
    @objc private func buttonsClicked(currentButton:UIButton) {
        self.buttons.forEach { button in
            button.isSelected = false
            button.transform = CGAffineTransform.identity
        }
        index = currentButton.tag
        currentButton.isSelected = true
        currentButton.transform = currentButton.transform.scaledBy(x: 1.1, y: 1.1)
        viewModel.calcModel.calcType = 0 // 计算状态
        if index == 0 { // 商贷
            if viewModel.calcModel.calcType == 0 {
                self.dataSource = ["计算方式","房屋单价","房屋面积","按揭成数","按揭年数","利率方式","基点","商贷利率","还款方式"]
            } else {
                self.dataSource = ["计算方式","贷款总额","按揭成数","按揭年数","利率方式","基点","商贷利率","还款方式"]
            }
        }
        if index == 1 { // 公积金贷
            if viewModel.calcModel.calcType == 0 {
                self.dataSource = ["计算方式","房屋单价","房屋面积","按揭成数","按揭年数","利率方式","还款方式"]
            } else {
                self.dataSource = ["计算方式","贷款总额","按揭成数","按揭年数","利率方式","还款方式"]
            }
        }
        if index == 2 { // 混合贷
            self.dataSource = ["贷款类别","商业贷款额","利率方式","公积金贷款额","按揭年数","公积金利率","基点","商贷利率","还款方式"]
        }
        tableView.snp.updateConstraints { make in
            make.height.equalTo(50.zoom() * Double(dataSource.count) + 70.zoom())
        }
        tableView.reloadData()
        tableView.scrollsToTop = true
    }
    
}
extension LHLoanCalcController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell\(indexPath.row)"
        var cell:LHLoanCalculatorCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHLoanCalculatorCell
        if cell == nil {
            cell = LHLoanCalculatorCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.textField.tag = indexPath.row
        cell.lprButton.tag = indexPath.row;
        cell.baseButton.tag = indexPath.row;
         
        let title = self.dataSource[indexPath.row] as! String
        cell.titleLabel.text = title
        if title == "计算方式" || title == "贷款类别" {
            cell.arrowButton.isHidden = false
            if index == 2 {
                cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: "组合型贷款", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
            } else {
                if viewModel.calcModel.calcType == 0 {
                    cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: "根据面积、单价计算", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                } else {
                    cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: "根据贷款总额计算", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                }
            }
        }
        if title == "贷款总额" || title == "商业贷款额" || title == "公积金贷款额" {
            cell.textField.isHidden = false
            cell.textField.placeholder = "请输入"
            cell.textField.text = nil
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "万"
            viewModel.calcModel.businessTotalPrice = 0
            viewModel.calcModel.fundTotalPrice = 0
        }
        if title == "房屋单价" {
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "元/平米"
            cell.textField.isHidden = false
            cell.textField.text = nil
            cell.textField.placeholder = "请输入房屋单价"
        }
        if title == "房屋面积" {
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "平米"
            cell.textField.isHidden = false
            cell.textField.text = nil
            cell.textField.placeholder = "请输入房屋面积"
            viewModel.calcModel.area = 0
        }
        if title == "按揭成数" {
            cell.arrowButton.isHidden = false
            cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: "6.5成", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
            viewModel.calcModel.loanMulti = 6.5
        }
        if title == "按揭年数" {
            cell.arrowButton.isHidden = false
            cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: "30年(360期)", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
            viewModel.calcModel.loanYear = 30
        }
        if title == "利率方式" || title == "公积金利率" {
            cell.lprButton.isHidden = false
            cell.baseButton.isHidden = false
            cell.lprButton.isSelected = true
            cell.baseButton.isSelected = false
            viewModel.calcModel.fundRate = 3.25
            viewModel.calcModel.bankRate = 4.65
        }
        if title == "基点" {
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "BP(‱)"
            cell.textField.isHidden = false
            cell.textField.text = "0"
        }
        if title == "商贷利率" {
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "=4.65%"
            cell.textField.isHidden = false
            cell.textField.text = nil
            cell.textField.placeholder = "4.65+0"
            cell.textField.isUserInteractionEnabled = false
        }
        if title == "还款方式" {
            cell.modeOneButton.isHidden = false
            cell.modeTwoButton.isHidden = false
            if viewModel.calcModel.mode == 1 {
                cell.modeOneButton.isSelected = true
                cell.modeTwoButton.isSelected = false
            } else {
                cell.modeOneButton.isSelected = false
                cell.modeTwoButton.isSelected = true
            }
        }
        
        
        // 切换基础利率
        cell.baseButtonClickedBlock = { [unowned self] sender in
            self.switchRateUI(cell: cell)
        }
        // 切换LPR
        cell.lprButtonClickedBlock = { [unowned self] sender in
            if (sender.tag == 5 || sender.tag == 4) && index == 0 { // 商业贷
                self.viewModel.calcModel.bankRate = 4.65
                self.updateRateValueUI()
            }
            if (sender.tag == 5 || sender.tag == 4) && index == 1 { // 公积金贷
                self.viewModel.calcModel.fundRate = 3.25
            }
            if sender.tag == 2 && index == 2 { // 混合贷 商贷
                self.viewModel.calcModel.bankRate = 4.65
                self.updateRateValueUI()
            }
            if sender.tag == 5 && index == 2 { // 混合贷 房贷
                self.viewModel.calcModel.bankRate = 3.25
            }
            
        }
        // 切换贷款方式
        cell.switchModeBlock = { [unowned self]  mode in
            self.viewModel.calcModel.mode = mode
        }
        cell.textFieldValueChangedBlock = { [unowned self]  sender in
            if index != 1 && sender.tag == self.dataSource.count - 3 { // 基点
                self.updateRateValueUI()
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let cell = tableView.cellForRow(at: indexPath) as! LHLoanCalculatorCell
        switch indexPath.row {
        case 0:
            if index == 0 || index == 1 { // 选择计算方式
                viewModel.showCalcTypePicker { [unowned self] string in
                    if index == 0 { // 商贷
                        if viewModel.calcModel.calcType == 0 {
                            self.dataSource = ["计算方式","房屋单价","房屋面积","按揭成数","按揭年数","利率方式","基点","商贷利率","还款方式"]
                        } else {
                            self.dataSource = ["计算方式","贷款总额","按揭成数","按揭年数","利率方式","基点","商贷利率","还款方式"]
                        }
                    }
                    if index == 1 { // 公积金贷
                        if viewModel.calcModel.calcType == 0 {
                            self.dataSource = ["计算方式","房屋单价","房屋面积","按揭成数","按揭年数","利率方式","还款方式"]
                        } else {
                            self.dataSource = ["计算方式","贷款总额","按揭成数","按揭年数","利率方式","还款方式"]
                        }
                    }
                    tableView.snp.updateConstraints { make in
                        make.height.equalTo(50.zoom() * Double(dataSource.count) + 70.zoom())
                    }
                    tableView.reloadData()
                }
            }
        case 3:
            
            if index == 0 || index == 1 { // 选择首付比例
                viewModel.showPaymentProportionPicker { title in
                    cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: title, titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                }
            }
        case 4:
            // 还款年限
            viewModel.showPaymentYearsPicker { year in
                cell.arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: year, titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
            }
            break
        default:
            break
        }
    }
    
    private func switchRateUI(cell: LHLoanCalculatorCell) {
        if index == 0 { // 商业贷款
            self.viewModel.showBusinessRatePicker {
                cell.baseButton.isSelected = true;
                cell.lprButton.isSelected = false;
                
                self.updateRateValueUI()
            }
        }
        if index == 1 { // 公积金贷款
            self.viewModel.showFundRatePicker {
                cell.baseButton.isSelected = true;
                cell.lprButton.isSelected = false;
            }
        }
        if index == 2 { // 混合贷款
            
            if cell.baseButton.tag == 2 {
                self.viewModel.showBusinessRatePicker {
                    cell.baseButton.isSelected = true;
                    cell.lprButton.isSelected = false;
                    
                    self.updateRateValueUI()
                }
            } else {
                self.viewModel.showFundRatePicker {
                    cell.baseButton.isSelected = true;
                    cell.lprButton.isSelected = false;
                }
            }
        }
    }
    private func updateRateValueUI() {
        let rateCell = self.tableView.cellForRow(at: IndexPath(row: self.dataSource.count - 2, section: 0))! as! LHLoanCalculatorCell
        let pointCell = self.tableView.cellForRow(at: IndexPath(row: self.dataSource.count - 3, section: 0))! as! LHLoanCalculatorCell
        let point = pointCell.textField.text!.count > 0 ? pointCell.textField.text! : "0";
        rateCell.unitLabel.text = "=\(String(format: "%.2f", self.viewModel.calcModel.bankRate + Double(point)!/100.0))%"
        
        rateCell.textField.placeholder = "\(String(format: "%.2f", self.viewModel.calcModel.bankRate)) + \(String(format: "%.2f", Double(point)!/100.0))(%)"
    }
}

extension LHLoanCalcController {
    @objc func calcAction () {
        
        var result:LHLoanCalcResultModel?
        
        
        var checkResult = true
        
        for cell in tableView.subviews {
            if cell is UITableViewCell == false {
                continue
            }
            let textFieldCell = cell as! LHLoanCalculatorCell
            let title = textFieldCell.titleLabel.text!
            let requiredArray = ["房屋单价","房屋面积","贷款总额","商业贷款额","公积金贷款额","基点"]
            if requiredArray.contains(title) == false { // 非必填 直接过
                continue
            }
            if let content = Double(textFieldCell.textField.text!) {
                if title == "房屋单价" {
                    if content == 0 {
                        checkResult = false
                        SVProgressHUD.showError(withStatus: "请输入\(title)")
                        break
                    } else {
                        viewModel.calcModel.unitPrice = content
                    }
                }
                if title == "房屋面积" {
                    if content == 0 {
                        checkResult = false
                        SVProgressHUD.showError(withStatus: "请输入\(title)")
                        break
                    } else {
                        viewModel.calcModel.area = content
                    }
                    
                }
                if title == "贷款总额" {
                    if content == 0 {
                        checkResult = false
                        SVProgressHUD.showError(withStatus: "请输入\(title)")
                        break
                    } else {
                        if index == 0 {
                            viewModel.calcModel.businessTotalPrice = content
                        } else {
                            viewModel.calcModel.fundTotalPrice = content
                        }
                    }
                }
                if title == "商业贷款额" {
                    if content == 0 {
                        checkResult = false
                        SVProgressHUD.showError(withStatus: "请输入\(title)")
                        break
                    } else {
                        viewModel.calcModel.businessTotalPrice = content
                    }
                }
                if title == "公积金贷款额" {
                    if content == 0 {
                        checkResult = false
                        SVProgressHUD.showError(withStatus: "请输入\(title)")
                        break
                    } else{
                        viewModel.calcModel.fundTotalPrice = content
                    }
                }
                if title == "基点"  {
                    viewModel.calcModel.basePoint = content
                }
            } else {
                SVProgressHUD.showError(withStatus: "请输入\(title)")
                checkResult = false
            }
        }
        if checkResult == false {
            return
        }
        
        if index == 0 || index == 1 { // 商贷和公积金贷
            
            if index == 0 && viewModel.calcModel.mode == 1 { // 商业 等额本息
                result = viewModel.calcModel.calculateBusinessLoanAsTotalPriceAndEqualPrincipalInterest()
            }
            if index == 0 && viewModel.calcModel.mode == 2 { // 商业 等额本金
                result = viewModel.calcModel.calculateBusinessLoanAsTotalPriceAndEqualPrincipal()
            }
            if index == 1 && viewModel.calcModel.mode == 1 { // 公积金 等额本息
                result = viewModel.calcModel.calculateFundLoanAsUnitPriceAndEqualPrincipalInterest()
            }
            if index == 1 && viewModel.calcModel.mode == 2 { // 公积金 等额本金
                result = viewModel.calcModel.calculateFundLoanAsUnitPriceAndEqualPrincipal()
            }
        }
        if index == 2 { // 混合贷
            
            if viewModel.calcModel.mode == 1 { // 混合贷 等额本息
                result = viewModel.calcModel.calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterest()
            }
            if viewModel.calcModel.mode == 2 { // 混合贷 等额本金
                result = viewModel.calcModel.calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel()
            }
        }
        // 缓存
        if result != nil {
            let resultController = LHLoanCalcResultController()
            resultController.resultModel = result!
            self.navigationController?.pushViewController(resultController, animated: true)
        }
    }
}
