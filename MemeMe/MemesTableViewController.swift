//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Kelvin Lee on 5/6/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit


class MemesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // edit button for table view
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()

        let memeEditorViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! MemesEditorViewController
        
        // if there's no meme saved, show the meme editor once
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            if MemeObject.sharedMemes().isEmpty {
                self.navigationController?.pushViewController(memeEditorViewController, animated: true)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section.
        NSLog("row count %lu", MemeObject.sharedMemes().count)
        
        return MemeObject.sharedMemes().count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell", forIndexPath: indexPath) as! MemeTableViewCell

        let memeObject = MemeObject.sharedMemes()[indexPath.row] as MemeObject

        // Configure the cell...
        NSLog("Meme object %@", memeObject.memedImage!)
        
        // set the meme image and text
        cell.memeImage.contentMode = UIViewContentMode.ScaleToFill
        cell.memeImage?.image = memeObject.memedImage!
        
        cell.topText.text = memeObject.topText
        cell.bottomText.text = memeObject.bottomText
        
        NSLog("cell for row %@", memeObject.memedImage!)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // push detail view controller for selected meme
        var meme = MemeObject.sharedMemes()[indexPath.row] as MemeObject
        let memeDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
        
        // pass the selected indexPath to detail view controller
        memeDetailViewController.memeObjectIndex = indexPath.row
        
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            // access the shared instance and remove the meme from the array
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            
            // animate the deletion
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }

}
