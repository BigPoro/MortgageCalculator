//
//  LHDaylightingCalcController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/15.
//

import UIKit
import SVProgressHUD

class LHDaylightingCalcController: LHTableViewController {
    private lazy var viewModel = LHHouseToolViewModel()
    private let titles = ["所在城市","经纬（中国经纬度为负数）","纬度","楼间距","您住在几层","您的楼每层高","遮阳楼层总层数","遮阳楼每层高"]

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "房屋采光时长计算"
        view.backgroundColor = .white
        
        let shareButton = UIButton.init(type: UIButton.ButtonType.custom)
        shareButton.setImage(.init(named: "icon_share_white"), for: .normal)
        shareButton.setImage(.init(named: "icon_share_white"), for: .highlighted)
        shareButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        shareButton.contentHorizontalAlignment = .right
        shareButton.onTap { [unowned self]  in
            let image = view.snapshot()
            self.nativeShareWithImage(image: image!) { result in
                if result == true {
                    SVProgressHUD.showSuccess(withStatus: "分享成功")
                }
            }
        }
        navigation.item.rightBarButtonItem = UIBarButtonItem.init(customView: shareButton)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 180.zoom())
        headerView.backgroundColor = .white
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_daylighting_bg")
        headerView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(20.zoom())
            make.centerX.equalToSuperview()
        }
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 90.zoom())
        
        let calcButton = UIButton.init(type: .custom)
        calcButton.configGradientButtonUI()
        calcButton.setTitle("立即计算", for: .normal)
        footerView.addSubview(calcButton)

        calcButton.onTap { [unowned self]  in
            for cell in tableView.visibleCells {
                let textFieldCell = cell as! LHTextFieldCell
                if textFieldCell.index.row != 0 { // 城市不考虑
                    var checkResult = true
                    if let content = Double(textFieldCell.textField.text!) {
                        if content == 0 {
                            checkResult = false
                        } else {
                            switch textFieldCell.index.row {
                            case 1:
                                viewModel.daylightingCalcModel.longitude = content
                            case 2:
                                viewModel.daylightingCalcModel.latitude = content
                            case 3:
                                viewModel.daylightingCalcModel.floorSpacing = content
                            case 4:
                                viewModel.daylightingCalcModel.myFloor = content
                            case 5:
                                viewModel.daylightingCalcModel.myFloorHeigth = content
                            case 6:
                                viewModel.daylightingCalcModel.coverFloor = content
                            case 7:
                                viewModel.daylightingCalcModel.coverFloorHeigth = content
                            default:
                                break
                            }
                        }
                    } else {
                        checkResult = false
                    }
                    if checkResult == false {
                        SVProgressHUD.showError(withStatus: "请输入\(titles[textFieldCell.index.row])")
                        return
                    }

                }
            }
            let result = viewModel.daylightingCalcModel.calculateDaylighting()
            let vc = LHDaylightingCalcResultController()
            vc.resultModel = result
            navigationController?.pushViewController(vc, animated: true)
        }
        
        calcButton.snp.makeConstraints { make in
            make.height.equalTo(44.zoom())
            make.width.equalTo(300.zoom())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(kNavigationBarHeight)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
    }
}

extension LHDaylightingCalcController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LHTextFieldCell"
        var cell:LHTextFieldCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LHTextFieldCell
        if cell == nil {
            cell = LHTextFieldCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.textField.isHidden = false
        cell.textField.placeholder = "请输入"
        cell.titleLabel.text = titles[indexPath.row]
        cell.index = indexPath
        switch indexPath.row {
        case 0:
            cell.textField.isHidden = true

            cell.arrowButton.isHidden = false
            cell.arrowButton.set(image: .init(named: "icon_arrow_gray_down"), title: "    \(viewModel.daylightingCalcModel.city)", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
        case 1:
            cell.textField.text = "\(viewModel.daylightingCalcModel.longitude)"
        case 2:
            cell.textField.text = "\(viewModel.daylightingCalcModel.latitude)"
        case 3:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "米"
        case 4:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "层"
        case 5:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "米"
        case 6:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "层"
        case 7:
            cell.unitLabel.isHidden = false
            cell.unitLabel.text = "米"
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let cell = tableView.cellForRow(at: indexPath) as! LHTextFieldCell
            let latitudeCell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! LHTextFieldCell
            let longitudeCell = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as! LHTextFieldCell

            viewModel.showCityPicker { city in
                cell.arrowButton.set(image: .init(named: "icon_arrow_gray_down"), title: "    \(city.name)", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
                latitudeCell.textField.text = "\(city.latitude)"
                longitudeCell.textField.text = "\(city.longitude)"
            }
            
        default:
            break
        }
    }
}
