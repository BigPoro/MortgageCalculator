//
//  LHColors.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import Foundation
import UIKit

func RGBA(R:CGFloat, G: CGFloat , B:CGFloat, A: CGFloat) -> UIColor {
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}

func HexColorA(rgbValue:UInt) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: 1)
}

let kGray_35        = RGBA(R: 35, G: 35, B: 35, A: 1)
let kGray_61        = RGBA(R: 61, G: 61, B: 61, A: 1)
let kGray_123       = RGBA(R: 123, G: 123, B: 123, A: 1)
let kGray_184       = RGBA(R: 184, G: 184, B: 184, A: 1)
let kGray_235       = RGBA(R: 235, G: 235, B: 235, A: 1)
let kGray_244       = RGBA(R: 244, G: 244, B: 244, A: 1)

let kYellow_255     = RGBA(R: 255, G: 177, B: 14, A: 1)

let kRed_200        = RGBA(R: 220, G: 0, B: 0, A: 1)

let kPurple_135     = RGBA(R: 135, G: 84, B: 186, A: 1)
