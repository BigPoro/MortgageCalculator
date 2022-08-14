//
//  LHLoginViewModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/19.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class LHLoginViewModel: LHBaseViewModel {
    var phoneNum = ""
    var authCode = ""
    var password = ""
    /// register:注册 retrievePassword:找回密码 codelLogin:验证码登录
    var type = ""
    var checkedAgressment = false
    
    /// 获取验证码
    func getAuthCode( callback: @escaping (()->Void)) {
        if phoneNum.isEmpty {
            errorBlock?(NSError(domain: "请输入手机号码", code: 0, userInfo: nil))
            return
        }

    }
    
    /// 密码登录
    func loginWithPassword( callback: @escaping (()->Void)) {
        if phoneNum.isEmpty {
            errorBlock?(NSError(domain: "请输入手机号码", code: 0, userInfo: nil))
            return
        }
        if password.isEmpty {
            errorBlock?(NSError(domain: "请输入密码", code: 0, userInfo: nil))
            return
        }
        if checkedAgressment == false {
            errorBlock?(NSError(domain: "请阅读并同意用户协议", code: 0, userInfo: nil))
            return
        }

    }

    /// 验证码登录
    func loginWithAuthCode(callback: @escaping (()->Void)) {
        if phoneNum.isEmpty {
            errorBlock?(NSError(domain: "请输入手机号码", code: 0, userInfo: nil))
            return
        }
        if authCode.isEmpty {
            errorBlock?(NSError(domain: "请输入验证码", code: 0, userInfo: nil))
            return
        }
        if checkedAgressment == false {
            errorBlock?(NSError(domain: "请阅读并同意用户协议", code: 0, userInfo: nil))
            return
        }
    }
    
    /// 找回密码
    func findPassword(callback: @escaping (()->Void)) {
        if phoneNum.isEmpty {
            errorBlock?(NSError(domain: "请输入手机号码", code: 0, userInfo: nil))
            return
        }
        if authCode.isEmpty {
            errorBlock?(NSError(domain: "请输入验证码", code: 0, userInfo: nil))
            return
        }
        if password.isEmpty {
            errorBlock?(NSError(domain: "请输入新密码", code: 0, userInfo: nil))
            return
        }

    }
    /// 注册
    func registerAction(callback: @escaping (()->Void)) {
        if phoneNum.isEmpty {
            errorBlock?(NSError(domain: "请输入手机号码", code: 0, userInfo: nil))
            return
        }
        if authCode.isEmpty {
            errorBlock?(NSError(domain: "请输入验证码", code: 0, userInfo: nil))
            return
        }
        if password.isEmpty {
            errorBlock?(NSError(domain: "请输入密码", code: 0, userInfo: nil))
            return
        }
        if checkedAgressment == false {
            errorBlock?(NSError(domain: "请阅读并同意用户协议", code: 0, userInfo: nil))
            return
        }

    }
    
    /// 获取隐私协议
    func getUsePolicy( callback: @escaping ((String)->Void)) {
        

    }
    
    /// 获取用户协议
    func getUserPolicy( callback: @escaping ((String)->Void)) {
        

    }
    
}
