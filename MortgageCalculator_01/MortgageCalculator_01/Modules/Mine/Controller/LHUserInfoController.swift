//
//  LHUserInfoController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/20.
//

import UIKit
import Kingfisher

class LHUserInfoController: LHTableViewController {
    private lazy var viewModel = LHMineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let token = LHCacheHelper.helper.getToken()
        if token != nil && token?.isBlank == false { // 已登录
            viewModel.getUserInfo { [weak self] _ in
                self?.tableView.reloadData()
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
        titleLabel.text = "个人设置"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButtton)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(backButtton.snp.bottom)
        }
    }
}
extension LHUserInfoController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 80.zoom()
        }
        return 50.zoom()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell\(indexPath.row)"
        var cell:LHTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTableViewCell
        if cell == nil {
            if indexPath.row == 3 {
                cell = LHTableViewCell.init(style: .subtitle, reuseIdentifier: identifier)
            } else {
                cell = LHTableViewCell.init(style: .value1, reuseIdentifier: identifier)
            }
            
            cell.textLabel?.font = FontRegularHeiti(fontSize: 15)
            cell.textLabel?.textColor = kGray_61
            cell.detailTextLabel?.font = FontRegularHeiti(fontSize: 14)
            cell.detailTextLabel?.textColor = kGray_184
        }
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "昵称"
            if let nickName = viewModel.userModel?.nickname,nickName.isBlank == false {
                cell.detailTextLabel?.text = nickName
            } else {
                cell.detailTextLabel?.text = "未设置"
            }
        case 1:
            cell.textLabel?.text = "头像"
            if viewModel.userModel == nil || viewModel.userModel?.avatar == nil || viewModel.userModel?.avatar?.isBlank == true {
                cell.detailTextLabel?.text = "未设置"
            } else {
                cell.detailTextLabel?.text = nil
                var imageView:UIImageView
                if cell.accessoryView == nil {
                    imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40.zoom(), height: 40.zoom()))
                    imageView.layer.cornerRadius = 6.zoom()
                    imageView.layer.masksToBounds = true
                    cell.accessoryView = imageView
                } else {
                    imageView = cell.accessoryView as! UIImageView
                }
                imageView.kf.setImage(with: viewModel.userModel?.avatar?.toURL())
            }
        case 2:
            cell.textLabel?.text = "昵称"
            if let user = viewModel.userModel {
                switch user.sex {
                case .male:
                    cell.detailTextLabel?.text = "男"
                case .female:
                    cell.detailTextLabel?.text = "女"

                }
            } else {
                cell.detailTextLabel?.text = "未设置"
            }
            
        case 3:
            cell.textLabel?.text = "个性签名"
            if let signature = viewModel.userModel?.signature, signature.isBlank == false {
                cell.detailTextLabel?.text = signature
            } else {
                cell.detailTextLabel?.text = "未设置"
            }
            
        default:
            break
        }
        
        return cell
    }
    
    // 更新用户信息
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            viewModel.showRenameAlert { [unowned self] nickName in
                viewModel.updateUserInfo(params: ["nickname":nickName]) {
                    viewModel.userModel?.nickname = nickName
                    tableView.reloadData()
                }
            }
        case 1:
            let vc = LHEditAvatarController()
            vc.avatarURL = viewModel.userModel?.avatar ?? ""
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            viewModel.showSexPicker { [unowned self] sex in
                viewModel.updateUserInfo(params: ["sex":sex == .male ? "1" : "2"]) {
                    viewModel.userModel?.sex = sex
                    tableView.reloadData()
                }
            }
        case 3:
            viewModel.showEditSignatureAlert { [unowned self] signature in
                viewModel.updateUserInfo(params: ["signature":signature]) {
                    viewModel.userModel?.signature = signature
                    tableView.reloadData()
                }
            }
        default:
            break
        }
    }
}



