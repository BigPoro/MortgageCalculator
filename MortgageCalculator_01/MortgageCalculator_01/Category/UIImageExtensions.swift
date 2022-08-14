//
//  UIColor+Image.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/5.
//

import Foundation
import UIKit

extension UIImage {
    /// 根据颜色生成图片
    static func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 修改图片颜色
    func changeColor(color:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size,false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0,y: self.size.height)
        context?.scaleBy(x: 1.0,y: -1.0)//kCGBlendModeNormal
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0,width: self.size.width,height: self.size.height)
        context?.clip(to: rect,mask: self.cgImage!);
        color.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    /// 修改尺寸
    func scaleToSize(size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size,false,0)
        self.draw(in: CGRect(x: 0,y: 0,width: size.width,height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    /// 转Data
    func convertToData() -> Data? {
        return hasAlpha
        ? pngData()
        : jpegData(compressionQuality: 0.5)
    }
    
    /// 检查是否有透明通道
    var hasAlpha: Bool {
        let result: Bool
        
        guard let alpha = cgImage?.alphaInfo else {
            return false
        }
        
        switch alpha {
        case .none, .noneSkipFirst, .noneSkipLast:
            result = false
        default:
            result = true
        }
        
        return result
    }
}
