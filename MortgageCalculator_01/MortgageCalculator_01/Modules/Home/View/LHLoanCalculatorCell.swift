//
//  LHLoanCalculatorCell.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/6.
//

import UIKit


class LHLoanCalculatorCell: LHTableViewCell {

    let titleLabel = UILabel()
    let arrowButton = UIButton(type: .custom)
    let textField = UITextField()
    let unitLabel = UILabel()
    let lprButton = UIButton(type: .custom)
    let baseButton = UIButton(type: .custom)
    let modeOneButton = UIButton(type: .custom)
    let modeTwoButton = UIButton(type: .custom)

    var switchModeBlock : ((_ mode: Int) -> Void)?
    var lprButtonClickedBlock : ((_ sender: UIButton) -> Void)?
    var baseButtonClickedBlock : ((_ sender: UIButton) -> Void)?
    var textFieldValueChangedBlock : ((_ sender: UITextField) -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()
        arrowButton.isHidden = true
        textField.isHidden = true
        unitLabel.isHidden = true
        lprButton.isHidden = true
        baseButton.isHidden = true
        modeOneButton.isHidden = true
        modeTwoButton.isHidden = true
        lprButton.tag = 0;
        baseButton.tag = 0;
        unitLabel.textColor = kGray_184
        textField.isUserInteractionEnabled = true
    }
    
    override func setupUI() {
        super.setupUI()
        titleLabel.font = FontRegularHeiti(fontSize: 15)
        titleLabel.textColor = kGray_35
        titleLabel.textColor = kGray_35
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(20.zoom())
            make.centerY.equalToSuperview()
        }
        
        arrowButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        arrowButton.titleLabel?.textAlignment = .right
        arrowButton.setTitleColor(kGray_184, for: .normal)
        arrowButton.setTitleColor(kGray_184, for: .disabled)
        arrowButton.titleLabel?.font = FontRegularHeiti(fontSize: 15)
        arrowButton.set(image: .init(named: "icon_arrow_black_down"), title: "根据面积、单价计算", titlePosition: .left, additionalSpacing: 10.zoom(), state: .normal)
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
        
        lprButton.setImage(.init(named: "icon_lpr_normal"), for: .normal)
        lprButton.setImage(.init(named: "icon_lpr_selected"), for: .selected)
        lprButton.isSelected = true
        contentView.addSubview(lprButton)
        lprButton.snp.makeConstraints { make in
            make.trailing.equalTo(arrowButton)
            make.centerY.equalToSuperview()
        }
        
        baseButton.setImage(.init(named: "icon_base_normal"), for: .normal)
        baseButton.setImage(.init(named: "icon_base_selected"), for: .selected)
        contentView.addSubview(baseButton)
        baseButton.snp.makeConstraints { make in
            make.trailing.equalTo(lprButton.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        modeTwoButton.setTitle(" 等额本金", for: .normal)
        modeTwoButton.setTitleColor(kGray_184, for: .normal)
        modeTwoButton.setTitleColor(kGray_35, for: .selected)
        modeTwoButton.setImage(.init(named: "icon_radio_button_normal"), for: .normal)
        modeTwoButton.setImage(.init(named: "icon_radio_button_selected"), for: .selected)
        contentView.addSubview(modeTwoButton)
        modeTwoButton.snp.makeConstraints { make in
            make.trailing.equalTo(arrowButton)
            make.centerY.equalToSuperview()
        }
        
        modeOneButton.setTitle(" 等额本息", for: .normal)
        modeOneButton.setTitleColor(kGray_184, for: .normal)
        modeOneButton.setTitleColor(kGray_35, for: .selected)
        modeOneButton.setImage(.init(named: "icon_radio_button_normal"), for: .normal)
        modeOneButton.setImage(.init(named: "icon_radio_button_selected"), for: .selected)
        contentView.addSubview(modeOneButton)
        modeOneButton.snp.makeConstraints { make in
            make.trailing.equalTo(modeTwoButton.snp.leading).offset(-10.zoom())
            make.centerY.equalToSuperview()
        }
        
        arrowButton.isHidden = true
        textField.isHidden = true
        unitLabel.isHidden = true
        lprButton.isHidden = true
        baseButton.isHidden = true
        modeOneButton.isHidden = true
        modeTwoButton.isHidden = true
        
        modeOneButton.onTap { [unowned self]  in
            modeTwoButton.isSelected = false
            modeOneButton.isSelected = true
            if (self.switchModeBlock != nil) {
                self.switchModeBlock!(1)
            }
        }
        modeTwoButton.onTap { [unowned self]  in
            modeOneButton.isSelected = false
            modeTwoButton.isSelected = true
            if (self.switchModeBlock != nil) {
                self.switchModeBlock!(2)
            }
        }
        lprButton.onTap { [unowned self] in
            lprButton.isSelected = true
            baseButton.isSelected = false
            if (self.lprButtonClickedBlock != nil) {
                self.lprButtonClickedBlock!(lprButton)
            }
        }
        baseButton.onTap { [unowned self]  in
            if (self.baseButtonClickedBlock != nil) {
                self.baseButtonClickedBlock!(baseButton)
            }
        }
    }

}
extension LHLoanCalculatorCell:UITextFieldDelegate {
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
