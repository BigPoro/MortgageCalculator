//
//  LHToolsCalculatorModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/15.
//

import Foundation

//MAKR: 采光

struct LHDaylightingCalcModel {
    var city = "北京"
    /// 经度
    var longitude = -115.4
    /// 纬度
    var latitude = 39.9
    /// 我的楼层
    var myFloor:Double = 0
    /// 我的层高
    var myFloorHeigth:Double = 0
    /// 遮阳楼层
    var coverFloor:Double = 0
    /// 遮阳楼层高
    var coverFloorHeigth:Double = 0
    /// 楼间距
    var floorSpacing: Double = 0
    func calculateDaylighting () -> LHDaylightingCalcResultModel {
        
        let floorHeigth = (myFloorHeigth + coverFloorHeigth) / 2 // 层高取平均值
        let angle = atan((coverFloor - myFloor) * floorHeigth / floorSpacing)
        let result = 90 - angle - latitude
        
        var resultModel = LHDaylightingCalcResultModel()
        resultModel.result = result
        return resultModel
    }
}

struct LHDaylightingCalcResultModel {
    var result:Double = 0
    var resultDesc:String {
        get {
            if result > 0 {
                return "计算得出本楼的采光良好，不存在问题。"
            } else {
                return "计算得出本楼的采光不足，采光有所限制。"
            }
        }
    }
}

struct LHCityModel:Codable {
    var longitude:Double = 0
    var latitude:Double = 0
    var name = ""
}

//MARK: 房产税
struct LHPropertyTaxCalcModel {
    /// 单价
    var unitPrice: Double = 0
    /// 面积
    var area: Double = 0
    
    func calculatePropertyTax () -> LHPropertyTaxCalcResultModel {
        let houseTotalPrice = unitPrice * area
        var resultModel = LHPropertyTaxCalcResultModel()
        
        resultModel.houseTotalPrice = houseTotalPrice // 总价
        resultModel.stampDutyPrice = houseTotalPrice * 0.0005 // 印花税
        resultModel.notaryFee = houseTotalPrice * 0.003 // 公证费
        resultModel.commissionFee = houseTotalPrice * 0.003 // 委托手续费
        // 契税
        if (unitPrice <= 9432) {
            resultModel.deedTaxFee = houseTotalPrice * 0.015
        } else if (unitPrice > 9432) {
            resultModel.deedTaxFee = houseTotalPrice * 0.03
        }
        // 买卖手续费
        if (area <= 120) {
            resultModel.transactionFee = 500
        } else if (area <= 5000 && area > 120) {
            resultModel.transactionFee = 1500
        }
        if (area > 5000) {
            resultModel.transactionFee = 5000
        }
        return resultModel
    }
}

struct LHPropertyTaxCalcResultModel {
    /// 房款总价
    var houseTotalPrice:Double = 0
    /// 印花税
    var stampDutyPrice:Double = 0
    /// 公证费
    var notaryFee:Double = 0
    /// 契税
    var deedTaxFee:Double = 0
    /// 委托办理产权手续费
    var commissionFee:Double = 0
    /// 房屋买卖手续费
    var transactionFee:Double = 0
}

//MARK: 购房能力
struct LHHousePurchasCalcModel {
    /// 购房资金 万元
    var houseMoney: Double = 0
    /// 家庭月收入
    var monthIncome: Double = 0
    /// 每月购房支出
    var monthHouseExpenditure: Double = 0
    /// 贷款年限 默认15年
    var loanYear: Double = 15
    /// 面积
    var area: Double = 0
    
    func calculateHousePurchasAssessment () -> LHHousePurchasCalcResultModel {
        let yhz = [1.978, 2.9344, 3.8699, 4.7847, 5.6794, 6.5544, 7.4102, 8.2472, 9.0657, 9.8662, 10.6491, 11.4148, 12.1636, 12.8959, 13.6121, 14.3126, 14.9977, 15.6677, 16.3229, 16.9637, 17.5904, 18.2034, 18.8028, 19.389, 19.9624, 20.5231, 21.0715, 21.6078, 22.1323]
        let rhb = [440.104, 301.103, 231.7, 190.136, 163.753, 144.08, 129.379, 117.991, 108.923, 101.542, 95.425, 90.282, 85.902, 82.133, 78.861, 75.997, 73.473, 71.236, 69.241, 67.455, 65.848, 64.397, 63.082, 61.887, 60.798, 59.802, 58.890, 58.052, 57.282]
        let js00 = houseMoney * 10000; // 购房资金
        let js01 = monthHouseExpenditure;
        var js02 = (js01 / rhb[Int(loanYear * 12) / 12 - 2]) * 10000;
        let js03 = area;
        if (js02 > js00 * 3.2) {
            js02 = js00 * 3.2;
        }
        
        let rs_1 = ((js02 + 0.8 * js00) * 100) / 100; // 可购买的房屋总价
        let rs_2 = (rs_1 / js03 * 100) / 100; // 可购买的房屋单价
        let rs_3 = js03 < 120 ? (rs_1 * 2) / 100 : ((rs_1 - rs_2 * 120) * 4 + rs_2 * 120 * 2) / 100 // 契税
        let rs_4 = (rs_1 * 2) / 100; // 公共维修基金
        let rs_5 = (rs_1*20)/100; // 首付款
        let rs_6 = (rs_1*0.05/100*yhz[Int(loanYear * 12)/12-2]*100)/100; // 保险费
        let rs_7 = (rs_1*0.3)/100; // 律师费
        
        var resultModel = LHHousePurchasCalcResultModel()
        resultModel.houseTotalPrice = rs_1
        resultModel.houseUnitPrice = rs_2
        resultModel.deedTaxPrice = rs_3
        resultModel.publicMaintenanceFund = rs_4
        resultModel.firstPayment = rs_5
        resultModel.insurance = rs_6
        resultModel.lawyerFee = rs_7
        return resultModel
    }
}

struct LHHousePurchasCalcResultModel {
    /// 可购买的房屋总价
    var houseTotalPrice:Double = 0
    /// 可购买的房屋单价
    var houseUnitPrice:Double = 0
    /// 契税
    var deedTaxPrice:Double = 0
    /// 公共维修基金
    var publicMaintenanceFund:Double = 0
    /// 首付款
    var firstPayment:Double = 0
    /// 保险费
    var insurance:Double = 0
    /// 律师费
    var lawyerFee:Double = 0
    /// 抵押登记费
    var registrationFee = "200~500"
}
