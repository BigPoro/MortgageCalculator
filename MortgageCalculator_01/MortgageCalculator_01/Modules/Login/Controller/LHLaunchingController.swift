//
//  LHLaunchingController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/21.
//

import UIKit
import AttributedString

let kAgreePolicyKey = "kAgreePolicyKey"

class LHLaunchingController: LHBaseController {
    private lazy var viewModel = LHLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.bar.isHidden = true
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_launcing")
        bgView.contentMode = .scaleAspectFill
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = kAppName
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-10 - kBottomSafeHeight)
            make.centerX.equalToSuperview()
        }
        
        let logoView = UIImageView()
        logoView.image = .init(named: "icon_logo_50")
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
            make.centerX.equalToSuperview()
        }
        
        // 判断协议状态
        if UserDefaults.standard.bool(forKey: kAgreePolicyKey) == false {
            showPolicyView()
        } else {
            switchToHomeController()
        }
    }
    
    private func showPolicyView() {
        let maskView = UIView()
        maskView.backgroundColor = RGBA(R: 0, G: 0, B: 0, A: 0.5)
        view.addSubview(maskView)
        maskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let alertView = UIView()
        alertView.backgroundColor = kGray_244
        alertView.layer.cornerRadius = 8
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 2 * 20.zoom())
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "服务协议和隐私政策"
        titleLabel.font = FontMediumHeiti(fontSize: 16)
        titleLabel.textColor = kGray_61
        alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20.zoom())
            make.centerX.equalToSuperview()
        }
        
        let privacyPolicy: ASAttributedString = .init("《使用协议》",.font(FontMediumHeiti(fontSize: 14)),.foreground(kPurple_135),.action({ [weak self] in
            self?.viewModel.getUsePolicy { content in
                let vc = LHPolicyContentController()
                vc.htmlStr = content
                vc.policyTitle = "使用协议"
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        let userPolicy: ASAttributedString = .init("《用户条款》",.font(FontMediumHeiti(fontSize: 14)),.foreground(kPurple_135),.action({
            [weak self] in
            self?.viewModel.getUserPolicy { content in
                let vc = LHPolicyContentController()
                vc.htmlStr = content
                vc.policyTitle = "用户条款"
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        let contentAttr:ASAttributedString = "\("欢迎使用本App，我们非常重视您的个人信息和隐私保护，在您使用本产品服务之前，请您务必审慎阅读" + privacyPolicy + "和" + userPolicy + "，并充分理解协议条款内容。我们将严格按照您同意的各项条款使用您的个人信息，以便为您更好的提供服务。",.font(FontMediumHeiti(fontSize: 14)),.foreground(kGray_61))"
        let contentWidth = view.width - 2 * 20.zoom() - 2 * 15.zoom()
        let contentLabel = UILabel()
        contentLabel.attributed.text = contentAttr
        contentLabel.numberOfLines = 0
        contentLabel.preferredMaxLayoutWidth = contentWidth
        alertView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.zoom())
            make.width.equalTo(contentWidth)
            make.centerX.equalToSuperview()
        }
        
        let agreeButton = UIButton(type: .custom)
        agreeButton.setTitle("同意", for: .normal)
        agreeButton.configGradientButtonUI()
        alertView.addSubview(agreeButton)
        
        let disagreeButton = UIButton(type: .custom)
        disagreeButton.setTitle("不同意", for: .normal)
        disagreeButton.titleLabel?.font = FontMediumHeiti(fontSize: 15)
        disagreeButton.setTitleColor(kGray_61, for: .normal)
        disagreeButton.layer.cornerRadius = 8
        disagreeButton.layer.masksToBounds = true
        disagreeButton.backgroundColor = .white
        alertView.addSubview(disagreeButton)
        
        let buttons = [disagreeButton,agreeButton]
        buttons.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 30.zoom(), leadSpacing: 15.zoom(), tailSpacing: 15.zoom())
        buttons.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10.zoom())
            make.bottom.equalTo(-20.zoom())
        }
        
        agreeButton.onTap { [unowned self] in
            UserDefaults.standard.set(true, forKey: kAgreePolicyKey)
            self.switchToHomeController()
        }
        disagreeButton.onTap {
            UserDefaults.standard.set(false, forKey: kAgreePolicyKey)
            exit(0)
        }
    }
    
    private func switchToHomeController() {
        let tabBar = LHTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = tabBar
    }
}

