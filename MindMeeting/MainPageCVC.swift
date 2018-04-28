//
//  LoginCVC.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 4. 23..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit


class MainPageCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout,CollectionViewCellDelegate,signButtonClickedDelegate {
    
    
    func signBtnClick(email: String, password: String) {
        print("\(email)  \(password)")
    }
    

    var timer : Timer?
    
    var txt2 = [String]()
    //              0                  1                         2                3          4         5
    var txt = ["오 누군가오셨다!","안녕하세요! 만나서 반가워요~^^", "3초만에 시작해볼게요!", "yes.no 질문", "대답", "감사합니다"] // 0 - 5,count - 6
    
    
    var arrayNum = 0
    @objc func showTextPerSecond(){
        print("1초마다 행 삽입 함수 - showTextPerSecond txt2.count - \(txt2.count)")
        txt2.append(txt[arrayNum])
        //print("1초마다 행 삽입 함수 2 - txt2에 들어간 글자 - \(txt2[arrayNum]) \n") txt2[4] 오류남 없으니깐...
        arrayNum += 1
        let insertedIndexPath = IndexPath(item: txt2.count - 1, section: 0)
        collectionView?.insertItems(at: [insertedIndexPath])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(MainPageTextCell.self, forCellWithReuseIdentifier: "txt")
        self.collectionView!.register(ACell.self, forCellWithReuseIdentifier: "a")
        self.collectionView!.register(EmailJoinCell.self, forCellWithReuseIdentifier: "b")
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .brown
        
        timer =  Timer.scheduledTimer(timeInterval: 1.3,
                                      target: self,
                                      selector: #selector(showTextPerSecond),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return txt2.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "txt", for: indexPath) as? MainPageTextCell)!
        
        cell.textView.text = txt2[indexPath.row]
        cell.textView.layer.cornerRadius = 16
        cell.textView.layer.masksToBounds = true
        cell.textView.isEditable = false
        cell.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
        cell.bubbleViewLeftAnchor?.isActive = true
        cell.bubbleViewRightAnchor?.isActive = false
        cell.profileImageView.isHidden = false
        
        if(indexPath.item == 3){
            
            if(arrayNum == 5){
                print("array - 5")
                cell.textView.text = txt2[indexPath.row]
                cell.textView.backgroundColor = UIColor(red:0.73, green:0.73, blue:1.00, alpha:1.0)
                
                cell.textView.layer.cornerRadius = 16
                cell.textView.layer.masksToBounds = true
                cell.textView.isEditable = false
                cell.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
                
                cell.bubbleViewLeftAnchor?.isActive = false
                cell.bubbleViewRightAnchor?.isActive = true
                cell.profileImageView.isHidden = true
                
                return cell
            }else{
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "b", for: indexPath) as? EmailJoinCell)!

                cell.delegate = self
                
                stopTimerTest()
                
                return cell
            }
        }
//        else if(indexPath.item == 4){
//            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "a", for: indexPath) as? ACell)!
//            return cell
//        }
        return cell
    }


    //셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 45
        
        let cell =  collectionView.cellForItem(at: indexPath) as? MainPageTextCell
        if let text = cell?.textView.text {
            height = Int(estimatFrameForText(text: text).height + 20)
        }
        
        return CGSize(width: Int(view.frame.width), height: height)
    }
    
    //버블 높이
    private func estimatFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height:1000)
        let optoins = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string:text).boundingRect(with: size, options: optoins, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    func startTimerTest() {
        print("스타트 안 - 타이머 상태 \(timer?.isValid)")
        if timer == nil {
            print("시간 작동!")
            timer =  Timer.scheduledTimer(timeInterval: 1.3,
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

    func emailJoinBtn() {
        print("예스 버튼 \(arrayNum)")
        
        let sign = SignInVC()
        sign.signBtnDelegate = self
        sign.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        self.addChildViewController(sign)
        self.view.addSubview(sign.view)
        
        //self.present(sign, animated: true, completion: nil)
        
        
//                if(arrayNum == 4){
//                    print("txt2.cnt = \(txt2.count)")
//                    txt2.remove(at: 3)
//                    txt[4] = "넵~이메일로 가입할게요~"
//                    print("txt2.cnt = \(txt2.count)")
//                    let removeIndexPath = IndexPath(item: arrayNum-1, section: 0)
//                    collectionView?.deleteItems(at: [removeIndexPath])
//        }
//                startTimerTest()
    }

    @objc func noBtnTapped(){
        print("아니요 버튼")
    }
}

// ---------------------------------------------------------------------------------------------------------------- //

class ACell: UICollectionViewCell {
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"
        tv.backgroundColor = UIColor(red:0.16, green:0.70, blue:0.36, alpha:1.0)
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        //ios 9 constraints
        //x,y,w,h
        textView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// ---------------------------------------------------------------------------


protocol CollectionViewCellDelegate: class {
    func emailJoinBtn()
}

class EmailJoinCell: UICollectionViewCell {

    
    
    weak var delegate: CollectionViewCellDelegate?
    
    lazy var btn : UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("@ 이메일 가입", for: UIControlState())
        btn.setTitleColor(.black, for: UIControlState())
        btn.backgroundColor = UIColor(red:0.39, green:0.43, blue:0.81, alpha:1.0)
        btn.addTarget(self, action: #selector(btnbtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var btn2 : UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("이용약관", for: UIControlState())
        btn.setTitleColor(.black, for: UIControlState())
        btn.backgroundColor = UIColor.cyan
        btn.addTarget(self, action: #selector(actionWithParam), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    
    lazy var btn3 : UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("개인정보이용", for: UIControlState())
        btn.setTitleColor(.black, for: UIControlState())
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(btnbtn2), for: .touchUpInside)
        return btn
    }()
    
    @objc func actionWithParam(){
        print("이용약관 클릭")
    }
    
    @objc func btnbtn(){
        print("이메일가입 클릭 됏음")

        delegate?.emailJoinBtn()
    }
    
    

    
    
    @objc func btnbtn2(){
        print("개인 정보 클릭됏음")
    }
    
    
    let lable : UILabel = {
            let lbl = UILabel()
            lbl.text = "과"
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
    }()
    
    let lable2 : UILabel = {
        let lbl = UILabel()
        lbl.text = "에 동의합니다."
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(btn)
        self.addSubview(btn2)
        self.addSubview(btn3)
        self.addSubview(lable)
        self.addSubview(lable2)

        //ios 9 constraints
        //x,y,w,h

        btn.leftAnchor.constraint(equalTo: self.leftAnchor,constant:20).isActive = true
        btn.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10).isActive = true
        btn.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //이용약관
        btn2.leftAnchor.constraint(equalTo: btn.leftAnchor).isActive = true
        btn2.topAnchor.constraint(equalTo: btn.bottomAnchor,constant:20).isActive = true
        btn2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        //과
        lable.leftAnchor.constraint(equalTo: btn2.rightAnchor,constant:5).isActive = true
        lable.topAnchor.constraint(equalTo: btn.bottomAnchor,constant:20).isActive = true
        lable.widthAnchor.constraint(equalToConstant: 5).isActive = true
        lable.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        //개인정보
        btn3.leftAnchor.constraint(equalTo: lable.rightAnchor).isActive = true
        btn3.topAnchor.constraint(equalTo: btn.bottomAnchor,constant:20).isActive = true
        btn3.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn3.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        //에 동의합니다.
        lable2.leftAnchor.constraint(equalTo: btn3.rightAnchor).isActive = true
        lable2.topAnchor.constraint(equalTo: btn.bottomAnchor,constant:20).isActive = true
        lable2.widthAnchor.constraint(equalToConstant: 200).isActive = true
        lable2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// --------------------------------------------------------------------------------------------------------

class MainPageTextCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = ""
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kyk2.jpeg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //ios 9 constraints
        //x,y,w,h
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ios 9 constraints
        //x,y,w,h
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

