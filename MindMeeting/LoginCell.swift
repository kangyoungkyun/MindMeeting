//
//  LoginCell.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 4. 23..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    
    let noBtn: UIButton = {
      let btn = UIButton()
        btn.titleLabel?.text = "아니요"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let yesBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.text = "네"
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = ""
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        addSubview(yesBtn)
        addSubview(noBtn)
        
        //ios 9 constraints
        //x,y,w,h
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
