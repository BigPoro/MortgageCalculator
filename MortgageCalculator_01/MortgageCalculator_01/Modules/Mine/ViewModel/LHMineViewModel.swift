//
//  LHMineViewModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import BRPickerView
import LEEAlert
import SwiftyJSON
import CleanJSON
class LHMineViewModel: LHBaseViewModel {
    var userModel:LHUserModel?
    
    func getUserInfo(callback: @escaping (LHUserModel)->Void) {
        LHMineProvider.request(.getUserInfo) { result in
            switch result {
            case .success(let response):
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if json["code"].intValue == 0 {
                    let decoder = CleanJSONDecoder()
                    let user = try! decoder.decode(LHUserModel.self, from: json["data"].rawData())
                    self.userModel = user
                    
                    callback(user)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateUserInfo(params:[String:String],callback: @escaping ()->Void) {

        LHMineProvider.request(.updateUserInfo(parameter: params)) { result in
            switch result {
            case .success(let response):
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if json["code"].intValue == 0 {
                    callback()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func updateUserAvatar(imageData:Data,progressCallback: @escaping (Double)->Void,callback: @escaping ()->Void) {
        LHMineProvider.request(.updateAvatar(avatar: imageData)) { progress in
            progressCallback(progress.progress)
            print(progress.progress)
        } completion: { result in
            switch result {
            case .success(let response):
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if json["code"].stringValue.isEmpty == false && json["code"].intValue == 0 {
                    callback()
                } else {
                    self.errorBlock?(NSError(domain: json["message"].stringValue, code: 0, userInfo: nil))
                }
                
            case .failure(let error):
                self.errorBlock?(NSError(domain: "上传失败", code: 0, userInfo: nil))
                print(error)
            }
        }
        
    }
        
    func showRenameAlert(callback: @escaping (String)->Void) {
        var nameTextField:UITextField!
        let alert = LEEAlert.alert()
        _ = alert.config.leeAddTitle { label in
            label.text = "修改昵称"
        }.leeAddTextField { textField in
            textField.placeholder = "请输入昵称"
            nameTextField = textField
        }.leeAddAction { action in
            action.title = "取消"
        }.leeAddAction { action in
            action.title = "确定"
            action.clickBlock = {
                if nameTextField.text!.count > 0 {
                    callback(nameTextField.text!)
                }
            }
        }.leeShow()
    }
    
    func showEditSignatureAlert(callback: @escaping (String)->Void) {
        var signatureTextField:UITextField!
        let alert = LEEAlert.alert()
        _ = alert.config.leeAddTitle { label in
            label.text = "修改签名"
        }.leeAddTextField { textField in
            textField.placeholder = "请输入签名"
            signatureTextField = textField
        }.leeAddAction { action in
            action.title = "取消"
        }.leeAddAction { action in
            action.title = "确定"
            action.clickBlock = {
                if signatureTextField.text!.count > 0 {
                    callback(signatureTextField.text!)
                }
            }
        }.leeShow()
    }
    
    
    /// 选择性别
    func showSexPicker(callback: @escaping (LHUserSex)->Void) {
        
        let sexs = ["男","女"]
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = sexs
        
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                callback(LHUserSex(rawValue: tempResult.index + 1)!)
            }
        }
        
        pickerView.show()
    }
    
    func showOpenSettingAlert(content:String) {
        let alert = LEEAlert.alert()
        _ = alert.config.leeAddTitle { label in
            label.text = "提示"
        }.leeAddContent { label in
            label.text = content
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
    }
}
