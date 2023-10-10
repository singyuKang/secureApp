//
//  UIImage.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/10/10.
//

import Foundation
import UIKit

extension UIImage {
    func resize(targetSize: CGSize, opaque: Bool = false) -> UIImage? {
        // 1. context를 획득 (사이즈, 투명도, scale 입력)
        // scale의 값이 0이면 현재 화면 기준으로 scale을 잡고, sclae의 값이 1이면 self(이미지) 크기 기준으로 설정
        UIGraphicsBeginImageContextWithOptions(targetSize, opaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        
        // 2. 그리기
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        draw(in: newRect)
        
        // 3. 그려진 이미지 가져오기
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4. context 종료
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // image with rounded corners
      public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
          let maxRadius = min(size.width, size.height) / 2
          let cornerRadius: CGFloat
          if let radius = radius, radius > 0 && radius <= maxRadius {
              cornerRadius = radius
          } else {
              cornerRadius = maxRadius
          }
          UIGraphicsBeginImageContextWithOptions(size, false, scale)
          let rect = CGRect(origin: .zero, size: size)
          UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
          draw(in: rect)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return image
      }
    
    
    
    
    
    
    
    
    
    
    
}



