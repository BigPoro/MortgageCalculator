//
//  AppDelegate.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import Reachability
import SVProgressHUD
import IQKeyboardManagerSwift
import LEEAlert
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let reachability = try! Reachability()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if self.window == nil {
            self.window = UIWindow.init(frame: UIScreen.main.bounds)
        }
        self.window?.rootViewController = LHNavigationController(rootViewController: LHLaunchingController())
        self.window?.makeKeyAndVisible()
        
        // 不适配Dark Mode
        if #available(iOS 13.0, *) {
            keyWindow?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        }
        self.configReachability()
        self.configKeyboardManager()
        self.configSVProgressHUD()
        LEEAlert.configMainWindow(self.window!)
        return true
    }

    private func configReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            SVProgressHUD.showError(withStatus: "请检查网络")
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    private func configKeyboardManager() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
    }
    
    private func configSVProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1.2)
    }
}
