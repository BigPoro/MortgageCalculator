//
//  LHHouseToolViewModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import UIKit
import BRPickerView

class LHHouseToolViewModel: NSObject {
    
    lazy var propertyTaxCalcModel = LHPropertyTaxCalcModel()
    lazy var housePurchasCalcModel = LHHousePurchasCalcModel()
    lazy var daylightingCalcModel = LHDaylightingCalcModel()
    
    lazy var cityList = [LHCityModel]()
    /// 选择按揭年数
    func showPaymentYearsPicker(callback: @escaping (String)->Void) {
        var years = Array<String>()
        for i in 1..<31 {
            let yearDesc = "\(i)年\(i*12)期"
            years.append(yearDesc)
        }
        
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = years.reversed()
        pickerView.selectIndex = 15 // 默认选中15年
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                let title = years.reversed()[tempResult.index]
                self.housePurchasCalcModel.loanYear = Double(30 - tempResult.index)
                callback(title)
            }
        }
 
        pickerView.show()
    }
    
    /// 选择城市
    func showCityPicker(callback: @escaping (LHCityModel)->Void) {
        if cityList.isEmpty {
            // 解析本地文件
            let jsonPath = Bundle.main.url(forResource: "CityList", withExtension: "json")
            do {
                
                let jsonData = try Data(contentsOf: jsonPath!)
                let decoder = JSONDecoder()
                let result = try? decoder.decode([LHCityModel].self, from: jsonData)
                if result != nil {
                    cityList = result!
                }
                print(result ?? "城市列表解析失败")
            } catch {
                print("城市列表解析失败>>>>error:\(error)")
            }
        }
        
        let cityNames = cityList.map { city in
            return city.name
        }
        
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = cityNames
        pickerView.selectIndex = 0 //
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                let city = self.cityList[tempResult.index]
                self.daylightingCalcModel.city = city.name
                self.daylightingCalcModel.latitude = city.latitude
                self.daylightingCalcModel.longitude = city.longitude
                callback(city)
            }
        }
        
        pickerView.show()
    }
}
