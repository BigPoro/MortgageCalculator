//
//  LHCollectionViewController.swift
//  LHProject_Swift
//
//  Created by iDog on 2021/12/4.
//

import UIKit
import EmptyDataSet_Swift

class LHCollectionViewController: LHBaseController,EmptyDataSetSource,EmptyDataSetDelegate {
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView:UICollectionView!
    var dataSource = Array<Any>()
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func setupUI() {
        super.setupUI()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.frame = self.view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(self.collectionView)
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let titleAttr = NSAttributedString.init(string: "暂无数据", attributes: [NSAttributedString.Key.font:FontMediumHeiti(fontSize: 16),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
        return titleAttr
    }
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return .init(named: "img_empty_data")
    }
}

extension LHCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}
