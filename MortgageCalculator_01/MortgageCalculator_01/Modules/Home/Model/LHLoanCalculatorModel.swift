//
//  LHLoanCalculatorModel.swift
//  LoanCalculator_01
//
//  Created by iDog on 2021/12/9.
//

import Foundation

struct LHLoanCalcModel {
    /// 计算方式 0根据面积单价计算 1根据贷款总额
    var calcType = 0
    /// 单价
    var unitPrice: Double = 0
    /// 面积
    var area: Double = 0
    /// 商业贷款总额
    var businessTotalPrice: Double = 0.0
    /// 公积金贷款总额
    var fundTotalPrice: Double = 0.0
    /// 银行利率 默认为LPR4.65
    var bankRate: Double = 4.65
    /// 公积金利率 默认为LPR3.25
    var fundRate: Double = 3.25
    /// 按揭年数
    var loanYear: Double = 30.0
    /// 按揭成数
    var loanMulti: Double = 6.5
    /// 基点
    var basePoint: Double = 0.0
    /// 还款方式 1等额本息 2等额本金
    var mode:Int = 1
    
    //MARK: 商业贷款 等额本息
    /// 商业贷款 等额本息
    func calculateBusinessLoanAsTotalPriceAndEqualPrincipalInterest () -> LHLoanCalcResultModel {
        /// 房屋总价
        let houseTotalPrice = unitPrice * area
        /// 按揭月数
        let loanMonthCount = loanYear * 12
        /// 贷款总额
        let loanTotalPrice = calcType == 0 ? houseTotalPrice * loanMulti / 10 : businessTotalPrice * 10000
        /// 月利率
        let monthRate = (bankRate + basePoint / 100) / 100.0 / 12.0
        /// 每月还款
        let avgMonthRepayment = loanTotalPrice * monthRate * pow(1 + monthRate, loanMonthCount) / (pow(1 + monthRate, loanMonthCount) - 1)
        /// 还款总额
        let repayTotalPrice = avgMonthRepayment * loanMonthCount
        /// 总利息
        let interestPayment = repayTotalPrice - loanTotalPrice
        
        let result = LHLoanCalcResultModel()
        result.type = .business
        result.calcType = calcType
        result.houseTotalPrice = houseTotalPrice
        result.loanTotalPrice = loanTotalPrice
        result.repayTotalPrice = repayTotalPrice
        result.firstPayment = houseTotalPrice - loanTotalPrice
        result.interestPayment = interestPayment
        result.loanMonth = loanYear * 12
        var temploanTotalPrice = loanTotalPrice
        for month in 0..<Int(loanMonthCount) {
            let monthRepayment = LHMonthRepaymentModel()
            /// 期
            monthRepayment.month = month + 1
            /// 每期还款
            monthRepayment.monthRepayment = avgMonthRepayment
            /// 每期利息
            monthRepayment.monthInterest = temploanTotalPrice * monthRate
            /// 每期本金
            monthRepayment.monthPrincipal = avgMonthRepayment - monthRepayment.monthInterest
            /// 剩余本金
            temploanTotalPrice -= monthRepayment.monthPrincipal
            monthRepayment.remainingPrincipal = temploanTotalPrice
            result.monthRepaymentArr.append(monthRepayment)
        }
        return result
    }
    //MARK: 商业贷款 等额本金
    /// 商业贷款 等额本金
    func calculateBusinessLoanAsTotalPriceAndEqualPrincipal() -> LHLoanCalcResultModel {
        /// 房屋总价
        let houseTotalPrice = unitPrice * area
        /// 按揭月数
        let loanMonthCount = loanYear * 12
        /// 贷款总额
        let loanTotalPrice = calcType == 0 ? houseTotalPrice * loanMulti / 10 : businessTotalPrice * 10000
        /// 月利率
        let monthRate = (bankRate + basePoint / 100) / 100.0 / 12.0
        /// 每月本金
        let avgMonthPrincipalRepayment = loanTotalPrice / loanMonthCount
        
        let result = LHLoanCalcResultModel()
        result.calcType = calcType
        result.type = .business
        result.houseTotalPrice = houseTotalPrice
        result.loanTotalPrice = loanTotalPrice
        result.firstPayment = houseTotalPrice - loanTotalPrice
        result.loanMonth = loanYear * 12
        
        /// 还款总额
        var repayTotalPrice:Double = 0
        /// 剩余本金
        var temploanTotalPrice:Double = loanTotalPrice
        for month in 0..<Int(loanMonthCount) {
            let monthRepayment = LHMonthRepaymentModel()
            /// 期
            monthRepayment.month = month + 1
            /// 每期利息
            monthRepayment.monthInterest = (loanTotalPrice - avgMonthPrincipalRepayment * Double((month))) * monthRate
            /// 每期还款
            monthRepayment.monthRepayment = avgMonthPrincipalRepayment + monthRepayment.monthInterest;
            /// 每期本金
            monthRepayment.monthPrincipal = avgMonthPrincipalRepayment
            /// 剩余本金
            temploanTotalPrice -= monthRepayment.monthPrincipal
            monthRepayment.remainingPrincipal = temploanTotalPrice
            result.monthRepaymentArr.append(monthRepayment)
            // 累加还款总额
            repayTotalPrice += monthRepayment.monthRepayment;
        }
        result.repayTotalPrice = repayTotalPrice;
        return result
    }

