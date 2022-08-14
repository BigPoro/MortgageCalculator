//
//  LHBaseViewModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/20.
//

import UIKit


class LHBaseViewModel: NSObject {
    var errorBlock:((NSError) -> Void)?
    var successBlock:((Any) -> Void)?
    var dataBlock:((Any) -> Void)?
    
    deinit {
        print("销毁了>>>>: \(self.debugDescription)")
    }
}
