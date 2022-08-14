//
//  LHLoanCalcRecordController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import UIKit
import SwipeCellKit
import SwiftDate
import AttributedString
import SVProgressHUD

class LHLoanCalcRecordController: LHTableViewController {
    private lazy var viewModel = LHLoanCalcViewModel()
    var originalData:[LHLoanCalcResultModel]!
    var beginDate = Date() - 1.years // 默认筛选最近一年的数据
    var endDate = Date()
    let beginDateButton = UIButton.init(type: .custom)
    let endDateButton = UIButton.init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        // 载入缓存
        
        LHCacheHelper.helper.getCalcResultCache { [unowned self] array in
            if array != nil {
                self.originalData = array! // 保存原始数据
                self.dataSource = array!
                self.tableView.reloadData()
            }
        }
    }
    
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "计算历史记录"
        
        let topView = UIView()
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(kNavigationBarHeight)
            make.height.equalTo(45.zoom())
        }
        
        let lineView = UIView()
        lineView.backgroundColor = kGray_244
        topView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let allButton = UIButton.init(type: .custom)
        allButton.setTitle("全部", for: .normal)
        allButton.setTitleColor(kGray_61, for: .normal)
        allButton.titleLabel?.font = FontSemiboldHeiti(fontSize: 14)
        topView.addSubview(allButton)
        allButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50.zoom(), height: 45.zoom()))
            make.leading.centerY.equalToSuperview()
        }
        allButton.onTap { [unowned self]  in
            dataSource = originalData
            tableView.reloadData()
            SVProgressHUD.showSuccess(withStatus: "已展示全部数据")
        }
        
        let sureButton = UIButton.init(type: .custom)
        sureButton.setTitle("确定", for: .normal)
        sureButton.configGradientButtonUI()
        sureButton.layer.cornerRadius = 25.zoom()/2
        sureButton.titleLabel?.font = FontSemiboldHeiti(fontSize: 12)
        topView.addSubview(sureButton)
        sureButton.snp.makeConstraints { make in
            make.trailing.equalTo(-15.zoom())
            make.size.equalTo(CGSize(width: 52.zoom(), height: 25.zoom()))
            make.centerY.equalToSuperview()
        }
        sureButton.onTap { [unowned self]  in
            self.updateDataSource()
        }
        
        beginDateButton.titleLabel?.font = FontRegularHeiti(fontSize: 13)
        beginDateButton.size = CGSize(width: 115.zoom(), height: 30.zoom())
        beginDateButton.setTitleColor(kGray_123, for: .normal)
        beginDateButton.layer.cornerRadius = 3
        beginDateButton.layer.borderColor = kGray_244.cgColor
        beginDateButton.layer.borderWidth = 1
        beginDateButton.set(image: .init(named: "icon_arrow_gray_down"), title: beginDate.toFormat("yyyy-MM-dd"), titlePosition: .left, additionalSpacing: 20.zoom(), state: .normal)
        topView.addSubview(beginDateButton)
        beginDateButton.snp.makeConstraints { make in
            make.leading.equalTo(allButton.snp.trailing)
            make.centerY.equalToSuperview()
            make.height.equalTo(30.zoom())
            make.width.equalTo(115.zoom())
        }
        beginDateButton.onTap { [unowned self]  in
            self.viewModel.showBeginDatePicker() { selectDate in
                if selectDate > self.endDate {
                    SVProgressHUD.showError(withStatus: "不能大于结束时间")
                } else {
                    beginDate = selectDate
                    beginDateButton.set(image: .init(named: "icon_arrow_gray_down"), title: beginDate.toFormat("yyyy-MM-dd"), titlePosition: .left, additionalSpacing: 20.zoom(), state: .normal)
                }
            }
        }
        
        endDateButton.titleLabel?.font = FontRegularHeiti(fontSize: 13)
        endDateButton.size = CGSize(width: 115.zoom(), height: 30.zoom())
        endDateButton.setTitleColor(kGray_123, for: .normal)
        endDateButton.layer.cornerRadius = 3
        endDateButton.layer.borderColor = kGray_244.cgColor
        endDateButton.layer.borderWidth = 1
        endDateButton.set(image: .init(named: "icon_arrow_gray_down"), title: endDate.toFormat("yyyy-MM-dd"), titlePosition: .left, additionalSpacing: 20.zoom(), state: .normal)

        topView.addSubview(endDateButton)
        endDateButton.snp.makeConstraints { make in
            make.trailing.equalTo(sureButton.snp.leading).offset(-10.zoom())
            make.centerY.height.width.equalTo(beginDateButton)
        }
        endDateButton.onTap { [unowned self]  in
            self.viewModel.showEndDatePicker() { selectDate in
                if selectDate < self.beginDate {
                    SVProgressHUD.showError(withStatus: "不能小于开始时间")
                } else {
                    endDate = selectDate
                    endDateButton.set(image: .init(named: "icon_arrow_gray_down"), title: endDate.toFormat("yyyy-MM-dd"), titlePosition: .left, additionalSpacing: 20.zoom(), state: .normal)
                }
            }
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let titleAttr = NSAttributedString.init(string: "友情提示：使用习惯计算器可后保存记录备份", attributes: [NSAttributedString.Key.font:FontRegularHeiti(fontSize: 14),NSAttributedString.Key.foregroundColor:kGray_123])
        return titleAttr
    }
    private func updateDataSource() {
        let filterArr = self.dataSource.filter { model in
            let tempModel = model as! LHLoanCalcResultModel
            return tempModel.date >= beginDate && tempModel.date <= endDate
        }

        self.dataSource = filterArr
        self.tableView.reloadData()
        SVProgressHUD.showSuccess(withStatus: "数据已更新")
    }
}

