//
//  TimerViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit

class TimerViewController: UIViewController {

    var timerLabel: UILabel!
    var startLabel: UILabel!
    var resetLabel: UILabel!
    
    var count1: Int = 0
    var count2: Int = 0
    var count3: Int = 0

    var restAlarm: String = ""
    var meditationAlarm: String = ""
    var preparationAlarm: String = ""
    var completionSong: String = ""
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor( red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1 )
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.title = "Timer"

        if NSUserDefaults.standardUserDefaults().objectForKey( kCount1Key ) == nil {
            NSUserDefaults.standardUserDefaults().setInteger( kCount1Def, forKey: kCount1Key )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.count1 = NSUserDefaults.standardUserDefaults().objectForKey( kCount1Key ) as! Int
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kCount2Key ) == nil {
            NSUserDefaults.standardUserDefaults().setInteger( kCount2Def, forKey: kCount2Key )
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        self.count2 = NSUserDefaults.standardUserDefaults().objectForKey( kCount2Key ) as! Int

        if NSUserDefaults.standardUserDefaults().objectForKey( kCount3Key ) == nil {
            NSUserDefaults.standardUserDefaults().setInteger( kCount3Def, forKey: kCount3Key )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.count3 = NSUserDefaults.standardUserDefaults().objectForKey( kCount3Key ) as! Int

        if NSUserDefaults.standardUserDefaults().objectForKey( kPreparationAlarmKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kPreparationAlarmDef, forKey: kPreparationAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.preparationAlarm = NSUserDefaults.standardUserDefaults().objectForKey( kPreparationAlarmKey ) as! String
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kMeditationAlarmKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kMeditationAlarmDef, forKey: kMeditationAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.meditationAlarm = NSUserDefaults.standardUserDefaults().objectForKey( kMeditationAlarmKey ) as! String
        
        if NSUserDefaults.standardUserDefaults().objectForKey( kRestAlarmKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kRestAlarmDef, forKey: kRestAlarmKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.restAlarm = NSUserDefaults.standardUserDefaults().objectForKey( kRestAlarmKey ) as! String

        if NSUserDefaults.standardUserDefaults().objectForKey( kCompletionSongNameKey ) == nil {
            NSUserDefaults.standardUserDefaults().setValue( kCompletionSongNameDef, forKey: kCompletionSongNameKey )
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        self.completionSong = NSUserDefaults.standardUserDefaults().objectForKey( kCompletionSongNameKey ) as! String
        
        var y: CGFloat = 64
        
        self.timerLabel = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 200 ))
        self.timerLabel.font = UIFont( name: "HelveticaNeue-Thin", size: 100 )
        self.timerLabel.text = "20:00"
        self.timerLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview( self.timerLabel )
        
        y += 200
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 1 ))
            view.backgroundColor = UIColor.blackColor()
            self.view.addSubview( view )
        }

        y += 1
        
        do
        {
            let tabBarHeight = self.tabBarController!.tabBar.frame.height
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
    }
    
    //------------------------------------------------------------------------------
    func startLabelTapped()
    //------------------------------------------------------------------------------
    {
        print( "startLabelTapped" )
    }
    
    //------------------------------------------------------------------------------
    func resetLabelTapped()
    //------------------------------------------------------------------------------
    {
        print( "resetLabelTapped" )
    }
}
