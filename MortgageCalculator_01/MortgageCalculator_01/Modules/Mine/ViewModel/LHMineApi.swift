//
//  LHMineApi.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/20.
//

import Foundation
import Moya

let LHMineProvider = MoyaProvider<LHMineAPI>(plugins: [LHNetworkPlugin()])


public enum LHMineAPI {
    case getUserInfo
    case updateUserInfo(parameter:Dictionary<String, String>)
    case updateAvatar(avatar:Data)
}

extension LHMineAPI: LHNetworkTargetType {
    public var baseURL: URL { return URL(string: kHost)! }
    
    public var path: String {
        switch self {
        case .getUserInfo:
            return ""
        case .updateUserInfo:
            return ""
        case .updateAvatar:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
            
        case .updateUserInfo(let parameter):
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            
        case .updateAvatar(let data):

            let formData = MultipartFormData(provider: .data(data), name: "avatar",
                                             fileName: "avatar", mimeType: "image/jpeg")

            return .uploadMultipart([formData])
        
        default:
            return .requestPlain
        }
    }
    public var headers: [String: String]? {
        if let token = LHCacheHelper.helper.getToken() {
            return ["token":token]
        }
        return nil
    }
    
    public var needsHUD: Bool {
        switch self {
        case .getUserInfo:
            return false
        default:
            return true
        }
    }
}
