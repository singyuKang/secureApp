//
//  Log.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/10/11.
//

import Foundation

class Log {
    static func print(_ file: String = #file, _ function: String = #function, _ line: Int = #line, message: Any? = "") {
        var fileName = (file as NSString).lastPathComponent
        fileName = fileName.components(separatedBy: ".").first ?? ""
        
        var printLog = "\(fileName) - \(function) [\(line)]"
        if let msg = message {
            printLog += " : \(msg)"
        }
        
        NSLog("\(printLog)")
    }
}