    //MARK: 公积金贷款 等额本息
    
    /// 公积金贷款 等额本息
    func calculateFundLoanAsUnitPriceAndEqualPrincipalInterest () -> LHLoanCalcResultModel {
        /// 房屋总价
        let houseTotalPrice = unitPrice * area
        /// 按揭月数
        let loanMonthCount = loanYear * 12
        /// 贷款总额
        let loanTotalPrice = calcType == 0 ? houseTotalPrice * loanMulti / 10 : fundTotalPrice * 10000
        /// 月利率
        let monthRate = fundRate / 100.0 / 12.0
        /// 每月还款
        let avgMonthRepayment = loanTotalPrice * monthRate * pow(1 + monthRate, loanMonthCount) / (pow(1 + monthRate, loanMonthCount) - 1)
        /// 还款总额
        let repayTotalPrice = avgMonthRepayment * loanMonthCount
        /// 总利息
        let interestPayment = repayTotalPrice - loanTotalPrice
        
        let result = LHLoanCalcResultModel()
        result.calcType = calcType
        result.type = .fund
        result.houseTotalPrice = houseTotalPrice
        result.loanTotalPrice = loanTotalPrice
        result.repayTotalPrice = repayTotalPrice
        result.firstPayment = houseTotalPrice - loanTotalPrice
        result.interestPayment = interestPayment
        result.loanMonth = loanYear * 12
        
        var temploanTotalPrice = loanTotalPrice
        for month in 0..<Int(loanMonthCount) {
            let monthRepayment = LHMonthRepaymentModel()
            /// 期
            monthRepayment.month = month + 1
            /// 每期还款
            monthRepayment.monthRepayment = avgMonthRepayment
            /// 每期利息
            monthRepayment.monthInterest = temploanTotalPrice * monthRate
            /// 每期本金
            monthRepayment.monthPrincipal = avgMonthRepayment - monthRepayment.monthInterest
            /// 剩余本金
            temploanTotalPrice -= monthRepayment.monthPrincipal
            monthRepayment.remainingPrincipal = temploanTotalPrice
            result.monthRepaymentArr.append(monthRepayment)
        }
        return result
    }
    
