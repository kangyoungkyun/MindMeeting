//
//  QuestionListTVC.swift
//  MindMeeting
//
//  Created by MacBookPro on 2018. 5. 2..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import Firebase
class QuestionListTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target:self , action: #selector(handleLogout))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.backgroundColor = .lightGray
        checkIfUserIsLoggedIn()
    }

    //로그인or로그아웃 체크 함수
    func checkIfUserIsLoggedIn(){
        //로그아웃 되었을 때 실행
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            
            //로그인 되었으면 네비게이션 타이틀의 제목을 유저 이름으로 지정해준다.
            //fetchUserAndSetupNavBarTitle()
        }
    }
    //로그아웃 액션
    @objc func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        } catch let logError{
            print(logError)
        }
        //messagesController?.fetchUserAndSetupNavBarTitle()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let loginCVC = MainPageCVC(collectionViewLayout: layout)
        
        //loginController.messagesController = self
        present(loginCVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.backgroundColor = .green
        cell.textLabel?.text = "aaa"
       
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    


}
