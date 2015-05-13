//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Kelvin Lee on 5/6/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeGridCell"

class MemesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return MemeObject.sharedMemes().count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    
        let memeObject = MemeObject.sharedMemes()[indexPath.row] as MemeObject
        
        NSLog("Meme object in collection %@", memeObject.memedImage!)
        // Configure the cell
        cell.memeImage?.image = memeObject.memedImage!
        cell.backgroundColor = UIColor.blueColor()
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        // push detail view controller for selected meme
        let memeObject = MemeObject.sharedMemes()[indexPath.row] as MemeObject
        
        let memeDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
        
        memeDetailViewController.memeObjectIndex = indexPath.row
        
        self.navigationController?.pushViewController(memeDetailViewController, animated: true)
        
    }

}
