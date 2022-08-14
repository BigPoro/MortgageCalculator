//
//  LHLookHouseRecordModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit

enum LHHouseAgencyCompany:String,Codable {
    case lianjia = "链家"
    case beike = "贝壳"
    case soufang = "搜房网"
    case five8 = "58同城"
    case wawj = "我爱我家"
    case other = "其他"
    
    static let allValues = [lianjia, beike, soufang, five8, wawj,other]
}

enum LHHouseIntention:String,Codable {
    case strong = "强"
    case normal = "一般"
    case bad = "较差"
    
    static let allValues = [strong, normal, bad]
}

class LHLookHouseRecordModel:Codable,Equatable {
    static func == (lhs: LHLookHouseRecordModel, rhs: LHLookHouseRecordModel) -> Bool {
        return lhs.date == rhs.date
    }
    
    /// 小区名称
    var communityName: String = ""
    /// 带看人
    var agency:String = ""
    /// 中介公司 默认链家
    var agencyCompany:LHHouseAgencyCompany = .lianjia
    /// 带看日期
    var date:Date = Date()
    /// 面积
    var area:Double = 0
    /// 单价
    var unitPrice:Double = 0
    /// 意向 默认
    var intention:LHHouseIntention = .strong
    /// 照片 Data类型
    var photos = Array<Data>()
    /// 选中
    var isSelected = false
}
