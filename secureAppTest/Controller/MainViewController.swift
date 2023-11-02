//
//  MainViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/12.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.isNavigationBarHidden = true
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    

}
