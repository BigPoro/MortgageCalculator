//
//  LHLoanCalcResultController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/9.
//

import UIKit
import AttributedString
import SVProgressHUD

class LHLoanCalcResultController: LHTableViewController {
    var resultModel: LHLoanCalcResultModel!
    /// 隐藏保存记录按钮
    var hiddenSaveAction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if hiddenSaveAction == true {
            LHCacheHelper.helper.readCalcResultModel(model: resultModel) { result in
                print("看房记录已读")
            }
        }
    }
    //MARK: UI
    override func setupUI() {
        super.setupUI()
        navigation.bar.isHidden = true
        view.backgroundColor = kGray_244
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_result_bg")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(255.zoom())
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
        titleLabel.text = "计算详情"
        titleLabel.textColor = UIColor.white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        let tagOne = UILabel()
        tagOne.font = FontRegularHeiti(fontSize: 15)
        tagOne.text = "还款总额(万元)"
        tagOne.textColor = UIColor.white
        view.addSubview(tagOne)
        tagOne.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.zoom())
            make.centerX.equalToSuperview()
        }
        
        let repayTotalLabel = UILabel()
        repayTotalLabel.font = FontSemiboldHeiti(fontSize: 28)
        repayTotalLabel.text = String(format: "%.2f", (resultModel.repayTotalPrice/10000).rounded(2))
        repayTotalLabel.textColor = UIColor.white
        view.addSubview(repayTotalLabel)
        repayTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(tagOne.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        if resultModel.type != .combined && resultModel.calcType == 0 { // 组合贷款/贷款总额计算 不显示
            let houseTotalLabel = UILabel()
            let tagTwo:ASAttributedString = "\("房款总额(万元)", .font(FontRegularHeiti(fontSize: 12)),.foreground(RGBA(R:255, G:255, B:255, A:0.8)))"
            let houseTotalPrice:ASAttributedString = "\(String(format: "%.2f", (resultModel.houseTotalPrice/10000).rounded(2)), .font(FontRegularHeiti(fontSize: 15)),.foreground(RGBA(R:255, G:255, B:255, A:0.8)))"
            houseTotalLabel.attributed.text = tagTwo + houseTotalPrice
            view.addSubview(houseTotalLabel)
            houseTotalLabel.snp.makeConstraints { make in
                make.top.equalTo(repayTotalLabel.snp.bottom)
                make.centerX.equalToSuperview()
            }
        }

        
        var tagLabels = [UILabel]()
        var tagTitles = ["贷款总额(万元)","利息总额(万元)","还款月数(个月)"]
        if resultModel.type != .combined && resultModel.calcType == 0 { // 组合贷款/贷款总额计算 不显示首付
            tagTitles.insert("首付金额(万元)", at: 0)
        }
        for tag in tagTitles{
            let tagLabel = UILabel()
            tagLabel.textAlignment = .center
            tagLabel.textColor = RGBA(R: 255, G: 255, B: 255, A: 0.5)
            tagLabel.font = FontRegularHeiti(fontSize: 12)
            tagLabel.text = tag
            view.addSubview(tagLabel)
            tagLabels.append(tagLabel)
        }
        tagLabels.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 8.zoom(), leadSpacing: 15.zoom(), tailSpacing: 15.zoom())
        tagLabels.snp.makeConstraints { make in
            make.top.equalTo(repayTotalLabel.snp.bottom).offset(50.zoom())
        }
        
        var contentLabels = [UILabel]()
        if resultModel.type == .combined || resultModel.calcType == 1 { // 组合贷款/贷款总额计算 不显示首付
            for _ in 0..<3 {
                let contentLabel = UILabel()
                contentLabel.textColor = .white
                contentLabel.textAlignment = .center
                contentLabel.font = FontMediumHeiti(fontSize: 15)
                view.addSubview(contentLabel)
                contentLabels.append(contentLabel)
            }
            contentLabels[0].text = String(format: "%.2f", (resultModel.loanTotalPrice/10000).rounded(2))
            contentLabels[1].text = String(format: "%.2f", (resultModel.interestPayment/10000).rounded(2))
            contentLabels[2].text = "\(Int(resultModel.loanMonth))"
            contentLabels.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 8.zoom(), leadSpacing: 15.zoom(), tailSpacing: 15.zoom())
            contentLabels.snp.makeConstraints { make in
                make.top.equalTo(tagLabels.first!.snp.bottom).offset(5.zoom())
            }
        } else {
            for _ in 0..<4 {
                let contentLabel = UILabel()
                contentLabel.textColor = .white
                contentLabel.textAlignment = .center
                contentLabel.font = FontMediumHeiti(fontSize: 15)
                view.addSubview(contentLabel)
                contentLabels.append(contentLabel)
            }
            contentLabels[0].text = String(format: "%.2f", (resultModel.firstPayment/10000).rounded(2))
            contentLabels[1].text = String(format: "%.2f", (resultModel.loanTotalPrice/10000).rounded(2))
            contentLabels[2].text = String(format: "%.2f", (resultModel.interestPayment/10000).rounded(2))
            contentLabels[3].text = "\(Int(resultModel.loanMonth))"
            contentLabels.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 8.zoom(), leadSpacing: 15.zoom(), tailSpacing: 15.zoom())
            contentLabels.snp.makeConstraints { make in
                make.top.equalTo(tagLabels.first!.snp.bottom).offset(5.zoom())
            }
        }

        
        let sectionView = UIView()
        sectionView.backgroundColor = kGray_235
        view.addSubview(sectionView)
        sectionView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44.zoom())
        }
        
        var sectionLabels = [UILabel]()
        let sectionTitles = ["期数","月供","本金","利息","剩余本金"]
        for title in sectionTitles {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.textColor = kGray_61
            titleLabel.font = FontRegularHeiti(fontSize: 12)
            titleLabel.text = title
            sectionView.addSubview(titleLabel)
            sectionLabels.append(titleLabel)
        }
        sectionLabels.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        sectionLabels.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            
        }
        
        let screenshotButton = UIButton.init(type: .custom)
        screenshotButton.configGradientButtonUI()
        screenshotButton.setTitle("保存图片", for: .normal)
        view.addSubview(screenshotButton)
        screenshotButton.onTap { [unowned self] in
            let screenshot = self.view.snapshot()
            LHSaveImageHelper.saveImageToPhotoLibrary(image: screenshot)
        }
        
        if hiddenSaveAction == true { // 隐藏保存记录按钮
            screenshotButton.snp.makeConstraints { make in
                make.bottom.equalTo(-20.zoom() - kBottomSafeHeight)
                make.height.equalTo(44.zoom())
                make.width.equalTo(300.zoom())
                make.centerX.equalToSuperview()
            }
        } else {
            let saveResultButton = UIButton.init(type: .custom)
            saveResultButton.configGradientButtonUI()
            saveResultButton.setTitle("保存记录", for: .normal)
            view.addSubview(saveResultButton)
            saveResultButton.onTap { [unowned self] in
                LHCacheHelper.helper.saveCalcResultModel(model: resultModel) { result in
                    if result == true {
                        SVProgressHUD.showSuccess(withStatus: "保存成功")
                    } else {
                        SVProgressHUD.showSuccess(withStatus: "保存失败")
                    }
                }
            }
            
            let buttons = [screenshotButton, saveResultButton]
            buttons.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 20.zoom(),leadSpacing: 25.zoom(), tailSpacing: 25.zoom())
            buttons.snp.makeConstraints { make in
                make.bottom.equalTo(-20.zoom() - kBottomSafeHeight)
                make.height.equalTo(44.zoom())
            }
        }
        
        self.tableView.snp.remakeConstraints { make in
            make.top.equalTo(sectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(screenshotButton.snp.top).offset(-15.zoom())
        }
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = kGray_244
    }
}

extension LHLoanCalcResultController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultModel.monthRepaymentArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHMonthRepaymentCell"
        var cell:LHMonthRepaymentCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHMonthRepaymentCell
        if cell == nil {
            cell = LHMonthRepaymentCell.init(style: .default, reuseIdentifier: identifier)
        }
        let monthRepayment = resultModel.monthRepaymentArr[indexPath.row]
        cell.contentLabelArr[0].text = "\(monthRepayment.month)"
        cell.contentLabelArr[1].text = String(format: "%.2f", monthRepayment.monthRepayment.rounded(2))
        cell.contentLabelArr[2].text = String(format: "%.2f", monthRepayment.monthPrincipal.rounded(2))
        cell.contentLabelArr[3].text = String(format: "%.2f", monthRepayment.monthInterest.rounded(2))
        cell.contentLabelArr[4].text = String(format: "%.2f", monthRepayment.remainingPrincipal.rounded(2))
        
        return cell
    }
}
