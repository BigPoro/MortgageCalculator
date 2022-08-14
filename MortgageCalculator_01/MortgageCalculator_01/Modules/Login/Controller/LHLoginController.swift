//
//  LHLoginController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/19.
//

import UIKit
import FSTextView
import JKCountDownButton
import SVProgressHUD

enum LHLoginWay {
    case password
    case authCode
}

class LHLoginController: LHBaseController {
    
    private lazy var viewModel = LHLoginViewModel()
    private let phoneTextField = FSTextView()
    private let passwordTextFiled = UITextField()
    private let eyeButton = UIButton.init(type: .custom)
    private let forgetButton = UIButton.init(type: .custom)
    private let switchButton = UIButton.init(type: .custom)
    private let agreeButton = UIButton.init(type: .custom)
    private let loginButton = UIButton.init(type: .custom)
    private let countDownButton = JKCountDownButton.init(type: .custom)

    // 登录方式 默认密码登录1 验证码登录2
    private var loginWay:LHLoginWay = .password {
        didSet {
            switch loginWay {
            case .password:
                passwordTextFiled.placeholder = "请输入密码"
                passwordTextFiled.isSecureTextEntry = true
                passwordTextFiled.keyboardType = .default
                switchButton.isSelected = false
                eyeButton.isHidden = false
                countDownButton.isHidden = true
            case .authCode:
                passwordTextFiled.placeholder = "请输入验证码"
                passwordTextFiled.isSecureTextEntry = false
                passwordTextFiled.keyboardType = .numberPad
                switchButton.isSelected = true
                eyeButton.isHidden = true
                eyeButton.isSelected = false
                countDownButton.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func bindData () {
        viewModel.type = "codelLogin"
        
        viewModel.errorBlock = {error  in
            SVProgressHUD.showError(withStatus: error.domain)
        }
        loginButton.onTap { [weak self] in
            if (self?.loginWay == .password) {
                self?.viewModel.loginWithPassword(callback: {
                    SVProgressHUD.showSuccess(withStatus: "登录成功")
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                })
            } else {
                self?.viewModel.loginWithAuthCode(callback: {
                    SVProgressHUD.showSuccess(withStatus: "登录成功")
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                })
            }

        }
        
        phoneTextField.addTextDidChangeHandler { [unowned self] textView in
            if let content = textView?.formatText {
                viewModel.phoneNum = content
            }
        }
        
        passwordTextFiled.onChange {[unowned self] text in
            if loginWay == .password {
                viewModel.password = "\(text)"
            } else {
                viewModel.authCode = "\(text)"
            }
        }

        // 密码
        eyeButton.onTap { [unowned self] in
            eyeButton.isSelected = !eyeButton.isSelected
            passwordTextFiled.isSecureTextEntry = !eyeButton.isSelected
        }
        // 倒计时
        
        countDownButton.countDownChanging { sender, second in
            let title = "\(second)后可重新获取"
            sender?.isEnabled = false
            return title
        }
        countDownButton.countDownFinished { sender, second in
            sender?.isEnabled = false
            return "重新发送"
        }
        countDownButton.countDownButtonHandler { [unowned self] sender, tag in
            viewModel.getAuthCode {
                sender?.startCountDown(withSecond: 60)
            }
        }
        
        // 切换登录方式
        switchButton.onTap { [unowned self] in
            loginWay = loginWay == .password ? .authCode : .password
        }
        // 协议
        agreeButton.onTap { [unowned self] in
            agreeButton.isSelected = !agreeButton.isSelected
            viewModel.checkedAgressment = agreeButton.isSelected
        }
        
        
    }
    
    override func setupUI() {
        super.setupUI()
        navigation.bar.isHidden = true
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_login_bg")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let backButtton = configBackButton()
        backButtton.contentHorizontalAlignment = .center
        view.addSubview(backButtton)
        backButtton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.width.equalTo(44)
            make.top.equalTo(kStatusBarHeight)
        }
        
        let registerbutton = UIButton(type: .custom)
        registerbutton.setTitle("立即注册", for: .normal)
        registerbutton.titleLabel?.font = FontRegularHeiti(fontSize: 14)
        registerbutton.setTitleColor(.white, for: .normal)
        view.addSubview(registerbutton)
        registerbutton.snp.makeConstraints { make in
            make.trailing.equalTo(-15.zoom())
            make.centerY.equalTo(backButtton)
        }
        registerbutton.onTap { [unowned self] in
            navigationController?.pushViewController(LHRegisterController(), animated: true)
        }
        
        let logoView = UIImageView()
        logoView.image = .init(named: "icon_logo_50")
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(60.zoom() + kStatusBarHeight)
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontMediumHeiti(fontSize: 15)
        titleLabel.textColor = .white
        titleLabel.text = kAppName
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(10.zoom())
            make.centerX.equalToSuperview()
        }
        
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.placeholderColor = .white
        phoneTextField.backgroundColor = .clear
        phoneTextField.keyboardType = .numberPad
        phoneTextField.font = FontRegularHeiti(fontSize: 16)
        phoneTextField.textColor = .white
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50.zoom())
            make.height.equalTo(40.zoom())
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 2 * 25.zoom())
        }
        
        let lineOne = UIView()
        lineOne.backgroundColor = .white
        view.addSubview(lineOne)
        lineOne.snp.makeConstraints { make in
            make.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        passwordTextFiled.attributedPlaceholder = NSAttributedString(string: " 请输入密码", attributes: [.font:FontRegularHeiti(fontSize: 16),.foregroundColor:UIColor.white])
        passwordTextFiled.isSecureTextEntry = true
        passwordTextFiled.backgroundColor = .clear
        passwordTextFiled.font = FontRegularHeiti(fontSize: 16)
        passwordTextFiled.textColor = .white
        view.addSubview(passwordTextFiled)
        passwordTextFiled.snp.makeConstraints { make in
            make.top.equalTo(lineOne.snp.bottom).offset(20.zoom())
            make.height.equalTo(40.zoom())
            make.leading.equalTo(phoneTextField)
            make.trailing.equalTo(-150.zoom())
        }
        
        let lineTwo = UIView()
        lineTwo.backgroundColor = .white
        view.addSubview(lineTwo)
        lineTwo.snp.makeConstraints { make in
            make.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(passwordTextFiled.snp.bottom)
            make.height.equalTo(1)
        }
        
        eyeButton.setImage(.init(named: "icon_eye_close"), for: .normal)
        eyeButton.setImage(.init(named: "icon_eye_open"), for: .selected)
        view.addSubview(eyeButton)
        eyeButton.snp.makeConstraints { make in
            make.trailing.equalTo(phoneTextField);
            make.centerY.equalTo(passwordTextFiled)
        }
        
        countDownButton.setTitle("获取验证码", for: .normal)
        countDownButton.setTitleColor(.white, for: .normal)
        countDownButton.setTitleColor(kGray_235, for: .disabled)
        countDownButton.titleLabel?.font = FontRegularHeiti(fontSize: 14)
        countDownButton.isHidden = true
        view.addSubview(countDownButton)
        countDownButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextFiled)
            make.trailing.equalTo(eyeButton)
        }
        
        forgetButton.setTitle("忘记密码？", for: .normal)
        forgetButton.titleLabel?.font = FontRegularHeiti(fontSize: 14)
        forgetButton.setTitleColor(.white, for: .normal)
        view.addSubview(forgetButton)
        forgetButton.snp.makeConstraints { make in
            make.trailing.equalTo(phoneTextField)
            make.top.equalTo(lineTwo.snp.bottom).offset(15.zoom())
        }
        forgetButton.onTap { [unowned self]  in
            navigationController?.pushViewController(LHFinsPasswordController(), animated: true)
        }
        
        loginButton.backgroundColor = .white
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = FontRegularHeiti(fontSize: 16)
        loginButton.layer.cornerRadius = 6
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(phoneTextField)
            make.height.equalTo(44)
            make.top.equalTo(lineTwo.snp.bottom).offset(120.zoom())
        }
        
        switchButton.setTitle("手机号登录", for: .normal)
        switchButton.setTitle("密码登录", for: .selected)
        switchButton.setTitleColor(.white, for: .normal)
        switchButton.titleLabel?.font = FontRegularHeiti(fontSize: 16)
        switchButton.layer.cornerRadius = 6
        switchButton.layer.borderColor = UIColor.white.cgColor
        switchButton.layer.borderWidth = 1
        switchButton.backgroundColor = .clear
        view.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.centerX.size.equalTo(loginButton)
            make.top.equalTo(loginButton.snp.bottom).offset(15.zoom())
        }
        
        let agreementView = UIStackView()
        agreementView.axis = .horizontal
        view.addSubview(agreementView)
        agreementView.snp.makeConstraints { make in
            make.bottom.equalTo(-kBottomSafeHeight - 30.zoom())
            make.centerX.equalToSuperview()
            make.height.equalTo(30.zoom())
        }
        
        agreeButton.setImage(.init(named: "icon_check_empty"), for: .normal)
        agreeButton.setImage(.init(named: "icon_check_full"), for: .selected)
        agreeButton.setTitle(" 我已阅读并遵守", for: .normal)
        agreeButton.setTitleColor(.white, for: .normal)
        agreeButton.titleLabel?.font = FontRegularHeiti(fontSize: 12)
        agreementView.addArrangedSubview(agreeButton)
                 
        let useButton = UIButton.init(type: .custom)
        useButton.titleLabel?.font = FontRegularHeiti(fontSize: 12)
        useButton.setTitle("《使用协议》", for: .normal)
        useButton.setTitleColor(kPurple_135, for: .normal)
        agreementView.addArrangedSubview(useButton)
        useButton.onTap { [unowned self] in
            self.viewModel.getUsePolicy { content in
                let vc = LHPolicyContentController()
                vc.htmlStr = content
                vc.policyTitle = "使用协议"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let userButton = UIButton.init(type: .custom)
        userButton.titleLabel?.font = FontRegularHeiti(fontSize: 12)
        userButton.setTitle("《用户条款》", for: .normal)
        userButton.setTitleColor(kPurple_135, for: .normal)
        agreementView.addArrangedSubview(userButton)
        userButton.onTap { [unowned self] in
            self.viewModel.getUserPolicy { content in
                let vc = LHPolicyContentController()
                vc.htmlStr = content
                vc.policyTitle = "用户条款"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
