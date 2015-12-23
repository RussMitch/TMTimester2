//
//  ForumViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import Parse

class ForumViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let kCreatedAt = "createdAt"
    let kCommentClass = "Comment"
    let tableView: UITableView = UITableView()
    
    var heightForRow : [CGFloat] = []
    var textForRow : [NSMutableAttributedString] = []
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        let button =  UIButton(type: .Custom)
        button.frame = CGRectMake( 0, 0, 200, 44 )
        button.setTitleColor( UIColor.blueColor(), forState: .Normal )
        button.setTitle("Post New Message", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("postNewMessageButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = button
        
        self.tableView.frame = CGRectMake( 0, 0, self.view.frame.width, self.view.frame.height );
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass( UITableViewCell.self, forCellReuseIdentifier: "cell" )
        self.view.addSubview( self.tableView )
        
        let query = PFQuery( className:kCommentClass )
        
        query.orderByDescending( kCreatedAt )
        query.limit = 100
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil && objects != nil {
                
                for object in objects! {
                    
                    var title : String = ""
                    var comment : String = ""
                    var name : String = ""
                    
                    if let pTitle = object["title"] as? String {
                        title = pTitle
                    }
                    
                    if let pComment = object["comment"] as? String {
                        comment = pComment
                    }
                    
                    if let pName = object["name"] as? String {
                        name = pName
                    }
                    
                    let titleLength = title.characters.count
                    let commentLength = comment.characters.count
                    let nameLength = name.characters.count
                
                    let attributedText = NSMutableAttributedString( string: title + "\n" + comment + "\n" + name )
                    
                    attributedText.addAttribute( NSFontAttributeName, value: UIFont.boldSystemFontOfSize(18), range: NSMakeRange( 0, titleLength ))
                    attributedText.addAttribute( NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange( titleLength+1, commentLength ))
                    attributedText.addAttribute( NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange( titleLength+commentLength+2, nameLength ))
                    attributedText.addAttribute( NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange( titleLength+commentLength+2, nameLength ))
                    
                    self.textForRow.append( attributedText )
                    
                    let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 1000 ))
                    label.attributedText = attributedText
                    label.numberOfLines = 100
                    let rect = label.textRectForBounds( label.bounds, limitedToNumberOfLines: 100 )
                    
                    self.heightForRow.append( rect.height+4+44 )
                    
                }
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    //------------------------------------------------------------------------------
    func postNewMessageButtonTapped()
    //------------------------------------------------------------------------------
    {
        print( "postNewMessageButtonTapped" )
    }
    
    //------------------------------------------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //------------------------------------------------------------------------------
    {
        return self.textForRow.count
    }
    
    //------------------------------------------------------------------------------
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    //------------------------------------------------------------------------------
    {
        if self.heightForRow.count > 0 {
            return self.heightForRow[indexPath.row]
        } else {
            return 0
        }
    }
    
    //------------------------------------------------------------------------------
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    //------------------------------------------------------------------------------
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var label : UILabel! = cell.contentView.viewWithTag(1) as? UILabel
        var line1 : UILabel! = cell.contentView.viewWithTag(2) as? UILabel
        var line2 : UILabel! = cell.contentView.viewWithTag(3) as? UILabel
        var button : UIButton! = cell.contentView.viewWithTag(4) as? UIButton
        
        if label == nil {
            
            label = UILabel()
            label.tag = 1
            label.numberOfLines = 100
            cell.contentView.addSubview( label )
            
            line1 = UILabel()
            line1.tag = 2
            line1.backgroundColor = UIColor.darkGrayColor()
            cell.contentView.addSubview(line1)

            line2 = UILabel()
            line2.tag = 3
            line2.backgroundColor = UIColor.darkGrayColor()
            cell.contentView.addSubview(line2)
            
            button = UIButton()
            button.tag = 4
            button.setTitleColor( UIColor.blueColor(), forState: .Normal )
            button.setTitle( "Add Comment", forState: .Normal )
            button.addTarget( self, action: "addCommentButtonPressed", forControlEvents: .TouchUpInside )
            cell.contentView.addSubview( button )
            
        }
        
        label.attributedText = textForRow[indexPath.row]
        
        var y : CGFloat = 0
        
        label.frame = CGRectMake( 10, y, tableView.frame.width-20, heightForRow[indexPath.row]-44 )
        y += label.frame.height-1
        
        line1.frame = CGRectMake( 10, y, tableView.frame.width-10, 1 )
        y += 1
        
        button.frame = CGRectMake( 0, y, tableView.frame.width, 44 )
        
        y += 44
        
        line2.frame = CGRectMake( 10, y-2, tableView.frame.width-10, 1 )
        
        return cell
        
    }
    
    //------------------------------------------------------------------------------
    func addCommentButtonPressed()
    //------------------------------------------------------------------------------
    {
       print( "addCommentButtonPressed" )
    }
    
}
