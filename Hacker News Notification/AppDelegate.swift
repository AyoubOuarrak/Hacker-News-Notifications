//
//  AppDelegate.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 28/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSUserNotificationCenterDelegate, NSApplicationDelegate {
   
    func applicationDidFinishLaunching(aNotification: NSNotification) {
         NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        // return true to always display the User Notification
        return true
    }
    
    // notification delegate
    func userNotificationCenter(center: NSUserNotificationCenter, didActivateNotification notification: NSUserNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // check if the story url is nil
        if defaults.stringForKey("storyUrl") != nil {
            let story = defaults.stringForKey("storyUrl")
            // open the story url using the defautl browser
            NSWorkspace.sharedWorkspace().openURL(NSURL(string: story!)!)
        }
    }
}

