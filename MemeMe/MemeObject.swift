//
//  MemeObject.swift
//  MemeMe
//
//  Created by Kelvin Lee on 5/4/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import Foundation
import UIKit

struct MemeObject {
    
    var topText: String?
    var bottomText: String?
    
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    // convenience method that returns the array in appDelegate
    static func sharedMemes() -> [MemeObject] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes
    }
}
