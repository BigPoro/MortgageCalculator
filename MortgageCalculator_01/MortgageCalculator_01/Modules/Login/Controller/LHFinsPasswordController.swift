//
//  LHFinsPasswordController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/19.
//

import UIKit
import FSTextView
import JKCountDownButton
import SVProgressHUD

class LHFinsPasswordController: LHBaseController {
    private lazy var viewModel = LHLoginViewModel()
    private let phoneTextField = FSTextView()
    private let codeTextField = FSTextView()
    private let passwordTextFiled = UITextField()
    private let eyeButton = UIButton.init(type: .custom)
    private let newButton = UIButton.init(type: .custom)
    private let countDownButton = JKCountDownButton.init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    /// 绑定数据
    private func bindData () {
        viewModel.type = "retrievePassword"
        
        viewModel.errorBlock = { error  in
            SVProgressHUD.showError(withStatus: error.domain)
        }
        
        newButton.onTap { [weak self] in
            self?.viewModel.findPassword {
                SVProgressHUD.showSuccess(withStatus: "密码已修改")
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
        phoneTextField.addTextDidChangeHandler { [unowned self] textView in
            if let content = textView?.formatText {
                viewModel.phoneNum = content
            }
        }
        
        codeTextField.addTextDidChangeHandler { [unowned self] textView in
            if let content = textView?.formatText {
                viewModel.authCode = content
            }
        }
        passwordTextFiled.onChange {[unowned self] text in
            viewModel.password = text
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
    }
    
    override func setupUI() {
        super.setupUI()
        navigation.bar.isHidden = true
        navigation.bar.statusBarStyle = .default
        
        let backButtton = configBackButton()
        let blackArrow = backButtton.imageView?.image?.changeColor(color: kGray_35)
        backButtton.setImage(blackArrow, for: .normal)
        backButtton.contentHorizontalAlignment = .center
        view.addSubview(backButtton)
        backButtton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.width.equalTo(44)
            make.top.equalTo(kStatusBarHeight)
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontMediumHeiti(fontSize: 18)
        titleLabel.textColor = kGray_61
        titleLabel.text = "找回密码"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButtton)
            make.centerX.equalToSuperview()
        }
        
        let shadowView = UIView()
        shadowView.backgroundColor = kGray_244
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backButtton.snp.bottom)
            make.height.equalTo(3)
        }
        
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.backgroundColor = .clear
        phoneTextField.font = FontRegularHeiti(fontSize: 16)
        phoneTextField.textColor = kGray_61
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.zoom())
            make.height.equalTo(40.zoom())
            make.centerX.equalToSuperview()
            make.width.equalTo(view.width - 2 * 25.zoom())
        }
        
        let lineOne = UIView()
        lineOne.backgroundColor = kGray_244
        view.addSubview(lineOne)
        lineOne.snp.makeConstraints { make in
            make.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        codeTextField.placeholder = "请输入验证码"
        codeTextField.backgroundColor = .clear
        codeTextField.font = FontRegularHeiti(fontSize: 16)
        codeTextField.textColor = kGray_61
        view.addSubview(codeTextField)
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(lineOne.snp.bottom).offset(20.zoom())
            make.height.equalTo(40.zoom())
            make.leading.equalTo(phoneTextField)
            make.trailing.equalTo(-150.zoom())
        }
        
        countDownButton.setTitle("获取验证码", for: .normal)
        countDownButton.setTitleColor(kPurple_135, for: .normal)
        countDownButton.titleLabel?.font = FontRegularHeiti(fontSize: 14)
        view.addSubview(countDownButton)
        countDownButton.snp.makeConstraints { make in
            make.trailing.equalTo(phoneTextField);
            make.centerY.equalTo(codeTextField)
        }
        
        let lineTwo = UIView()
        lineTwo.backgroundColor = kGray_244
        view.addSubview(lineTwo)
        lineTwo.snp.makeConstraints { make in
            make.leading.trailing.equalTo(phoneTextField)
            make.top.equalTo(codeTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        passwordTextFiled.attributedPlaceholder = NSAttributedString(string: " 请输入密码", attributes: [.font:FontRegularHeiti(fontSize: 16),.foregroundColor:RGBA(R: 199, G: 199, B: 205, A: 1)])
        passwordTextFiled.isSecureTextEntry = true
        passwordTextFiled.font = FontRegularHeiti(fontSize: 16)
        passwordTextFiled.textColor = kGray_61
        view.addSubview(passwordTextFiled)
        passwordTextFiled.snp.makeConstraints { make in
            make.top.equalTo(lineTwo.snp.bottom).offset(20.zoom())
            make.height.equalTo(40.zoom())
            make.leading.equalTo(phoneTextField)
            make.trailing.equalTo(-150.zoom())
        }
        
        let lineThree = UIView()
        lineThree.backgroundColor = kGray_244
        view.addSubview(lineThree)
        lineThree.snp.makeConstraints { make in
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
        
        newButton.setTitle("找回密码", for: .normal)
        newButton.configGradientButtonUI()
        newButton.titleLabel?.font = FontRegularHeiti(fontSize: 16)
        view.addSubview(newButton)
        newButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(phoneTextField)
            make.height.equalTo(44)
            make.top.equalTo(lineTwo.snp.bottom).offset(120.zoom())
        }
    }
}
