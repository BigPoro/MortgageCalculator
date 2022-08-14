//
//  LHCommonFunctions.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import Foundation
import UIKit

var isFullScreen: Bool {
    if #available(iOS 11, *) {
          guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
              return false
          }
          
          if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
              print(unwrapedWindow.safeAreaInsets)
              return true
          }
    }
    return false
}

var keyWindow: UIWindow? = {
    var window: UIWindow?
    if #available(iOS 13.0, *) {
        window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .last?.windows
            .filter({ $0.isKeyWindow })
            .last
    } else {
        window = UIApplication.shared.keyWindow
    }
    return window
}()

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

var kNavigationBarHeight: CGFloat {
    return isFullScreen ? 88.0 : 64.0
}
var kTabBarHeight: CGFloat {
    return isFullScreen ? 83.0 : 49.0
}
var kBottomSafeHeight: CGFloat {
    return isFullScreen ? 34.0 : 0.0
}
var kTopSafeHeight: CGFloat {
    return isFullScreen ? 22.0 : 0.0
}

var kStatusBarHeight: CGFloat {
    return isFullScreen ? 44.0 : 20.0
}

let kVersion                = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
let kBuild                  = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
let kTargetName             = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
let kAppName                = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String

let kHUDDelay               = 1.5

func currentViewController() -> (UIViewController?) {
   var window = UIApplication.shared.keyWindow
   if window?.windowLevel != UIWindow.Level.normal{
     let windows = UIApplication.shared.windows
     for  windowTemp in windows{
       if windowTemp.windowLevel == UIWindow.Level.normal{
          window = windowTemp
          break
        }
      }
    }
   let vc = window?.rootViewController
   return currentViewController(vc)
}

func currentViewController(_ vc :UIViewController?) -> UIViewController? {
   if vc == nil {
      return nil
   }
   if let presentVC = vc?.presentedViewController {
      return currentViewController(presentVC)
   }
   else if let tabVC = vc as? UITabBarController {
      if let selectVC = tabVC.selectedViewController {
          return currentViewController(selectVC)
       }
       return nil
    }
    else if let naiVC = vc as? UINavigationController {
       return currentViewController(naiVC.visibleViewController)
    }
    else {
       return vc
    }
 }
