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
    
    var numMonths: Int!
    var cellHeight: CGFloat!
    var tableView: UITableView!
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
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
