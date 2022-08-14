//
//  File.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/20.
//

import Foundation
import Moya
import SwiftyJSON
import SVProgressHUD

let kHost = "http://mortgagecalculator.com"

let kLogoutNotiName = NSNotification.Name.init(rawValue: "kLogoutNotiName")

protocol LHNetworkTargetType: TargetType {
    /// 是否需要HUD
    var needsHUD: Bool { get }
}

struct LHNetworkPlugin: PluginType {

    //开始发起请求
    func willSend(_ request: RequestType, target: TargetType) {
        if let target = target as? LHNetworkTargetType, target.needsHUD {
            SVProgressHUD.show(withStatus: "加载中...")
        }
    }
    
    //收到请求
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        guard let target = target as? LHNetworkTargetType, target.needsHUD
            else {
            return
        }
        SVProgressHUD.dismiss()
        switch result {
        case .success(let response):
            let data = try? response.mapJSON()
            guard data != nil else {
                return
            }
            let json = JSON(data!)
            if json["code"].stringValue.isEmpty == false && json["code"].intValue != 0 {
                let message = json["message"].stringValue
                if message.isEmpty == false {
                    SVProgressHUD.showError(withStatus: message)
                }
                if json["code"].intValue == 401 {
                    
                    NotificationCenter.default.post(name: kLogoutNotiName, object: nil)
                    let vc = LHNavigationController.init(rootViewController: LHLoginController())
                    currentViewController()?.present(vc, animated: true, completion: nil)
                }
            }
            
        case .failure(let error):
            let message = error.errorDescription ?? "未知错误"
            SVProgressHUD.showError(withStatus: message)
            
            print(error)
        }
        
    }
}

