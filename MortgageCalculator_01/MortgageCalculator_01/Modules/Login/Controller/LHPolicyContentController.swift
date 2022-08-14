//
//  LHPolicyContentController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/21.
//

import UIKit
import WebKit

class LHPolicyContentController: LHBaseController {
    
    var htmlStr: String = "" {
        didSet {
            // 适配字体
            webView.loadHTMLString("<html><body><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,Proxima Nova-Regular\">\(htmlStr)</body></html>", baseURL: nil)
        }
    }
    var policyTitle = ""
    private let webView = WKWebView.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func setupUI() {
        super.setupUI()
        navigation.item.title = policyTitle
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: kNavigationBarHeight, left: 0, bottom: 0, right: 0))
        }
    }

}
