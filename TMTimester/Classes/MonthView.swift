//
//  MonthView.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/27/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit

class MonthView: UIView {
    
    //------------------------------------------------------------------------------
    func setDate( date: NSDate )
    //------------------------------------------------------------------------------
    {
        while self.subviews.count > 0 {
            self.subviews[0].removeFromSuperview()
        }
        
        var dateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: date )
        
        dateComponents.day = 1
        
        let firstDate = NSCalendar.currentCalendar().dateFromComponents( dateComponents )
        
        dateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Weekday], fromDate: firstDate! )
        
        var startDay = dateComponents.weekday - 1 // zero indexed
        
        let lastDay = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date ).length
        
        var day = 1
        var y: CGFloat = 30
        let width: CGFloat = frame.width / 7
        var x: CGFloat = CGFloat( startDay ) * width
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        let titleLabel = UILabel( frame: CGRectMake( x, 0, width, 30 ))
        titleLabel.text = dateFormatter.stringFromDate( date ).uppercaseString
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.blackColor()
        self.addSubview( titleLabel )
        
        for _ in 0...6 {
            
            var j: Int
            
            for j=startDay; j<7; j++ {
                
                let contentView = UIView( frame: CGRectMake( x, y, width, width ))
                self.addSubview( contentView )
                
                let label = UILabel( frame: CGRectMake( 0, 0, width, 30 ))
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.blackColor()
                label.text = String( format: "%d", day )
                contentView.addSubview( label )
                
                day++
                x += width
                
                if (day > lastDay) {
                    break
                }
            }
            
            let lineView = UIView( frame: CGRectMake( CGFloat(startDay)*width, y, CGFloat(j+1)*width, 1 ))
            lineView.backgroundColor = UIColor.lightGrayColor()
            self.addSubview( lineView )
            
            if day > lastDay {
                break
            }
            
            x = 0
            y += width
            startDay = 0
        }
    }
}
