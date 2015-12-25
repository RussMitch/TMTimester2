//
//  SettingsViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit

class SettingsViewController: UIViewController {

    var restTimeLabel: UILabel!
    var completionSongLabel: UILabel!
    var meditationTimeLabel: UILabel!
    var meditationAlarmLabel: UILabel!
    var completionAlarmLabel: UILabel!
    
    let barColor = UIColor( red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1 )
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = barColor
        
        self.navigationItem.title = "Settings"
        
        self.view.backgroundColor = UIColor.whiteColor()

        var y: CGFloat = 64
        
        do
        {
            let label = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 30 ))
            label.backgroundColor = barColor
            label.text = "  Meditation Times"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 18 )
            self.view.addSubview( label )
        }
        
        y += 30
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.view.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "meditationTimeTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Meditation Time"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )

            self.meditationTimeLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.meditationTimeLabel.text = "20:00"
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
            self.view.addSubview( view )
        }
        
        y += 1

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.view.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "restTimeTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Rest Time"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            self.restTimeLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.restTimeLabel.text = "2:00"
            self.restTimeLabel.textAlignment = NSTextAlignment.Right
            self.restTimeLabel.textColor = UIColor.redColor()
            self.restTimeLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.restTimeLabel )
        }
        
        y += 44

        do
        {
            let label = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 30 ))
            label.backgroundColor = barColor
            label.text = "  Alarm Sounds"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 18 )
            self.view.addSubview( label )
        }
        
        y += 30

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.view.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "meditationAlarmTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Meditation Alarm"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            self.meditationAlarmLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.meditationAlarmLabel.text = "Jai Guru Dev"
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
            self.view.addSubview( view )
        }
        
        y += 1
        
        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.view.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "completionAlarmTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            label.text = "Completion Alarm"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( label )
            
            self.completionAlarmLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.completionAlarmLabel.text = "gong"
            self.completionAlarmLabel.textAlignment = NSTextAlignment.Right
            self.completionAlarmLabel.textColor = UIColor.redColor()
            self.completionAlarmLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.completionAlarmLabel )
        }
        
        y += 44
        
        do
        {
            let label = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 30 ))
            label.backgroundColor = barColor
            label.text = "  Completion Song"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 18 )
            self.view.addSubview( label )
        }
        
        y += 30

        do
        {
            let view = UIView( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            self.view.addSubview( view )
            
            let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "completionSongTapped" ))
            view.addGestureRecognizer( tapGestureRecognizer )
            
            self.completionSongLabel = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 44 ))
            self.completionSongLabel.text = "None"
            self.completionSongLabel.textColor = UIColor.redColor()
            self.completionSongLabel.font = UIFont.systemFontOfSize( 18 )
            view.addSubview( self.completionSongLabel )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-10, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            self.view.addSubview( view )
        }
        
        y += 1
    }
    
    //------------------------------------------------------------------------------
    func meditationTimeTapped()
    //------------------------------------------------------------------------------
    {
        print( "meditationTimeTapped" )
    }
    
    //------------------------------------------------------------------------------
    func restTimeTapped()
    //------------------------------------------------------------------------------
    {
        print( "restTimeTapped" )
    }

    //------------------------------------------------------------------------------
    func meditationAlarmTapped()
    //------------------------------------------------------------------------------
    {
        print( "meditationAlarmTapped" )
    }

    //------------------------------------------------------------------------------
    func completionAlarmTapped()
    //------------------------------------------------------------------------------
    {
        print( "completionAlarmTapped" )
    }

    //------------------------------------------------------------------------------
    func completionSongTapped()
    //------------------------------------------------------------------------------
    {
        print( "completionSongTapped" )
    }
}
