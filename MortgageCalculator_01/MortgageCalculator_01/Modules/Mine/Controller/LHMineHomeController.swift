//
//  LHMineHomeController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import SVProgressHUD
import Kingfisher

class LHMineHomeController: LHTableViewController {
    private lazy var viewModel = LHMineViewModel()
    private lazy var loginViewModel = LHLoginViewModel()

    let avaterView = UIButton()
    let nameView = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ["计算记录","用户条款","使用协议","关于我们","清理缓存"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let token = LHCacheHelper.helper.getToken()
        if token != nil && token?.isBlank == false { // 已登录
            viewModel.getUserInfo { [weak self] _ in
                self?.updateUI()
            }
        } else {
            avaterView.setImage(.init(named: "icon_avatar_placeholder"), for: .normal)
            nameView.setTitle("未登录", for: .normal)
            tableView.snp.updateConstraints { make in
                make.height.equalTo(5 * 50.zoom())
            }
            tableView.tableFooterView = UIView()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        navigation.bar.isHidden = true
        view.backgroundColor = kGray_244
        
        let bgView = UIImageView()
        bgView.contentMode = .scaleToFill
        bgView.image = .init(named: "img_mine_bg")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(190.zoom())
        }
        
        avaterView.layer.cornerRadius = 50.zoom()/2
        avaterView.layer.borderColor = UIColor.white.cgColor
        avaterView.layer.borderWidth = 1
        avaterView.layer.masksToBounds = true
        avaterView.backgroundColor = kGray_184
        avaterView.addTarget(self, action: #selector(userInfoClicked(_:)), for: .touchUpInside)
        view.addSubview(avaterView)
        avaterView.snp.makeConstraints { make in
            make.top.equalTo(40.zoom() + kTopSafeHeight)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50.zoom())
        }
        nameView.titleLabel?.font = FontMediumHeiti(fontSize: 15)
        nameView.setTitleColor(.white, for: .normal)
        nameView.setTitle("未登录", for: .normal)
        nameView.addTarget(self, action: #selector(userInfoClicked(_:)), for: .touchUpInside)
        view.addSubview(nameView)
        nameView.snp.makeConstraints { make in
            make.top.equalTo(avaterView.snp.bottom).offset(10.zoom())
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(300.zoom())
        }
        
        let startView = UIView()
        startView.backgroundColor = .white
        startView.layer.cornerRadius = 7
        view.addSubview(startView)
        startView.snp.makeConstraints { make in
            make.leading.equalTo(15.zoom())
            make.trailing.equalTo(-15.zoom())
            make.top.equalTo(nameView.snp.bottom).offset(10.zoom())
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontMediumHeiti(fontSize: 18)
        titleLabel.textColor = kGray_35
        titleLabel.text = "全能房贷计算器"
        startView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20.zoom())
            make.centerX.equalToSuperview().offset(-25.zoom())
        }
        
        let tagLabel = UILabel()
        tagLabel.font = FontRegularHeiti(fontSize: 11)
        tagLabel.textColor = kYellow_255
        tagLabel.text = " 多种计算 "
        tagLabel.layer.borderColor = kYellow_255.cgColor
        tagLabel.layer.borderWidth = 1
        tagLabel.layer.cornerRadius = 3
        startView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(5);
        }
        
        let subTitleLabel = UILabel()
        subTitleLabel.font = FontRegularHeiti(fontSize: 15)
        subTitleLabel.textColor = kGray_123
        subTitleLabel.text = "房贷计算 装修计算 看房记录"
        startView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5.zoom())
            make.centerX.equalToSuperview()
        }
        
        let startButton = UIButton.init(type: .custom)
        startButton.configGradientButtonUI()
        startButton.layer.cornerRadius = 28.zoom()/2
        startButton.setTitle("现在开始", for: .normal)
        startButton.titleLabel?.font = FontMediumHeiti(fontSize: 12)
        startView.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 112.zoom(), height: 28.zoom()))
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20.zoom())
            make.bottom.equalTo(-10.zoom())
        }
        startButton.onTap { [unowned self]  in
            let vc = LHLoanCalcController()
            vc.index = 0
            navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.bounces = false
        tableView.layer.cornerRadius = 7
        tableView.snp.makeConstraints { make in
            make.top.equalTo(startView.snp.bottom).offset(10.zoom())
            make.leading.equalTo(15.zoom())
            make.trailing.equalTo(-15.zoom())
            make.height.equalTo(5 * 50.zoom())
        }
    }
    @objc private func userInfoClicked(_ sender:UIButton) {
        let token = LHCacheHelper.helper.getToken()
        if token != nil {
            let vc = LHUserInfoController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = LHNavigationController.init(rootViewController: LHLoginController())
            navigationController?.present(vc, animated: true, completion: nil)
        }

    }
    
    private func updateUI () {
        guard viewModel.userModel != nil
            
        else {
            return
        }
        if let url = viewModel.userModel?.avatar {
            avaterView.kf.setImage(with: url.toURL(),for:.normal,placeholder: .init(named: "icon_avatar_placeholder"))
        } else {
            avaterView.setImage(.init(named: "icon_avatar_placeholder"),for:.normal)
        }
        if let nickName = viewModel.userModel?.nickname {
            nameView.setTitle(nickName, for: .normal)
        } else {
            nameView.setTitle("未设置", for: .normal)
        }
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 70.zoom())
        let submitButton = UIButton.init(type: .custom)
        submitButton.setTitle("退出登录", for: .normal)
        submitButton.configGradientButtonUI()
        submitButton.onTap { [unowned self] in
            
            NotificationCenter.default.post(name: kLogoutNotiName, object: nil)
            viewModel.userModel = nil
            viewWillAppear(true) // 刷新UI
            SVProgressHUD.showSuccess(withStatus: "已退出登录")
            tabBarController?.selectedIndex = 0
        }
        footerView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.leading.equalTo(20.zoom())
            make.trailing.equalTo(-20.zoom())
            make.bottom.equalTo(-20.zoom())
            make.height.equalTo(44.zoom())
        }
        tableView.tableFooterView = footerView
        tableView.snp.updateConstraints { make in
            make.height.equalTo(5 * 50.zoom() + 70.zoom())
        }
    }
}

extension LHMineHomeController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHTableViewCell"
        var cell:LHTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTableViewCell
        if cell == nil {
            cell = LHTableViewCell.init(style: .subtitle, reuseIdentifier: identifier)
        }
        cell.imageView?.image = .init(named: "icon_mine_list_\(indexPath.row)")
        cell.textLabel?.text = dataSource[indexPath.row] as? String
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(LHLoanCalcRecordController(), animated: true)
        case 1:
            loginViewModel.getUserPolicy { [weak self] content in
                let vc = LHPolicyContentController()
                vc.htmlStr = content
                vc.policyTitle = "用户条款"
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            loginViewModel.getUsePolicy {[weak self] content in
                let vc = LHPolicyContentController()
                vc.htmlStr = content
                vc.policyTitle = "使用协议"
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
        case 3:
            navigationController?.pushViewController(LHAboutUsController(), animated: true)
        case 4:
            SVProgressHUD .show(withStatus: "清理中...")
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                SVProgressHUD.showSuccess(withStatus: "已清理")
            })
        default:
            break
        }
    }
}
