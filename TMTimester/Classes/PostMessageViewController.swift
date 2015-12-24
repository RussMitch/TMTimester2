//
//  PostMessageViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/23/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit

class PostMessageViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

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
        
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.frame = CGRectMake( 10, y, self.view.frame.width-20, 44 )
        self.contentView.addSubview( titleLabel )
        
        y += 44
        
        let titleFrame = UIView( frame: CGRectMake( 10, y, self.view.frame.width-20, 44 ))
        titleFrame.layer.borderColor = UIColor.blackColor().CGColor
        titleFrame.layer.borderWidth = 1
        self.contentView.addSubview( titleFrame )
        
        self.titleTextField = UITextField( frame: CGRectMake( 10, 0, titleFrame.frame.width-20, 44 ))
        self.titleTextField.delegate = self
        self.titleTextField.returnKeyType = UIReturnKeyType.Done
        titleFrame.addSubview( self.titleTextField )

        y += 44
        
        // comment layout
        
        let commentLabel = UILabel()
        commentLabel.text = "Comment"
        commentLabel.frame = CGRectMake( 10, y, self.view.frame.width-20, 44 )
        self.contentView.addSubview( commentLabel )
        
        y += 44
        
        let commentFrame = UIView( frame: CGRectMake( 10, y, self.view.frame.width-20, 200 ))
        commentFrame.layer.borderColor = UIColor.blackColor().CGColor
        commentFrame.layer.borderWidth = 1
        self.contentView.addSubview( commentFrame )
        
        self.commentTextView = UITextView( frame: CGRectMake( 5, 0, commentFrame.frame.width-10, 200 ))
        self.commentTextView.delegate = self
        commentFrame.addSubview( self.commentTextView )
        
        y += 200
        
        // name layout
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.frame = CGRectMake( 10, y, self.view.frame.width-20, 44 )
        self.contentView.addSubview( nameLabel )
        
        y += 44
        
        let nameFrame = UIView( frame: CGRectMake( 10, y, self.view.frame.width-20, 44 ))
        nameFrame.layer.borderColor = UIColor.blackColor().CGColor
        nameFrame.layer.borderWidth = 1
        self.contentView.addSubview( nameFrame )
        
        self.nameTextField = UITextField( frame: CGRectMake( 10, 0, titleFrame.frame.width-20, 44 ))
        self.nameTextField.delegate = self
        self.nameTextField.returnKeyType = UIReturnKeyType.Done
        nameFrame.addSubview( self.nameTextField )
        
        y += 44
        
        let postButton = UIButton( frame: CGRectMake( 0, y, self.view.frame.width, 44 ))
        postButton.setTitle( "Post Comment", forState: .Normal )
        postButton.setTitleColor( UIColor.redColor(), forState: .Normal )
        postButton.addTarget( self, action: Selector( "postCommentButtonTapped" ), forControlEvents: .TouchUpInside )
        self.contentView.addSubview( postButton )
        
        // top bar layout
        
        let topBarView = UIView( frame: CGRectMake( 0, 0, self.view.frame.width, 64 ))
        topBarView.backgroundColor = UIColor( red:0.98, green: 0.98, blue: 0.98, alpha: 1.0 )
        self.view.addSubview( topBarView )
        
        let title = UILabel( frame: CGRectMake( 0, 20, self.view.frame.width, 44 ))
        title.text = "Post New Comment"
        title.textColor = UIColor.blackColor()
        title.font = UIFont.boldSystemFontOfSize( 17 )
        title.textAlignment = NSTextAlignment.Center
        topBarView.addSubview( title )
        
        let button =  UIButton(type: .Custom)
        button.frame = CGRectMake( self.view.frame.width - 70, 20, 70, 44 )
        button.setTitleColor( UIColor.redColor(), forState: .Normal )
        button.setTitle("Done", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("doneButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
        topBarView.addSubview( button )
        
        let topBarSeparatorView = UIView( frame: CGRectMake( 0, 64-1, self.view.frame.width, 1 ))
        topBarSeparatorView.backgroundColor = UIColor.lightGrayColor()
        topBarView.addSubview( topBarSeparatorView )
    }
    
    //------------------------------------------------------------------------------
    override func viewDidAppear(animated: Bool)
    //------------------------------------------------------------------------------
    {
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
            
            doneButtonTapped()
            
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
