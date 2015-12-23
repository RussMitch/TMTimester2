//
//  ReplyView.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/23/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit

class MessageView: UIView {

    let line = UIView()
    let label = UILabel()
    
    //------------------------------------------------------------------------------
    override init( frame: CGRect )
    //------------------------------------------------------------------------------
    {
        super.init( frame: frame )
        
        self.addSubview( self.label )
        
        self.addSubview( self.line )
    }

    //------------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder)
        //------------------------------------------------------------------------------
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //------------------------------------------------------------------------------
    func updateFrame( frame: CGRect, attributedText: NSAttributedString, inset: CGFloat )
    //------------------------------------------------------------------------------
    {
        self.label.frame = CGRectMake( inset, 0, frame.width-2*inset, CGFloat.max )
        self.label.numberOfLines = 100
        self.label.attributedText = attributedText
        
        let rect = label.textRectForBounds( label.bounds, limitedToNumberOfLines: 100 )
        
        self.label.frame = CGRectMake( inset, 0, frame.width-2*inset, rect.height )
        
        self.line.backgroundColor = UIColor.lightGrayColor()
        self.line.frame = CGRectMake( inset, rect.height-1, frame.width-inset, 1 );
        
        self.frame = CGRectMake( 0, frame.origin.y, frame.width, rect.height )
    }
}