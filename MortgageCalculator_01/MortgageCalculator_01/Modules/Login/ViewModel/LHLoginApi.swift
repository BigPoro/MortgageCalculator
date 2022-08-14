//
//  LHLoginApi.swift.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/19.
//

import Foundation
import Moya

let LHLoginProvider = MoyaProvider<LHLoginAPI>(plugins: [LHNetworkPlugin()])

public enum LHLoginAPI {
    case getAuthCode(phoneNum:String,type:String)
    case loginWithPassword(phoneNum:String,passoword:String)
    case loginWithAuthCode(phoneNum:String,authCode:String)
    case register(phoneNum:String,passoword:String,authCode:String)
    case findPassword(phoneNum:String,passoword:String,authCode:String)
    case getUsePolicy
    case getUserPolicy
}

extension LHLoginAPI: LHNetworkTargetType {
    public var baseURL: URL { return URL(string: kHost)! }
    
    public var path: String {
        switch self {
        case .getAuthCode:
            return ""
        case .loginWithPassword:
            return ""
        case .loginWithAuthCode:
            return ""
        case .register:
            return ""
        case .findPassword:
            return ""
        case .getUsePolicy:
            return ""
        case .getUserPolicy:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserPolicy,.getUsePolicy:
            return .get
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .getAuthCode(let phoneNum,let type):
            return .requestParameters(parameters: ["phone_number": phoneNum,"type":type], encoding: URLEncoding.default)
            
        case .loginWithPassword(let phoneNum,let password):
            return .requestParameters(parameters: ["phone_number": phoneNum,"password":password], encoding: URLEncoding.default)
            
        case .loginWithAuthCode(let phoneNum,let code):
            return .requestParameters(parameters: ["phone_number": phoneNum,"code":code], encoding: URLEncoding.default)
            
        case .register(let phoneNum,let password,let code):
            return .requestParameters(parameters: ["phone_number": phoneNum,"password":password,"code":code], encoding: URLEncoding.default)
            
        case .findPassword(let phoneNum,let password,let code):
            return .requestParameters(parameters: ["phone_number": phoneNum,"password":password,"code":code], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }

    }
    public var headers: [String: String]? {
        return nil
    }

    public var needsHUD: Bool {
        return true
    }
}
