//
//  LoginCVC.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 4. 23..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainPageCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var timer : Timer?
    
    //오른쪽 왼쪽으로 돌렸을 때
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        print("진입점 - viewDidLoad \n")
        //셀 등록
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(MainPageTextCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView!.backgroundColor = UIColor(red:0.61, green:0.85, blue:0.49, alpha:1.0)
        
        
        timer =  Timer.scheduledTimer(timeInterval: 2.0,
                                      target: self,
                                      selector: #selector(showTextPerSecond),
                                      userInfo: nil,
                                      repeats: true)
    }
    var txt2 = [String]()
    var txt = ["안녕" , "반가워" , "10초걸리는데 괜찮아?","yes or no", "yes","감사합니다."] // 0 - 5    , count - 6
    
    var arrayNum = 0
    @objc func showTextPerSecond(){
        print("1초마다 행 삽입 함수 - showTextPerSecond txt2.count - \(txt2.count)")
        txt2.append(txt[arrayNum])
        //print("1초마다 행 삽입 함수 2 - txt2에 들어간 글자 - \(txt2[arrayNum]) \n") txt2[4] 오류남 없으니깐...
        arrayNum += 1
        let insertedIndexPath = IndexPath(item: txt2.count - 1, section: 0)
        collectionView?.insertItems(at: [insertedIndexPath])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("행개수 - numberOfItemsInSection -txt2.count -  \(txt2.count) \n")
        return txt2.count
    }
    
    
    lazy var yesBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("네", for: UIControlState())
        btn.backgroundColor = .green
        btn.addTarget(self, action: #selector(yesBtnTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var noBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("아니요", for: UIControlState())
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(noBtnTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("행구성 - cellForItemAt - 몇번째 행 - \(indexPath.row)")
        print("arraynum - \(arrayNum) \n")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MainPageTextCell
        if(indexPath.row < 3){
            cell?.textView.text = txt2[indexPath.row]
            cell?.textView.backgroundColor = .white
            cell?.textView.layer.cornerRadius = 16
            cell?.textView.layer.masksToBounds = true
            cell?.textView.isEditable = false
            cell?.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
        }else if (indexPath.row == 3){
            if(arrayNum == 5){
                print("array - 5")
                cell?.textView.text = txt2[indexPath.row]
                //cell?.textView.backgroundColor = .white
                cell?.textView.layer.cornerRadius = 16
                cell?.textView.layer.masksToBounds = true
                cell?.textView.isEditable = false
                cell?.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
                return cell!
            }else{
                //cell =  yesNoCellButton(indexPath: indexPath)
                print("indexpath-3 번째 행에서 arraynum - \(arrayNum) \n")
                //cell?.textView.backgroundColor = .clear
                //cell?.textView.isHidden = true
                cell?.bubbleView.backgroundColor = .clear
                
                cell?.addSubview(yesBtn)
                cell?.addSubview(noBtn)
                
                yesBtn.leadingAnchor.constraint(equalTo: (cell?.leadingAnchor)!, constant: 30).isActive = true
                yesBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
                yesBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
                noBtn.trailingAnchor.constraint(equalTo: (cell?.trailingAnchor)!, constant: -30).isActive = true
                noBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
                noBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
                cell?.textView.isEditable = false
                stopTimerTest()
            }
            
        }else{
            cell?.textView.text = txt2[indexPath.row]
            cell?.textView.backgroundColor = .white
            cell?.textView.layer.cornerRadius = 16
            cell?.textView.layer.masksToBounds = true
            cell?.textView.isEditable = false
            cell?.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
        }
        
        return cell!
    }
    
    //셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 40
        
        let cell =  collectionView.cellForItem(at: indexPath) as? MainPageTextCell
        if let text = cell?.textView.text {
            height = Int(estimatFrameForText(text: text).height + 20)
        }
        
        return CGSize(width: Int(view.frame.width), height: height)
    }
    
    
    private func estimatFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height:1000)
        let optoins = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string:text).boundingRect(with: size, options: optoins, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    func startTimerTest() {
        print("스타트 안 - 타이머 상태 \(timer?.isValid)")
        if timer == nil {
            print("시간 작동!")
            timer =  Timer.scheduledTimer(timeInterval: 2.0,
                                          target: self,
                                          selector: #selector(showTextPerSecond),
                                          userInfo: nil,
                                          repeats: true)
        }
    }
    func stopTimerTest() {
        print("스탑 안 - 타이머 상태 \(timer?.isValid)")
        if timer != nil {
            print("시간 정지!")
            timer?.invalidate()
            timer = nil
        }
    }
    @objc func yesBtnTapped(){
        print("예스 버튼")
        if(arrayNum == 4){
            print("네, 아뇨 삭제")
            print("txt2.cnt = \(txt2.count)")
            txt2.remove(at: 3)
            txt[4] = "괜찮아요~~~~"
            print("txt2.cnt = \(txt2.count)")
            let removeIndexPath = IndexPath(item: arrayNum-1, section: 0)
            collectionView?.deleteItems(at: [removeIndexPath])
            yesBtn.isHidden = true
            noBtn.isHidden = true
            
        }
        startTimerTest()
    }
    @objc func noBtnTapped(){
        print("아니요 버튼")
    }
}
