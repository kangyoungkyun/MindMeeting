//
//  SignInVC.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 4. 28..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//



import UIKit

protocol signButtonClickedDelegate: class{
    func signBtnClick(email:String,password:String)
    func loginBtnClick(email:String,password:String)
}

class SignInVC: UIViewController {
    
    var signBtnDelegate : signButtonClickedDelegate?
    
    //바탕화면 view
    let uiview : UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .white
        uiview.layer.masksToBounds = true
        uiview.layer.cornerRadius = 16
        return uiview
    }()
    //타이틀 라벨
    let titleLable : UILabel = {
        let uilabel = UILabel()
        uilabel.translatesAutoresizingMaskIntoConstraints = false
        uilabel.text = "가입하기"
        
        return uilabel
    }()
    
    
    //x 버튼
    let xButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("x", for: UIControlState())
        btn.setTitleColor(UIColor.darkGray, for: UIControlState())
        btn.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    @objc func dismissButtonClicked(){
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    //이메일 텍스트 필드
    let emailTextField : UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.masksToBounds = true
        txtField.layer.cornerRadius = 10
        txtField.layer.backgroundColor = UIColor.lightGray.cgColor
        txtField.placeholder = "  이메일"
        
        return txtField
    }()
    
    //패스워드 텍스트 필드
    let passwordTextField : UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.masksToBounds = true
        txtField.layer.cornerRadius = 10
        txtField.layer.backgroundColor = UIColor.lightGray.cgColor
        txtField.placeholder = "  패스워드"
        return txtField
    }()
    
    //기존 계정으로 로그인
    lazy var loginButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("로그인하러가기", for: UIControlState())
        btn.setTitleColor(UIColor.darkGray, for: UIControlState())
        btn.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        return btn
    }()
    //기존 계정으로 로그인 버튼 눌렸을 때
    @objc func loginButtonClicked(){
        
        print("로그인하기 버튼 클릭")
        if(loginButton.titleLabel?.text == "로그인하러가기"){
            loginButton.setTitle("가입하러가기", for: UIControlState())
            titleLable.text = "로그인"
            signButton.setTitle("로그인하기", for: UIControlState())
        }else{
            loginButton.setTitle("로그인하러가기", for: UIControlState())
            titleLable.text = "가입하기"
            signButton.setTitle("가입하기", for: UIControlState())
        }
        
    }
    
    
    
    // 가입하기 버튼
    lazy var signButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("가입하기", for: UIControlState())
        btn.setTitleColor(UIColor.blue, for: UIControlState())
        btn.addTarget(self, action: #selector(signButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    
    @objc func signButtonClicked(){
        //가입 로그인 분기
        if(signButton.titleLabel?.text == "가입하기"){
            print(" 가입하기 클릭됨~! \(emailTextField.text)   - \(passwordTextField.text)")
            signBtnDelegate?.signBtnClick(email: emailTextField.text!, password: passwordTextField.text!)
            emailTextField.text = ""
            passwordTextField.text = ""
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }else{
            print(" 로그인 하기 클릭됨~! \(emailTextField.text)   - \(passwordTextField.text)")
            signBtnDelegate?.loginBtnClick(email: emailTextField.text!, password: passwordTextField.text!)
            emailTextField.text = ""
            passwordTextField.text = ""
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(uiview)
        
        setupView()
    }
    
    
    func setupView(){
        
        uiview.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        uiview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        uiview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        
 //       uiview.widthAnchor.constraint(equalToConstant: 400).isActive = true
//        uiview.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        uiview.addSubview(titleLable)
        uiview.addSubview(xButton)
        uiview.addSubview(emailTextField)
        uiview.addSubview(passwordTextField)
        uiview.addSubview(loginButton)
        uiview.addSubview(signButton)
        
        xButton.topAnchor.constraint(equalTo: uiview.topAnchor,constant:15).isActive = true
        xButton.trailingAnchor.constraint(equalTo: uiview.trailingAnchor,constant:-15).isActive = true
        xButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
        titleLable.leftAnchor.constraint(equalTo: uiview.leftAnchor,constant:20).isActive = true
        titleLable.topAnchor.constraint(equalTo: xButton.topAnchor,constant:20).isActive = true
        titleLable.widthAnchor.constraint(equalToConstant: 60).isActive = true
        titleLable.heightAnchor.constraint(equalToConstant: 20).isActive = true
        

        emailTextField.topAnchor.constraint(equalTo: titleLable.bottomAnchor,constant:20).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: uiview.leftAnchor,constant:20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: uiview.trailingAnchor,constant:-20).isActive = true
        //emailTextField.widthAnchor.constraint(equalToConstant: 180).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant:20).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: uiview.leftAnchor,constant:20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: uiview.trailingAnchor,constant:-20).isActive = true
        //passwordTextField.widthAnchor.constraint(equalToConstant: 180).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //passwordTextField.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant:20).isActive = true
        loginButton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        //loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        
        
        signButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant:20).isActive = true
        signButton.rightAnchor.constraint(equalTo: uiview.rightAnchor,constant:-20).isActive = true
        signButton.bottomAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        signButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        //signButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        signButton.bottomAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        
        
    }
    
    
    
}
