//
//  LHLookHouseViewModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import BRPickerView
import SwiftDate
class LHLookHouseViewModel: NSObject {
    var allRecord = [LHLookHouseRecordModel]()
    /// 新增看房记录
    lazy var newRecord = LHLookHouseRecordModel()
    var filterDate = Date()
    var filterKeywords:String? = nil
    var filterAgency:LHHouseAgencyCompany? = nil
    var filterIntention:LHHouseIntention? = nil
    
    override init() {
        super.init()
        getAllLookHouseRecord(callback: nil)
    }
    
    /// 意向
    func showIntentionPicker(callback: @escaping (LHHouseIntention?)->Void) {
        var types = LHHouseIntention.allValues.map { intention in
            return intention.rawValue
        }
        types.insert("全部", at: 0)
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = types
        pickerView.selectIndex = 0
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                if tempResult.index == 0 {
                    callback(nil)
                } else {
                    callback(LHHouseIntention.allValues[tempResult.index - 1])
                }
            }
        }
 
        pickerView.show()
    }
    
    /// 选择中介
    func showAgencyCompanyPicker(callback: @escaping (LHHouseAgencyCompany?)->Void) {
        var types = LHHouseAgencyCompany.allValues.map { agency in
            return agency.rawValue
        }
        types.insert("全部", at: 0)
        let pickerView = BRStringPickerView(pickerMode: .componentSingle)
        pickerView.dataSourceArr = types
        pickerView.selectIndex = 0
        pickerView.resultModelBlock =  { result in
            if let tempResult = result {
                if tempResult.index == 0 {
                    callback(nil)
                } else {
                    callback(LHHouseAgencyCompany.allValues[tempResult.index - 1])
                }
            }
        }
        pickerView.show()
    }
    
    /// 选择过滤时间
    func showFilterDatePicker(callback: @escaping (Date)->Void) {
        
        let pickerView = BRDatePickerView()
        pickerView.pickerMode = .YM
        pickerView.resultBlock = { (selectDate, selectValue) in
            if let value = selectValue {
                callback(value.toDate("yyyy-MM")!.date)
            }
        }
 
        pickerView.show()
    }
    
    /// 选择看房时间
    func showLookHouseDatePicker(callback: @escaping (Date)->Void) {
        
        let pickerView = BRDatePickerView()
        pickerView.isShowToday = true
        pickerView.resultBlock = { (selectDate, selectValue) in
            self.newRecord.date = selectDate!
            callback(selectDate!)
        }
        pickerView.show()
    }
    
    /// 保存记录
    func saveCurrentNewRecord(callback: @escaping (Bool)->Void) {
        
        LHCacheHelper.helper.saveLookHouseRecordModel(model: newRecord) { result in
            callback(result)
        }
    }
    
    /// 获取全部看房记录
    func getAllLookHouseRecord(callback: (([LHLookHouseRecordModel])->Void)?) {
        LHCacheHelper.helper.getLookHouseRecordCache {[unowned self] dataArray in
            if let tempData = dataArray {
                self.allRecord = tempData
                callback?(tempData)
            } else {
                callback?(Array<LHLookHouseRecordModel>())
            }
        }
    }
    
    /// 获取过滤后的看房记录
    func getFiltedLookHouseRecord(needUpdate:Bool = false,callback: @escaping ([LHLookHouseRecordModel])->Void) {
        
        if needUpdate == true {
            getAllLookHouseRecord { [unowned self] allData in
                self.getUpdatedFiltedLookHouseRecord { filterData in
                    callback(filterData)
                }
            }
        } else {
            self.getUpdatedFiltedLookHouseRecord { filterData in
                callback(filterData)
            }
        }
    }
    /// 获取更新后的过滤后的看房记录
    func getUpdatedFiltedLookHouseRecord(callback: @escaping ([LHLookHouseRecordModel])->Void) {
        let keyworksFilted = allRecord.filter { record in // 关键词筛选
            if filterKeywords == nil {
                return true
            }
            if filterKeywords?.isBlank == true {
                return true
            }
            return record.communityName.contains(filterKeywords!)
        }
        
        let dateFilted = keyworksFilted.filter { record in // 日期筛选
            return record.date.year == filterDate.year && record.date.month == filterDate.month
        }
        
        let agencyFilted = dateFilted.filter { record in // 中介筛选
            if filterAgency == nil {
                return true
            } else {
                return record.agencyCompany == filterAgency!
            }
        }
        
        let intentionFilted = agencyFilted.filter { record in // 意向筛选
            if filterIntention == nil {
                return true
            } else {
                return record.intention == filterIntention!
            }
        }
        callback(intentionFilted)
    }
}
