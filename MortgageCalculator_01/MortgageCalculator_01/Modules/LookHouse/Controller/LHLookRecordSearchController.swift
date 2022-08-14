//
//  LHLookRecordSearchController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/30.
//

import UIKit
import AttributedString
import FSTextView

class LHLookRecordSearchController: LHCollectionViewController, UITextViewDelegate {
    private var filterButtons = [UIButton]()
    
    private lazy var viewModel = LHLookHouseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 根据当前筛选条件 重新查询
        viewModel.getFiltedLookHouseRecord(needUpdate: true) {[unowned self] data in
            self.dataSource = data
            self.collectionView.reloadData()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        navigation.item.title = "搜索看房记录"
        
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
        
        let searchIcon = UIImageView()
        searchIcon.image = .init(named: "icon_search_gray")
        searchBarView.addSubview(searchIcon)
        searchIcon.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22.zoom())
        }
        
        let textView = FSTextView()
        textView.delegate = self
        textView.returnKeyType = .search
        textView.placeholder = "可以通过搜索小区名称查询"
        textView.placeholderFont = FontRegularHeiti(fontSize: 13)
        textView.placeholderColor = kGray_184
        textView.cornerRadius = 35.zoom()/2
        textView.backgroundColor = kGray_244
        searchBarView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.leading.equalTo(searchIcon.snp.trailing).offset(10.zoom())
            make.trailing.equalTo(-15.zoom())
            make.centerY.equalTo(searchIcon).offset(2.zoom())
            make.height.equalTo(34.zoom())
        }
        
        let titles = ["意向","经纪公司",Date().toFormat("yyyy-MM")]
        
        for i in 0..<3 {
            let button = UIButton.init(type: UIButton.ButtonType.custom)
            button.setTitleColor(kGray_61, for: .normal)
            button.titleLabel?.font = FontRegularHeiti(fontSize: 15)
            button.size = CGSize(width: 80.zoom(), height: 22.zoom())
            button.set(image: .init(named: "icon_arrow_black_down"), title: titles[i], titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
            button.addTarget(self, action: #selector(filterButtonsClicked), for: .touchUpInside)
            button.tag = i
            headerView.addSubview(button)
            filterButtons.append(button)
        }
        filterButtons.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 80.zoom(), leadSpacing: 15.zoom(), tailSpacing: 15.zoom())
        filterButtons.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80.zoom(), height: 22.zoom()))
            make.top.equalTo(searchBarView.snp.bottom).offset(20.zoom())
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
        collectionView.frame = CGRect(x: 0, y: kNavigationBarHeight, width: view.width, height: view.height - kNavigationBarHeight)
        
    }
    
    /// 设置筛选条件
    @objc private func filterButtonsClicked(sender:UIButton) {
        switch sender.tag {
        case 0:
            viewModel.showIntentionPicker {[unowned self]   intention in
                if intention == nil {
                    sender.set(image: .init(named: "icon_arrow_black_down"), title: "意向 ", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                } else {
                    sender.set(image: .init(named: "icon_arrow_black_down"), title: "意向 " + intention!.rawValue, titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                }
                self.viewModel.filterIntention = intention
                self.viewModel.getFiltedLookHouseRecord { [unowned self] filtedRecord in
                    self.dataSource = filtedRecord
                    self.collectionView.reloadData()
                }
            }
        case 1:
            viewModel.showAgencyCompanyPicker {[unowned self]  agency in
                if agency == nil {
                    sender.set(image: .init(named: "icon_arrow_black_down"), title: "经纪公司", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                } else {
                    sender.set(image: .init(named: "icon_arrow_black_down"), title: agency!.rawValue, titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                }
                self.viewModel.filterAgency = agency
                self.viewModel.getFiltedLookHouseRecord { filtedRecord in
                    self.dataSource = filtedRecord
                    self.collectionView.reloadData()
                }
            }
        case 2:
            viewModel.showFilterDatePicker { [unowned self]  date in
                sender.set(image: .init(named: "icon_arrow_black_down"), title: date.toString(.custom("yyyy-MM")), titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                self.viewModel.filterDate = date
                self.viewModel.getFiltedLookHouseRecord { filtedRecord in
                    self.dataSource = filtedRecord
                    self.collectionView.reloadData()
                }
            }
            
        default:
            break
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains("\n") {
            view.endEditing(true)
            
            self.viewModel.filterKeywords = textView.text
            self.viewModel.getFiltedLookHouseRecord { filtedRecord in
                self.dataSource = filtedRecord
                self.collectionView.reloadData()
            }
            return false
        }
        return true
    }
    
    override func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let titleAttr = NSAttributedString.init(string: "当前暂无看房记录！", attributes: [NSAttributedString.Key.font:FontMediumHeiti(fontSize: 16),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        return titleAttr
    }
}

extension LHLookRecordSearchController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LHLookHourseRecordCell", for: indexPath) as! LHLookHourseRecordCell
        let model = self.dataSource[indexPath.item] as! LHLookHouseRecordModel
        cell.coverView.image = UIImage(data: model.photos.first!)
        cell.intentionView.image = .init(named: "icon_intention_corner_\(LHHouseIntention.allValues.firstIndex(of: model.intention)!)")
        cell.intentionView.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LHLookHouseRecordController()
        vc.recordModel = dataSource[indexPath.item] as? LHLookHouseRecordModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
