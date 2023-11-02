//
//  ImageViewController.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/11/01.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
//    let contentView : UIView! = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    func setupView(){

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(scrollView)

        imageView.image = UIImage(named: "mobile_inspection")
        imageView.contentMode = .scaleAspectFill

        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollView.isScrollEnabled = true
        
        
    }
    


}