extension LHLoanCalcRecordController:SwipeTableViewCellDelegate {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87.zoom()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHCalcRecordCell"
        var cell:LHCalcRecordCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHCalcRecordCell
        if cell == nil {
            cell = LHCalcRecordCell.init(style: .default, reuseIdentifier: identifier)
            cell.delegate = self
        }
        let model = self.dataSource[indexPath.row] as! LHLoanCalcResultModel
        switch model.type {
        case .business:
            cell.nameLabel.text = "商业房贷计算"
            cell.typeIcon.image = .init(named: "icon_mortgage_result_01")
        case .fund:
            cell.nameLabel.text = "公积金房贷计算"
            cell.typeIcon.image = .init(named: "icon_mortgage_result_02")
        case .combined:
            cell.nameLabel.text = "组合型房贷计算"
            cell.typeIcon.image = .init(named: "icon_mortgage_result_03")
        }
        if model.name != nil {
            cell.nameLabel.text = model.name!
        }
        cell.dateLabel.text = model.date.toString(.custom("yyyy/MM/dd"))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LHLoanCalcResultController()
        vc.hiddenSaveAction = true
        vc.resultModel = (self.dataSource[indexPath.row] as! LHLoanCalcResultModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //自定义滑动按钮
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //返回右侧的按钮
        if orientation == .right {
            
            let favoriteAction = SwipeAction(style: .default, title: "重命名") { [unowned self]
                action, indexPath in
                let model = (self.dataSource[indexPath.row] as! LHLoanCalcResultModel)
                self.viewModel.showRenameAlert(model: model) { newName in
                    LHCacheHelper.helper.renameCalcResultModel(model: model, newName: newName) { result in
                        model.name = newName
                        self.tableView.reloadData()
                    }
                }
            }
            favoriteAction.backgroundColor = .orange
            
            // 删除
            let deleteAction = SwipeAction(style: .destructive, title: "删除") { [unowned self]
                action, indexPath in
                let model = (self.dataSource[indexPath.row] as! LHLoanCalcResultModel)
                LHCacheHelper.helper.deleteCalcResultModel(model: model) { result in
                    if result == true {
                        self.dataSource.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                }
            }
            return [deleteAction, favoriteAction]
        }
        return nil
    }
    
    
}
