//
//  CollectionViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2024/1/11.
//  Copyright © 2024 Hem1ngT4i. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private let reuseId = "ReusedId"
    let dataList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.size.width
        let itemSpacing: CGFloat = 50
        let width = (screenWidth - itemSpacing) / 2.0
        layout.itemSize = CGSize(width: width, height: 120)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 140), collectionViewLayout: layout)
        collectionView.center = view.center
        collectionView.backgroundColor = .green
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        view.addSubview(collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        let view1001 = cell.contentView.subviews.first { $0.tag == 1001 }
        if view1001 == nil {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            label.backgroundColor = .red
            label.tag = 1001
//            label.image = UIImage(systemName: "circle")
            label.text = "\(dataList[indexPath.row])"
            cell.contentView.addSubview(label)
        }
        cell.backgroundColor = .orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("indexPath: \(indexPath)")
    }
}
