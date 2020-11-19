//
//  AppDelegate.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 27.12.2019.
//  Copyright © 2019 Vasily Petuhov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        // get MainViewController
//        let mainVC = NSApplication.shared.mainWindow?.windowController?.contentViewController as! MainViewController

        // set NSSwitches (timer and "soccer")
//        mainVC.isCountdown.state = UserDefaults.standard.value(forKey: "isCountdown") as? NSControl.StateValue ?? .on
//        mainVC.continueTimeSwitcher.state = UserDefaults.standard.value(forKey: "continueTimeSwitcher") as? NSControl.StateValue ?? .off
//
//        mainVC.titleTimerMode.stringValue = mainVC.isCountdown.state == .on ? "Countdown: ON" : "Countdown: OFF"
//        mainVC.continueTimeSwitcher.isEnabled = mainVC.isCountdown.state == .on ? false : true
        
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    

    // close the application completely after clicking the cross
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}

