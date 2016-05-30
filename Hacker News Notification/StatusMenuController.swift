//
//  StatusMenuController.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 28/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    var timer = NSTimer()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let HNApi = HackerNewsAPI()
    var preferencesWindow: PreferencesWindow!
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        preferencesWindow = PreferencesWindow()
        
        HNApi.getTopStories()
        
        scheduleRandomStories()
       
    }
    
    func scheduleRandomStories() {
        let calendar = NSCalendar.currentCalendar()
        let updateTime = calendar.components([.Hour, .Minute], fromDate: preferencesWindow.updateDatePicker.dateValue)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(updateTime.hour*3600 + updateTime.minute*60),
                                                       target: self,
                                                       selector: Selector("getRandomStory"),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func getRandomStory() {
        HNApi.showRandomStory()
    }
    
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func updateClicked(sender: NSMenuItem) {
        HNApi.getTopStories()
    }
    
    @IBAction func preferencesClicked(sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }

}
