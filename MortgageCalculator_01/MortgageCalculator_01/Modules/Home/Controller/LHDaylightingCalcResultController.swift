//
//  LHDaylightingCalcResultController.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/15.
//

import UIKit
import SVProgressHUD

class LHDaylightingCalcResultController: LHBaseController {
    var resultModel:LHDaylightingCalcResultModel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setupUI() {
        super.setupUI()
        navigation.item.title = "结算结果"
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
        
        let scrollerView = UIScrollView(frame: CGRect(x: 0, y: kNavigationBarHeight, width: view.width, height: view.height - kNavigationBarHeight))
        view.addSubview(scrollerView)
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 180.zoom())
        containerView.backgroundColor = .white
        scrollerView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollerView.width)
        }
        
        let bgView = UIImageView()
        bgView.image = .init(named: "img_daylighting_bg")
        containerView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(20.zoom())
            make.centerX.equalToSuperview()
        }
        
        let titleOne = UILabel()
        titleOne.text = "结论（仅供参考）"
        titleOne.textColor = kGray_35
        titleOne.font = FontMediumHeiti(fontSize: 15)
        containerView.addSubview(titleOne)
        titleOne.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(20.zoom())
            make.leading.equalTo(30.zoom())
        }
        
        let resultLabel = UILabel()
        resultLabel.text = resultModel.resultDesc
        resultLabel.textColor = kGray_123
        resultLabel.font = FontRegularHeiti(fontSize: 15)
        containerView.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(titleOne.snp.bottom).offset(10.zoom())
            make.leading.equalTo(titleOne)
        }
        
        let titleTwo = UILabel()
        titleTwo.text = "计算公式"
        titleTwo.textColor = kGray_35
        titleTwo.font = FontMediumHeiti(fontSize: 15)
        containerView.addSubview(titleTwo)
        titleTwo.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20.zoom())
            make.leading.equalTo(titleOne)

        }
        
        let formulaLabel = UILabel()
        formulaLabel.textColor = kGray_123
        formulaLabel.font = FontRegularHeiti(fontSize: 15)
        formulaLabel.numberOfLines = 0
        formulaLabel.preferredMaxLayoutWidth = view.width - 2 * 30.zoom()
        formulaLabel.text = """
        tan(a)=(遮阳楼层数-你的楼层数)*层高/楼间距
        
        城市冬至日采光度 = 90°-a°-城市纬度
        
        说明：冬至日是北半球太阳最远的位置，如计算该天采光直射角度 > a ,则全年不存在问题
        """
        containerView.addSubview(formulaLabel)
        formulaLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTwo.snp.bottom).offset(10.zoom())
            make.leading.equalTo(titleOne)
        }
        
        let titleThree = UILabel()
        titleThree.text = "备注"
        titleThree.textColor = kGray_123
        titleThree.font = FontRegularHeiti(fontSize: 15)
        titleThree.numberOfLines = 0
        containerView.addSubview(titleThree)
        titleThree.snp.makeConstraints { make in
            make.top.equalTo(formulaLabel.snp.bottom).offset(40.zoom())
            make.leading.equalTo(titleOne)
        }
        let remarkLabel = UILabel()
        remarkLabel.textColor = kGray_123
        remarkLabel.font = FontRegularHeiti(fontSize: 13)
        remarkLabel.numberOfLines = 0
        remarkLabel.text = """
        纬度取值范围：0~90
        计算结果基于以下假设：遮阳楼与所住楼均朝正南方向
        本工具计算结果仅供参考
        """
        containerView.addSubview(remarkLabel)
        remarkLabel.snp.makeConstraints { make in
            make.top.equalTo(titleThree.snp.bottom).offset(2.zoom())
            make.leading.equalTo(titleOne)
        }

        let saveButton = UIButton.init(type: .custom)
        saveButton.configGradientButtonUI()
        saveButton.setTitle("保存照片", for: .normal)
        containerView.addSubview(saveButton)
        saveButton.onTap { [unowned self]  in
            let screenshot = view.snapshot()
            LHSaveImageHelper.saveImageToPhotoLibrary(image: screenshot)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(remarkLabel.snp.bottom).offset(40.zoom())
            make.height.equalTo(44.zoom())
            make.width.equalTo(300.zoom())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20.zoom())
        }
        
    }
}
