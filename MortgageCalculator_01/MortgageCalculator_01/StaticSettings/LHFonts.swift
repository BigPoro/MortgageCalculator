//
//  LHFonts.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import Foundation
import UIKit

func FontRegularHeiti(fontSize:CGFloat) -> UIFont {
    var tempSize = fontSize
    if kScreenWidth > 375 {
        tempSize += 1
    } else if (kScreenWidth < 375){
        tempSize -= 1
    }
    return UIFont.init(name: "PingFangSC-Regular", size: tempSize)!
}

func FontMediumHeiti(fontSize:CGFloat) -> UIFont {
    var tempSize = fontSize
    if kScreenWidth > 375 {
        tempSize += 1
    } else if (kScreenWidth < 375){
        tempSize -= 1
    }
    return UIFont.init(name: "PingFangSC-Medium", size: tempSize)!
}

func FontSemiboldHeiti(fontSize:CGFloat) -> UIFont {
    var tempSize = fontSize
    if kScreenWidth > 375 {
        tempSize += 1
    } else if (kScreenWidth < 375){
        tempSize -= 1
    }
    return UIFont.init(name: "PingFangSC-Semibold", size: tempSize)!
}

/// 英文系统字体-Heavy
func EnFontHeavyHeiti(fontSize:CGFloat) -> UIFont {
    var tempSize = fontSize
    if kScreenWidth > 375 {
        tempSize += 1
    } else if (kScreenWidth < 375){
        tempSize -= 1
    }
    return UIFont.systemFont(ofSize: tempSize, weight: UIFont.Weight.heavy);
}

/// 英文系统字体-Regular
func EnFontHeiti(fontSize:CGFloat) -> UIFont {
    var tempSize = fontSize
    if kScreenWidth > 375 {
        tempSize += 1
    } else if (kScreenWidth < 375){
        tempSize -= 1
    }
    return UIFont.systemFont(ofSize: tempSize, weight: UIFont.Weight.regular);
}

/// 英文系统字体-Bold
func EnFontBoldHeiti(fontSize:CGFloat) -> UIFont {
    var tempSize = fontSize
    if kScreenWidth > 375 {
        tempSize += 1
    } else if (kScreenWidth < 375){
        tempSize -= 1
    }
    return UIFont.systemFont(ofSize: tempSize, weight: UIFont.Weight.bold);
}

