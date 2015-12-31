//
//  HistoryViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import StoreKit

class HistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SKPaymentTransactionObserver {
    
    var numMonths: Int!
    var priceLabel: UILabel!
    var cellHeight: CGFloat!
    var tableView: UITableView!
    var inAppPurchaseView: UIView!
    var activityIndicatorView: UIActivityIndicatorView!
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver( self )
        
        self.navigationController?.navigationBar.barTintColor = kBarColor
        
        self.view.backgroundColor = UIColor.whiteColor()
        
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
            
            self.inAppPurchaseView = UIView( frame: self.view.bounds )
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
                let label = UILabel( frame: CGRectMake( 20, y, self.view.frame.width-40, 90 ))
                label.text = "The meditation log will allow you to automatically track your daily meditation activity."
                label.numberOfLines = 3
                self.inAppPurchaseView.addSubview( label )
            }
            
            y += 90
            
            do
            {
                self.priceLabel = UILabel( frame: CGRectMake( 20, y, self.view.frame.width-40, 30 ))
                self.priceLabel.textColor = UIColor.blackColor()
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
                button.setTitle( "Restore Purchase", forState: .Normal )
                button.setTitleColor( UIColor.redColor(), forState: .Normal )
                button.addTarget( self, action: Selector( "restorePurchaseButtonTapped" ), forControlEvents: .TouchUpInside )
                self.inAppPurchaseView.addSubview( button )
            }
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
        
        let actionSheetController = UIAlertController(title: "Meditation Logging", message: "Would you like to purchase the Meditation Logging capability?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let buyAction = UIAlertAction(title: "Buy Now", style: UIAlertActionStyle.Default) { (action) -> Void in
         
            self.view.addSubview( self.activityIndicatorView )

            let payment = SKPayment( product: appDelegate.productsArray[0] as SKProduct )
            SKPaymentQueue.defaultQueue().addPayment(payment)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    //------------------------------------------------------------------------------
    func restorePurchaseButtonTapped()
    //------------------------------------------------------------------------------
    {
        self.view.addSubview( self.activityIndicatorView )
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
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
                
                
                case SKPaymentTransactionState.Failed:
                    
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

        monthView.setDate( date! )
        
        self.navigationItem.title = String( dateComponents.year )
        
        return cell
    }
}
