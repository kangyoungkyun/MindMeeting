//
//  LoginCVC.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 4. 23..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase

class MainPageCVC: UICollectionViewController, UICollectionViewDelegateFlowLayout,CollectionViewCellDelegate,signButtonClickedDelegate,NameCellDelegate {
    
    var loginCheck = false
    
    func nameInsertBtn(name: String) {
        print("메인페이지로 넘어와서 이름 버튼! \(name)")
        print("arraynum - \(arrayNum)")
        if name == ""{
            return
        }else{
            let ChangeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
            ChangeRequest.displayName = name
            ChangeRequest.commitChanges(completion: nil)
            
            //데이터 베이스 참조 함수
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            //부모키 user를 만들고 그 밑에 각자의 아이디로 또 자식을 만든다.
            let usersReference = ref.child("users").child(uid!)
            
            //데이터 객체 만들기
            let userInfo: [String:Any] = ["name" : name]
            //해당 경로에 삽입
            usersReference.setValue(userInfo)
            
            ref.removeAllObservers()
            
            if(arrayNum == 9){
                print("txt2.cnt = \(txt2.count)")
                
                print("\(txt2[7])") //호칭질문
                
                txt2.remove(at: 7)
                txt[9] = "\(name)으로 불러주세요"
                txt[10] = "오 괜찮은것 같아요^^"
                txt[11] = "그럼 \(name)님, 시작해 볼게요~!"
                print("txt2.cnt = \(txt2.count)")
                let removeIndexPath = IndexPath(item: arrayNum-2, section: 0)
                collectionView?.deleteItems(at: [removeIndexPath])
            }
            startTimerTest()
        }
    }
    
    //로그인
    func loginBtnClick(email: String, password: String) {
        print("메인페이지로 넘어와서 로그인 버튼! \(email)  \(password)")
        print("arraynum - \(arrayNum)")
        
        
        //nil 값 검사
        guard email != "", password != "" else{return}
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                //로그인 폼 유효성 검사
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        let alert = UIAlertController(title: "알림 ", message:"이메일 형식을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .wrongPassword :
                        let alert = UIAlertController(title: "알림 ", message:"비밀번호를 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .accountExistsWithDifferentCredential :
                        let alert = UIAlertController(title: "알림 ", message:"이메일을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .userNotFound :
                        let alert = UIAlertController(title: "알림 ", message:"존재하지 않는 이메일입니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = UIAlertController(title: "알림 ", message:"다시 시도해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                return
            }else{
                //유저가 있을때
                if user != nil{
                    self.loginCheck = true
                    if(self.arrayNum == 4){
                        self.txt2.remove(at: 3)
                        self.txt[4] = "네~ 이메일로 시작할게요"
                        self.txt[5] = "오오~가입하셨네요^^"
                        self.txt[6] = "어쩐지 낯설지 않은 느낌?"
                        self.txt[7] = "그럼 바로 시작해 볼까요^^?"
                        //print("txt2.cnt = \(txt2.count)") //3
                        let removeIndexPath = IndexPath(item: self.arrayNum-1, section: 0)
                        self.collectionView?.deleteItems(at: [removeIndexPath])
                    }
                    self.startTimerTest()
                    
                }
            }

        }
    }

    func signBtnClick(email: String, password: String) {
        print("메인페이지로 넘어와서 가입 버튼! \(email)  \(password)")
        
        guard email != "", password != "" else{return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                //가입 폼 유효성 검사
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        let alert = UIAlertController(title: "알림 ", message:"이메일 형식을 확인해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.stopTimerTest()
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "알림 ", message:"이미 존재하는 이메일입니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.stopTimerTest()
                    case .weakPassword :
                        let alert = UIAlertController(title: "알림 ", message:"보안에 취약한 비밀번호입니다.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.stopTimerTest()
                    default:
                        let alert = UIAlertController(title: "알림 ", message:"다시 시도해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.stopTimerTest()
                    }
                }
                return
            }else{
                if let user = user{
                    
                    //데이터 베이스 참조 함수
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    //부모키 user를 만들고 그 밑에 각자의 아이디로 또 자식을 만든다.
                    let usersReference = ref.child("users").child(user.uid)
                    
                    //데이터 객체 만들기
                    let userInfo: [String:Any] = ["uid" : user.uid]
                    //해당 경로에 삽입
                    usersReference.setValue(userInfo)
                    
                    //대화 진행
                    print("arraynum - \(self.arrayNum)")
                    if(self.arrayNum == 4){
                        
                        print("txt2.cnt = \(self.txt2.count)")
                        self.txt2.remove(at: 3)
                        self.txt[4] = "네~ 이메일로 시작할게요"
                        print("txt2.cnt = \(self.txt2.count)")
                        let removeIndexPath = IndexPath(item: self.arrayNum-1, section: 0)
                        self.collectionView?.deleteItems(at: [removeIndexPath])
                    }
                    self.startTimerTest()
                }
                
            }
            
        }
    }

    var timer : Timer?
    var txt2 = [String]()
    //              0                  1                         2                3          4         5
    var txt = ["오 누군가오셨다!","안녕하세요! 반가워요~^^", "3초만에 시작해볼게요!", "yes.no 질문", "대답", "에고 3초 더 걸린것 같네요^^;",
               "저는 운영자 강영균 입니다." , "제가 님을 어떻게 불러드려요^^?", "호칭 질문", "호칭대답" ,"오 괜찮은것 같아요^^","그럼 000님 시작해 볼게요^^", "네 좋아요"]
    //6                               7                          8        9          10                    11
    // 0 - 5,count - 6
    
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
        collectionView?.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 58, right: 0)
        self.collectionView!.register(MainPageTextCell.self, forCellWithReuseIdentifier: "txt")
        self.collectionView!.register(nameCell.self, forCellWithReuseIdentifier: "a")
        self.collectionView!.register(EmailJoinCell.self, forCellWithReuseIdentifier: "b")
        self.collectionView!.register(startCell.self, forCellWithReuseIdentifier: "start")
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(red:0.81, green:0.87, blue:0.56, alpha:1.0)
        
        timer =  Timer.scheduledTimer(timeInterval: 1.3,
                                      target: self,
                                      selector: #selector(showTextPerSecond),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                cell.textView.backgroundColor = UIColor(red:0.98, green:0.89, blue:0.55, alpha:1.0)
                cell.bubbleView.backgroundColor = UIColor(red:0.98, green:0.89, blue:0.55, alpha:1.0)
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
        else if(indexPath.item == 7){
            print("인덱스가 7일때 어레이 넘. \(arrayNum)")
            if(arrayNum == 10){
                print("array - 10")
                cell.textView.text = txt2[indexPath.row]
                cell.textView.backgroundColor = UIColor(red:0.98, green:0.89, blue:0.55, alpha:1.0)
                cell.bubbleView.backgroundColor = UIColor(red:0.98, green:0.89, blue:0.55, alpha:1.0)
                cell.textView.layer.cornerRadius = 16
                cell.textView.layer.masksToBounds = true
                cell.textView.isEditable = false
                cell.bubbleWidthAnchor?.constant = estimatFrameForText(text: txt2[indexPath.row]).width + 32
                
                cell.bubbleViewLeftAnchor?.isActive = false
                cell.bubbleViewRightAnchor?.isActive = true
                cell.profileImageView.isHidden = true
                
                return cell
            }else{
                
                //이미 로그인 한 사람이면  바로 시작 하기 cell
                if(loginCheck){
                    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "start", for: indexPath) as? startCell)!
                    stopTimerTest()
                    return cell
                    
                }else{
                    //이름 입력하는 부분
                    let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "a", for: indexPath) as? nameCell)!
                    cell.nameDelegate = self
                    stopTimerTest()
                    return cell
                }

            }
            
        }else if(indexPath.item == 10){
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "start", for: indexPath) as? startCell)!
            stopTimerTest()
            return cell
        }
        return cell
    }
    
    //셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 39
        
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
        print("이메일 가입 버튼 \(arrayNum)")
        let sign = SignInVC()
        sign.signBtnDelegate = self
        sign.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChildViewController(sign)
        self.view.addSubview(sign.view)
    }
}

