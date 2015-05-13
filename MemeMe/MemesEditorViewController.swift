//
//  ViewController.swift
//  MemeMe
//
//  Created by Kelvin Lee on 5/1/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class MemesEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
        
        // if the camera is available, enable the camera button
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // enable share button only when image is present
        if self.imagePickerView.image == nil {
            NSLog("image picker image is nil")
            self.shareButton.enabled = false
        } else {
            NSLog("image picker image")
            self.shareButton.enabled = true
        }
        
        // hide tabbar when editor is presented
        self.tabBarController?.tabBar.hidden = true
        
        // for moving the keyboard
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // show tabbar when editor dismissed
        self.tabBarController?.tabBar.hidden = false
        
        self.unsubscribeFromKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveMeme() {
        
        // create the meme
        var meme = MemeObject()
        meme.topText = self.defaultTextField.text
        meme.bottomText = self.textField.text
        meme.originalImage = self.imagePickerView.image!
        meme.memedImage = self.memedImage!
        
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
        // text attributes for meme text
        let memeTextAttributes = [NSStrokeColorAttributeName:UIColor.blackColor(), NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName:-3.0]
        
        // center and always capitalize
        self.defaultTextField.defaultTextAttributes = memeTextAttributes
        self.defaultTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.defaultTextField.textAlignment = NSTextAlignment.Center
        
        self.textField.defaultTextAttributes = memeTextAttributes
        self.textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        self.textField.textAlignment = NSTextAlignment.Center
    }

    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        
        // show image picker library
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        
        // show camera photos if available
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if self.cameraButton.enabled {
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }

        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func activityCompletionWithItemsHandler(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        // save meme and dismiss the activity view
        if completed {
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // show alert if meme text fields empty
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
        // alert for empty meme text
        let alertController = UIAlertController(title: "Warning", message: "You didn't enter a meme!", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert) -> Void in
            NSLog("There's no meme")
        }
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        NSLog("Image Picked %@", image)
        
        // scale image to fill screen
        self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imagePickerView.image = image;
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        // move view up when keyboard is present and hide the toolbar
        NSLog("Show keyboard height %f", getKeyboardHeight(notification))
        if self.textField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            self.toolbar.hidden = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // return view to original position
        NSLog("Hide keyboard height %f", getKeyboardHeight(notification))
        if self.textField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
            self.toolbar.hidden = false
        }
    }
    
    func getKeyboardHeight(notifcation: NSNotification) -> CGFloat {
        
        // get the keyboard height
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

