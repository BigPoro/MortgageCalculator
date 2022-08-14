//
//  LHMortgageCalculator.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import Foundation
import BRPickerView
import LEEAlert

class LHLoanCalcViewModel:NSObject {
    
    lazy var calcModel = LHLoanCalcModel()
    
    /// 选择计算方式
    func showCalcTypePicker(callback: @escaping (String)->Void) {
        let titles = ["根据面积、单价计算","根据贷款总额计算"]
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = titles
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                let title = titles[tempResult.index]
                self.calcModel.calcType = tempResult.index
                callback(title)
            }
        }
 
        pickerView.show()
    }
    
    /// 选择按揭成数
    func showPaymentProportionPicker(callback: @escaping (String)->Void) {
        let titles = ["2.0成","2.5成","3.0成","3.5成","4.0成","4.5成","5.0成","5.5成","6.0成","6.5成","7.0成","7.5成","8.0成"]
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = titles
        pickerView.selectIndex = 9 // 默认选中6.5
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                let title = titles[tempResult.index]
                self.calcModel.loanMulti = Double(titles[tempResult.index].prefix(3))!
                callback(title)
            }
        }
 
        pickerView.show()
    }
    /// 选择按揭年数
    func showPaymentYearsPicker(callback: @escaping (String)->Void) {
        var years = Array<String>()
        for i in 1..<31 {
            let yearDesc = "\(i)年\(i*12)期"
            years.append(yearDesc)
        }
        
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = years.reversed()
        pickerView.selectIndex = 0 // 默认选中30年
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                let title = years.reversed()[tempResult.index]
                self.calcModel.loanYear = Double(30 - tempResult.index)
                callback(title)
            }
        }
 
        pickerView.show()
    }
    /// 选择商贷利率
    func showBusinessRatePicker(callback: @escaping ()->Void) {
        let rateDescs = ["7折（3.43%）","75折（3.68%）","8折（3.92%）","85折（4.17%）","9折（4.41%)","95折（4.66%)",
                     "基准利率（4.90%）","上浮5(5.15%)","上浮10（5.39%）","上浮15（5.63%）","上浮20（5.88%）","上浮25（6.12%）","上浮30(6.37%)","上浮35（6.62%）","上浮40（6.86%）","上浮45（7.11%）","上浮50（7.35%）"]
        let rates = [3.43,3.68,3.92,4.17,4.41,4.66,
                     4.90,5.15,5.39,5.63,5.88,6.12,6.37,6.62,6.86,7.11,7.35]
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = rateDescs
        pickerView.selectIndex = 6 // 默认选中基准
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                self.calcModel.bankRate = rates[tempResult.index]
                callback()
            }
        }
 
        pickerView.show()
    }
    
    /// 选择公积金贷利率
    func showFundRatePicker(callback: @escaping ()->Void) {
        let rateDescs = ["7折（2.28%）","85折（2.76%）",
                     "基准利率（3.25%）","上浮5(3.41%)","上浮10（3.57%）"]
        let rates = [2.28,2.76,3.25,3.41,3.57]
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = rateDescs
        pickerView.selectIndex = 2 // 默认选中基准
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                
                self.calcModel.fundRate = rates[tempResult.index]
                callback()
            }
        }
 
        pickerView.show()
    }
    
    func showRenameAlert(model:LHLoanCalcResultModel,callback: @escaping (String)->Void) {
        var nameTextField:UITextField!
        let alert = LEEAlert.alert()
        _ = alert.config.leeAddTitle { label in
            label.text = "修改名称"
        }.leeAddTextField { textField in
            textField.placeholder = "请输入名称"
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
    
    /// 选择开始时间
    func showBeginDatePicker(callback: @escaping (Date)->Void) {
        
        let pickerView = BRDatePickerView()
        pickerView.isShowToday = true
        pickerView.resultBlock = { (selectDate, selectValue) in
            callback(selectDate!)
        }
 
        pickerView.show()
    }
    /// 选择结束时间
    func showEndDatePicker(callback: @escaping (Date)->Void) {
        
        let pickerView = BRDatePickerView()
        pickerView.resultBlock = { (selectDate, selectValue) in
            callback(selectDate!)
        }
 
        pickerView.show()
    }
}
