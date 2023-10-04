//
//  UserInfoViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/09/26.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class UserInfoViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    let storage = Storage.storage()
    
    
     
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePickerController.delegate = self
        // 7. pickerController 의 타입 지정

        
    }
    
    
    @IBAction func albumPressed(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func takePicturePressed(_ sender: UIButton) {
        // 카메라로 찍은 사진을 소스로 합니다.
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func savePicturePressed(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func firebaseButtonPressed(_ sender: UIButton) {
//        guard let urlString = UserDefaults.standard.string(forKey: "gs://app-e78d7.appspot.com") else { return }
        
//        FirebaseStorageManager.downloadImage(urlString: urlString) { [weak self] image in
//            self?.imageView.image = image
//        }
        downloadimage(imgview: self.imageView)
        
        
    }
    
    
    func upLoadImage(img: UIImage){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)! //지정한 이미지를 포함하는 데이터 개체를 JPEG 형식으로 반환, 0.8은 데이터의 품질을 나타낸것 1에 가까울수록 품질이 높은 것
        let filePath = "password"
        let metaData = StorageMetadata() //Firebase 저장소에 있는 개체의 메타데이터를 나타내는 클래스, URL, 콘텐츠 유형 및 문제의 개체에 대한 FIRStorage 참조를 검색하는 데 사용
        metaData.contentType = "image/png" //데이터 타입을 image or png 팡이
        storage.reference().child(filePath).putData(data, metadata: metaData){
            (metaData,error) in if let error = error { //실패
                print(error)
                return
            }else{ //성공
                print("성공")
            }
        }
    }
    
    func downloadimage(imgview : UIImageView){
        storage.reference(forURL: "gs://app-e78d7.appspot.com/password").downloadURL { (url, error) in
            
            if let error = error {
                print("downloadImage error::::", error)
            }else{

                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    guard let imageData = data else { return }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: imageData)
                    }
                }.resume()
            }
        }
    
    }

}

extension UserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // delegate Method 들어가는부분
    
    // 8. 이미지가 지정되었을 때 호출되는 델리게이트 메소드를 만들어줍니다.
    // picker : 우리가 실행한 UIImagePickerController입니다.
    // info : 카메라로 찍은 소스 이미지입니다. 타입은 Any입니다.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,let user = Auth.auth().currentUser else { return }

        upLoadImage(img: selectedImage)
     
//        FirebaseStorageManager.uploadImage(image: selectedImage, pathRoot: user.uid) { url in
//            print("url::::::::::", url)
//                 if let url = url {
//                     UserDefaults.standard.set(url.absoluteString, forKey: "gs://app-e78d7.appspot.com")
//                     self.title = "이미지 업로드 완료"
//                 }
//             }
        
        // 9. 실행한 카메라를 닫습니다.
        self.imagePickerController.dismiss(animated: true)

        // 10. 선택된 이미지(소스)가 없을수도 있으니 옵셔널 바인딩해주고, 이미지가 선택된게 없다면 오류를 발생시킵니다.
        guard let userPickedImage = info[.originalImage] as? UIImage else {
        fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
    }
        
        // 11. 이미지뷰에 소스 이미지를 업데이트합니다.
        imageView.image = userPickedImage
    
        
    }
    
    
    
}



