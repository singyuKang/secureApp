//
//  CheckBox.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/10/25.
//

import UIKit

final class CheckBox: UIView {
 
    private var isChecked = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.secondaryLabel.cgColor
//        layer.cornerRadius = frame.size.width / 2.0
        layer.cornerRadius = 10
        backgroundColor = .systemBackground
         
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        self.isChecked = !isChecked

        if self.isChecked {
            backgroundColor = .systemGreen
        }else{
            backgroundColor = .systemBackground
        }
   
    }
    
    func getIsChecked() -> Bool {
        return isChecked
    }
    

}
