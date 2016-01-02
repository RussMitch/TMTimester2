//
//  TimerViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import CoreData
import MediaPlayer
import AVFoundation

class TimerViewController: UIViewController,AVAudioPlayerDelegate {
    
    var timerLabel: UILabel!
    var startLabel: UILabel!
    var resetLabel: UILabel!
    
    var count1: Int = 0
    var count2: Int = 0
    var count3: Int = 0

    var restTimeOver: Bool = true
    var meditationTimeOver: Bool = true
    var preparationTimeOver: Bool = true
    
    var timer: NSTimer!
    var startDate: NSDate!
    var pauseDate: NSDate!
    
    var restAlarm: String = ""
    var meditationAlarm: String = ""
    var preparationAlarm: String = ""
    var completionSong: String = ""

    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    var musicPlayerController: MPMusicPlayerController!
        
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = kBarColor
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.title = "Timer"

        if NSUserDefaults.standardUserDefaults().objectForKey( kLoggingUnlockedKey ) == nil {
            NSUserDefaults.standardUserDefaults().setBool( false, forKey: kLoggingUnlockedKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kCount1Key ) == nil {
            NSUserDefaults.standardUserDefaults().setInteger( kCount1Def, forKey: kCount1Key )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kCount2Key ) == nil {
            NSUserDefaults.standardUserDefaults().setInteger( kCount2Def, forKey: kCount2Key )
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        if NSUserDefaults.standardUserDefaults().objectForKey( kCount3Key ) == nil {
            NSUserDefaults.standardUserDefaults().setInteger( kCount3Def, forKey: kCount3Key )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kPreparationAlarmKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kPreparationAlarmDef, forKey: kPreparationAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kMeditationAlarmKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kMeditationAlarmDef, forKey: kMeditationAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kRestAlarmKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kRestAlarmDef, forKey: kRestAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kCompletionSongNameKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kCompletionSongNameDef, forKey: kCompletionSongNameKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        if NSUserDefaults.standardUserDefaults().objectForKey( kCompletionCountKey ) == nil {
            NSUserDefaults.standardUserDefaults().setInteger( 0, forKey: kCompletionCountKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        loadUserDefaults()
        
        var y: CGFloat = 64
        
        self.timerLabel = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 200 ))
        self.timerLabel.font = UIFont( name: "HelveticaNeue-Thin", size: 100 )
        self.timerLabel.text = String( format: "%02d:%02d", self.count1/60, self.count1%60 )
        self.timerLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview( self.timerLabel )
        
        if self.count1 == 0 {
            self.timerLabel.text = String( format: "%02d:%02d", self.count2/60, self.count2%60 )
        }
        
        y += 200
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 1 ))
            view.backgroundColor = UIColor.blackColor()
            self.view.addSubview( view )
        }

