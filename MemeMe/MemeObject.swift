//
//  MemeObject.swift
//  MemeMe
//
//  Created by Kelvin Lee on 5/4/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import Foundation
import UIKit

class MemeObject: NSObject {
    
    var topText: String?
    var bottomText: String?
    
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    init(topText: String!, bottomText: String!, image: UIImage, memedImage: UIImage) {
        
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = image
        self.memedImage = memedImage
    }
    
    class func sharedMemes() -> [MemeObject] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes
    }
}
