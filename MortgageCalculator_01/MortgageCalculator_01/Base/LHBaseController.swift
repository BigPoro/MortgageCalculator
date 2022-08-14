//
//  LHBaseController.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import UIKit

class LHBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        print("进入了>>>: \(self.debugDescription)")
    }
    
    deinit {
        print("销毁了>>>>: \(self.debugDescription)")
    }
    
    func setupUI() {
//        self.edgesForExtendedLayout = [] // 和导航栏库冲突
        view.backgroundColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.view.backgroundColor = .white
        navigation.bar.isTranslucent = false
        navigation.bar.isShadowHidden = true
        navigation.bar.statusBarStyle = .lightContent

        self.adapterTheScrollViewAndTableView()
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            let button = self.configBackButton()
            navigation.bar.backBarButtonItem = .init(customView: button)
        }
    }
    
    func adapterTheScrollViewAndTableView() {
        UITableView.appearance().estimatedRowHeight = 0
        UITableView.appearance().estimatedSectionHeaderHeight = 0
        UITableView.appearance().estimatedSectionFooterHeight = 0
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
    
    func configBackButton() -> UIButton {
        let backButton = UIButton.init(type: UIButton.ButtonType.custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.contentHorizontalAlignment = .leading
        backButton.setImage(UIImage(named: "icon_arrow_white_left"), for: UIControl.State.normal)
        backButton.addTarget(self, action: #selector(barBackButtonAction), for: UIControl.Event.touchUpInside)
        return backButton
    }
    
    func shouldAutorotate() -> Bool {

        return false
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientation {

        return .portrait
    }
    
    @objc func barBackButtonAction() {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        } else if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
