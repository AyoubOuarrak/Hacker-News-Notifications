//
//  PreferencesWindow.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 29/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Cocoa

class PreferencesWindow: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var updateDatePicker: NSDatePicker!
    
    override var windowNibName: String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
    }
    
    @IBAction func saveClicked(sender: NSButton) {
        self.window?.close()
    }
    
    func windowWillClose(notification: NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(updateDatePicker.dateValue, forKey: "updateTime")
    }
}
