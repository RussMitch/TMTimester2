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
    let postMessageViewController = PostMessageViewController()
    
    var heightForRow : [CGFloat] = []
    var repliesForRow : [NSArray] = []
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
                    attributedText.addAttribute( NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange( titleLength+commentLength+2, nameLength ))
                    
                    self.textForRow.append( attributedText )
                    
                    let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 1000 ))
                    label.attributedText = attributedText
                    label.numberOfLines = 100
                    let rect = label.textRectForBounds( label.bounds, limitedToNumberOfLines: 100 )
                    
                    var height : CGFloat = rect.height
                    
                    var replies : [NSMutableAttributedString] = []

                    if let pReplies = object["replies"] as? NSArray {
                        
                        for var i = 0;i < pReplies.count; i++ {
                            
                            let reply = pReplies[i] as! String
                            let tokens = reply.characters.split{$0 == "|"}.map(String.init)
                            let attributedText = NSMutableAttributedString( string: tokens[0] + " - " + tokens[1] + " " + tokens[2] )
                            
                            attributedText.addAttribute( NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange( 0, attributedText.length ))
                            attributedText.addAttribute( NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange( 0, attributedText.length ))
                            
                            replies.append( attributedText )
                            
                            let label = UILabel( frame: CGRectMake( 10, 0, self.view.frame.width-20, 1000 ))
                            label.attributedText = attributedText
                            label.numberOfLines = 100
                            let rect = label.textRectForBounds( label.bounds, limitedToNumberOfLines: 100 )
                            
                            height += rect.height
                            
                        }
                    }
                    
                    self.repliesForRow.append( replies )

                    height += 44
                    
                    self.heightForRow.append( height )
                }
                
                self.tableView.reloadData()
                
            }
        }
    }
    
    //------------------------------------------------------------------------------
    func postNewMessageButtonTapped()
    //------------------------------------------------------------------------------
    {
        self.presentViewController( self.postMessageViewController, animated: true, completion: nil )
        
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
        
        var messageView: MessageView! = cell.contentView.viewWithTag( 1 ) as? MessageView
        var replyViewHolder: UIView! = cell.contentView.viewWithTag( 2 ) as UIView!
        var button: UIButton! = cell.contentView.viewWithTag( 3 ) as? UIButton
        var line: UIView! = cell.contentView.viewWithTag( 4 ) as UIView!
        
        if messageView == nil {
            
            messageView = MessageView( frame: CGRectZero )
            messageView.tag = 1
            cell.contentView.addSubview( messageView )
            
            replyViewHolder = UILabel()
            replyViewHolder.tag = 2
            cell.contentView.addSubview( replyViewHolder )
            
            button = UIButton()
            button.tag = 3
            button.setTitleColor( UIColor.blueColor(), forState: .Normal )
            button.setTitle( "Add Comment", forState: .Normal )
            button.addTarget( self, action: "addCommentButtonPressed", forControlEvents: .TouchUpInside )
            cell.contentView.addSubview( button )
            
            line = UIView( frame: CGRectZero )
            line.tag = 4
            line.backgroundColor = UIColor.lightGrayColor()
            cell.contentView.addSubview( line )
        }

        messageView.updateFrame( CGRectMake( 0, 0, tableView.frame.width, 0 ), attributedText: textForRow[indexPath.row], inset: 10 )
        
        replyViewHolder.hidden = true;

        let numReplies = repliesForRow[indexPath.row].count
        
        if numReplies > 0 {
            
            for view in replyViewHolder.subviews {
                view.hidden = true;
            }
            
            let numViewsNeeded = numReplies - replyViewHolder.subviews.count

            for var i=0;i<numViewsNeeded;i++ {
                let replyView = MessageView( frame: CGRectZero )
                replyViewHolder.addSubview( replyView )
            }

            var y: CGFloat = 0
            
            for var i=0;i<numReplies;i++ {
                
                let replyView = replyViewHolder.subviews[i] as! MessageView
                
                replyView.hidden = false
                replyView.updateFrame( CGRectMake( 0, y, tableView.frame.width, 0 ), attributedText: repliesForRow[indexPath.row][i] as! NSAttributedString, inset: 10 )
                
                y += replyView.frame.height
                
            }
            
            replyViewHolder.hidden = false;
            replyViewHolder.frame = CGRectMake( 0, messageView.frame.height, messageView.frame.width, y )
        }
        
        button.frame = CGRectMake( 0, heightForRow[indexPath.row]-44, tableView.frame.width, 44 )
        line.frame = CGRectMake( 10, heightForRow[indexPath.row]-1, tableView.frame.width-10, 1 )
        
        return cell
    }

    
    //------------------------------------------------------------------------------
    func addCommentButtonPressed()
    //------------------------------------------------------------------------------
    {
       print( "addCommentButtonPressed" )
    }
    
}
