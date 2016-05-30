//
//  StatusMenuController.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 28/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Cocoa

// default update time to 30minute
let DEFAULT_UPDATE_TIME_H = 0
let DEFAULT_UPDATE_TIME_M = 30

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    // timer for the show story scheduler
    var showStoryScheduler = NSTimer()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    // instance of the hacker news api
    let HNApi = HackerNewsAPI()
    
    // instance of the preferences and about windows
    var preferencesWindow: PreferencesWindow!
    var aboutWindow: AboutWindow!
    
    override func awakeFromNib() {
        // add an icon for the status bar app
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        // initialize
        preferencesWindow = PreferencesWindow()
        aboutWindow = AboutWindow()
        
        // delegate for the preferences window
        preferencesWindow.delegate = self
        
        // by default load best stories
        HNApi.getStories("beststories")
        
        // initialize the scheduler
        scheduleRandomStories()
    }
    
    func scheduleRandomStories() {
        // get hours and minute from the datepicker in the preferences window
        let defaults = NSUserDefaults.standardUserDefaults()
        let updateTimeH = defaults.integerForKey("updateTimeH") ?? DEFAULT_UPDATE_TIME_H
        let updateTimeM = defaults.integerForKey("updateTimeM") ?? DEFAULT_UPDATE_TIME_M
        
        // fire the scheduler to show random stories at the chosen update time
        showStoryScheduler.invalidate()
        showStoryScheduler = NSTimer.scheduledTimerWithTimeInterval(Double(updateTimeH*3600) + Double(updateTimeM*60),
                    target: self,
                    selector: Selector("getRandomStory"),
                    userInfo: nil,
                    repeats: true)

    }

    func getRandomStory() {
        HNApi.showRandomStory()
    }
    
    func preferencesDidUpdate() {
        scheduleRandomStories()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func updateClicked(sender: NSMenuItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let stories = defaults.stringForKey("stories")
        HNApi.getStories(stories!)
    }
    
    @IBAction func preferencesClicked(sender: NSMenuItem) {
        preferencesWindow.showWindow(nil)
    }
    
    @IBAction func aboutClicked(sender: NSMenuItem) {
        aboutWindow.showWindow(nil)
    }
    
    @IBAction func bestStoriesSelected(sender: NSMenuItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("beststories", forKey: "stories")
        HNApi.getStories("beststories")
    }

    @IBAction func topStoriesSelected(sender: NSMenuItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("topstories", forKey: "stories")
        HNApi.getStories("topstories")
    }
    
    @IBAction func newStoriesSelected(sender: NSMenuItem) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("newstories", forKey: "stories")
        HNApi.getStories("newstories")
    }
}
