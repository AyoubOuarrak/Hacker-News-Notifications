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

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    let HNApi = HackerNewsAPI()
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        HNApi.getTopStories()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    @IBAction func updateClicked(sender: NSMenuItem) {
        HNApi.showRandomStory()
    }

}