    //MARK: 公积金贷款 等额本金
    /// 公积金贷款 等额本金
    func calculateFundLoanAsUnitPriceAndEqualPrincipal() -> LHLoanCalcResultModel {
        /// 房屋总价
        let houseTotalPrice = unitPrice * area
        /// 按揭月数
        let loanMonthCount = loanYear * 12
        /// 贷款总额
        let loanTotalPrice = calcType == 0 ? houseTotalPrice * loanMulti / 10 : fundTotalPrice * 10000
        /// 月利率
        let monthRate = fundRate / 100.0 / 12.0
        /// 每月本金
        let avgMonthPrincipalRepayment = loanTotalPrice / loanMonthCount
        
        let result = LHLoanCalcResultModel()
        result.calcType = calcType
        result.type = .fund
        result.houseTotalPrice = houseTotalPrice
        result.loanTotalPrice = loanTotalPrice
        result.firstPayment = houseTotalPrice - loanTotalPrice
        result.loanMonth = loanYear * 12
        
        /// 还款总额
        var repayTotalPrice:Double = 0
        /// 剩余本金
        var temploanTotalPrice:Double = loanTotalPrice
        for month in 0..<Int(loanMonthCount) {
            let monthRepayment = LHMonthRepaymentModel()
            /// 期
            monthRepayment.month = month + 1
            /// 每期利息
            monthRepayment.monthInterest = (loanTotalPrice - avgMonthPrincipalRepayment * Double((month))) * monthRate
            /// 每期还款
            monthRepayment.monthRepayment = avgMonthPrincipalRepayment + monthRepayment.monthInterest;
            /// 每期本金
            monthRepayment.monthPrincipal = avgMonthPrincipalRepayment
            /// 剩余本金
            temploanTotalPrice -= monthRepayment.monthPrincipal
            monthRepayment.remainingPrincipal = temploanTotalPrice
            result.monthRepaymentArr.append(monthRepayment)
            // 累加还款总额
            repayTotalPrice += monthRepayment.monthRepayment
        }
        result.repayTotalPrice = repayTotalPrice;
        result.interestPayment = repayTotalPrice - loanTotalPrice

        return result
    }
    //MARK: 组合型贷款等额本息总价计算(总价)
    /// 组合型贷款等额本息总价计算(总价)
    mutating func calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterest () -> LHLoanCalcResultModel {
        businessTotalPrice *= 10000
        fundTotalPrice *= 10000
        // 贷款月数
        let loanMonthCount = loanYear * 12;
        // 银行月利率
        let bankMonthRate = (bankRate + basePoint / 100) / 100.0 / 12.0 
        // 公积金月利率
        let fundMonthRate = fundRate / 100.0 / 12.0;
        // 贷款总额
        let loanTotalPrice = businessTotalPrice + fundTotalPrice;
        // 每月还款
        let businessAvgMonthRepayment = businessTotalPrice * bankMonthRate * pow(1 + bankMonthRate, loanMonthCount) / (pow(1 + bankMonthRate, loanMonthCount) - 1)
        let fundAvgMonthRepayment = fundTotalPrice * fundMonthRate * pow( 1 + fundMonthRate, loanMonthCount) / (pow( 1 + fundMonthRate, loanMonthCount) - 1)
        let avgMonthRepayment:Double = businessAvgMonthRepayment + fundAvgMonthRepayment
        // 还款总额
        let repayTotalPrice = avgMonthRepayment * loanMonthCount
        // 支付利息
        let interestPayment = repayTotalPrice - loanTotalPrice
        
        let result = LHLoanCalcResultModel()
        result.type = .combined
        result.houseTotalPrice = businessTotalPrice + fundTotalPrice
        result.loanTotalPrice = loanTotalPrice
        result.repayTotalPrice = repayTotalPrice
        result.interestPayment = interestPayment
        result.loanMonth = loanYear * 12
        
        var temploanTotalPrice = loanTotalPrice
        for month in 0..<Int(loanMonthCount) {
            let monthRepayment = LHMonthRepaymentModel()
            /// 期
            monthRepayment.month = month + 1
            /// 每期还款
            monthRepayment.monthRepayment = avgMonthRepayment
            /// 每期利息
            monthRepayment.monthInterest = businessTotalPrice * bankMonthRate + fundTotalPrice * fundMonthRate
            /// 每期本金
            monthRepayment.monthPrincipal = avgMonthRepayment - monthRepayment.monthInterest
            /// 剩余本金
            temploanTotalPrice -= monthRepayment.monthPrincipal
            monthRepayment.remainingPrincipal = temploanTotalPrice
            result.monthRepaymentArr.append(monthRepayment)
        }
        return result
    }
    //MARK: 组合型贷款等额本金总价计算(总价)
    /// 组合型贷款等额本金总价计算(总价)
    mutating func calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel() -> LHLoanCalcResultModel {
        businessTotalPrice *= 10000
        fundTotalPrice *= 10000
        // 贷款月数
        let loanMonthCount = loanYear * 12;
        // 银行月利率
        let bankMonthRate = (bankRate + basePoint / 100) / 100.0 / 12.0
        // 公积金月利率
        let fundMonthRate = fundRate / 100.0 / 12.0
        // 贷款总额
        let loanTotalPrice = businessTotalPrice + fundTotalPrice;
        // 商业每月所还本金（每月还款）
        let businessAvgMonthPrincipalRepayment = businessTotalPrice / loanMonthCount;
        // 公积金每月所还本金（每月还款）
        let fundAvgMonthPrincipalRepayment = fundTotalPrice / loanMonthCount;
        
        let result = LHLoanCalcResultModel()
        result.type = .combined
        result.loanTotalPrice = loanTotalPrice
        result.loanMonth = loanMonthCount
        
        /// 还款总额
        var repayTotalPrice:Double = 0
        /// 剩余本金
        var temploanTotalPrice:Double = loanTotalPrice
        for month in 0..<Int(loanMonthCount) {
            let monthRepayment = LHMonthRepaymentModel()
            /// 期
            monthRepayment.month = month + 1
            /// 每期利息
            monthRepayment.monthInterest = (businessTotalPrice - businessAvgMonthPrincipalRepayment * Double(month)) * bankMonthRate + (fundTotalPrice - fundAvgMonthPrincipalRepayment * Double(month)) * fundMonthRate
            /// 每期还款
            monthRepayment.monthRepayment = businessAvgMonthPrincipalRepayment + fundAvgMonthPrincipalRepayment + monthRepayment.monthInterest
            /// 每期本金
            monthRepayment.monthPrincipal = businessAvgMonthPrincipalRepayment + fundAvgMonthPrincipalRepayment
            /// 剩余本金
            temploanTotalPrice -= monthRepayment.monthPrincipal
            monthRepayment.remainingPrincipal = temploanTotalPrice
            result.monthRepaymentArr.append(monthRepayment)
            // 累加还款总额
            repayTotalPrice += monthRepayment.monthRepayment
        }
        result.repayTotalPrice = repayTotalPrice
        result.interestPayment = repayTotalPrice - loanTotalPrice

        return result
    }
    
}