        y += 1
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.height

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, self.view.frame.height - 64 - tabBarHeight ))
            view.backgroundColor = UIColor( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 )
            self.view.addSubview( view )
        }
        
        y += 20
        
        var x = (self.view.frame.width - 160) / 3

        self.startLabel = UILabel( frame: CGRectMake( x, y, 80, 80 ))
        self.startLabel.layer.cornerRadius = 40
        self.startLabel.layer.borderWidth = 1
        self.startLabel.layer.masksToBounds = true
        self.startLabel.layer.borderColor = UIColor.greenColor().CGColor
        self.startLabel.text = "Start"
        self.startLabel.backgroundColor = UIColor.whiteColor()
        self.startLabel.textColor = UIColor.greenColor()
        self.startLabel.textAlignment = NSTextAlignment.Center
        self.startLabel.userInteractionEnabled = true
        self.view.addSubview( self.startLabel )

        do
        {
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "startLabelTapped" ))
            self.startLabel.addGestureRecognizer( tapGestureRecognizer )
        }
        
        x += (80 + x)

        self.resetLabel = UILabel( frame: CGRectMake( x, y, 80, 80 ))
        self.resetLabel.layer.cornerRadius = 40
        self.resetLabel.layer.borderWidth = 1
        self.resetLabel.layer.masksToBounds = true
        self.resetLabel.layer.borderColor = UIColor.blackColor().CGColor
        self.resetLabel.text = "Reset"
        self.resetLabel.backgroundColor = UIColor.whiteColor()
        self.resetLabel.textColor = UIColor.blackColor()
        self.resetLabel.textAlignment = NSTextAlignment.Center
        self.resetLabel.userInteractionEnabled = true
        self.view.addSubview( self.resetLabel )

        do
        {
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "resetLabelTapped" ))
            self.resetLabel.addGestureRecognizer( tapGestureRecognizer )
        }
        
        y += 80 + 40
        
        playSoundNamed( "none.wav", isRestAlarm: false )

        y = self.view.frame.height-tabBarHeight-20-44-20-10
        
        do
        {
            let imageView = UIImageView( frame: CGRectMake( 20, y-15, 30, 30 ))
            imageView.image = UIImage( named: "speaker-off" )
            self.view.addSubview( imageView )
        }

        do
        {
            let imageView = UIImageView( frame: CGRectMake( self.view.frame.width-20-30, y-15, 30, 30 ))
            imageView.image = UIImage( named: "speaker-on" )
            self.view.addSubview( imageView )
        }
        
        let volumeView = MPVolumeView( frame: CGRectMake( 20+10+30, y-10, self.view.frame.width-120, 20 ))
        volumeView.showsVolumeSlider = true
        volumeView.showsRouteButton = false
        self.view.addSubview( volumeView )
        
        let playButton = UIButton( frame: CGRectMake( self.view.frame.width/2-22, self.view.frame.height-tabBarHeight-20-44, 44, 44 ))
        playButton.setBackgroundImage( UIImage( named: "play" ), forState: .Normal )
        playButton.addTarget( self, action: Selector( "playTestSound" ), forControlEvents: .TouchUpInside )
        self.view.addSubview( playButton )
    }
    
    //------------------------------------------------------------------------------
    func playTestSound()
    //------------------------------------------------------------------------------
    {
        loadUserDefaults()
        
        var soundName = "gong.wav"
        
        if self.preparationAlarm != "none.wav" {
            soundName = self.preparationAlarm
        } else if self.meditationAlarm != "none.wav" {
            soundName = self.meditationAlarm
        } else if self.restAlarm != "none.wav" {
            soundName = self.restAlarm
        }
        
        playSoundNamed( soundName, isRestAlarm: false )
    }
    
    //------------------------------------------------------------------------------
    func loadUserDefaults()
    //------------------------------------------------------------------------------
    {
        self.count1 = NSUserDefaults.standardUserDefaults().objectForKey( kCount1Key ) as! Int
        self.count2 = NSUserDefaults.standardUserDefaults().objectForKey( kCount2Key ) as! Int
        self.count3 = NSUserDefaults.standardUserDefaults().objectForKey( kCount3Key ) as! Int
        
        self.preparationAlarm = NSUserDefaults.standardUserDefaults().objectForKey( kPreparationAlarmKey ) as! String
        self.meditationAlarm = NSUserDefaults.standardUserDefaults().objectForKey( kMeditationAlarmKey ) as! String
        self.restAlarm = NSUserDefaults.standardUserDefaults().objectForKey( kRestAlarmKey ) as! String
        self.completionSong = NSUserDefaults.standardUserDefaults().objectForKey( kCompletionSongNameKey ) as! String
    }
    
    //------------------------------------------------------------------------------
    func startLabelTapped()
    //------------------------------------------------------------------------------
    {
        if self.startLabel.text == "Start" {

            loadUserDefaults()

            self.startLabel.text = "Pause"
            self.startLabel.textColor = UIColor.redColor()
            self.startLabel.layer.borderColor = UIColor.redColor().CGColor
            
            self.pauseDate = nil
            self.startDate = NSDate()
            
            self.restTimeOver = false
            self.meditationTimeOver = false
            self.preparationTimeOver = false
            
            self.timerLabel.text = String( format: "%02d:%02d", self.count1/60, self.count1%60 )

            if self.count1 == 0 {
                self.preparationTimeOver = true
                self.timerLabel.text = String( format: "%02d:%02d", self.count2/60, self.count2%60 )
            }
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval( 1, target: self, selector: Selector( "timerFired" ), userInfo: nil, repeats: true )
            
        } else if self.startLabel.text == "Pause" {
            
            self.pauseDate = NSDate()
            
            self.startLabel.text = "Restart"
            self.startLabel.textColor = UIColor.greenColor()
            self.startLabel.layer.borderColor = UIColor.greenColor().CGColor
            
        } else if self.startLabel.text == "Restart" {
            
            self.startDate = NSDate( timeInterval: fabs( self.pauseDate.timeIntervalSinceNow ), sinceDate: self.startDate )
            self.pauseDate = nil
            
            self.startLabel.text = "Pause"
            self.startLabel.textColor = UIColor.redColor()
            self.startLabel.layer.borderColor = UIColor.redColor().CGColor
            
        }
    }
    
    //------------------------------------------------------------------------------
    func resetLabelTapped()
    //------------------------------------------------------------------------------
    {
        if self.timer != nil {
            self.timer.invalidate()
        }
        
        if self.audioPlayer != nil {
            self.audioPlayer.stop()
        }
        
        if self.musicPlayerController != nil {
            self.musicPlayerController.stop()
        }
        
        loadUserDefaults()
        
        self.startLabel.text = "Start"
        self.startLabel.textColor = UIColor.greenColor()
        self.startLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.timerLabel.text = String( format: "%02d:%02d", self.count1/60, self.count1%60 )
        
        if self.count1 == 0 {
            self.timerLabel.text = String( format: "%02d:%02d", self.count2/60, self.count2%60 )
        }
    }
    
    //------------------------------------------------------------------------------
    func timerFired()
    //------------------------------------------------------------------------------
    {
        if self.startDate != nil && self.pauseDate == nil {
            
            let count = Int( fabs( self.startDate.timeIntervalSinceNow ))
            
            if !preparationTimeOver {
                
                var adjustedCount = self.count1 - count
                
                if adjustedCount < 0 {
                    adjustedCount = 0
                }
                
                self.timerLabel.text = String( format: "%02d:%02d", adjustedCount/60, adjustedCount%60 )
                
                if adjustedCount <= 0 {
                    
                    self.preparationTimeOver = true
                    self.startDate = NSDate()
                    
                    playSoundNamed( self.preparationAlarm, isRestAlarm: false )
                    
                }
                
            } else if !meditationTimeOver {

                var adjustedCount = self.count2 - count
                
                if adjustedCount < 0 {
                    adjustedCount = 0
                }

                self.timerLabel.text = String( format: "%02d:%02d", adjustedCount/60, adjustedCount%60 )
                
                if adjustedCount <= 0 {
                    
                    self.meditationTimeOver = true
                    self.startDate = NSDate()
                    
                    playSoundNamed( self.meditationAlarm, isRestAlarm: false )
                    
                }
                
            } else if !restTimeOver {

                var adjustedCount = self.count3 - count
                
                if adjustedCount < 0 {
                    adjustedCount = 0
                }
                
                self.timerLabel.text = String( format: "%02d:%02d", adjustedCount/60, adjustedCount%60 )
                
                if adjustedCount <= 0 {
                    
                    self.restTimeOver = true
                    self.startDate = NSDate()

                    let loggingUnlocked = NSUserDefaults.standardUserDefaults().objectForKey( kLoggingUnlockedKey ) as! Bool
                
                    if (loggingUnlocked) {                        
                        updateMeditationRecord()
                    }

                    var completionCount = NSUserDefaults.standardUserDefaults().integerForKey( kCompletionCountKey )
                    
                    completionCount++
                    
                    NSUserDefaults.standardUserDefaults().setInteger( completionCount, forKey: kCompletionCountKey )
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    print( completionCount )
                    
                    if completionCount == 10 {
                        
                        let message = "Hi, I'm Russell,\n I hope that you have found TM Timester to be helpful in your daily meditations and if so, would you mind taking a moment to rate it?  Thanks!"
                        
                        let alert = UIAlertController( title: "A message from the developer", message: message, preferredStyle: UIAlertControllerStyle.Alert )
                        
                        let rateAction = UIAlertAction( title: "Rate it now", style: UIAlertActionStyle.Default) { (action) -> Void in

                            let url = "itms-apps://itunes.apple.com/app/id847100368"
                            UIApplication.sharedApplication().openURL( NSURL( string: url )! )
                            
                        }

                        let remindMeLaterAction = UIAlertAction( title: "Remind me later", style: UIAlertActionStyle.Default) { (action) -> Void in
                            completionCount--
                            NSUserDefaults.standardUserDefaults().setInteger( completionCount, forKey: kCompletionCountKey )
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }

                        let noThanksAction = UIAlertAction( title: "No, thanks", style: UIAlertActionStyle.Default) { (action) -> Void in
                        }
                        
                        alert.addAction( rateAction )
                        alert.addAction( remindMeLaterAction )
                        alert.addAction( noThanksAction )
                        
                        self.presentViewController( alert, animated: true, completion: nil )
                        
                    } else if completionCount > 300 {
                        
                        NSUserDefaults.standardUserDefaults().setInteger( 0, forKey: kCompletionCountKey )
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                    }
                    
                    self.resetLabelTapped()
                    
                    playSoundNamed( self.restAlarm, isRestAlarm: true )
                    
                }
            }
        }
    }
    
    //------------------------------------------------------------------------------
    func playSoundNamed( name: String, isRestAlarm: Bool )
    //------------------------------------------------------------------------------
    {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ))
        {
            let nameWithoutExtension = name.substringToIndex( name.endIndex.advancedBy(-4))
            
            let url = NSURL( fileURLWithPath: NSBundle.mainBundle().pathForResource( nameWithoutExtension, ofType: "wav" )! )
            
            do
            {
                self.audioPlayer = try AVAudioPlayer( contentsOfURL: url )
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
                
                if isRestAlarm && self.completionSong != kCompletionSongNameDef {
                    self.audioPlayer.delegate = self
                }
            } catch {
            }
        }
    }
    
    //------------------------------------------------------------------------------
    func audioPlayerDidFinishPlaying( player: AVAudioPlayer, successfully flag: Bool )
    //------------------------------------------------------------------------------
    {
        let persistentId: NSNumber = NSUserDefaults.standardUserDefaults().objectForKey( kCompletionSongIdKey ) as! NSNumber!
        
        let mediaPropertyPredicate: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: persistentId, forProperty: MPMediaItemPropertyPersistentID )
        
        let mediaQuery: MPMediaQuery = MPMediaQuery.songsQuery()
        
        mediaQuery.addFilterPredicate( mediaPropertyPredicate )
        
        let mediaItemCollection: MPMediaItemCollection = MPMediaItemCollection( items: mediaQuery.items! )
        
        self.musicPlayerController = MPMusicPlayerController.applicationMusicPlayer()
        
        self.musicPlayerController.setQueueWithItemCollection( mediaItemCollection )
        
        self.musicPlayerController.play()        
    }
    
    //------------------------------------------------------------------------------
    func updateMeditationRecord()
    //------------------------------------------------------------------------------
    {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ))
        {
            let dateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: NSDate() )
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let fetchRequest = NSFetchRequest( entityName: kMeditationRecord )
            
            let predicate1 = NSPredicate( format: "day == %d", dateComponents.day )
            let predicate2 = NSPredicate( format: "month == %d", dateComponents.month )
            let predicate3 = NSPredicate( format: "year == %d", dateComponents.year )
            
            fetchRequest.predicate = NSCompoundPredicate( andPredicateWithSubpredicates: [predicate1,predicate2,predicate3] )
            
            var meditationRecords = [NSManagedObject]()
            
            do {
                
                let results = try appDelegate.managedObjectContext.executeFetchRequest( fetchRequest )
                
                meditationRecords = results as! [NSManagedObject]
                
            } catch _ as NSError {
            }
            
            if meditationRecords.count > 0 {
                
                let count = meditationRecords[0].valueForKey( kCount ) as! Int
                meditationRecords[0].setValue( count+1, forKey: kCount )
                
            } else {
                
                let entity =  NSEntityDescription.entityForName( kMeditationRecord, inManagedObjectContext:appDelegate.managedObjectContext )
                
                let meditationRecord = NSManagedObject( entity: entity!, insertIntoManagedObjectContext: appDelegate.managedObjectContext )
                
                meditationRecord.setValue( dateComponents.day, forKey: kDay )
                meditationRecord.setValue( dateComponents.month, forKey: kMonth )
                meditationRecord.setValue( dateComponents.year, forKey: kYear )
                meditationRecord.setValue( 1, forKey: kCount )
                
                meditationRecords.append( meditationRecord )
                
            }
            
            do {
                try appDelegate.managedObjectContext.save()
            } catch _ as NSError  {
            }
        }
    }
}
