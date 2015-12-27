//
//  SongViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/26/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//

import UIKit
import MediaPlayer

class SongViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MPMediaPickerControllerDelegate {

    var tableView: UITableView!
    var musicPlayerController: MPMusicPlayerController!
    var mediaPickerController: MPMediaPickerController!
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // top bar layout
        //------------------------------------------------------------------------------
        
        do
        {
            let topBarView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 64 ))
            topBarView.backgroundColor = UIColor( red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0 )
            self.view.addSubview( topBarView )
            
            let label = UILabel( frame: CGRectMake( 0, 20, self.view.frame.width, 44 ))
            label.text = "Completion Song"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 17 )
            label.textAlignment = NSTextAlignment.Center
            topBarView.addSubview( label )
            
            let button =  UIButton(type: .Custom)
            button.frame = CGRectMake( self.view.frame.width - 70, 20, 70, 44 )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.setTitle("Done", forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("doneButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
            topBarView.addSubview( button )
            
            let view = UIView( frame: CGRectMake( 0, 64-1, self.view.frame.width, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            topBarView.addSubview( view )
        }
        
        self.tableView = UITableView( frame: CGRectMake( 0, 64, self.view.frame.width, self.view.frame.height-64 ))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview( self.tableView )
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //------------------------------------------------------------------------------
    {
        return 44
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //------------------------------------------------------------------------------
    {
        return 2
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //------------------------------------------------------------------------------
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        
        if cell == nil {
            
            cell = UITableViewCell( style: UITableViewCellStyle.Default, reuseIdentifier: "cell" )
            cell!.textLabel!.textColor = UIColor.redColor()
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            
        }

        let song: String = NSUserDefaults.standardUserDefaults().objectForKey( kCompletionSongNameKey ) as! String
        
        if indexPath.row == 0 {

            cell!.textLabel!.text = "None"
            
            if song == kCompletionSongNameDef {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }
            
        } else {
            
            cell!.textLabel!.text = song
            
            if song == kCompletionSongNameDef {
                cell?.accessoryType = UITableViewCellAccessoryType.None
            } else {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        return cell!
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath )
    //------------------------------------------------------------------------------
    {
        if self.musicPlayerController != nil {
            self.musicPlayerController.stop()
        }
        
        if indexPath.row == 0 {
            
            NSUserDefaults.standardUserDefaults().setValue( kCompletionSongNameDef, forKey: kCompletionSongNameKey )
            NSUserDefaults.standardUserDefaults().synchronize()
            
        } else {
            
            self.mediaPickerController = MPMediaPickerController()
            self.mediaPickerController.delegate = self
            self.presentViewController( self.mediaPickerController, animated: true, completion: nil )
            
        }
        
        tableView.reloadData()
    }
    
    //------------------------------------------------------------------------------
    func mediaPicker( mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection )
    //------------------------------------------------------------------------------
    {
        self.mediaPickerController.dismissViewControllerAnimated( true, completion: nil )
        
        if mediaItemCollection.count > 0 {
            
            let mediaItem: MPMediaItem = mediaItemCollection.items[0]
            
            let title: String = mediaItem.valueForProperty( MPMediaItemPropertyTitle ) as! String!
            let persistentId: NSNumber = mediaItem.valueForProperty( MPMediaItemPropertyPersistentID ) as! NSNumber!
            
            NSUserDefaults.standardUserDefaults().setValue( title, forKey: kCompletionSongNameKey )
            NSUserDefaults.standardUserDefaults().setValue( persistentId, forKey: kCompletionSongIdKey )
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let mediaPropertyPredicate: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: persistentId, forProperty: MPMediaItemPropertyPersistentID )
            
            let mediaQuery: MPMediaQuery = MPMediaQuery.songsQuery()
            
            mediaQuery.addFilterPredicate( mediaPropertyPredicate )
        
            let mediaItemCollection: MPMediaItemCollection = MPMediaItemCollection( items: mediaQuery.items! )
            
            self.musicPlayerController = MPMusicPlayerController.applicationMusicPlayer()
            
            self.musicPlayerController.setQueueWithItemCollection( mediaItemCollection )
            
            self.musicPlayerController.play()
            
            self.tableView.reloadData()
        }
    }
    
    //------------------------------------------------------------------------------
    func mediaPickerDidCancel( mediaPicker: MPMediaPickerController )
    //------------------------------------------------------------------------------
    {
        self.mediaPickerController.dismissViewControllerAnimated( true, completion: nil )
    }
    
    //------------------------------------------------------------------------------
    func doneButtonTapped()
    //------------------------------------------------------------------------------
    {
        if self.musicPlayerController != nil {
            self.musicPlayerController.stop()
        }
        
        self.dismissViewControllerAnimated( true, completion: nil )
    }
    
}
