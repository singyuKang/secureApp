//
//  RegisterViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/20.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

// 이메일 자동저장 , 딥링크 값 저장 로그인 검사 있으면 그 화면이동 ,
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if let e = error {
                    //TODO : Show Alert error description
                    print("error description ::::::::::::::",e.localizedDescription)
                }else{
                    //no error -> Navigate to the ChatViewController
                    self.performSegue(withIdentifier: "registerToMain", sender: self)
                }
            }
            
        }else{
            print("fill the blank")
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
