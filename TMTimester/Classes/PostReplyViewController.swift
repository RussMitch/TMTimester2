//
//  PostReplyViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/24/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import Parse

class PostReplyViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    var pfObject: PFObject!
    var contentView: UIScrollView!
    var replyTextView: UITextView!
    var nameTextField: UITextField!

    //------------------------------------------------------------------------------
    convenience init( pfObject: PFObject )
    //------------------------------------------------------------------------------
    {
        self.init( nibName: nil, bundle: nil )
        
        self.pfObject = pfObject
    }

    //------------------------------------------------------------------------------
    override init( nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle! )
    //------------------------------------------------------------------------------
    {
        super.init( nibName: nibNameOrNil, bundle: nibBundleOrNil )
    }
    
    //------------------------------------------------------------------------------
    required init?( coder aDecoder: NSCoder )
    //------------------------------------------------------------------------------
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // top bar layout
        //------------------------------------------------------------------------------
        
        do
        {
            let topBarView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 64 ))
            topBarView.backgroundColor = UIColor( red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0 )
            self.view.addSubview( topBarView )
            
            let label = UILabel( frame: CGRectMake( 0, 20, self.view.frame.width, 44 ))
            label.text = "Post Reply"
            label.textColor = UIColor.blackColor()
            label.font = UIFont.boldSystemFontOfSize( 17 )
            label.textAlignment = NSTextAlignment.Center
            topBarView.addSubview( label )
            
            let button =  UIButton(type: .Custom)
            button.frame = CGRectMake( self.view.frame.width - 70, 20, 70, 44 )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.setTitle("Done", forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("doneButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
            topBarView.addSubview( button )
            
            let view = UIView( frame: CGRectMake( 0, 64-1, self.view.frame.width, 1 ))
            view.backgroundColor = UIColor.lightGrayColor()
            topBarView.addSubview( view )
        }
        
        self.contentView = UIScrollView( frame: CGRectMake( 0, 64, self.view.frame.width, self.view.frame.height-64 ))
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview( self.contentView )
        
        var y: CGFloat = 0
        
        do
        {
            var title : String = ""
            if let pTitle = self.pfObject["title"] as? String {
                title = pTitle
            }
            
            var comment : String = ""
            if let pComment = self.pfObject["comment"] as? String {
                comment = pComment
            }
            
            var name : String = ""
            if let pName = self.pfObject["name"] as? String {
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
            
            let messageView: MessageView = MessageView( frame: CGRectZero )
            messageView.updateFrame( CGRectMake( 0, y, self.view.frame.size.width, 0 ), attributedText: attributedText, inset: 10 )
            self.contentView.addSubview( messageView )
            
            y = messageView.frame.height
            
            if let pReplies = pfObject["replies"] as? NSArray {
                
                for var i = 0;i < pReplies.count; i++ {
                    
                    let reply = pReplies[i] as! String
                    let tokens = reply.characters.split{$0 == "|"}.map(String.init)
                    let attributedText = NSMutableAttributedString( string: tokens[0] + " - " + tokens[1] + " " + tokens[2] )
                    
                    attributedText.addAttribute( NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange( 0, attributedText.length ))
                    attributedText.addAttribute( NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange( 0, attributedText.length ))

                    let messageView: MessageView = MessageView( frame: CGRectZero )
                    messageView.updateFrame( CGRectMake( 0, y, self.view.frame.size.width, 0 ), attributedText: attributedText, inset: 10 )
                    self.contentView.addSubview( messageView )
                    
                    y += messageView.frame.height
                    
                }
            }
        }
        
        do
        {
            let label = UILabel()
            label.text = "Reply"
            label.frame = CGRectMake( 10, y, self.view.frame.width-20, 44 )
            self.contentView.addSubview( label )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-20, 150 ))
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.layer.borderWidth = 1
            self.contentView.addSubview( view )
            
            self.replyTextView = UITextView( frame: CGRectMake( 5, 0, view.frame.width-10, 150 ))
            self.replyTextView.delegate = self
            view.addSubview( self.replyTextView )
        }
        
        y += 150
        
        // name layout
        //------------------------------------------------------------------------------
        
        do
        {
            let label = UILabel()
            label.text = "Name"
            label.frame = CGRectMake( 10, y, self.view.frame.width-20, 44 )
            self.contentView.addSubview( label )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-20, 44 ))
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.layer.borderWidth = 1
            self.contentView.addSubview( view )
            
            self.nameTextField = UITextField( frame: CGRectMake( 10, 0, view.frame.width-10, 44 ))
            self.nameTextField.delegate = self
            self.nameTextField.returnKeyType = UIReturnKeyType.Done
            view.addSubview( self.nameTextField )
        }
        
        y += 44
        
        do
        {
            let button = UIButton( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
            button.setTitle( "Post Reply", forState: .Normal )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.addTarget( self, action: Selector( "postCommentButtonTapped" ), forControlEvents: .TouchUpInside )
            self.contentView.addSubview( button )
        }
        
        y += 44

        self.contentView.contentSize = CGSizeMake( self.view.frame.width, y )
    }
    
    //------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool)
    //------------------------------------------------------------------------------
    {
        super.viewDidAppear( animated )

        NSNotificationCenter.defaultCenter().addObserver( self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver( self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //------------------------------------------------------------------------------
    override func viewDidDisappear(animated: Bool)
    //------------------------------------------------------------------------------
    {
        NSNotificationCenter().removeObserver( self )
    }
    
    //------------------------------------------------------------------------------
    func keyboardWillShow( notification: NSNotification )
    //------------------------------------------------------------------------------
    {
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        var view: UIView!
        
        if (self.replyTextView.isFirstResponder()) {
            
            view = self.replyTextView
            
        } else if self.nameTextField.isFirstResponder() {
            
            view = self.nameTextField
            
        }
        
        if view != nil {
            
            let superView = view.superview!
            
            let y1: CGFloat = superView.frame.origin.y + view.frame.height
            let y2: CGFloat = self.view.frame.height - frame.height
            
            if y1 > y2 {
                
                let offset = y1 - y2 + 10 + 64
                
                self.contentView.contentOffset = CGPointMake( 0, offset )
                
            }
        }
    }
    
    //------------------------------------------------------------------------------
    func keyboardWillHide( notification: NSNotification )
    //------------------------------------------------------------------------------
    {
        self.contentView.contentOffset = CGPointMake( 0, 0 )
    }
    
    //------------------------------------------------------------------------------
    func textFieldShouldReturn(textField: UITextField) -> Bool
    //------------------------------------------------------------------------------
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    //------------------------------------------------------------------------------
    func postCommentButtonTapped()
    //------------------------------------------------------------------------------
    {
        var message: String?
        
        let reply = self.replyTextView.text!
        let name = self.nameTextField.text!
        
        if reply.characters.count == 0 {
            message = "You must enter a reply."
        } else if name.characters.count == 0 {
            message = "You must enter a name"
        }
        
        if message != nil {
            
            let alert = UIAlertController(title: "Oops!", message: message!, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            let overlayView = UIView( frame: self.view.bounds )
            overlayView.backgroundColor = UIColor.clearColor()
            self.view.addSubview( overlayView )

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM d, ''yy"
            
            let reply = reply + "|" + name + "|" + dateFormatter.stringFromDate( NSDate())
            
            if let replies = self.pfObject[kReplies] as? NSMutableArray {
                
                replies.addObject( reply )
                self.pfObject[kReplies] = replies
                
            } else {
                
                let replies: NSMutableArray = []
                replies.addObject( reply )
                self.pfObject[kReplies] = replies
                
            }
            
            self.pfObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                
                overlayView.removeFromSuperview()
                
                self.dismissViewControllerAnimated( true, completion: nil )
                
            }            
        }
    }
    
    //------------------------------------------------------------------------------
    func doneButtonTapped()
    //------------------------------------------------------------------------------
    {
        if self.nameTextField.isFirstResponder() {
            
            self.nameTextField.resignFirstResponder()
            
        } else if self.replyTextView.isFirstResponder() {
            
            self.replyTextView.resignFirstResponder()
            
        } else {
            
            self.dismissViewControllerAnimated( true, completion: nil )
            
        }
    }
}
