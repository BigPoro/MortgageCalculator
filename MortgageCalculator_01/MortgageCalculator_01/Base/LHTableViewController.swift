//
//  LHTableViewController.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import EmptyDataSet_Swift
class LHTableViewController: LHBaseController,EmptyDataSetSource,EmptyDataSetDelegate {
    
    var tableView = UITableView()
    var dataSource = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        super.setupUI()
        self.setupTableView()
    }
    func setupTableView() {
        tableView.frame = self.view.bounds
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = 50
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = kGray_244
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let titleAttr = NSAttributedString.init(string: "暂无数据", attributes: [NSAttributedString.Key.font:FontMediumHeiti(fontSize: 16),NSAttributedString.Key.foregroundColor:kGray_61])
        return titleAttr
    }
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return .init(named: "img_empty_data")
    }
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }
}

extension LHTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.zoom()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
