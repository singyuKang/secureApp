//
//  WebViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/07.
//

import UIKit
import WebKit
import Foundation



class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webView : WKWebView?
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        
        let webConfiguration = WKWebViewConfiguration()
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            webView?.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            // Fallback on earlier versions
            webView?.configuration.preferences.javaScriptEnabled = true
        }
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webConfiguration.userContentController.add(self, name: "test")
        
//
//        if let path = Bundle.main.url(forResource: "test2", withExtension: "html"){
//            let myURLRequest:URLRequest = URLRequest(url: path)
//            webView?.load(myURLRequest)
//        }else {
//            print("nonon")
//        }
//
//        self.webView?.navigationDelegate = self
//        webView?.uiDelegate = self
        
        guard let localFilePath = Bundle.main.path(forResource: "map", ofType: "html")
                else {
                    print("")
                    print("====================================")
                    print("-------------------------------")
                    print("error :: file path is nil")
                    print("====================================")
                    print("")
                    return
                }
        let urlFile = URL(fileURLWithPath: localFilePath) // [url 형식 변환]
        let request = URLRequest(url: urlFile) // [url request 지정]

        self.webView?.load(request) // [웹뷰 로드 수행 실시]

    
        let lat = 123.12238
        let long = 145.12231
        
        
        self.webView?.evaluateJavaScript("javascript:what", completionHandler: { (result, error) in
            if let error = error {
                print("JavaScript 오류: \(error)")
                // 오류 처리 로직 추가
            } else {
                print("Success")
                print(result)
                // 성공적으로 실행된 경우의 로직 추가
            }
        })
    
        
    }


}

extension WebViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//    guard
//        let name = message.name,
//      let body = message.body as? [String: Any],
//      let command = body["command"] as? String
//    else { return }
    
//    if name == "여기에 처리할 메시지 입력" {
//      if command == "popOpened" {
//        print("call back")
//      }
//    }
  }
}



