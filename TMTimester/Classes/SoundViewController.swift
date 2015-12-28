//
//  SoundViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/26/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import AVFoundation

class SoundViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var name: String = ""
    var soundFileName: String = ""
    var audioPlayer: AVAudioPlayer!
    var tableData: NSMutableArray = []
    
    //------------------------------------------------------------------------------
    convenience init( name: String )
    //------------------------------------------------------------------------------
    {
        self.init( nibName: nil, bundle: nil )
    
        self.name = name
        
        if name == "Preparation" {

            self.soundFileName = NSUserDefaults.standardUserDefaults().objectForKey( kPreparationAlarmKey ) as! String

        } else if name == "Meditation" {
            
            self.soundFileName = NSUserDefaults.standardUserDefaults().objectForKey( kMeditationAlarmKey ) as! String

        } else {
            
            self.soundFileName = NSUserDefaults.standardUserDefaults().objectForKey( kRestAlarmKey ) as! String

        }
    }
    
    //------------------------------------------------------------------------------
    override init( nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle! )
    //------------------------------------------------------------------------------
    {
        super.init( nibName: nibNameOrNil, bundle: nibBundleOrNil )
    }
    
    //------------------------------------------------------------------------------
    required init?( coder aDecoder: NSCoder )
    //------------------------------------------------------------------------------
    {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            topBarView.backgroundColor = kBarColor
            self.view.addSubview( topBarView )
            
            let label = UILabel( frame: CGRectMake( 0, 20, self.view.frame.width, 44 ))
            label.text = name + " Alarm"
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
        
        self.tableData.addObject( ["title":"None","name":"none.wav"] )
        self.tableData.addObject( ["title":"Bell","name":"bell.wav"] )
        self.tableData.addObject( ["title":"Chime","name":"chime.wav"] )
        self.tableData.addObject( ["title":"Gong","name":"gong.wav"] )
        self.tableData.addObject( ["title":"Gong 2","name":"gong2.wav"] )
        self.tableData.addObject( ["title":"Maharishi Mahesh Yogi Jai Guru Dev","name":"jai-guru-dev.wav"] )
        self.tableData.addObject( ["title":"Ocean","name":"ocean.wav"] )
        self.tableData.addObject( ["title":"Rain","name":"rain.wav"] )
        self.tableData.addObject( ["title":"Ting","name":"ting.wav"] )
        self.tableData.addObject( ["title":"Water Drop","name":"water-drop.wav"] )
        self.tableData.addObject( ["title":"Waterfall","name":"waterfall.wav"] )
        self.tableData.addObject( ["title":"Whales","name":"whales.wav"] )
        self.tableData.addObject( ["title":"Whippoorwill","name":"whippoorwill.wav"] )

        let tableView = UITableView( frame: CGRectMake( 0, 64, self.view.frame.width, self.view.frame.height-64 ))
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview( tableView )
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
        return self.tableData.count
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //------------------------------------------------------------------------------
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?
        
        if cell == nil {
            
            cell = UITableViewCell( style: UITableViewCellStyle.Default, reuseIdentifier: "cell" )
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.textLabel!.textColor = UIColor.redColor()
            
        }
        
        let dict = self.tableData[indexPath.row] as! Dictionary<String,String>
        
        cell!.textLabel!.text = dict["title"]
        
        if dict["name"] == self.soundFileName {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath )
    //------------------------------------------------------------------------------
    {
        let dict = self.tableData[indexPath.row] as! Dictionary<String,String>

        self.soundFileName = dict["name"]!

        if name == "Preparation" {
            
            NSUserDefaults.standardUserDefaults().setValue( self.soundFileName, forKey: kPreparationAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
            
        } else if name == "Meditation" {
            
            NSUserDefaults.standardUserDefaults().setValue( self.soundFileName, forKey: kMeditationAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
            
        } else {
            
            NSUserDefaults.standardUserDefaults().setValue( self.soundFileName, forKey: kRestAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
        tableView.reloadData()
        
        playSound()
    }
    
    //------------------------------------------------------------------------------
    func playSound()
    //------------------------------------------------------------------------------
    {
        let name = self.soundFileName.substringToIndex( self.soundFileName.endIndex.advancedBy(-4))
        
        let url = NSURL( fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "wav")! )
        
        do {
            self.audioPlayer = try AVAudioPlayer( contentsOfURL: url )
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        } catch {
        }
    }
    
    //------------------------------------------------------------------------------
    func doneButtonTapped()
    //------------------------------------------------------------------------------
    {
        self.dismissViewControllerAnimated( true, completion: nil )
    }
    
}
