//
//  LHCacheHelper.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/11.
//

import Foundation
import Cache

let kCalcResultCacheKey     = "kCalcResultCache"
let kLookHouseCacheKey      = "kLookHouseCache"
let kUserInfoCacheKey       = "kUserInfoCacheKey"
let kTokenCacheKey          = "kUserInfoCacheKey"

class LHCacheHelper:NSObject {
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(cleanUserInfoData), name: kLogoutNotiName, object: nil)
    }
    
    static let helper = LHCacheHelper()
    
    @objc private func cleanUserInfoData () {
        _ = try? userStorage.removeAll()
        _ = try? tokenStorage.removeAll()
    }
    
    //MARK: 计算结果缓存
    private lazy var calcStorage = { () -> Storage<String, [LHLoanCalcResultModel]> in
        let diskConfig = DiskConfig(name: kCalcResultCacheKey)
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        let storage = try! Storage<String, [LHLoanCalcResultModel]>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: [LHLoanCalcResultModel].self)
        )
        return storage
    }()
    
    func saveCalcResultModel(model:LHLoanCalcResultModel, callback: @escaping (Bool)->Void) {
        var models = try? calcStorage.object(forKey: kCalcResultCacheKey)
        if models == nil {
            models = [LHLoanCalcResultModel]()
        }
        if models?.first?.date == model.date {
            callback(true)
            return
        }
        models?.insert(model, at: 0) // 插在第一个

        calcStorage.async.setObject(models!, forKey: kCalcResultCacheKey) { result in
          switch result {
            case .value:
              DispatchQueue.main.async {
                  callback(true)
              }
            case .error:
              DispatchQueue.main.async {
                  callback(false)
              }
          }
        }
    }
    
    func deleteCalcResultModel(model:LHLoanCalcResultModel, callback: @escaping (Bool)->Void) {
        var models = try? calcStorage.object(forKey: kCalcResultCacheKey)
        if models == nil {
            models = [LHLoanCalcResultModel]()
        }
        
        if models?.contains(model) == true {
            models!.remove(at: models!.firstIndex(of:model)!)
        }

        calcStorage.async.setObject(models!, forKey: kCalcResultCacheKey) { result in
          switch result {
            case .value:
              DispatchQueue.main.async {
                  callback(true)
              }
            case .error:
              DispatchQueue.main.async {
                  callback(false)
              }
          }
        }
    }
    
    func renameCalcResultModel(model:LHLoanCalcResultModel, newName:String, callback: @escaping (Bool)->Void) {
        var models = try? calcStorage.object(forKey: kCalcResultCacheKey)
        if models == nil {
            models = [LHLoanCalcResultModel]()
        }
        
        if models?.contains(model) == true {
            model.name = newName
        }

        calcStorage.async.setObject(models!, forKey: kCalcResultCacheKey) { result in
          switch result {
            case .value:
              DispatchQueue.main.async {
                  callback(true)
              }
            case .error:
              DispatchQueue.main.async {
                  callback(false)
              }
          }
        }
    }
    
    func readCalcResultModel(model:LHLoanCalcResultModel, callback: @escaping (Bool)->Void) {
        var models = try? calcStorage.object(forKey: kCalcResultCacheKey)
        if models == nil {
            models = [LHLoanCalcResultModel]()
        }
        
        if models?.contains(model) == true {
            model.isReaded = true
        }

        calcStorage.async.setObject(models!, forKey: kCalcResultCacheKey) { result in
          switch result {
            case .value:
              DispatchQueue.main.async {
                  callback(true)
              }
            case .error:
              DispatchQueue.main.async {
                  callback(false)
              }
          }
        }
    }
    
    func getCalcResultCache(callback: @escaping (Array<LHLoanCalcResultModel>?)->Void) {
        calcStorage.async.object(forKey: kCalcResultCacheKey) { result in
            
            switch result {
              case .value(let value):
                DispatchQueue.main.async {
                    callback(value)
                }
              case .error:
                DispatchQueue.main.async {
                    callback(nil)
                }
            }
        }
    }
    
    //MARK: 看房记录缓存
    private lazy var lookHouseStorage = { () -> Storage<String, [LHLookHouseRecordModel]> in
        let diskConfig = DiskConfig(name: kLookHouseCacheKey)
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        let storage = try! Storage<String, [LHLookHouseRecordModel]>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: [LHLookHouseRecordModel].self)
        )
        return storage
    }()
    
    func saveLookHouseRecordModel(model:LHLookHouseRecordModel, callback: @escaping (Bool)->Void) {
        var models = try? lookHouseStorage.object(forKey: kLookHouseCacheKey)
        if models == nil {
            models = [LHLookHouseRecordModel]()
        }
        if models?.first?.date == model.date {
            callback(true)
            return
        }
        models?.insert(model, at: 0) // 插在第一个

        lookHouseStorage.async.setObject(models!, forKey: kLookHouseCacheKey) { result in
          switch result {
            case .value:
              DispatchQueue.main.async {
                  callback(true)
              }
            case .error:
              DispatchQueue.main.async {
                  callback(false)
              }
          }
        }
    }
    
    func getLookHouseRecordCache(callback: @escaping (Array<LHLookHouseRecordModel>?)->Void) {
        lookHouseStorage.async.object(forKey: kLookHouseCacheKey) { result in
            switch result {
              case .value(let value):
                DispatchQueue.main.async {
                    callback(value)
                }
              case .error(let error):
                print(error)
                DispatchQueue.main.async {
                    callback(nil)
                }
            }
        }
    }
    
    func deletelLookHouseRecordModel(modelArray:[LHLookHouseRecordModel], callback: @escaping (Bool)->Void) {
        var models = try? lookHouseStorage.object(forKey: kLookHouseCacheKey)
        if models == nil {
            models = [LHLookHouseRecordModel]()
        }
        
        modelArray.forEach { model in
            if models?.contains(model) == true {
                models!.remove(at: models!.firstIndex(of:model)!)
            }
        }

        lookHouseStorage.async.setObject(models!, forKey: kLookHouseCacheKey) { result in
          switch result {
            case .value:
              DispatchQueue.main.async {
                  callback(true)
              }
            case .error:
              DispatchQueue.main.async {
                  callback(false)
              }
          }
        }
    }
    
    //MARK: 用户缓存
    private lazy var userStorage = { () -> Storage<String, LHUserModel> in
        let diskConfig = DiskConfig(name: kUserInfoCacheKey)
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        let storage = try! Storage<String, LHUserModel>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: LHUserModel.self)
        )
        return storage
    }()
    
    func getUserInfoModel() -> LHUserModel? {
        let model = try? userStorage.object(forKey: kUserInfoCacheKey)
        return model
    }
    
    func saveUserInfoModel(model:LHUserModel) -> Bool {
        let result: ()? = try? userStorage.setObject(model, forKey: kUserInfoCacheKey, expiry: nil)
        if result == nil {
            return true
        }
        return false
    }
    
    //MARK: Token缓存
    private lazy var tokenStorage = { () -> Storage<String, String> in
        let diskConfig = DiskConfig(name: kTokenCacheKey)
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        let storage = try! Storage<String, String>(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: String.self)
        )
        return storage
    }()
    
    func getToken() -> String? {
        let model = try? tokenStorage.object(forKey: kTokenCacheKey)
        return model
    }
    
    func saveToken(token:String)  {
        _ = try? tokenStorage.setObject(token, forKey: kTokenCacheKey, expiry: nil)
    }
    func removeToken()  {
        _ = try? tokenStorage.removeAll()
    }
}

