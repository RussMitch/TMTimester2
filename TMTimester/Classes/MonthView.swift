//
//  MonthView.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/27/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import CoreData

class MonthView: UIView {
    
    //------------------------------------------------------------------------------
    func setDate( date: NSDate, previewMode: Bool )
    //------------------------------------------------------------------------------
    {
        while self.subviews.count > 0 {
            self.subviews[0].removeFromSuperview()
        }

        let currentDateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: NSDate())

        let currentDay = currentDateComponents.day
        let currentMonth = currentDateComponents.month
        let currentYear = currentDateComponents.year
        
        var dateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: date )

        let month = dateComponents.month
        let year = dateComponents.year
        
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
                
                let imageView = UIImageView( frame: CGRectMake( width/2-14, width-30, 28, 28 ))
                contentView.addSubview( imageView )

                if previewMode {
                    
                    if month==currentMonth && year==currentYear && day<currentDay {
                        imageView.image = UIImage( named: "star" )
                    } else if month==currentMonth && year==currentYear && day==currentDay {
                        imageView.image = UIImage( named: "half-star4" )
                    } else if (month<currentMonth) || (year<currentYear) {
                        imageView.image = UIImage( named: "star" )                        
                    }
                    
                } else {
                    
                    if let meditationRecord = fetchMeditationRecordForDay( day, month: month, year: year ) {
                        
                        let count = meditationRecord.valueForKey( kCount ) as! Int
                        
                        if count == 1 {
                            imageView.image = UIImage( named: "half-star4" )
                        } else if count > 1 {
                            imageView.image = UIImage( named: "star" )
                        }
                    }
                }
                
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
    
    //------------------------------------------------------------------------------
    func fetchMeditationRecordForDay( day: Int, month: Int, year: Int  ) -> NSManagedObject?
    //------------------------------------------------------------------------------
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest( entityName: kMeditationRecord )
        
        let predicate1 = NSPredicate( format: "day == %d", day )
        let predicate2 = NSPredicate( format: "month == %d", month )
        let predicate3 = NSPredicate( format: "year == %d", year )
        
        fetchRequest.predicate = NSCompoundPredicate( andPredicateWithSubpredicates: [predicate1,predicate2,predicate3] )
        
        var meditationRecords = [NSManagedObject]()
        
        do {
            
            let results = try appDelegate.managedObjectContext.executeFetchRequest( fetchRequest )
            
            meditationRecords = results as! [NSManagedObject]
            
        } catch _ as NSError {
        }
        
        if meditationRecords.count > 0 {
            
            return meditationRecords[0]
            
        } else {
            
            return nil
            
        }
    }
}
