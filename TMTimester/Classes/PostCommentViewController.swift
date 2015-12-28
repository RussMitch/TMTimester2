//
//  PostMessageViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/23/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import Parse

class PostCommentViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    var contentView: UIView!
    var nameTextField: UITextField!
    var titleTextField: UITextField!
    var commentTextView: UITextView!
    
    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.contentView = UIView( frame: CGRectMake( 0, 64, self.view.frame.width, self.view.frame.height-64 ))
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview( self.contentView )
        
        var y: CGFloat = 0
        
        // title layout
        //------------------------------------------------------------------------------
        
        do
        {
            let label = UILabel()
            label.text = "Title"
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
            
            self.titleTextField = UITextField( frame: CGRectMake( 10, 0, view.frame.width-10, 44 ))
            self.titleTextField.delegate = self
            self.titleTextField.returnKeyType = UIReturnKeyType.Done
            view.addSubview( self.titleTextField )
        }
        
        y += 44
        
        // comment layout
        //------------------------------------------------------------------------------
        
        do
        {
            let label = UILabel()
            label.text = "Comment"
            label.frame = CGRectMake( 10, y, self.view.frame.width-20, 44 )
            self.contentView.addSubview( label )
        }
        
        y += 44
        
        do
        {
            let view = UIView( frame: CGRectMake( 10, y, self.view.frame.width-20, 200 ))
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.layer.borderWidth = 1
            self.contentView.addSubview( view )
            
            self.commentTextView = UITextView( frame: CGRectMake( 5, 0, view.frame.width-10, 200 ))
            self.commentTextView.delegate = self
            view.addSubview( self.commentTextView )
        }
        
        y += 200
        
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
            button.setTitle( "Post Comment", forState: .Normal )
            button.setTitleColor( UIColor.redColor(), forState: .Normal )
            button.addTarget( self, action: Selector( "postCommentButtonTapped" ), forControlEvents: .TouchUpInside )
            self.contentView.addSubview( button )
        }
        
        // top bar layout
        //------------------------------------------------------------------------------
        
        do
        {
            let topBarView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 64 ))
            topBarView.backgroundColor = kBarColor
            self.view.addSubview( topBarView )
            
            let label = UILabel( frame: CGRectMake( 0, 20, self.view.frame.width, 44 ))
            label.text = "Post New Comment"
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
        
        if (self.commentTextView.isFirstResponder()) {
            
            view = self.commentTextView
            
        } else if self.nameTextField.isFirstResponder() {
            
            view = self.nameTextField
            
        }
        
        if view != nil {
            
            let superView = view.superview!
            
            let y1: CGFloat = superView.frame.origin.y + view.frame.height
            let y2: CGFloat = self.view.frame.height - frame.height
            
            if y1 > y2 {
                
                let offset = y1 - y2 + 10
                
                self.contentView.frame = CGRectMake( 0, -offset, self.view.frame.width, self.view.frame.height )
                
            }
        }
    }

    //------------------------------------------------------------------------------
    func keyboardWillHide( notification: NSNotification )
    //------------------------------------------------------------------------------
    {
        self.contentView.frame = CGRectMake( 0, 64, self.view.frame.width, self.view.frame.height )
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
        
        let title = self.titleTextField.text!
        let comment = self.commentTextView.text!
        let name = self.nameTextField.text!

        if title.characters.count == 0 {
            message = "You must enter a title."
        } else if comment.characters.count == 0 {
            message = "You must enter a comment."
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
            dateFormatter.dateFormat = "EEEE MMMM d, yyyy"
            
            let name = "By " + name + " on " + dateFormatter.stringFromDate( NSDate())
            
            let pfObject: PFObject = PFObject( className: "Comment" )
            
            pfObject[kName] = name
            pfObject[kTitle] = title
            pfObject[kComment] = comment

            pfObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                
                overlayView.removeFromSuperview()
                
                self.dismissViewControllerAnimated( true, completion: nil )
                
            }
        }
    }
    
    //------------------------------------------------------------------------------
    func doneButtonTapped()
    //------------------------------------------------------------------------------
    {
        if self.titleTextField.isFirstResponder() {
            
            self.titleTextField.resignFirstResponder()
            
        } else if self.nameTextField.isFirstResponder() {

            self.nameTextField.resignFirstResponder()
            
        } else if self.commentTextView.isFirstResponder() {
            
            self.commentTextView.resignFirstResponder()
            
        } else {

            self.dismissViewControllerAnimated( true, completion: nil )
            
        }
    }
}
