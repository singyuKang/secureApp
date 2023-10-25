//
//  UserInfo.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/10/13.
//

import Foundation
import RealmSwift

class UserInfo : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var uid : String = ""
    @objc dynamic var email : String = ""
    @objc dynamic var imageURL : String = ""
    
}
