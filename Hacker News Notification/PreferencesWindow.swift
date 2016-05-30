//
//  PreferencesWindow.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 29/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController, NSWindowDelegate {
    @IBOutlet weak var updateDatePicker: NSDatePicker!
    // preferences window delegate
    var delegate: PreferencesWindowDelegate?
    
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
        // get minute and hour from the datepicker
        let defaults = NSUserDefaults.standardUserDefaults()
        let updateTime = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: updateDatePicker.dateValue)
        
        // save minute and hour and close the window
        defaults.setValue(updateTime.hour, forKey: "updateTimeH")
        defaults.setValue(updateTime.minute, forKey: "updateTimeM")
        self.window?.close()
    }
    
    func windowWillClose(notification: NSNotification) {
        delegate?.preferencesDidUpdate()
    }
}
