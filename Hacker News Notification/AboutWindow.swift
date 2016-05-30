//
//  AboutWindow.swift
//  Hacker News Notification
//
//  Created by Ayoub Ouarrak on 30/05/2016.
//  Copyright © 2016 Ayoub Ouarrak. All rights reserved.
//

import Cocoa

class AboutWindow: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()

        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
    }
    
    override var windowNibName : String! {
        return "AboutWindow"
    }
}
