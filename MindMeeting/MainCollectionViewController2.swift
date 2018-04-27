//
//  MainCollectionViewController2.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 4. 26..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController2: UICollectionViewController,UICollectionViewDelegateFlowLayout{

    var timer : Timer?
    
    //오른쪽 왼쪽으로 돌렸을 때
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 58, right: 0)
        print("진입점 - viewDidLoad \n")
        //셀 등록
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(MainPageTextCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView!.backgroundColor = UIColor(red:0.61, green:0.85, blue:0.49, alpha:1.0)
        
        
        timer =  Timer.scheduledTimer(timeInterval: 1.3,
                                      target: self,
                                      selector: #selector(showTextPerSecond),
                                      userInfo: nil,
                                      repeats: true)
    }
    var txt2 = [String]()
    var txt = ["안녕하세요^^" , "만나뵈서 정말 반가워요~!", "10초정도만 시간을 주실 수 있으세요^^?","yes or no", "yes", "네 알겠습니다~"] // 0 - 5    , count - 6
    
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("행구성 - cellForItemAt - 몇번째 행 - \(indexPath.row)")
        print("arraynum - \(arrayNum) \n")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MainPageTextCell
        if(indexPath.row < 3){
            cell?.textView.text = txt2[indexPath.row]
            //cell?.textView.backgroundColor = .white
            cell?.textView.layer.cornerRadius = 16
            cell?.textView.layer.masksToBounds = true
            cell?.textView.isEditable = false
            cell?.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
            cell?.bubbleViewLeftAnchor?.isActive = true
            cell?.bubbleViewRightAnchor?.isActive = false
            cell?.profileImageView.isHidden = false
            
            
        }else if (indexPath.row == 3){
            if(arrayNum == 5){
                print("array - 5")
                cell?.textView.text = txt2[indexPath.row]
                cell?.textView.backgroundColor = UIColor(red:0.73, green:0.73, blue:1.00, alpha:1.0)
                
                cell?.textView.layer.cornerRadius = 16
                cell?.textView.layer.masksToBounds = true
                cell?.textView.isEditable = false
                cell?.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
                
                cell?.bubbleViewLeftAnchor?.isActive = false
                cell?.bubbleViewRightAnchor?.isActive = true
                cell?.profileImageView.isHidden = true
                
                return cell!
            }else{
                
                print("indexpath-3 번째 행에서 arraynum - \(arrayNum) \n")
                cell?.textView.isEditable = false
                cell?.profileImageView.isHidden = true
                cell?.bubbleView.backgroundColor = .clear
                
                
                let yesbtn = UIButton(frame: CGRect(x: 5, y:20, width:(cell?.frame.size.width)! - 30,height:40))
                yesbtn.backgroundColor = .green
                yesbtn.setTitle("이메일로 가입할래요", for: UIControlState())
                yesbtn.addTarget(self, action: #selector(emailJoin), for: .touchUpInside)
                
                let nobtn = UIButton(frame: CGRect(x: 5, y: 80, width:(cell?.frame.size.width)! - 30,height:40))
                nobtn.backgroundColor = .red
                nobtn.setTitle("아뇨", for: UIControlState())
                nobtn.addTarget(self, action: #selector(noBtnTapped), for: .touchUpInside)
                
                
                cell?.addSubview(yesbtn)
                cell?.addSubview(nobtn)
                stopTimerTest()
                
            }
            
        }else{
            cell?.textView.text = txt2[indexPath.row]
            //cell?.textView.backgroundColor = .white
            cell?.textView.layer.cornerRadius = 16
            cell?.textView.layer.masksToBounds = true
            cell?.textView.isEditable = false
            cell?.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
            
            cell?.bubbleViewLeftAnchor?.isActive = false
            cell?.bubbleViewRightAnchor?.isActive = true
            cell?.profileImageView.isHidden = true
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
    @objc func emailJoin(cell: UICollectionViewCell){
        print("예스 버튼")
        if(arrayNum == 4){
            //cell.backgroundView?.isHidden = true
            
            print("네, 아뇨 삭제")
            print("txt2.cnt = \(txt2.count)")
            txt2.remove(at: 3)
            txt[5] = "넵~이메일로 가입할게요~"
            print("txt2.cnt = \(txt2.count)")
            let removeIndexPath = IndexPath(item: arrayNum-1, section: 0)
            collectionView?.deleteItems(at: [removeIndexPath])
            
            cell.superview?.isHidden = true
            //collectionView?.cellForItem(at: removeIndexPath)?.contentView
            //cell.delete(cell)
            //cell.isHidden = true
            // Timer.scheduledTimer(timeInterval: 0.1, target: self,  selector: #selector(noBtnTapped), userInfo: nil, repeats: false)
        }
        
        startTimerTest()
    }
    
    
    @objc func noBtnTapped(){
        print("아니요 버튼")
        
    }
}
