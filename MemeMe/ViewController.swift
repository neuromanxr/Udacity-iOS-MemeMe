//
//  ViewController.swift
//  MemeMe
//
//  Created by Kelvin Lee on 5/1/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var defaultTextField: UITextField!
    
    @IBOutlet weak var textField: UITextField!
    
    // saved meme
    var memedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupTextAttributes()
        
        self.defaultTextField.delegate = self
        self.textField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        if self.imagePickerView.image == nil {
            NSLog("image picker image is nil")
            self.shareButton.enabled = false
        } else {
            NSLog("image picker image")
            self.shareButton.enabled = true
        }
        
        self.tabBarController?.tabBar.hidden = true
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        
        self.unsubscribeFromKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveMeme() {
        
        // create the meme
        var meme = MemeObject(topText: self.defaultTextField.text, bottomText: self.textField.text, image: self.imagePickerView.image!, memedImage: self.memedImage!)
        
        // add to memes array in app delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        NSLog("Saved meme %@", meme.memedImage!)
    }
    
    func generateMemedImage() -> UIImage {
        
        // hide toolbar and navbar
        self.navigationController?.navigationBar.hidden = true
        self.toolbar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        self.navigationController?.navigationBar.hidden = false
        self.toolbar.hidden = false
        
        NSLog("Meme generated")
        
        return memedImage
    }
    
    func setupTextAttributes() {
        let memeTextAttributes = [NSStrokeColorAttributeName:UIColor.blackColor(), NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName:-3.0]
        
        self.defaultTextField.defaultTextAttributes = memeTextAttributes
        self.defaultTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.defaultTextField.textAlignment = NSTextAlignment.Center
        
        self.textField.defaultTextAttributes = memeTextAttributes
        self.textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.textField.textAlignment = NSTextAlignment.Center
    }

    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if self.cameraButton.enabled {
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }

        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func activityCompletionWithItemsHandler(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        if completed {
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        if self.textField.text.isEmpty || self.defaultTextField.text.isEmpty {
            self.showMemeIsEmptyAlert()
        } else {
            // generate the meme image
            self.memedImage = self.generateMemedImage()
            
            let activityController = UIActivityViewController(activityItems: [self.imagePickerView.image!], applicationActivities: nil)
            activityController.completionWithItemsHandler = activityCompletionWithItemsHandler
            
            self.presentViewController(activityController, animated: true, completion: nil)
        }
    }
    
    func showMemeIsEmptyAlert() {
        let alertController = UIAlertController(title: "Warning", message: "You didn't enter a meme!", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert) -> Void in
            NSLog("There's no meme")
        }
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        NSLog("Image Picked %@", image)
        
        self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imagePickerView.image = image;
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        NSLog("Show keyboard height %f", getKeyboardHeight(notification))
        if self.textField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            self.toolbar.hidden = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        NSLog("Hide keyboard height %f", getKeyboardHeight(notification))
        if self.textField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
            self.toolbar.hidden = false
        }
    }
    
    func getKeyboardHeight(notifcation: NSNotification) -> CGFloat {
        let userInfo = notifcation.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}

