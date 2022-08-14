//
//  LHCalcRecordCell.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/12.
//

import UIKit
import SwipeCellKit

class LHCalcRecordCell: SwipeTableViewCell {
    let typeIcon = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(typeIcon)
        typeIcon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 38.zoom(), height: 38.zoom()))
            make.leading.equalTo(15.zoom())
            make.top.equalTo(25.zoom())
            make.bottom.equalTo(-25.zoom())
        }
       
        let tagOne = UILabel()
        tagOne.text = "项目名称"
        tagOne.font = FontRegularHeiti(fontSize: 12)
        tagOne.textColor = kGray_123
        contentView.addSubview(tagOne)
        tagOne.snp.makeConstraints { make in
            make.top.equalTo(typeIcon)
            make.leading.equalTo((typeIcon.snp.trailing)).offset(10.zoom())
        }
        
        nameLabel.font = FontMediumHeiti(fontSize: 14)
        nameLabel.textColor = kGray_61
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(typeIcon)
            make.leading.equalTo(tagOne)
        }
        
        let tagTwo = UILabel()
        tagTwo.text = "计算时间"
        tagTwo.font = FontRegularHeiti(fontSize: 12)
        tagTwo.textColor = kGray_123
        contentView.addSubview(tagTwo)
        tagTwo.snp.makeConstraints { make in
            make.centerY.equalTo(tagOne)
            make.trailing.equalTo(-15.zoom())
        }
        
        dateLabel.font = FontRegularHeiti(fontSize: 14)
        dateLabel.textColor = kGray_61
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.trailing.equalTo(tagTwo)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
