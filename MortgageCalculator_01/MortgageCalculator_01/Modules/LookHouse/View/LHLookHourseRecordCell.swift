//
//  LHLookHourseRecordCell.swift
//  MortgageCalculator_01
//
//  Created by iDog on 2021/12/4.
//

import UIKit

class LHLookHourseRecordCell: LHCollectionViewCell {
    let intentionView = UIImageView()
    let coverView = UIImageView()
    let selectView = UIImageView()

    override func setupUI() {
        super.setupUI()
        
        coverView.layer.cornerRadius = 6
        coverView.layer.masksToBounds = true
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(intentionView)
        intentionView.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
        }
        
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints { make in
            make.leading.top.equalTo(10.zoom())
            make.width.height.equalTo(24.zoom())
        }
        
    }
}
