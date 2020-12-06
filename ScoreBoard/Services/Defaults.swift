//
//  Defaults.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 13.11.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

extension MainViewController {    
    func loadDefaults() {
        // restore NSSwitches state (timer and "soccer")
        isCountdown.state = UserDefaults.standard.value(forKey: "isCountdown") as? NSControl.StateValue ?? .on
        continueTimeSwitcher.state = UserDefaults.standard.value(forKey: "continueTimeSwitcher") as? NSControl.StateValue ?? .off
        titleTimerMode.stringValue = isCountdown.state == .on ? "Countdown: ON" : "Countdown: OFF"
        continueTimeSwitcher.isEnabled = isCountdown.state == .on ? false : true
                
        // restore slider and time
        sliderTimer.integerValue = scoreboardData.timeUserPreset
        textFieldForTimerSetting.stringValue = isCountdown.state == .on ?
            "Timer setting (from \(sliderTimer.integerValue / 60):00 to 00:00)" :
            "Timer setting (from 00:00 to \(sliderTimer.integerValue / 60):00)"
        
        // restore team names
        homeNameTextField.stringValue = scoreboardData.homeName
        awayNameTextField.stringValue = scoreboardData.awayName
        
        // set timer text style
        timerTextField.font = NSFont.monospacedDigitSystemFont(ofSize: 30, weight: .regular)
    }
    
    func saveDefaults() {
        // save NSSwitches state (timer and "soccer")
        UserDefaults.standard.set(isCountdown.state, forKey: "isCountdown")
        UserDefaults.standard.set(continueTimeSwitcher.state, forKey: "continueTimeSwitcher")
    }
    
}
