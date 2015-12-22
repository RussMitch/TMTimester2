//
//  AppDelegate.swift
//  TMTimester
//
//  Created by Russell Mitchell on 12/22/15.
//  Copyright © 2015 russell@russell-research.com. All rights reserved.
//
//------------------------------------------------------------------------------

import UIKit
import Parse
import Bolts

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //------------------------------------------------------------------------------
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    //------------------------------------------------------------------------------
    {
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("1Cpum25gZqxdQ8hYAC38vL61QrQPI8H0srazNVzo", clientKey: "Y0TvIY0s5F0wzD1WvbdURrmPo7psOjLV367Ekdmu")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        return true
    }
}

