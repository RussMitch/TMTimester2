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
import StoreKit
import CloudKit

class HistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SKPaymentTransactionObserver {
    
    var numMonths: Int!
    var headerView: UIView!
    var priceLabel: UILabel!
    var cellHeight: CGFloat!
    var tableView: UITableView!
    var previewMode: Bool = false
    var previewOverlayView: UIView!
    var inAppPurchaseView: UIScrollView!
    var activityIndicatorView: UIActivityIndicatorView!
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver( self )
        
        self.navigationController?.navigationBar.barTintColor = kBarColor
        
        self.view.backgroundColor = UIColor.whiteColor()

        do
        {
            let button =  UIButton(type: .Custom)
            button.frame = CGRectMake( 0, 0, 64, 44 )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.setTitle("Save", forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("saveButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: button )
        }

        do
        {
            let button =  UIButton(type: .Custom)
            button.frame = CGRectMake( 0, 0, 64, 44 )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.setTitle("Restore", forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("restoreButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem( customView: button )
        }
        
        self.headerView = UIView( frame: CGRectMake( 0, 20+44-10, self.view.frame.width, 10 ))
        self.headerView.backgroundColor = UIColor.clearColor()
        self.navigationController?.view.addSubview( self.headerView )

        var x: CGFloat = 0
        let width: CGFloat = self.view.frame.width / 7

        let days = ["S","M","T","W","T","F","S"]
        
        for var i=0;i<7;i++ {
            
            let label = UILabel( frame: CGRectMake( x, 0, width, 10 ))
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.darkGrayColor()
            label.text = days[i]
            label.font = UIFont.systemFontOfSize( 10 )
            self.headerView.addSubview( label )
            
            x += width
            
        }
        
        cellHeight = self.view.frame.width / 7 * 6 + 30
        
        let dateComponents = NSCalendar.currentCalendar().components( [NSCalendarUnit.Day,NSCalendarUnit.Month,NSCalendarUnit.Year], fromDate: NSDate() )

        numMonths = (dateComponents.year - 2015) * 12 + dateComponents.month
                
        self.tableView = UITableView( frame: CGRectMake( 0, 0, self.view.frame.width, self.view.frame.height ))
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.view.addSubview( self.tableView )

        let loggingUnlocked = NSUserDefaults.standardUserDefaults().objectForKey( kLoggingUnlockedKey ) as! Bool

        if !loggingUnlocked {
            
            self.headerView.hidden = true
            self.navigationItem.leftBarButtonItem?.customView?.hidden = true
            self.navigationItem.rightBarButtonItem?.customView?.hidden = true

            self.inAppPurchaseView = UIScrollView( frame: self.view.bounds )
            self.inAppPurchaseView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview( self.inAppPurchaseView )
            
            var y: CGFloat = 64
            
            do
            {
                let label = UILabel( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
                label.text = "Meditation Log"
                label.textColor = UIColor.blackColor()
                label.font = UIFont.boldSystemFontOfSize(18)
                label.textAlignment = NSTextAlignment.Center
                self.inAppPurchaseView.addSubview( label )
            }

            y += 44
            
            do
            {
                let label = UILabel( frame: CGRectMake( 20, y, self.view.frame.width-40, 1000 ))
                label.text = "The meditation log will allow you to automatically track your daily meditation activity.\n\nTap the 'Preview' button below to see an example of the meditation log.  For any given day, a half star indicates that you have completed one meditation, while a full star indicates that you have completed two meditations."    
                label.numberOfLines = 100
                self.inAppPurchaseView.addSubview( label )
                
                let rect = label.textRectForBounds( label.bounds, limitedToNumberOfLines: 100 )

                label.frame = CGRectMake( 20, y, self.view.frame.width-40, rect.height )
                
                y += rect.height + 30
            }
            
            do
            {
                self.priceLabel = UILabel( frame: CGRectMake( 20, y, self.view.frame.width-40, 30 ))
                self.priceLabel.textColor = UIColor.darkGrayColor()
                self.priceLabel.textAlignment = NSTextAlignment.Center
                self.inAppPurchaseView.addSubview( self.priceLabel )
            }
            
            y += 30
            
            do
            {
                let button = UIButton( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
                button.setTitle( "Buy Now", forState: .Normal )
                button.setTitleColor( UIColor.redColor(), forState: .Normal )
                button.addTarget( self, action: Selector( "purchaseButtonTapped" ), forControlEvents: .TouchUpInside )
                self.inAppPurchaseView.addSubview( button )
            }
            
            y += 44

            do
            {
                let button = UIButton( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
                button.setTitle( "Preview", forState: .Normal )
                button.setTitleColor( UIColor.redColor(), forState: .Normal )
                button.addTarget( self, action: Selector( "previewButtonTapped" ), forControlEvents: .TouchUpInside )
                self.inAppPurchaseView.addSubview( button )
            }
            
            y += 44
            
            do
            {
                let button = UIButton( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
                button.setTitle( "Restore Purchase", forState: .Normal )
                button.setTitleColor( UIColor.redColor(), forState: .Normal )
                button.addTarget( self, action: Selector( "restorePurchaseButtonTapped" ), forControlEvents: .TouchUpInside )
                self.inAppPurchaseView.addSubview( button )
            }
            
            y += 44 + 64
            
            self.inAppPurchaseView.contentSize = CGSizeMake( self.inAppPurchaseView.frame.width, y )
        }
        
        self.activityIndicatorView = UIActivityIndicatorView( frame: self.view.bounds )
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.activityIndicatorView.backgroundColor = UIColor( red:0, green: 0, blue:0, alpha:0.2 )
        self.activityIndicatorView.startAnimating()
    }

    //------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool)
    //------------------------------------------------------------------------------
    {
        super.viewDidAppear( animated )

        if self.activityIndicatorView != nil {
        
            self.activityIndicatorView.removeFromSuperview()
            
        }
        
        if self.previewOverlayView != nil {
            
            self.dismissPreview();
            
        }
        
        self.activityIndicatorView.removeFromSuperview()
        
        let loggingUnlocked = NSUserDefaults.standardUserDefaults().objectForKey( kLoggingUnlockedKey ) as! Bool
        
        if !loggingUnlocked {

            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            self.priceLabel.text = "Price: " + appDelegate.price
            
        }
        
        self.tableView.reloadData()

        if tableView.contentOffset.y < 0 {
            tableView.contentOffset = CGPointMake( 0, tableView.contentSize.height-tableView.frame.height+64 )
        }
    }
    
    //------------------------------------------------------------------------------
    func purchaseButtonTapped()
    //------------------------------------------------------------------------------
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        self.view.addSubview( self.activityIndicatorView )
        
        if appDelegate.productsArray.count > 0 {
            
            let payment = SKPayment( product: appDelegate.productsArray[0] as SKProduct )
            SKPaymentQueue.defaultQueue().addPayment( payment )

        }
    }
    
    //------------------------------------------------------------------------------
    func previewButtonTapped()
    //------------------------------------------------------------------------------
    {
        self.previewMode = true
        self.headerView.hidden = false
        self.inAppPurchaseView.hidden = true
        
        self.tableView.reloadData()
        
        self.previewOverlayView = UIView( frame: self.view.bounds )
        self.previewOverlayView.backgroundColor = UIColor.clearColor()
        self.view.addSubview( self.previewOverlayView )
    
        let tapGestureRecognizer = UITapGestureRecognizer( target:self, action: Selector( "dismissPreview" ))
        view.addGestureRecognizer( tapGestureRecognizer )
    }
    
    //------------------------------------------------------------------------------
    func dismissPreview()
    //------------------------------------------------------------------------------
    {
        self.previewMode = false
        self.headerView.hidden = true
        self.inAppPurchaseView.hidden = false
        self.previewOverlayView.removeFromSuperview()
        
        self.tableView.reloadData()
    }
    
    //------------------------------------------------------------------------------
    func restorePurchaseButtonTapped()
    //------------------------------------------------------------------------------
    {
        self.view.addSubview( self.activityIndicatorView )
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    //------------------------------------------------------------------------------
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError)
    //------------------------------------------------------------------------------
    {
        self.activityIndicatorView.removeFromSuperview()
    }
    
    //------------------------------------------------------------------------------
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    //------------------------------------------------------------------------------
    {
        for transaction in transactions {
            
            switch transaction.transactionState {
            
                case SKPaymentTransactionState.Purchased, SKPaymentTransactionState.Restored:
                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
                    NSUserDefaults.standardUserDefaults().setBool( true, forKey: kLoggingUnlockedKey )
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.inAppPurchaseView.removeFromSuperview()
                    self.activityIndicatorView.removeFromSuperview()
                    
                    self.previewMode = false
                    self.headerView.hidden = false
                    self.navigationItem.leftBarButtonItem?.customView?.hidden = false
                    self.navigationItem.rightBarButtonItem?.customView?.hidden = false
                
                case SKPaymentTransactionState.Failed:

//                    if let error = transaction.error {
//                        let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert )
//                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
//                        self.presentViewController(alert, animated: true, completion: nil)
//                    }
                    
                    print( transaction.error?.localizedDescription )
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                    self.activityIndicatorView.removeFromSuperview()
                
                default: break
            }
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
        dateComponents.year = 2015 + indexPath.row / 12
        
        let date = NSCalendar.currentCalendar().dateFromComponents( dateComponents )

        monthView.setDate( date!, previewMode: self.previewMode )
        
        self.navigationItem.title = String( dateComponents.year )
        
        return cell
    }
    
    //------------------------------------------------------------------------------
    func fetchMeditationRecords() -> [NSManagedObject]?
    //------------------------------------------------------------------------------
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest( entityName: kMeditationRecord )
        
        do {
            
            let results = try appDelegate.managedObjectContext.executeFetchRequest( fetchRequest )
            
            return results as? [NSManagedObject]
            
        } catch _ as NSError {
            return nil
        }
    }

    //------------------------------------------------------------------------------
    func saveButtonTapped()
    //------------------------------------------------------------------------------
    {
        let alert = UIAlertController(title: "Save to iCloud", message: "Would you like to save your meditation log to your iCloud account?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            self.saveMeditationLog()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //------------------------------------------------------------------------------
    func saveMeditationLog()
    //------------------------------------------------------------------------------
    {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 )) {
        
            let cdRecords = self.fetchMeditationRecords()
            
            if cdRecords?.count == 0 {
                
                dispatch_async( dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Oops!", message: "You do not have anything to save", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            } else {
            
                let dictList = NSMutableArray()
                
                for cdRecord in cdRecords! {
                    
                    let count = cdRecord.valueForKey( kCount ) as! Int
                    let day = cdRecord.valueForKey( kDay ) as! Int
                    let month = cdRecord.valueForKey( kMonth ) as! Int
                    let year = cdRecord.valueForKey( kYear ) as! Int
                    
                    let dict = NSMutableDictionary()
                    
                    dict[kCount] = NSNumber( integer: count )
                    dict[kDay] = NSNumber( integer: day )
                    dict[kMonth] = NSNumber( integer: month )
                    dict[kYear] = NSNumber( integer: year )
                    
                    dictList.addObject( dict )
                    
                }
                
                NSUbiquitousKeyValueStore.defaultStore().setArray( dictList as [AnyObject], forKey:kMeditationRecord )
                NSUbiquitousKeyValueStore.defaultStore().synchronize()
                
                dispatch_async( dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Success!", message: "Your meditation log has been successfully saved to your iCloud account", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }

    //------------------------------------------------------------------------------
    func restoreButtonTapped()
    //------------------------------------------------------------------------------
    {
        let alert = UIAlertController(title: "Restore from iCloud", message: "Would you like to restore your meditation log from your iCloud account?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
            self.restoreMeditationLog()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //------------------------------------------------------------------------------
    func restoreMeditationLog()
    //------------------------------------------------------------------------------
    {
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 )) {
            
            let data = NSUbiquitousKeyValueStore.defaultStore().arrayForKey( kMeditationRecord )
            
            if let records = data as NSArray? {
            
                var count = 0
                
                if let cdRecords = self.fetchMeditationRecords() {
                    count = cdRecords.count
                }
                
                if count > records.count {
                    
                    dispatch_async( dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        let alert = UIAlertController(title: "Oops!", message: "Your local meditation log is new than the one stored in your iCloud account.  You should probably 'Save' your log before restoring.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                } else if records.count > count {
                    
                    self.clearDataBase()
                    
                    for record in records {
                        
                        let day = record.valueForKey( kDay ) as! Int
                        let month = record.valueForKey( kMonth ) as! Int
                        let year = record.valueForKey( kYear ) as! Int
                        let count = record.valueForKey( kCount ) as! Int
                        
                        self.addMeditationRecordWithDay( day, month: month, year: year, count: count )
                        
                    }
                    
                    do {
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        try appDelegate.managedObjectContext.save()
                        
                        dispatch_async( dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                            let alert = UIAlertController(title: "Success!", message: "Your meditation log has been successfully restored from your iCloud account.", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    } catch _ as NSError  {
                    }
                    
                } else {
                    dispatch_async( dispatch_get_main_queue()) {
                        let alert = UIAlertController(title: "Oops!", message: "Your meditation log is already up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                dispatch_async( dispatch_get_main_queue()) {
                    let alert = UIAlertController(title: "Oops!", message: "You do not have a meditation log saved in your iCloud account.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
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
    func addMeditationRecordWithDay( day: Int, month: Int, year: Int, count: Int )
    //------------------------------------------------------------------------------
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let entity =  NSEntityDescription.entityForName( kMeditationRecord, inManagedObjectContext:appDelegate.managedObjectContext )
        
        let meditationRecord = NSManagedObject( entity: entity!, insertIntoManagedObjectContext: appDelegate.managedObjectContext )
        
        meditationRecord.setValue( day, forKey: kDay )
        meditationRecord.setValue( month, forKey: kMonth )
        meditationRecord.setValue( year, forKey: kYear )
        meditationRecord.setValue( count, forKey: kCount )
        
    }
}
