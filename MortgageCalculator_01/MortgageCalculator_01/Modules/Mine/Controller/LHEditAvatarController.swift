//
//  LHEditAvatarController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/20.
//

import UIKit
import ZLPhotoBrowser
import SwiftUI
import SVProgressHUD
import PermissionKit

class LHEditAvatarController: LHBaseController {
    private lazy var viewModel = LHMineViewModel()
    private let avatarView = UIImageView()
    var avatarURL = "" {
        didSet {
            avatarView.kf.setImage(with: avatarURL.toURL())
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.errorBlock = { error in
            SVProgressHUD.showError(withStatus: error.domain)
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
        titleLabel.text = "头像"
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButtton)
            make.centerX.equalToSuperview()
        }
        
        avatarView.backgroundColor = kGray_235
        view.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backButtton.snp.bottom)
            make.height.equalTo(300.zoom())
        }
        
        let chooseButton = UIButton(type: .custom)
        chooseButton.layer.cornerRadius = 7
        chooseButton.layer.borderColor = kGray_244.cgColor
        chooseButton.layer.borderWidth = 1
        chooseButton.setTitle("从相册选一张", for: .normal)
        chooseButton.setTitleColor(kGray_123, for: .normal)
        chooseButton.titleLabel?.font = FontSemiboldHeiti(fontSize: 15)
        view.addSubview(chooseButton)
        chooseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 300.zoom(), height: 44.zoom()))
            make.top.equalTo(avatarView.snp.bottom).offset(20.zoom())
        }
        chooseButton.onTap {  [unowned self] in
            if Provider.photos(.readWrite).isAuthorized == true {
                showImagePicker()
            } else {
                Provider.photos(.readWrite).request { result in
                    if result == true {
                        showImagePicker()
                    } else {
                        viewModel.showOpenSettingAlert(content: "无相册访问权限，请前往设置页面开启")
                    }
                }
            }
        }
        
        let takeButton = UIButton(type: .custom)
        takeButton.layer.cornerRadius = 7
        takeButton.layer.borderColor = kGray_244.cgColor
        takeButton.layer.borderWidth = 1
        takeButton.setTitle("拍一张照片", for: .normal)
        takeButton.setTitleColor(kGray_123, for: .normal)
        takeButton.titleLabel?.font = FontSemiboldHeiti(fontSize: 15)
        view.addSubview(takeButton)
        takeButton.snp.makeConstraints { make in
            make.centerX.size.equalTo(chooseButton)
            make.top.equalTo(chooseButton.snp.bottom).offset(10.zoom())
        }
        takeButton.onTap { [unowned self] in
            if Provider.camera.isAuthorized == true {
                showImageTaker()
            } else {
                Provider.camera.request { result in
                    if result == true {
                        showImageTaker()
                    } else {
                        viewModel.showOpenSettingAlert(content: "无相机访问权限，请前往设置页面开启")
                    }
                }
            }

        }
    }
    private func showImagePicker() {
        let ps = ZLPhotoPreviewSheet()
        let config = ZLPhotoConfiguration.default()
        config.maxSelectCount = 1
        config.allowSelectVideo = false
        config.allowRecordVideo = false
        config.allowTakePhoto = false
        ps.selectImageBlock = { [weak self] (images, assets, isOriginal) in
            self?.uploadImage(image: images.first!)
        }
        ps.showPhotoLibrary(sender: self)
    }
    private func showImageTaker() {
        UIImagePickerController(source: .camera, allow: .image) { [weak self] result, picker in
            if let image = result.originalImage {
                self?.uploadImage(image: image)
            }
        }.present(from: self)
    }
    
    private func uploadImage(image:UIImage) {
        viewModel.updateUserAvatar(imageData: image.convertToData()!) {  progress in
            SVProgressHUD.showProgress(Float(progress), status: "上传中\(Int(progress * 100))%")
        } callback: { [weak self] in
            SVProgressHUD.showSuccess(withStatus: "已上传")
            self?.avatarView.image = image
        }
    }
}
