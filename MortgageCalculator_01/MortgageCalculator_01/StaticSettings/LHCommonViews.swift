//
//  LHCommonViews.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/5.
//

import Foundation
import UIKit

//MARK: 渐变按钮
extension UIButton {
    func configGradientButtonUI() {
        self.setBackgroundImage(.init(named: "img_gradient_button_bg"), for: .normal)
        self.setBackgroundImage(.init(named: "img_gradient_button_bg"), for: .highlighted)
        self.titleLabel?.font = FontMediumHeiti(fontSize: 15)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}

//MARK: LHTextFieldCell
class LHTextFieldCell: LHTableViewCell {
    
    typealias textFieldValueChangedBlock = (_ sender: UITextField) -> Void

    let titleLabel = UILabel()
    let arrowButton = UIButton(type: .custom)
    let textField = UITextField()
    let unitLabel = UILabel()
    var index = IndexPath()
    var textFieldValueChangedBlock : textFieldValueChangedBlock?

    override func prepareForReuse() {
        super.prepareForReuse()
        arrowButton.isHidden = true
        textField.isHidden = true
        unitLabel.isHidden = true
        textField.isUserInteractionEnabled = true
    }
    
    override func setupUI() {
        super.setupUI()
        titleLabel.font = FontRegularHeiti(fontSize: 15)
        titleLabel.textColor = kGray_35
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(30.zoom())
            make.centerY.equalToSuperview()
        }
        
        arrowButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        arrowButton.titleLabel?.textAlignment = .right
        arrowButton.setTitleColor(kGray_184, for: .normal)
        arrowButton.setTitleColor(kGray_184, for: .disabled)
        arrowButton.titleLabel?.font = FontRegularHeiti(fontSize: 15)
        arrowButton.isUserInteractionEnabled = false
        contentView.addSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.trailing.equalTo(-20.zoom())
            make.centerY.equalToSuperview()
        }
        
        unitLabel.font = FontRegularHeiti(fontSize: 15)
        unitLabel.textColor = kGray_184
        contentView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowButton)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(100.zoom())
        }
        
        textField.font = FontRegularHeiti(fontSize: 15)
        textField.textColor = kGray_35
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueChanged), for: UIControl.Event.editingChanged)
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.trailing.equalTo(unitLabel.snp.leading).offset(-5.zoom())
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 150.zoom(), height: 20.zoom()))
        }
        
        arrowButton.isHidden = true
        textField.isHidden = true
        unitLabel.isHidden = true
    }
}
extension LHTextFieldCell:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" { // 允许删除
            return true
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    // 只允许输入数字和两位小数
        let expression =  "^[0-9]*((\\.|,)[0-9]{0,2})?$"
    // let expression = "^[0-9]*([0-9])?$" 只允许输入纯数字
    // let expression = "^[A-Za-z0-9]+$" //允许输入数字和字母
        let regex = try!  NSRegularExpression(pattern: expression, options: .allowCommentsAndWhitespace)
        let numberOfMatches =  regex.numberOfMatches(in: newString, options:.reportProgress,    range:NSMakeRange(0, newString.count))
        if  numberOfMatches == 0 {
             print("请输入数字")
             return false
        }
        
        let tempStr = textField.text?.appending(string);
        let numStr = tempStr?.split(separator: ".").first
        let num = Int(numStr!)
        if num! > 1000000 {
            return false
        }

       
      return true
    }
    @objc func textFieldValueChanged(_ textField: UITextField) {
        if (self.textFieldValueChangedBlock != nil) {
            self.textFieldValueChangedBlock!(textField)
        }
    }
}

//MARK: SectionView
class LHCommonSectionView: UITableViewHeaderFooterView {
    let titleLabel = UILabel()
    let lineView = UIImageView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        lineView.image = .init(named: "icon_section_line")
        lineView.contentMode = .scaleAspectFill
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(30.zoom())
            make.size.equalTo(CGSize(width: 3.zoom(), height: 13.zoom()))
            make.centerY.equalToSuperview()
        }
        
        titleLabel.font = FontRegularHeiti(fontSize: 15)
        titleLabel.textColor = kGray_35
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(lineView.snp.trailing).offset(10.zoom())
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: 空数据占位

class LHEmptyDataView:UIView {
    let coverView = UIImageView()
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setupUI() {
        backgroundColor = .white
        coverView.image = .init(named: "img_empty_data")
        addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10.zoom(), left: 30.zoom(), bottom: 40.zoom(), right: 30.zoom()))
        }
        
        titleLabel.textColor = kGray_61
        titleLabel.font = FontRegularHeiti(fontSize: 16)
        titleLabel.text = "暂无数据"
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverView.snp.bottom).offset(10.zoom())
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
