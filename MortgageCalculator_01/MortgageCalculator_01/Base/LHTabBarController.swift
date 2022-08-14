//
//  LHTabBarController.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import UIKit


class LHTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        addAllChildsControllors();
        super.viewDidLoad()
        self.delegate = self
        setupUI()
    }
    
    func setupUI() {
        
        self.tabBar.shadowImage = UIImage();
        self.tabBar.backgroundColor = UIColor.white
    }
    
    private func addAllChildsControllors() {
        ///首页
        addChildController(childController:LHHomeViewController(), title:nil, imageNormal:UIImage(named:"icon_tabbar_home_normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                           , imageSelect: UIImage(named:"icon_tabbar_home_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))

        ///看房
        addChildController(childController:LHLookHouseController(), title:nil, imageNormal:UIImage(named:"icon_tabbar_look_normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), imageSelect: UIImage(named:"icon_tabbar_look_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        //我的
        addChildController(childController:LHMineHomeController(), title:nil, imageNormal:UIImage(named:"icon_tabbar_me_normal")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                           , imageSelect: UIImage(named:"icon_tabbar_me_selected")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
    }
    
    private func addChildController(childController: LHBaseController, title: String?, imageNormal: UIImage?, imageSelect:UIImage?) {
        let nav = LHNavigationController(rootViewController: childController)

        let item = UITabBarItem()
        item.image = imageNormal
        item.selectedImage = imageSelect
        item.imageInsets = UIEdgeInsets(top: 10.zoom(), left: 0, bottom: -10.zoom(), right: 0)
        
        addChild(nav);
        nav.tabBarItem = item
    }
}
