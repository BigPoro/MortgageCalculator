//
//  LHLookHouseController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import AttributedString
import SVProgressHUD
import LEEAlert
class LHLookHouseController: LHCollectionViewController, UITextViewDelegate {
    private lazy var viewModel = LHLookHouseViewModel()
    private lazy var deleteModels = [LHLookHouseRecordModel]()
    private var isDeleting = false {
        didSet {
            dataSource.forEach { model in
                let tempModel = model as! LHLookHouseRecordModel
                tempModel.isSelected = false
            }
            deleteModels.removeAll()
            collectionView.reloadData()
            editView.isHidden = !isDeleting
        }
    }

    private var editView = UIView()

    private lazy var emptyView = { () -> LHEmptyDataView in
        let emptyView = LHEmptyDataView()
        emptyView.titleLabel.text = "当前暂无看房记录！"
        collectionView.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.centerY.equalTo(180.zoom())
            make.centerX.equalToSuperview()
        }
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 查询所有记录
        viewModel.getAllLookHouseRecord {[unowned self] data in
            self.dataSource = data
            self.collectionView.reloadData()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        let titleLabel = UILabel()
        let titleAttr:ASAttributedString = "\("看房",.font(FontMediumHeiti(fontSize: 18)),.foreground(.white))\("| 记录看房点点滴滴",.font(FontRegularHeiti(fontSize: 15)),.foreground(.white))"
        titleLabel.attributed.text = titleAttr
        navigation.item.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        let editButton = UIButton(type: .custom)
        editButton.size = CGSize(width: 44, height: 44)
        editButton.setImage(.init(named: "icon_delete_white"), for: .normal)
        editButton.contentHorizontalAlignment = .right
        editButton.onTap { [unowned self] in
            isDeleting = !isDeleting

        }
        navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: -300, width: view.width, height: 300)
        
        let searchBarView = UIView()
        searchBarView.backgroundColor = kGray_244
        searchBarView.layer.cornerRadius = 20.zoom()
        headerView.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(8.zoom())
            make.leading.equalTo(15.zoom())
            make.trailing.equalTo(-15.zoom())
            make.height.equalTo(40.zoom())
        }
        searchBarView.addTapGesture { [unowned self] gesture in
            navigationController?.pushViewController(LHLookRecordSearchController(), animated: true)
        }
        
        let searchIcon = UIImageView()
        searchIcon.image = .init(named: "icon_search_gray")
        searchBarView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22.zoom())
        }
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "可以通过搜索小区名称查询"
        placeholderLabel.font = FontRegularHeiti(fontSize: 13)
        placeholderLabel.textColor = kGray_184
        placeholderLabel.layer.cornerRadius = 35.zoom()/2
        placeholderLabel.backgroundColor = kGray_244
        searchBarView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchIcon.snp.trailing).offset(15.zoom())
            make.trailing.equalTo(-15.zoom())
            make.centerY.equalTo(searchIcon)
            make.height.equalTo(34.zoom())
        }
        
        let coverView = UIImageView()
        coverView.image = .init(named: "img_lookhouse_bg")
        headerView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15.zoom())
        }
        
        // 重设高度
        let headerHeight = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerView.frame = CGRect(x: 0, y: -headerHeight, width: view.width, height: headerHeight)
        
        let itemWidth = (kScreenWidth - 3 * 15.zoom()) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: 110.zoom())
        flowLayout.minimumLineSpacing = 8.zoom()
        flowLayout.minimumInteritemSpacing = 15.zoom()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15.zoom(), bottom: 0, right: 15.zoom())
        collectionView.register(LHLookHourseRecordCell.self, forCellWithReuseIdentifier: "LHLookHourseRecordCell")
        
        collectionView.addSubview(headerView)
        collectionView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0);
        collectionView.frame = CGRect(x: 0, y: kNavigationBarHeight, width: view.width, height: view.height - kTabBarHeight - kNavigationBarHeight - 40.zoom())
        
        view.addSubview(editView)
        editView.isHidden = true
        editView.backgroundColor = kGray_235
        editView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(-kTabBarHeight)
            make.height.equalTo(40.zoom())
        }
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.setTitle("全部删除", for: .normal)
        deleteButton.titleLabel?.font = FontRegularHeiti(fontSize: 14)
        deleteButton.setTitleColor(kGray_61, for: .normal)
        editView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(20.zoom())
            make.centerY.equalToSuperview()
        }
        deleteButton.onTap { [unowned self] in
            if deleteModels.isEmpty {
                SVProgressHUD.showError(withStatus: "请选择要删除的看房记录")
                return
            }
            let alert = LEEAlert.alert()
            _ = alert.config.leeAddTitle { label in
                label.text = "提示"
            }.leeAddContent { label in
                label.text = "删除后无法恢复，是否删除？"
                
            }.leeAddAction { action in
                action.title = "取消"
            }.leeAddAction { action in
                action.title = "确定"
                action.clickBlock = {
                    LHCacheHelper.helper.deletelLookHouseRecordModel(modelArray: deleteModels) { result in
                        if result == true {
                            SVProgressHUD.showSuccess(withStatus: "已删除")
                            isDeleting = false
                            // 查询所有记录
                            viewModel.getAllLookHouseRecord {[unowned self] data in
                                self.dataSource = data
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }.leeShow()
        }
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = FontRegularHeiti(fontSize: 14)
        cancelButton.setTitleColor(kGray_61, for: .normal)
        editView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(-20.zoom())
            make.centerY.equalToSuperview()
        }
        cancelButton.onTap { [unowned self] in
            isDeleting = false
        }
    }
}

extension LHLookHouseController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyView.isHidden = !dataSource.isEmpty

        return dataSource.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LHLookHourseRecordCell", for: indexPath) as! LHLookHourseRecordCell
        if indexPath.item == 0 {
            cell.coverView.image = .init(named: "icon_add_look_record")
            cell.intentionView.isHidden = true
            cell.selectView.isHidden = true
        } else {
            let model = self.dataSource[indexPath.item - 1] as! LHLookHouseRecordModel
            cell.coverView.image = UIImage(data: model.photos.first!)
            cell.intentionView.image = .init(named: "icon_intention_corner_\(LHHouseIntention.allValues.firstIndex(of: model.intention)!)")
            cell.intentionView.isHidden = false
            if isDeleting == true {
                cell.selectView.isHidden = false
                if model.isSelected  {
                    cell.selectView.image = .init(named: "icon_seleted")
                } else {
                    cell.selectView.image = .init(named: "icon_unseleted")
                }
            } else {
                cell.selectView.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDeleting {
            if indexPath.item != 0 {
                let model = dataSource[indexPath.item - 1] as! LHLookHouseRecordModel
                model.isSelected = !model.isSelected
                collectionView.reloadData()
                
                if model.isSelected {
                    deleteModels.append(model)
                } else {
                    deleteModels.remove(at: deleteModels.firstIndex(of: model)!)
                }
            }
        } else {
            if indexPath.item == 0 {
                let vc = LHAddLookHouseRecordController()
                vc.addRecordBlock = { [unowned self]  in
                    // 查询所有记录
                    viewModel.getAllLookHouseRecord {[unowned self] data in
                        self.dataSource = data
                        self.collectionView.reloadData()
                    }
                }
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = LHLookHouseRecordController()
                vc.recordModel = dataSource[indexPath.item - 1] as? LHLookHouseRecordModel
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

