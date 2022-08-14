//
//  LHNavigationController.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import UIKit
class LHNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigation.configuration.isEnabled = true
        self.navigation.configuration.setBackgroundImage(UIImage(named: "img_nav_bg_gradient_1"), for: .any, barMetrics: .default)
        self.navigation.configuration.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameorNil:String?,bundle nibBundleOrNil:Bundle?){
        super.init(nibName:nibNameorNil,bundle:nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
        }
        super.pushViewController(viewController, animated: animated)
    }
}
