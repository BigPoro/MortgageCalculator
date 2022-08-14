//
//  LHAboutUsController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/19.
//

import UIKit

class LHAboutUsController: LHBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "关于我们"
        
        let logoView = UIImageView()
        logoView.image = .init(named: "icon_logo_70")
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(100.zoom() + kNavigationBarHeight)
        }
        
        let titleLabel = UILabel()
        titleLabel.font = FontMediumHeiti(fontSize: 18)
        titleLabel.textColor = kGray_35
        titleLabel.text = kAppName
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(30.zoom())
            make.centerX.equalToSuperview()
        }
        
        let versionLabel = UILabel()
        versionLabel.font = FontMediumHeiti(fontSize: 14)
        versionLabel.textColor = kGray_123
        versionLabel.text = "当前版本：V" + kVersion!
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5.zoom())
            make.centerX.equalToSuperview()
        }
    }
    
}
