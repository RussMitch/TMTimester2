//
//  SettingsViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    var restTimeLabel: UILabel!
    var restAlarmLabel: UILabel!
    var contentView: UIScrollView!
    var pickerContainerView: UIView!
    var completionSongLabel: UILabel!
    var meditationTimeLabel: UILabel!
    var meditationAlarmLabel: UILabel!
    var preparationTimeLabel: UILabel!
    var preparationAlarmLabel: UILabel!
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = kBarColor
        
        self.navigationItem.title = "Settings"
        
        self.view.backgroundColor = UIColor.whiteColor()

        self.contentView = UIScrollView( frame: self.view.bounds )
        self.view.addSubview( self.contentView )
        
        var y: CGFloat = 0
        
        do
        {
            let label = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 30 ))
            label.backgroundColor = kBarColor
            label.text = "  Meditation Times"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 18 )
            self.contentView.addSubview( label )
        }
        
        y += 30

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.contentView.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "preparationTimeTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Preparation Time"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            let count1 = NSUserDefaults.standardUserDefaults().objectForKey( kCount1Key ) as! Int
            
            self.preparationTimeLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.preparationTimeLabel.text = String( format: "%d:%02d", count1/60, count1%60 )
            self.preparationTimeLabel.textAlignment = NSTextAlignment.Right
            self.preparationTimeLabel.textColor = UIColor.redColor()
            self.preparationTimeLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.preparationTimeLabel )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-10, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview( view )
        }
        
        y += 1
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.contentView.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "meditationTimeTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Meditation Time"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )

            let count2 = NSUserDefaults.standardUserDefaults().objectForKey( kCount2Key ) as! Int
            
            self.meditationTimeLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.meditationTimeLabel.text = String( format: "%d:%02d", count2/60, count2%60 )
            self.meditationTimeLabel.textAlignment = NSTextAlignment.Right
            self.meditationTimeLabel.textColor = UIColor.redColor()
            self.meditationTimeLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.meditationTimeLabel )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-10, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview( view )
        }
        
        y += 1

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.contentView.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "restTimeTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Rest Time"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            let count3 = NSUserDefaults.standardUserDefaults().objectForKey( kCount3Key ) as! Int
            
            self.restTimeLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.restTimeLabel.text = String( format: "%d:%02d", count3/60, count3%60 )
            self.restTimeLabel.textAlignment = NSTextAlignment.Right
            self.restTimeLabel.textColor = UIColor.redColor()
            self.restTimeLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.restTimeLabel )
        }
        
        y += 44

        do
        {
            let label = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 30 ))
            label.backgroundColor = kBarColor
            label.text = "  Alarm Sounds"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 18 )
            self.contentView.addSubview( label )
        }
        
        y += 30

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.contentView.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "preparationAlarmTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Preparation Alarm"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            self.preparationAlarmLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.preparationAlarmLabel.textAlignment = NSTextAlignment.Right
            self.preparationAlarmLabel.textColor = UIColor.redColor()
            self.preparationAlarmLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.preparationAlarmLabel )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-10, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview( view )
        }
        
        y += 1
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.contentView.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "meditationAlarmTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Meditation Alarm"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            self.meditationAlarmLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.meditationAlarmLabel.textAlignment = NSTextAlignment.Right
            self.meditationAlarmLabel.textColor = UIColor.redColor()
            self.meditationAlarmLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.meditationAlarmLabel )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-10, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview( view )
        }
        
        y += 1
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.contentView.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "restAlarmTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Rest Alarm"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            self.restAlarmLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.restAlarmLabel.textAlignment = NSTextAlignment.Right
            self.restAlarmLabel.textColor = UIColor.redColor()
            self.restAlarmLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.restAlarmLabel )
        }
        
        y += 44
        
        do
        {
            let label = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 30 ))
            label.backgroundColor = kBarColor
            label.text = "  Completion Song"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 18 )
            self.contentView.addSubview( label )
        }
        
        y += 30

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.contentView.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "completionSongTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            self.completionSongLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.completionSongLabel.textColor = UIColor.redColor()
            self.completionSongLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.completionSongLabel )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-10, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview( view )
        }
        
        y += 1
        
        self.contentView.contentSize = CGSizeMake( self.view.frame.width, y )
    }
    
    //------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool)
    //------------------------------------------------------------------------------
    {
        super.viewDidAppear( animated )
        
        do
        {
            var alarm = NSUserDefaults.standardUserDefaults().objectForKey( kPreparationAlarmKey ) as! String
            
            if alarm == "jai-guru-dev.wav" {
                alarm = "Jai Guru Dev"
            } else if alarm == "water-drop.wav" {
                alarm = "Water Drop"
            } else {
                alarm = alarm.substringToIndex( alarm.endIndex.advancedBy(-4)).capitalizedString
            }
            
            self.preparationAlarmLabel.text = alarm
        }

        do
        {
            var alarm = NSUserDefaults.standardUserDefaults().objectForKey( kMeditationAlarmKey ) as! String
            
            if alarm == "jai-guru-dev.wav" {
                alarm = "Jai Guru Dev"
            } else if alarm == "water-drop.wav" {
                alarm = "Water Drop"
            } else {
                alarm = alarm.substringToIndex( alarm.endIndex.advancedBy(-4)).capitalizedString
            }
            
            self.meditationAlarmLabel.text = alarm
        }

        do
        {
            var alarm = NSUserDefaults.standardUserDefaults().objectForKey( kRestAlarmKey ) as! String
            
            if alarm == "jai-guru-dev.wav" {
                alarm = "Jai Guru Dev"
            } else if alarm == "water-drop.wav" {
                alarm = "Water Drop"
            } else {
                alarm = alarm.substringToIndex( alarm.endIndex.advancedBy(-4)).capitalizedString
            }
            
            self.restAlarmLabel.text = alarm
        }
        
        let song = NSUserDefaults.standardUserDefaults().objectForKey( kCompletionSongNameKey ) as! String
        self.completionSongLabel.text = song
    }
    
    //------------------------------------------------------------------------------
    func preparationTimeTapped()
    //------------------------------------------------------------------------------
    {
        let count1 = NSUserDefaults.standardUserDefaults().objectForKey( kCount1Key ) as! Int

        createPickerWithTitle( "Preparation Time", tag: 1, count: count1 )
    }

    //------------------------------------------------------------------------------
    func meditationTimeTapped()
    //------------------------------------------------------------------------------
    {
        let count2 = NSUserDefaults.standardUserDefaults().objectForKey( kCount2Key ) as! Int

        createPickerWithTitle( "Meditation Time", tag: 2, count: count2 )
    }
    
    //------------------------------------------------------------------------------
    func restTimeTapped()
    //------------------------------------------------------------------------------
    {
        let count3 = NSUserDefaults.standardUserDefaults().objectForKey( kCount3Key ) as! Int

        createPickerWithTitle( "Rest Time", tag: 3, count: count3 )
    }

    //------------------------------------------------------------------------------
    func preparationAlarmTapped()
    //------------------------------------------------------------------------------
    {
        let soundViewController = SoundViewController( name: "Preparation" )
        self.presentViewController( soundViewController, animated: true, completion: nil )
    }
    
    //------------------------------------------------------------------------------
    func meditationAlarmTapped()
    //------------------------------------------------------------------------------
    {
        let soundViewController = SoundViewController( name: "Meditation" )
        self.presentViewController( soundViewController, animated: true, completion: nil )
    }

    //------------------------------------------------------------------------------
    func restAlarmTapped()
    //------------------------------------------------------------------------------
    {
        let soundViewController = SoundViewController( name: "Rest" )
        self.presentViewController( soundViewController, animated: true, completion: nil )
    }

    //------------------------------------------------------------------------------
    func completionSongTapped()
    //------------------------------------------------------------------------------
    {
        let songViewController = SongViewController()
        self.presentViewController( songViewController, animated: true, completion: nil )
    }

    //------------------------------------------------------------------------------
    func createPickerWithTitle( title: String, tag: Int, count: Int )
    //------------------------------------------------------------------------------
    {
        self.pickerContainerView = UIView( frame: self.view.bounds )
        self.pickerContainerView.tag = tag
        self.view.addSubview( self.pickerContainerView )
        
        let overlayView = UIView( frame: self.view.bounds )
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.alpha = 0
        overlayView.tag = 1
        self.pickerContainerView.addSubview( overlayView )
        
        let pickerViewHolder = UIView( frame: CGRectMake( 0, self.view.frame.height, self.view.frame.width, 216+44 ))
        pickerViewHolder.tag = 2
        pickerViewHolder.backgroundColor = UIColor.whiteColor()
        self.pickerContainerView.addSubview( pickerViewHolder )
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, 0, pickerViewHolder.frame.width, 44 ))
            view.backgroundColor = kBarColor
            pickerViewHolder.addSubview( view )
            
            let label = UILabel( frame: view.bounds )
            label.text = title
            label.textColor = UIColor.blackColor()
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.boldSystemFontOfSize( 18 )
            view.addSubview( label )
            
            let button = UIButton( frame: CGRectMake( pickerViewHolder.frame.width - 70, 0, 70,44 ))
            button.setTitle( "Done", forState: .Normal )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.addTarget( self, action: Selector( "pickerDoneButtonTapped" ), forControlEvents: .TouchUpInside )
            view.addSubview( button )
        }
        
        let pickerView = UIPickerView( frame: CGRectMake( 0, 44, self.view.frame.width, 216 ))
        pickerView.tag = 10
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerViewHolder.addSubview( pickerView )
        
        let mins = count / 60
        let secs = count % 60
        
        pickerView.selectRow( 30, inComponent: 0, animated: false )
        pickerView.selectRow( mins, inComponent: 1, animated: false )
        pickerView.selectRow( secs, inComponent: 2, animated: false )
        
        var x: CGFloat = 0
        
        do
        {
            let label = UILabel( frame: CGRectMake( x-4, pickerView.frame.height/2-15, pickerView.frame.width/3, 30 ))
            label.textAlignment = NSTextAlignment.Right
            label.textColor = UIColor.blueColor()
            label.text = "hrs"
            pickerView.addSubview( label )
        }
        
        x += pickerView.frame.width/3
        
        do
        {
            let label = UILabel( frame: CGRectMake( x-4, pickerView.frame.height/2-15, pickerView.frame.width/3, 30 ))
            label.textAlignment = NSTextAlignment.Right
            label.textColor = UIColor.blueColor()
            label.text = "mins"
            pickerView.addSubview( label )
        }

        x += pickerView.frame.width/3
        
        do
        {
            let label = UILabel( frame: CGRectMake( x-4, pickerView.frame.height/2-15, pickerView.frame.width/3, 30 ))
            label.textAlignment = NSTextAlignment.Right
            label.textColor = UIColor.blueColor()
            label.text = "secs"
            pickerView.addSubview( label )
        }
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.height

        UIView.animateWithDuration( 0.25, animations: {
            overlayView.alpha = 0.25
            pickerViewHolder.frame.origin.y -= (216+44+tabBarHeight)
        })
    }
    
    //------------------------------------------------------------------------------
    func numberOfComponentsInPickerView( pickerView: UIPickerView ) -> Int
    //------------------------------------------------------------------------------
    {
        return 3
    }
    
    //------------------------------------------------------------------------------
    func pickerView( pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int
    //------------------------------------------------------------------------------
    {
        return 60
    }
    
    //------------------------------------------------------------------------------
    func rowSizeForComponent( component: Int ) -> CGSize
    //------------------------------------------------------------------------------
    {
        return CGSizeMake( self.view.frame.width, 44 )
    }
    
    //------------------------------------------------------------------------------
    func pickerView( pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    //------------------------------------------------------------------------------
    {
        let label = UILabel( frame: CGRectMake( 0, 0, pickerView.frame.width/3, 30 ))
        label.textColor = UIColor.redColor()
        label.textAlignment = NSTextAlignment.Center
        
        if component == 0 {
            label.text = "0"
        } else {
            label.text = String( format: "%lu", arguments: [row] )
        }
        
        return label
    }

    //------------------------------------------------------------------------------
    func pickerDoneButtonTapped()
    //------------------------------------------------------------------------------
    {
        let overlayView = self.pickerContainerView.viewWithTag( 1 )!
        let pickerViewHolder = self.pickerContainerView.viewWithTag( 2 )!
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.height
        
        UIView.animateWithDuration( 0.25, animations: {
            
            overlayView.alpha = 0
            pickerViewHolder.frame.origin.y += 216+44+tabBarHeight
            
        }, completion: { (value: Bool) in
                
            self.pickerContainerView.removeFromSuperview()
                
        })

        let pickerView: UIPickerView  = pickerViewHolder.viewWithTag( 10 ) as! UIPickerView
        
        let mins = pickerView.selectedRowInComponent( 1 )
        let secs = pickerView.selectedRowInComponent( 2 )
        
        if self.pickerContainerView.tag == 1 {
            
            NSUserDefaults.standardUserDefaults().setInteger( mins*60+secs, forKey: kCount1Key )
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.preparationTimeLabel.text = String( format: "%d:%02d", mins, secs )
            
        } else if self.pickerContainerView.tag == 2 {
            
            NSUserDefaults.standardUserDefaults().setInteger( mins*60+secs, forKey: kCount2Key )
            NSUserDefaults.standardUserDefaults().synchronize()

            self.meditationTimeLabel.text = String( format: "%d:%02d", mins, secs )
            
        } else {
            
            NSUserDefaults.standardUserDefaults().setInteger( mins*60+secs, forKey: kCount3Key )
            NSUserDefaults.standardUserDefaults().synchronize()

            self.restTimeLabel.text = String( format: "%d:%02d", mins, secs )
            
        }
        
    }
}
