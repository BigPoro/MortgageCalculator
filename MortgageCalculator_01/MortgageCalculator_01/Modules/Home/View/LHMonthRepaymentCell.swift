//
//  LHMonthRepaymentCell.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/9.
//

import UIKit

class LHMonthRepaymentCell: LHTableViewCell {
    
    var contentLabelArr = Array<UILabel>()
    
    override func setupUI() {
        super.setupUI()
        self.backgroundColor = kGray_244
        contentView.backgroundColor = kGray_244
        for _ in 0..<5 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = FontRegularHeiti(fontSize: 12)
            label.textColor = kGray_61
            contentView.addSubview(label)
            contentLabelArr.append(label)
        }
        
        contentLabelArr.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        contentLabelArr.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(38.zoom())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
