//
//  LHUserModel.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit

enum LHUserSex:Int,Codable {
    case male = 1
    case female = 2
}

class LHUserModel: NSObject,Codable {
    var nickname:String?
    var signature:String?
    var sex:LHUserSex = .male
    var avatar: String?
}
