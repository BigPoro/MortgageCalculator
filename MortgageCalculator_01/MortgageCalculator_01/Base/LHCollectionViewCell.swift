//
//  LHCollectionViewCell.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import UIKit

class LHCollectionViewCell: UICollectionViewCell {
    var cellData:Any?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor.white
    }
}
