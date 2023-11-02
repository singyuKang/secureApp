//
//  IndicatorView.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/10/30.
//

import UIKit

var alphaView: UIView? = UIView()
var backView: UIView? = UIView()
var imageView:UIImageView? = UIImageView()

class IndicatorView: UIViewController {
    func loading(params: [String:Any]) {
        if let flag = params["FLAG"] as? String {
            if flag == "ON" {
                showProgress()
            } else {
                hideProgress()
            }
        }
    }
}

extension UIViewController {
    
    func progressView() -> UIImage {
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "load", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(data: imageData! as NSData)
        
        return advTimeGif!
    }
    
    func showProgress() {
        let topView = UIApplication.topViewController()
        
        backView!.frame = self.view.frame
        backView!.backgroundColor = .clear
        
        alphaView!.frame = self.view.frame
        alphaView!.backgroundColor = .white
        alphaView!.alpha = 0.7
        
        imageView!.image = progressView()
        imageView!.frame.size = CGSize(width: 80, height: 80)
        imageView!.center = self.view.center
        imageView!.contentMode = .scaleAspectFit
        
        backView!.addSubview(alphaView!)
        backView!.addSubview(imageView!)
        topView?.view.addSubview(backView!)
        
    }
    
    func hideProgress(dismissHandler: (() -> Void)? = nil) {
        if let loadingView = backView {
            loadingView.removeFromSuperview()
        }
    }
}
