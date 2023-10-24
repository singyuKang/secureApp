//
//  RxTestViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/08/25.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire



class RxTestViewController: UIViewController, UITableViewDataSource {

    

    let allCities = ["NewYork", "London", "Paris", "Osaka", "Osagu", "Seoul"]
    var shownCities = [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let disposeBag = DisposeBag()
    
    //notification Center 알림
    let center = UNUserNotificationCenter.current()
    
    
//    let observable = Observable.of(1,2,3)
//    let observable: Observable<Int> = Observable<Int>.just(1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        tableView.dataSource = self

        searchBar
          .rx.text // RxCocoa의 Observable 속성(ControlProperty<String?>). 검색 바의 텍스트가 변경될 때 신호 발생
          .orEmpty // 옵셔널이 아니게 만듦 (Transforms control property of type String? into control property of type String.)
          .distinctUntilChanged()
          .subscribe(onNext: { [unowned self] query in // subscribe
            print("query: \(query)")
            self.shownCities = self.allCities.filter({ $0.hasPrefix(query) })
            print(self.allCities.filter({$0.hasPrefix(query)}))
            self.tableView.reloadData()
          })
          .disposed(by: disposeBag)
        
        
//        requestAuthNotification()
//        requestSendNotification(seconds: 3)
//        observable.subscribe(onNext: { [unowned self]  num in
//                print(num)
//            }, onCompleted: {
//                print("completed")
//            }).disposed(by: disposeBag)
        
        
        //Alamofire Test
        getTest()
        
        
    }
    
    func getTest() {
        let url = "https://jsonplaceholder.typicode.com/todos/1" //주소입력
        AF.request(url,
                  method: .get,
                  parameters: nil,
                  encoding: URLEncoding.default,
                  headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate()
        .responseDecodable(of: TestModel.self){ (response) in
           print(response)
       }
        
        //method : 통신방식
        //parametrs : 보낼 데이터 값
        //encoding : URLEncoding
        //headers : 어떤형식으로 받을지
        //validate : 확인코드
        //responseJSON : 데이터 받는 부분
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func requestAuthNotification() {
        let notificationAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        center.requestAuthorization(options: notificationAuthOptions) { success, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func requestSendNotification(seconds: Double) {
        let content = UNMutableNotificationContent()
        content.title = "알림 제목"
        content.body = "알림 내용"
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
            
        center.add(request) { error in
            if let error = error {
            print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
         cell.textLabel?.text = shownCities[indexPath.row]
         return cell
    }
    
    
    

}
