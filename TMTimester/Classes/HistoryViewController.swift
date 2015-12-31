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
    var cellHeight: CGFloat!
    var tableView: UITableView!
    var activityIndicatorView: UIActivityIndicatorView!
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        let loggingUnlocked = NSUserDefaults.standardUserDefaults().objectForKey( kLoggingUnlockedKey ) as! Bool
        
        SKPaymentQueue.defaultQueue().addTransactionObserver( self )
        
        self.navigationController?.navigationBar.barTintColor = kBarColor
        
        self.view.backgroundColor = UIColor.whiteColor()

        if !loggingUnlocked {
            let button = UIButton( frame: CGRectMake( 0, 0, 80, 44 ))
            button.setTitle( "Purchase", forState: .Normal )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.addTarget( self, action: Selector( "purchaseButtonTapped" ), forControlEvents: .TouchUpInside )
            self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: button )

            do
            {
                let label = UILabel( frame: CGRectMake( 0, 0, 80, 44 ))
                label.numberOfLines = 2
                label.text = "Restore\nPurchase"
                label.font = UIFont.systemFontOfSize( 18 )
                label.textColor = UIColor.redColor()
                label.textAlignment = NSTextAlignment.Center
                
                let button = UIButton( frame: CGRectMake( 0, 0, 80, 44 ))
                button.addSubview( label )
                button.addTarget( self, action: Selector( "restorePurchaseButtonTapped" ), forControlEvents: .TouchUpInside )
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem( customView: button )
            }
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
        
        self.tableView.reloadData()

        if tableView.contentOffset.y < 0 {
            tableView.contentOffset = CGPointMake( 0, tableView.contentSize.height-tableView.frame.height+64 )
        }
    }
    
    //------------------------------------------------------------------------------
    func purchaseButtonTapped()
    //------------------------------------------------------------------------------
    {
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let actionSheetController = UIAlertController(title: "Meditation Logging", message: "Would you like to purchase the Meditation Logging capability?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let buyAction = UIAlertAction(title: "Buy Now", style: UIAlertActionStyle.Default) { (action) -> Void in
         
            let payment = SKPayment( product: appDelegate.productsArray[0] as SKProduct )
            SKPaymentQueue.defaultQueue().addPayment(payment)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in

            self.navigationItem.leftBarButtonItem?.enabled = true
            self.navigationItem.rightBarButtonItem?.enabled = true
            
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
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    //------------------------------------------------------------------------------
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    //------------------------------------------------------------------------------
    {
        for transaction in transactions {
            
            switch transaction.transactionState {
            
                case SKPaymentTransactionState.Purchased, SKPaymentTransactionState.Restored:
                    print( "Transaction Purchased" )

                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
                    NSUserDefaults.standardUserDefaults().setBool( true, forKey: kLoggingUnlockedKey )
                    NSUserDefaults.standardUserDefaults().synchronize()
                
                    self.navigationItem.leftBarButtonItem = nil
                    self.navigationItem.rightBarButtonItem = nil
                
                    self.activityIndicatorView.removeFromSuperview()
                
                case SKPaymentTransactionState.Failed:
                    print("Transaction Failed");
                
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
                    self.navigationItem.leftBarButtonItem?.enabled = true
                    self.navigationItem.rightBarButtonItem?.enabled = true

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
    
    //------------------------------------------------------------------------------
    func requestProductInfo()
    //------------------------------------------------------------------------------
    {
    }    
}
