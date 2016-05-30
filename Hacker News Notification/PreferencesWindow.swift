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
    var delegate: PreferencesWindowDelegate?
    
    override var windowNibName: String! {
        return "PreferencesWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        //let defaults = NSUserDefaults.standardUserDefaults()
        //let updateTimeH = defaults.integerForKey("updateTimeH") ?? DEFAULT_UPDATE_TIME_H
        //let updateTimeM = defaults.integerForKey("updateTimeM") ?? DEFAULT_UPDATE_TIME_M
        
    }
    
    @IBAction func saveClicked(sender: NSButton) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let updateTime = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: updateDatePicker.dateValue)
        
        defaults.setValue(updateTime.hour, forKey: "updateTimeH")
        defaults.setValue(updateTime.minute, forKey: "updateTimeM")
        //delegate?.preferencesDidUpdate()
        self.window?.close()
    }
    
    func windowWillClose(notification: NSNotification) {
        //let defaults = NSUserDefaults.standardUserDefaults()
        //let updateTime = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: updateDatePicker.dateValue)
        
        //defaults.setValue(updateTime.hour, forKey: "updateTimeH")
        //defaults.setValue(updateTime.minute, forKey: "updateTimeM")
        delegate?.preferencesDidUpdate()
    }
}
