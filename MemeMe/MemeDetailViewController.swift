//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kelvin Lee on 5/7/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak private var memedImageView: UIImageView!

    var memeObjectIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.navigationItem.title = "Detail"
        
        // delete meme button
        let deleteButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "deleteMeme")
        self.navigationItem.rightBarButtonItem = deleteButton
        
        self.memedImageView.image = MemeObject.sharedMemes()[self.memeObjectIndex!].memedImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDeleteAlert() {
        
        // warn user before deleting the meme
        let alertController = UIAlertController(title: "Delete", message: "Delete meme image?", preferredStyle: UIAlertControllerStyle.Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (delete) -> Void in
            NSLog("Deleted meme")
            self.memedImageView.image = nil
            
            // delete the meme
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(self.memeObjectIndex!)
            
            // then show the editor button
            let editorButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "showMemeEditor")
            self.navigationItem.rightBarButtonItem = editorButton
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (cancel) -> Void in
            NSLog("Cancel delete")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteMeme() {
        self.showDeleteAlert()
    }
    
    func showMemeEditor() {
        self.navigationController?.popViewControllerAnimated(true)
        
        let memeEditorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! MemesEditorViewController
        self.navigationController?.pushViewController(memeEditorViewController, animated: false)
    }

}
