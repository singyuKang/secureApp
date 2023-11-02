//
//  LoginViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/20.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let realm = try! Realm()
    var userInfo : Results<UserInfo>?
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            DispatchQueue.main.async {
                IndicatorView().showProgress()
            }
//            [weak self] guard let strongSelf = self else { return } 는 왜 쓰는지
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    DispatchQueue.main.async {
                        IndicatorView().hideProgress()
                    }
                }else{
                    print("Login Success")
                    self.loadUserInfo()
                    
                    if let userinfo = self.userInfo {
                        if userinfo.count > 0 {
                            // 기존 유저 정보 존재 uid 없데이트
                            let user = Auth.auth().currentUser
                            if let user = user {
                                
                                //TODO uid update`
                                print("userinfo first :::: ",userinfo.first)
                                
                            }
                            
                        }else{
                            // 새로운 유저 정보 추가
                            let user = Auth.auth().currentUser
                            if let user = user {
                                
                                let newUserInfo = UserInfo()
                                newUserInfo.uid = user.uid
                                newUserInfo.email = user.email ?? ""
                                //TODO name , imageURL Add
                                self.saveUserInfo(userInfo: newUserInfo)
                            }
                            
                        }
                    }
                    
                    
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                    
                    
                    DispatchQueue.main.async {
                        IndicatorView().hideProgress()
                    }
                    
                    
                }
              // ...
            }
        }else{
            print("fill the blank")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        
    }
    
    
    //MARK - Save Data Load Data
    func saveUserInfo(userInfo : UserInfo) {
        do {
            try realm.write{
                realm.add(userInfo)
            }
        }catch{
            print("Error Save userInfo")
        }
    }
    
    func loadUserInfo() {
        userInfo = realm.objects(UserInfo.self)
        print("userInfo::::::::::::\(userInfo)")
    }
    
    
    
    
    
    
    

}
