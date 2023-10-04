//
//  ViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/08/24.
//

import UIKit
import WebKit
import CoreLocation
import Foundation


class ViewController: UIViewController, WKUIDelegate {
        
    @IBOutlet weak var webView: WKWebView!
    var locationManager: CLLocationManager!
    
    @IBAction func pressedButton(_ sender: Any) {
        webView.evaluateJavaScript("addWmsLayer();") { (result, error) in
            print("result:::::::::",result)
            print("error::::::::::",error)
        }
//
        
    }
    override func loadView() {
             super.loadView()
//             webView = WKWebView(frame: self.view.bounds)
             webView.uiDelegate = self
//             self.view = self.webView
            
         }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() } //모달창 닫힐때 앱 종료현상 방
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadView()

        self.webView?.allowsBackForwardNavigationGestures = true  //뒤로가기 제스쳐 허용
        webView.configuration.preferences.javaScriptEnabled = true  //자바스크립트 활성화
        
        
        
        //위치 권한
        locationManager = CLLocationManager()
        locationManager.delegate = self
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
      
        self.webView.load(request) // [웹뷰 로드 수행 실시]
  
 
       
        
//        self.webView?.evaluateJavaScript("init(\(lonValue),\(latValue));", completionHandler: { result, error in
//
//            if let anError = error {
//                print("evaluateJavascript Error \(anError.localizedDescription)")
//            }
//
//            print("evaulte info update \(String(describing: result))")
//
//        })
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let lonValue = 37.439635
        let latValue = 127.173258
//        init('\(lonValue)','\(latValue)');
//        print(self.webView)
        
//        self.webView.evaluateJavaScript("what()") { result, error in
//            if let error = error {
//                print("evaluateJavaScript:::::::",error.localizedDescription)
//            }else if let result = result {
//                print(result)
//            }
//        }
        
//        self.webView.evaluateJavaScript("init(\(lonValue),\(latValue))"){ result, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }else if let result = result {
//                print(result)
//            }
//        }
        
        
    }
    
    
    func reloadData() {
        //
    }
    

    //alert 처리
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler() }))
        self.present(alertController, animated: true, completion: nil) }
    
    //confirm 처리
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(false) }))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler(true) }))
        self.present(alertController, animated: true, completion: nil) }
    
    // href="_blank" 처리
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil }

}

extension ViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 한다.
        if let coordinate = locations.last?.coordinate {
            // ⭐️ 사용자 위치 정보 사용
            print("coordinate::::::::",coordinate)
            
        }
        
        // startUpdatingLocation()을 사용하여 사용자 위치를 가져왔다면
        // 불필요한 업데이트를 방지하기 위해 stopUpdatingLocation을 호출
        locationManager.stopUpdatingLocation()
    }

    // 사용자가 GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했을 때 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }

    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
    
    
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            locationManager.requestWhenInUseAuthorization()
                
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
            
        // 3.1
        guard CLLocationManager.locationServicesEnabled() else {
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            return
        }
            
            
        // 3.2
        let authorizationStatus: CLAuthorizationStatus
            
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
            
        // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
//            async { await self?.reloadData() }
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
}

