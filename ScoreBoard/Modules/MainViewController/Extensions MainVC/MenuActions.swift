//
//  MenuActions.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 05.05.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Foundation
extension MainViewController {
    // MARK:- Menu action
    
    @IBAction func startPauseTimerFromMenu(_ sender: Any) {
        pushButtonStart(self)
    }
    
    @IBAction func plus1SecFromMenu(_ sender: Any) {
        guard isAllowedChangeTime(newTime: scoreboardData.timeNow + 1) else { return }
        scoreboardData.timeNow += 1
        showTimeInLabel()
    }
    
    @IBAction func minus1SecFromMenu(_ sender: Any) {
        guard scoreboardData.timeNow > 0 else { return }
        scoreboardData.timeNow -= 1
        showTimeInLabel()
    }
    
    @IBAction func plus1MinFromMenu(_ sender: Any) {
        guard isAllowedChangeTime(newTime: scoreboardData.timeNow + 60) else { return }
        scoreboardData.timeNow += 60
        showTimeInLabel()
    }
    
    @IBAction func minus1MinFromMenu(_ sender: Any) {
        guard scoreboardData.timeNow >= 60 else { return }
        scoreboardData.timeNow -= 60
        showTimeInLabel()
    }
    
    @IBAction func resetAllStateFromMenu(_ sender: Any) {
        resetButtonPush(self)
    }
    
    @IBAction func minus1GoalHomeFromMenu(_ sender: Any) {
        goalHome.selectedSegment = 0
        goalHomeAction(self)
    }
    
    @IBAction func plus1GoalHomeFromMenu(_ sender: Any) {
        goalHome.selectedSegment = 2
        goalHomeAction(self)
    }
    
    @IBAction func plus2GoalHomeFromMenu(_ sender: Any) {
        goalHome.selectedSegment = 3
        goalHomeAction(self)
    }
    
    @IBAction func plus3GoalHomeFromMenu(_ sender: Any) {
        goalHome.selectedSegment = 4
        goalHomeAction(self)
    }
    
    @IBAction func minus1GoalAwayFromMenu(_ sender: Any) {
        goalAway.selectedSegment = 0
        goalAwayAction(self)
    }
    
    @IBAction func plus1GoalAwayFromMenu(_ sender: Any) {
        goalAway.selectedSegment = 2
        goalAwayAction(self)
    }
    
    @IBAction func plus2GoalAwayFromMenu(_ sender: Any) {
        goalAway.selectedSegment = 3
        goalAwayAction(self)
    }
    
    @IBAction func plus3GoalAwayFromMenu(_ sender: Any) {
        goalAway.selectedSegment = 4
        goalAwayAction(self)
    }
    
    @IBAction func plus1PeriodFromMenu(_ sender: Any) {
        period.selectedSegment = 2
        periodAction(self)
    }
    
    @IBAction func clearUserDefaults(_ sender: Any) {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
