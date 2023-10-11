//
//  NaverMapWatchViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/12.
//

import UIKit
import NMapsMap
import CoreLocation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


//방을 들어간사람 Controller
class NaverMapWatchViewController: UIViewController {

    let db = Firestore.firestore()
    var lat : Double?
    var lon : Double?
    var naverMapView = NMFMapView()
    var nmfMarkerList : [NMFMarker] = []
    var pathArray : [NMGLatLng] = []
    var uid : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naverMapView = NMFMapView(frame: view.frame)
        view.addSubview(naverMapView)
        // Do any additional setup after loading the view.
        loadLocation()
        
        //TODO : Location 경로표시
        let pathOverlay = NMFPath()
    
//                        pathOverlay.path = NMGLineString(points: [
//                            NMGLatLng(lat: 37.57152, lng: 126.97714),
//                            NMGLatLng(lat: 37.56607, lng: 126.98268),
//                            NMGLatLng(lat: 37.56445, lng: 126.97707),
//                            NMGLatLng(lat: 37.55855, lng: 126.97822)
//                        ])
        pathOverlay.path = NMGLineString(points: pathArray)
        pathOverlay.mapView = naverMapView
        
  
    }
    
    func pathHistoryUpdate(){
        
    }

    func loadLocation(){
        //TODO : 방 ID로 document 변경
        db.collection(Constants.Firebase.COLLECTION_KEY).document(Constants.Firebase.DOCUMENT_KEY).addSnapshotListener{ [self](querySnapshot , error) in
            if let e = error {
                print("There was in issue retrieving data from Firestore. \(e)")
            }else{
//                print("querySnapshot:::::::", querySnapshot?.data())
                if let dataDescription = querySnapshot?.data() {
                    if let locationArray = dataDescription[Constants.Firebase.LOCATION_ARRAY] as? [Dictionary<String, Any>] {
//                        print("locationArray::::::;", locationArray.last)
                        for i in locationArray {
                            let NMGLatLngObject = NMGLatLng(lat: i["lat"] as! Double, lng: i["lon"] as! Double)
                            pathArray.append(NMGLatLngObject)
                        }
                        
                        if let myLocation = locationArray.last {
                            // List 이전꺼 지우고 새로운거 그림
                            for nmfMarker in self.nmfMarkerList {
                                nmfMarker.mapView = nil
                            }
                            self.nmfMarkerList = []
                            
                            //TODO : 위치 좌표 오류시 처리
                            self.drawMarker(myLocation["lat"] as? Double ?? 0, myLocation["lon"] as? Double ?? 0)
                        }
                        
                    }
                
                }

            }
        }
        
    }
    
    
    func drawMarker(_ lat : Double, _ lon : Double){
        let marker = NMFMarker()
        nmfMarkerList.append(marker)
        marker.position = NMGLatLng(lat: lat, lng: lon)
        marker.mapView = self.naverMapView
        
        print("lat::::::::::", lat )
        print("lon::::::::::", lon )

        let defaultCameraPosition = NMFCameraPosition(NMGLatLng(lat: lat, lng: lon), zoom: 15, tilt: 0, heading: 0)
        self.naverMapView.moveCamera(NMFCameraUpdate(position: defaultCameraPosition))
    }
    
}
