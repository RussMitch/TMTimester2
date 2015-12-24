//
//  SettingsViewController.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit

class SettingsViewController: UIViewController {

    //------------------------------------------------------------------------------
    override func viewDidLoad()
    //------------------------------------------------------------------------------
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1 )
        
        self.navigationItem.title = "Settings"
    }
}
