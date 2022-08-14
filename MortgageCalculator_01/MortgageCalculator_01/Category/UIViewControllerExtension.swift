//
//  UIViewControllerExtension.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import Foundation
import UIKit

extension UIViewController {
    /// 调用原生分享图片
    func nativeShareWithImage(image:UIImage, callback: ((Bool)->Void)?) {
        let activityItems = [image]
        let shareController = UIActivityViewController(activityItems:activityItems, applicationActivities: nil)
        self.present(shareController, animated: true, completion: nil)
        shareController.completionWithItemsHandler = { (type,completed,returnedItems,activityError) in
            if callback != nil {
                callback!(completed)
            }
        }
    }
}