// ---------------------------------------------------------------------------------------------------------------- //
protocol NameCellDelegate: class {
    func nameInsertBtn(name:String)
}
class nameCell: UICollectionViewCell {
    
    var nameDelegate: NameCellDelegate?
    
    //이메일 텍스트 필드
    let nameTextField : UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.masksToBounds = true
        txtField.layer.cornerRadius = 10
        txtField.layer.backgroundColor = UIColor(red:0.80, green:0.86, blue:0.87, alpha:1.0).cgColor
        txtField.placeholder = "  닉네임"
        return txtField
    }()
    
    //기존 계정으로 로그인
    lazy var nameButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("확인", for: UIControlState())
        btn.setTitleColor(UIColor(red:0.17, green:0.39, blue:0.67, alpha:1.0), for: UIControlState())
        btn.addTarget(self, action: #selector(nameInsert), for: .touchUpInside)
        return btn
    }()
    
    @objc func nameInsert(){
        print("이름 입력됨. \(nameTextField.text)")
        nameDelegate?.nameInsertBtn(name: nameTextField.text!)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameTextField)
        addSubview(nameButton)
        //ios 9 constraints
        //x,y,w,h
        nameTextField.leftAnchor.constraint(equalTo: self.leftAnchor,constant:40).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nameTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        nameButton.leftAnchor.constraint(equalTo: nameTextField.rightAnchor,constant:20).isActive = true
        nameButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        nameButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
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
        btn.setTitle("이메일로 시작할게요", for: UIControlState())
        btn.setTitleColor(.black, for: UIControlState())
        btn.backgroundColor = UIColor(red:0.98, green:0.89, blue:0.55, alpha:1.0)
        btn.addTarget(self, action: #selector(btnbtn), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()
    
    @objc func btnbtn(){
        print("이메일가입 클릭 됏음")
        delegate?.emailJoinBtn()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(btn)
        //ios 9 constraints
        //x,y,w,h
        btn.leftAnchor.constraint(equalTo: self.leftAnchor,constant:20).isActive = true
        btn.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20).isActive = true
        btn.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

class startCell: UICollectionViewCell {
    
    //기존 계정으로 로그인
    lazy var startButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("네, 좋아요!", for: UIControlState())
        
        
        btn.setTitleColor(.black, for: UIControlState())
        btn.backgroundColor = UIColor(red:0.98, green:0.89, blue:0.55, alpha:1.0)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(letsStart), for: .touchUpInside)
        return btn
    }()
    
    @objc func letsStart(){
        print("start")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(startButton)
        startButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        startButton.leftAnchor.constraint(equalTo: self.leftAnchor,constant:20).isActive = true
        startButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



