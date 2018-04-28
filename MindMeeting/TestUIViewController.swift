//
//  TestUIViewController.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 4. 28..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit

class TestUIViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //초기화
    let alarmCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        alarmCollectionView.setCollectionViewLayout(layout, animated: true)
        alarmCollectionView.delegate = self
        alarmCollectionView.dataSource = self
        alarmCollectionView.backgroundColor = UIColor.brown
        view.addSubview(alarmCollectionView)
        //view.backgroundColor = .yellow
        alarmCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    

    

}
