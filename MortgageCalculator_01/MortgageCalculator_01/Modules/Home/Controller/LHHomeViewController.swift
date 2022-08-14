//
//  LHHomeViewController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import BadgeHub

class LHHomeViewController: LHBaseController {
    var countBadge:BadgeHub!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBadgeValue()
    }
    
    //MARK: - UI
    override func setupUI() {
        super.setupUI()
        navigation.bar.isHidden = true
        navigation.bar.statusBarStyle = .default
        
        //MARK: TopView
        let topView = UIView()
        topView.backgroundColor = .white
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(106.zoom())
        }
        
        let leftLogo = UIImageView()
        leftLogo.image = .init(named: "icon_home_top")
        topView.addSubview(leftLogo)
        leftLogo.snp.makeConstraints { make in
            make.leading.equalTo(20.zoom())
            make.size.equalTo(CGSize(width: 45, height: 45).zoom())
            make.bottom.equalTo(-15.zoom())
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontMediumHeiti(fontSize: 17)
        titleLabel.textColor = kGray_61
        titleLabel.text = "全能房贷计算器"
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftLogo.snp.trailing).offset(10.zoom())
            make.top.equalTo(leftLogo)
        }
        
        let submitTitleLabel = UILabel()
        submitTitleLabel.font = FontRegularHeiti(fontSize: 12)
        submitTitleLabel.textColor = kGray_123
        submitTitleLabel.text = "房贷计算器 | 购房计算器 | 装修计算器"
        topView.addSubview(submitTitleLabel)
        submitTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(leftLogo)
        }
        
        let editButton = UIButton.init(type: .custom)
        editButton.setImage(.init(named: "icon_home_edit"), for: .normal)
        editButton.onTap { [unowned self] in
            let vc = LHLoanCalcRecordController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        topView.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(-20.zoom())
            make.centerY.equalTo(leftLogo)
        }
        
        countBadge = BadgeHub(view: editButton)
        countBadge.setMaxCount(to: 99)
        countBadge.setCountLabelFont(FontRegularHeiti(fontSize: 16))
        countBadge.scaleCircleSize(by: 0.7)
        countBadge.moveCircleBy(x: 40.zoom(), y: 0)

        let mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = kGray_244
        mainScrollView.frame = CGRect(x: 0, y: 106.zoom(), width: view.width, height: view.height - 106.zoom())
        view.addSubview(mainScrollView)
        
        let containerView = UIView()
        containerView.backgroundColor = kGray_244
        mainScrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.width)
        }
        
        //MARK: CenterView
        let sectionOne = self.getTopSectionView(index: 1)
        containerView.addSubview(sectionOne)
        sectionOne.snp.makeConstraints { make in
            make.top.equalTo(10.zoom())
            make.leading.equalTo(20.zoom())
            make.trailing.equalTo(-20.zoom())
            make.height.equalTo(78.zoom())
        }
        
        let sectionTwo = self.getTopSectionView(index: 2)
        containerView.addSubview(sectionTwo)
        sectionTwo.snp.makeConstraints { make in
            make.top.equalTo(sectionOne.snp.bottom).offset(10.zoom())
            make.leading.trailing.height.equalTo(sectionOne)
        }
        
        let sectionThree = self.getTopSectionView(index: 3)
        containerView.addSubview(sectionThree)
        sectionThree.snp.makeConstraints { make in
            make.top.equalTo(sectionTwo.snp.bottom).offset(10.zoom())
            make.leading.trailing.height.equalTo(sectionOne)
        }
        
        //MARK: BottomView
        let lineView = UIImageView()
        lineView.image = .init(named: "img_nav_bg_gradient_1")
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(20.zoom())
            make.top.equalTo(sectionThree.snp.bottom).offset(20.zoom())
            make.size.equalTo(CGSize(width: 3, height: 13))
        }
        
        let titleTwoLabel = UILabel()
        titleTwoLabel.font = FontMediumHeiti(fontSize: 16)
        titleTwoLabel.textColor = kGray_35
        titleTwoLabel.text = "购房计算工具"
        containerView.addSubview(titleTwoLabel)
        titleTwoLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(10.zoom())
            make.centerY.equalTo(lineView)
        }
        
        let halfWidth = (kScreenWidth - 2 * 20.zoom() - 10.0) / 2.0
        
        let sectionFour = self.getBottomSectionView(index: 4)
        containerView.addSubview(sectionFour)
        sectionFour.snp.makeConstraints { make in
            make.top.equalTo(titleTwoLabel.snp.bottom).offset(10.zoom())
            make.leading.equalTo(20.zoom())
            make.height.equalTo(170.zoom())
            make.width.equalTo(halfWidth)
            make.bottom.equalTo(-20.zoom())
        }
        
        let sectionFive = self.getBottomSectionView(index: 5)
        containerView.addSubview(sectionFive)
        sectionFive.snp.makeConstraints { make in
            make.top.width.equalTo(sectionFour)
            make.trailing.equalTo(-20.zoom())
            make.height.equalTo(80.zoom())
        }
        
        let sectionSix = self.getBottomSectionView(index: 6)
        containerView.addSubview(sectionSix)
        sectionSix.snp.makeConstraints { make in
            make.bottom.width.equalTo(sectionFour)
            make.trailing.equalTo(-20.zoom())
            make.height.equalTo(80.zoom())
        }
    }
    
    private func getTopSectionView(index:Int) -> UIView {
        let sectionView = UIView()
        sectionView.layer.cornerRadius = 8
        sectionView.layer.masksToBounds = true
        
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_home_bg_\(index)")
        sectionView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let iconView = UIImageView()
        iconView.image = .init(named: "icon_home_\(index)")
        sectionView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20.zoom())
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontSemiboldHeiti(fontSize: 15)
        titleLabel.textColor = UIColor.white
        sectionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(15.zoom())
            make.top.equalTo(18.zoom())
        }
        
        let submitTitleLabel = UILabel()
        submitTitleLabel.font = FontRegularHeiti(fontSize: 13)
        submitTitleLabel.textColor = RGBA(R: 255, G: 255, B: 255, A: 0.5)
        sectionView.addSubview(submitTitleLabel)
        submitTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(-18.zoom())
        }
        
        let arrowView = UIImageView()
        arrowView.image = .init(named: "icon_arrow_white_right")
        sectionView.addSubview(arrowView)
        arrowView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-20.zoom())
        }

        switch index {
        case 1:
            titleLabel.text = "商业房贷计算"
            submitTitleLabel.text = "Commercial mortgage calculator"
            sectionView.addTapGesture { [unowned self] gesture in
                let vc = LHLoanCalcController()
                vc.index = index - 1
                navigationController?.pushViewController(vc, animated: true)
            }
 
        case 2:
            titleLabel.text = "公积金房贷计算"
            submitTitleLabel.text = "Provident fund mortgage calculation"
            sectionView.addTapGesture { [unowned self] gesture in
                let vc = LHLoanCalcController()
                vc.index = index - 1
                navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            titleLabel.text = "组合型房贷计算"
            submitTitleLabel.text = "Portfolio mortgage calculation"
            sectionView.addTapGesture { [unowned self] gesture in
                let vc = LHLoanCalcController()
                vc.index = index - 1
                navigationController?.pushViewController(vc, animated: true)
            }
        default: break
            
        }
        
        return sectionView
    }
    
    private func getBottomSectionView(index:Int) -> UIView {
        let sectionView = UIView()
        sectionView.layer.cornerRadius = 8
        sectionView.layer.masksToBounds = true
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_home_bg_\(index)")
        sectionView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontMediumHeiti(fontSize: 15)
        titleLabel.textColor = kGray_35
        sectionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(20.zoom())
            make.top.equalTo(18.zoom())
        }
        
        let submitTitleLabel = UILabel()
        submitTitleLabel.font = FontRegularHeiti(fontSize: 11)
        submitTitleLabel.textColor = kGray_61
        sectionView.addSubview(submitTitleLabel)
        submitTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
                
        switch index {
        case 4:
            titleLabel.text = "房屋采光日照\n时长计算器"
            titleLabel.numberOfLines = 0;
            submitTitleLabel.text = "楼间距计算 、采光计算"
            
            sectionView.addTapGesture { [unowned self] gesture in
                let vc = LHDaylightingCalcController()
                navigationController?.pushViewController(vc, animated: true)
            }

        case 5:
            titleLabel.text = "房产税计算器"
            submitTitleLabel.text = "重庆上海试点城市"
            sectionView.addTapGesture { [unowned self] gesture in
                let vc = LHPropertyTaxCalcController()
                navigationController?.pushViewController(vc, animated: true)
            }
 
        case 6:
            titleLabel.text = "购房能力评估计算"
            submitTitleLabel.text = "根据购房者的资金收入备份"
            sectionView.addTapGesture { [unowned self] gesture in
                let vc = LHHousePurchasCalcController()
                navigationController?.pushViewController(vc, animated: true)
            }

        default: break
            
        }
        return sectionView
    }
    
    private func updateBadgeValue() {

        LHCacheHelper.helper.getCalcResultCache { [unowned self] array in
            if let tempArray = array {
                var unreadCount = 0
                 tempArray.forEach { result in
                     if result.isReaded == false {
                         unreadCount += 1
                     }
                }

                if unreadCount == 0 {
                    countBadge.hide()
                } else {
                    countBadge.setCount(unreadCount)
                    countBadge.show()
                }
            } else {
                countBadge.hide()
            }
        }
    }
}
