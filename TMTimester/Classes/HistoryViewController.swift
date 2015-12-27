//
//  HistoryViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import CoreData

class HistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView: UITableView!
    
    var cellHeight: CGFloat!
    var numMonths: Int!
    var meditationRecords = [NSManagedObject]()
    
    //------------------------------------------------------------------------------
    func saveMeditationRecordForDay( day: Int, month: Int, year: Int, count: Int )
    //------------------------------------------------------------------------------
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let entity =  NSEntityDescription.entityForName( kMeditationRecord, inManagedObjectContext:appDelegate.managedObjectContext )
        
        let meditationRecord = NSManagedObject( entity: entity!, insertIntoManagedObjectContext: appDelegate.managedObjectContext )
        
        meditationRecord.setValue( day, forKey: kDay )
        meditationRecord.setValue( month, forKey: kMonth )
        meditationRecord.setValue( year, forKey: kYear )
        meditationRecord.setValue( count, forKey: kCount )
        
        self.meditationRecords.append( meditationRecord )
        
        do {
            try appDelegate.managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    //------------------------------------------------------------------------------
    func clearDataBase()
    //------------------------------------------------------------------------------
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request = NSFetchRequest( entityName: kMeditationRecord )
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try appDelegate.persistentStoreCoordinator.executeRequest( deleteRequest, withContext: appDelegate.managedObjectContext )
        } catch _ as NSError {
        }
    }
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest( entityName: kMeditationRecord )
        
        let predicate1 = NSPredicate( format: "month == 12" )
        let predicate2 = NSPredicate( format: "year == 2015" )
        
        fetchRequest.predicate = NSCompoundPredicate( andPredicateWithSubpredicates: [predicate1,predicate2] )
        
        do {
            
            let results = try appDelegate.managedObjectContext.executeFetchRequest( fetchRequest )

            self.meditationRecords = results as! [NSManagedObject]

//            saveMeditationRecordForDay( 1, month: 12, year: 2014, count: 2 )
//            saveMeditationRecordForDay( 3, month: 12, year: 2014, count: 1 )
//            saveMeditationRecordForDay( 5, month: 12, year: 2014, count: 2 )
//
//            saveMeditationRecordForDay( 1, month: 12, year: 2015, count: 2 )
//            saveMeditationRecordForDay( 3, month: 12, year: 2015, count: 1 )
//            saveMeditationRecordForDay( 5, month: 12, year: 2015, count: 2 )
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.navigationController?.navigationBar.barTintColor = kBarColor
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        cellHeight = self.view.frame.width / 7 * 6 + 30
        
        let dateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: NSDate() )

        numMonths = (dateComponents.year - 2014) * 12 + dateComponents.month
        
        let headerView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 64 ))
        headerView.backgroundColor = UIColor.clearColor()
        self.navigationController?.view.addSubview( headerView )
        
        let width = self.view.frame.width / 7
        
        let days = ["S","M","T","W","T","F","S"]
        
        for var i=0; i<7; i++ {
            
            let label = UILabel( frame: CGRectMake( CGFloat(i)*width, 54, width, 10 ))
            label.text = days[i]
            label.font = UIFont.systemFontOfSize( 10 )
            label.textColor = UIColor.darkGrayColor()
            label.textAlignment = NSTextAlignment.Center
            headerView.addSubview( label )
            
        }
        
        self.tableView = UITableView( frame: CGRectMake( 0, 0, self.view.frame.width, self.view.frame.height ))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.view.addSubview( self.tableView )
    }

    //------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool)
    //------------------------------------------------------------------------------
    {
        super.viewDidAppear( animated )
        
        if tableView.contentOffset.y < 0 {
            tableView.contentOffset = CGPointMake( 0, tableView.contentSize.height-tableView.frame.height+64 )
        }
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //------------------------------------------------------------------------------
    {
        return cellHeight
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //------------------------------------------------------------------------------
    {
        return numMonths
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //------------------------------------------------------------------------------
    {
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        var monthView: MonthView!
        
        if cell == nil {
            
            cell = UITableViewCell( style: UITableViewCellStyle.Default, reuseIdentifier: "cell" )
            cell.selectionStyle = UITableViewCellSelectionStyle.None

            monthView = MonthView( frame: CGRectMake( 0, 0, self.view.frame.width, cellHeight ))
            monthView.tag = 1
            cell.contentView.addSubview( monthView )
            
        } else {
            
            monthView = cell.contentView.viewWithTag( 1 ) as! MonthView
        }
        
        let dateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: NSDate() )
        dateComponents.day = 1
        dateComponents.month = (indexPath.row % 12) + 1
        dateComponents.year = 2014 + indexPath.row / 12

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest( entityName: kMeditationRecord )
        
        let predicate1 = NSPredicate( format: "month == %d", dateComponents.month )
        let predicate2 = NSPredicate( format: "year == %d", dateComponents.year )
        
        fetchRequest.predicate = NSCompoundPredicate( andPredicateWithSubpredicates: [predicate1,predicate2] )
        fetchRequest.returnsObjectsAsFaults = false
        
        var records = [NSManagedObject]()
        
        do {
            let results = try appDelegate.managedObjectContext.executeFetchRequest( fetchRequest )            
            records = results as! [NSManagedObject]
        } catch _ as NSError {
        }
        
        let date = NSCalendar.currentCalendar().dateFromComponents( dateComponents )

        monthView.setDate( date!, records: records )
        
        self.navigationItem.title = String( dateComponents.year )
        
        return cell
    }
}
