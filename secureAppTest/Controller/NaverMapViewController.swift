//
//  NaverMapViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/11.
//

import UIKit
import NMapsMap
import CoreLocation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

//방을 판 사람 Controller
class NaverMapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    var naverMapView = NMFMapView()
    
    var lat : Double?
    var lon : Double?
    
    var uid : String?
    
    //timer
    var timer : Timer?
    
    var nmfMarkerList : [NMFMarker] = []
    
    let storage = Storage.storage()
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          self.uid = user.uid
//          let email = user.email
//          let photoURL = user.photoURL
//          var multiFactorString = "MultiFactor: "
//          for info in user.multiFactor.enrolledFactors {
//            multiFactorString += info.displayName ?? "[DispayName]"
//            multiFactorString += " "
//          }
          // ...
          
        }
        
        
        locationManager.delegate = self
        //permission request
        
        naverMapView = NMFMapView(frame: view.frame)
     
        
        // 앱을 사용할 때만 위치 정보를 허용할 경우 호출
        self.locationManager.requestWhenInUseAuthorization()
        // 위치 정보 제공의 정확도를 설정할 수 있다.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestLocation()

//        naverMapView.showLocationButton = true
        
    
        view.addSubview(naverMapView)
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        
    }
    
    
    @objc func getLocation() {
        let coor = locationManager.location?.coordinate
        lat = coor?.latitude
        lon = coor?.longitude
        print("lat::::::::::", lat )
        print("lon::::::::::", lon )
        updateMyLocation(lat ?? 0, lon ?? 0)
        
    }
    
    func updateMyLocation(_ lat : Double, _ lon : Double){
        
        // TODO ::::  방 처음 생성시 문서추가 해줘야됨 locationArray 필수 컬랙션 없을떄 addDocument 있을때는 getDocument
        if let uid = uid {
            
            let test = db.collection("location").document(uid)
            test.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let dataDescription = document.data() {
                        print("dataDescription::::::", dataDescription)
                        if let locationArray = dataDescription["locationArray"] as? [Dictionary<String, Any>] {
                            //locationArray 존재 TODO 기존배열 정렬후
                            var newlocationArray = locationArray
                            newlocationArray.append(["date" : Date().timeIntervalSince1970, "lat" : lat, "lon" : lon])
                            test.updateData(["locationArray" : newlocationArray])
                            
                            // List 이전꺼 지우고 새로운거 그림
                            for nmfMarker in self.nmfMarkerList {
                                nmfMarker.mapView = nil
                            }
                            self.nmfMarkerList = []
                            
                            self.drawMarker(lat , lon)
                        }else{
                            //TODO : locationArray 미존재 에러처리
                            
                        }
                        
                    }
        
                } else {
                    print("Document does not exist")
                    self.db.collection("location").document(uid).setData(["locationArray" : []])
                    
//                    self.db.collection("location").addDocument(data: ["date" : Date().timeIntervalSince1970 , "lat" : lat, "lon" : lon, "locationArray" : []]){ [weak self] (error) in
//                                if let e = error {
//                                    print("There was an issue saving data to firestore error :::::: \(e)")
//                                }else{
//                                    print("Success Save Data")
//                                    self?.drawMarker(lat ?? 0, lon ?? 0)
//                                }
//                            }
                }
            }
        }else{
            //TODO UID 미존재 처리
        }

        
//        test.updateData(setLocationArray)
        
    }
    
    func drawMarker(_ lat : Double, _ lon : Double){
        
        storage.reference(forURL: "gs://app-e78d7.appspot.com/password").downloadURL { (url, error) in
            if let error = error {
                print("downloadImage error::::", error)
            }else{

                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    guard let imageData = data else { return }
                    let marker = NMFMarker()
                    self.nmfMarkerList.append(marker)
                    
                    if let nmfImage = UIImage(data: imageData)?.resize(targetSize: CGSize(width: 75, height: 75))?.withRoundedCorners(radius: 30){
                        
                        marker.iconImage = NMFOverlayImage(image: nmfImage )
                        marker.position = NMGLatLng(lat: lat, lng: lon)
                        
                        //TODO : 유저정보 업데이트
                        marker.captionText = "강신규"
                        
                        DispatchQueue.main.async {
                            // code
                            marker.mapView = self.naverMapView
                            
                            print("lat::::::::::", lat )
                            print("lon::::::::::", lon )
                            
                            let defaultCameraPosition = NMFCameraPosition(NMGLatLng(lat: lat, lng: lon), zoom: 15, tilt: 0, heading: 0)
                            self.naverMapView.moveCamera(NMFCameraUpdate(position: defaultCameraPosition))
                    
                        }
       
                    }else{
                        print("image 존재하지않음")
                    }
 
                }.resume()
            }
        }
        

        
        
    }
 
}

//MARK - CLLocationManagerDelegate

extension NaverMapViewController : CLLocationManagerDelegate {
    func getLocationUsagePermission() {
          //location4
          self.locationManager.requestWhenInUseAuthorization()
          
      }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          //location5
          switch status {
          case .authorizedAlways, .authorizedWhenInUse:
              print("GPS 권한 설정됨")
              // 위치 정보를 지속적으로 받고 싶은 경우 이벤트를 시작
              self.locationManager.startUpdatingLocation() // 중요!
          case .restricted, .notDetermined:
              print("GPS 권한 설정되지 않음")
              getLocationUsagePermission()
          case .denied:
              print("GPS 권한 요청 거부됨")
              getLocationUsagePermission()
          default:
              print("GPS: Default")
          }
      }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

//        print("locations::::::::",locations.last)
//
//        if let location = locations.last {
////            locationManager.stopUpdatingLocation()
//
//            let marker = NMFMarker()
//            nmfMarkerList.append(marker)
//
//            print("nmfMarkerList::::",nmfMarkerList)
//
//
//            let lat = location.coordinate.latitude
//            let lon = location.coordinate.longitude
//            marker.position = NMGLatLng(lat: lat, lng: lon)
//            marker.mapView = self.naverMapView
//
//            print("lat::::::::::", lat )
//            print("lon::::::::::", lon )
//
//            let defaultCameraPosition = NMFCameraPosition(NMGLatLng(lat: lat, lng: lon), zoom: 15, tilt: 0, heading: 0)
//            self.naverMapView.moveCamera(NMFCameraUpdate(position: defaultCameraPosition))
//
//
//
//        }



      }
    
    
}

