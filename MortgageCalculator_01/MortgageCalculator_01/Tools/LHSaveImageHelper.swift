//
//  LHSaveImageHelper.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import Foundation
import UIKit
import Photos
import SVProgressHUD
import LEEAlert
struct LHSaveImageHelper {
    
    static func saveImageToPhotoLibrary(image: UIImage?) {
        
        guard let img = image else {
            return
        }
        // 判断权限
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            self.saveImage(image: img)
        case .notDetermined, .limited:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    
                    self.saveImage(image: img)
                } else {
                    SVProgressHUD.showError(withStatus: "无相册权限")
                }
            }
            
        case .restricted, .denied:
            let alert = LEEAlert.alert()
            _ = alert.config.leeAddTitle { label in
                label.text = "提示"
            }.leeAddContent { label in
                label.text = "无相册读取权限，点击前往设置打开。"
            }.leeAddAction { action in
                action.title = "取消"
            }.leeAddAction { action in
                action.title = "确定"
                action.clickBlock = {
                    if let url = URL.init(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: Dictionary(), completionHandler: nil)
                        }
                    }
                }
            }.leeShow()
            
        @unknown default:
            break
        }
    }
    
    static private func saveImage(image: UIImage) {
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { (isSuccess, error) in
            
            DispatchQueue.main.async {
                if isSuccess { // 成功
                    SVProgressHUD.showSuccess(withStatus: "保存成功")
                } else {
                    SVProgressHUD.showSuccess(withStatus: "保存失败")
                }
            }
        })
    }

}

