//
//  KakaoViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/19.
//

import UIKit
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon
import FirebaseAuth


class KakaoViewController: UIViewController {

    var uid : String?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        print(user?.uid)
        
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          self.uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
          // ...
          
        }
    
        kakao()
    
    }
    

    func kakao() {
        if ShareApi.isKakaoTalkSharingAvailable(){
            
            // Web Link로 전송이 된다. 하지만 우리는 앱 링크를 받을거기 때문에 딱히 필요가 없으.
            // 아래 줄을 주석해도 상관없다.
            let  link = Link(webUrl: URL(string:"https://www.naver.com/"),
            mobileWebUrl: URL(string:"https://www.naver.com/"))
            
            // 우리가 원하는 앱으로 보내주는 링크이다.
            // second, vvv는 url 링크 마지막에 딸려서 오기 때문에, 이 파라미터를 바탕으로 파싱해서
            // 앱단에서 원하는 기능을 만들어서 실행할 수 있다 예를 들면 다른 뷰 페이지로 이동 등등~
            
            if let myUID = uid {
                let appLink = Link(iosExecutionParams: ["uid":myUID])
                
                // 해당 appLink를 들고 있을 버튼을 만들어준다.
                let button = Button(title: "앱에서 보기", link: appLink)
                
                // Content는 이제 사진과 함께 글들이 적혀있다.
                let content = Content(title: "타이틀 문구",
                                      imageUrl: URL(string:"http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png")!,
                                      description: "#SecureAppTest",
                                      link: appLink)
                // 템플릿에 버튼을 추가할때 아래 buttons에 배열의 형태로 넣어준다.
                // 만약 버튼을 하나 더 추가하려면 버튼 변수를 만들고 [button, button2] 이런 식으로 진행하면 된다 .
                let template = FeedTemplate(content: content, buttons: [button])
                
                //메시지 템플릿 encode
                if let templateJsonData = (try? SdkJSONEncoder.custom.encode(template)) {
                    
                    //생성한 메시지 템플릿 객체를 jsonObject로 변환
                    if let templateJsonObject = SdkUtils.toJsonObject(templateJsonData) {
                        ShareApi.shared.shareDefault(templateObject:templateJsonObject) {(linkResult, error) in
                            if let error = error {
                                print("error : \(error)")
                            }
                            else {
                                print("defaultLink(templateObject:templateJsonObject) success.")
                                guard let linkResult = linkResult else { return }
                                
//                                let url = URL(string: "itms-apps://itunes.apple.com/app/[@id]"),
//                                                    UIApplication.shared.canOpenURL(url)
                                
                                print("linkResult::::::::;", linkResult)
                                
                                //TODO : App Store로 보내기
                                UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
     
            }else{
                //TODO : uid 없을때 오류처리
                
            }
  
        }
        else {
            print("카카오톡 미설치")
            // 카카오톡 미설치: 웹 공유 사용 권장
            // 아래 함수는 따로 구현해야함.
//            showAlert(msg: "카카오톡 미설치 디바이스")
            
        }
       
    }
    
    
    
}
