//
//  StatusMenuController.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 28/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Cocoa

let DEFAULT_UPDATE_TIME_H = 0
let DEFAULT_UPDATE_TIME_M = 30

class StatusMenuController: NSObject, PreferencesWindowDelegate {
    @IBOutlet weak var statusMenu: NSMenu!
    var showStoryScheduler = NSTimer()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let HNApi = HackerNewsAPI()
    var preferencesWindow: PreferencesWindow!
    var aboutWindow: AboutWindow!
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        preferencesWindow = PreferencesWindow()
        aboutWindow = AboutWindow()
        
        preferencesWindow.delegate = self
        
        HNApi.getStories("beststories")
        scheduleRandomStories()
    }
    
    func scheduleRandomStories() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let updateTimeH = defaults.integerForKey("updateTimeH") ?? DEFAULT_UPDATE_TIME_H
        let updateTimeM = defaults.integerForKey("updateTimeM") ?? DEFAULT_UPDATE_TIME_M
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
