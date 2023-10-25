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

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            LoadingIndicator.showLoading()
//            [weak self] guard let strongSelf = self else { return } 는 왜 쓰는지
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    LoadingIndicator.hideLoading()
                }else{
                    print("Login Success")
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                    LoadingIndicator.hideLoading()
                    
                }
              // ...
            }
        }else{
            print("fill the blank")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    

}