enum LHLoanCalcResultType:Codable {
    /// 商业贷款
    case business
    /// 公积金贷款
    case fund
    /// 组合贷款
    case combined
}

class LHMonthRepaymentModel:NSObject, Codable  {
    /// 期
    var month: Int = 1
    /// 每期还款
    var monthRepayment: Double = 0.0
    /// 每期本金
    var monthPrincipal: Double = 0.0
    /// 每期利息
    var monthInterest: Double = 0.0
    /// 剩余本金
    var remainingPrincipal: Double = 0.0
}

class LHLoanCalcResultModel:NSObject, Codable {
    /// 计算方式 0根据面积单价计算 1根据贷款总额
    var calcType = 0
    var type:LHLoanCalcResultType = .business
    var name:String?
    var date:Date = Date()
    /// 已读
    var isReaded = false
    /// 房屋总价
    var houseTotalPrice: Double = 0.0
    /// 贷款总额
    var loanTotalPrice: Double = 0.0
    /// 还款总额
    var repayTotalPrice: Double = 0.0
    /// 首付
    var firstPayment: Double = 0.0
    /// 支付利息
    var interestPayment: Double = 0.0
    /// 按揭月数
    var loanMonth: Double = 0.0
    /// 每月还款数组
    var monthRepaymentArr: [LHMonthRepaymentModel] = Array()
}

