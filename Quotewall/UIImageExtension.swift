//
//  UIImageExtension.swift
//  Quotewall
//
//  Created by Collin Cannavo on 8/17/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    public func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {return self }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
}
