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

   
    @objc func yesBtnTapped(){
    print("예스 버튼")
        if(count == 5){
            print("네, 아뇨 삭제")
            say.remove(at: 4)
            let removeIndexPath = IndexPath(item: count-1, section: 0)
            collectionView?.deleteItems(at: [removeIndexPath])
        }
        startTimerTest()
    }
    
    @objc func noBtnTapped(){
        print("아니요 버튼")
    }
    
    var timerTest : Timer?
    var say = [String]()
    var txt = ["안녕하세요","정말 반가워요^^" , "잠깐 10초면 진행가능 한데","괜찮으시겠어요^^?" , "권유대답버튼" , "감사합니다.^^","저는 강영균이라고 하는데" , "혹시 제가 님을 뭐라고 부르면 될까요^^?", "이름들어가는 텍스트 필드" ,"네~ 00님 제 친구랑 비슷한데요^^?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        //셀 등록
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(MainPageTextCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor(red:0.91, green:0.50, blue:0.01, alpha:1.0)
        
       timerTest =  Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(perTimeAddText),
                             userInfo: nil,
                             repeats: true)
    }
    
    var count = 0
    @objc func perTimeAddText(){
        print("perTimeAddText say배열 개수: \(say.count)  count: \(count)")
        
        if(say.count<10){
            
            say.append(txt[count])
            count += 1
            let insertedIndexPath = IndexPath(item: say.count-1, section: 0)
            collectionView?.insertItems(at: [insertedIndexPath])
            
            
        }else if (say.count>=10){
            stopTimerTest()
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection - \(say.count)")
        return say.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt - \(say.count) - \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MainPageTextCell
        
        if(indexPath.row < 4){
            cell?.layer.cornerRadius = 16
            cell?.layer.masksToBounds = true
            cell?.textView.text = say[indexPath.row]
            cell?.textView.backgroundColor = .white
            cell?.textView.isEditable = false
        }else if(indexPath.row == 4){
            print("4번째 로우 들어왔고 stop 타이머 호출")
            let yesbtn = UIButton(frame: CGRect(x:(cell?.frame.size.width)! / 2 - 90, y:20, width:80,height:40))
            yesbtn.backgroundColor = .green
            yesbtn.setTitle("네", for: UIControlState())
            yesbtn.addTarget(self, action: #selector(yesBtnTapped), for: .touchUpInside)
            
            let nobtn = UIButton(frame: CGRect(x:(cell?.frame.size.width)! / 2, y:20, width:80,height:40))
            nobtn.backgroundColor = .red
            nobtn.setTitle("아뇨", for: UIControlState())
            nobtn.addTarget(self, action: #selector(noBtnTapped), for: .touchUpInside)
            
            cell?.addSubview(yesbtn)
            cell?.addSubview(nobtn)
            cell?.textView.isEditable = false
            stopTimerTest()
        }else if(indexPath.row == 8){
            print("8번째 로우 들어왔고 stop타이머 호출")
            let yesbtn2 = UIButton(frame: CGRect(x:(cell?.frame.size.width)! / 2 - 90, y:20, width:80,height:40))
            yesbtn2.backgroundColor = .green
            yesbtn2.setTitle("네", for: UIControlState())
            yesbtn2.addTarget(self, action:#selector(yesBtnTapped), for: .touchUpInside)
            
            let nobtn2 = UIButton(frame: CGRect(x:(cell?.frame.size.width)! / 2, y:20, width:80,height:40))
            nobtn2.backgroundColor = .red
            nobtn2.setTitle("아뇨", for: UIControlState())
            nobtn2.addTarget(self, action: #selector(noBtnTapped), for: .touchUpInside)
            
            cell?.addSubview(yesbtn2)
            cell?.addSubview(nobtn2)
            cell?.textView.isEditable = false
            stopTimerTest()
        }else{
            cell?.layer.cornerRadius = 16
            cell?.layer.masksToBounds = true
            cell?.textView.text = say[indexPath.row]
            cell?.textView.backgroundColor = .white
            cell?.textView.isEditable = false
        }

        return cell!
    }
    
    //셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func startTimerTest() {
        print("스타트 안 - 타이머 상태 \(timerTest?.isValid)")
        if timerTest == nil {
            print("시간 작동!")
           timerTest =  Timer.scheduledTimer(timeInterval: 1.3,
                                 target: self,
                                 selector: #selector(perTimeAddText),
                                 userInfo: nil,
                                 repeats: true)
            
        }
    }
    func stopTimerTest() {
        print("스탑 안 - 타이머 상태 \(timerTest?.isValid)")
        if timerTest != nil {
            print("시간 정지!")
            timerTest?.invalidate()
            timerTest = nil
        }
    }
}
