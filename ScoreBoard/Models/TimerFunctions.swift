//
//  Timer.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 13.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Foundation

class TimerFunctions {
    
    var timerStatus: Timer?
    static var isCountdownState: Bool = true
    
    func startTimer(){
        if timerStatus == nil {
            timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                (timer) in
                //if MainViewController().switchTimerMode.state == .on {
                if TimerFunctions.isCountdownState {
                    guard ScoreBoardData.timeNow > 0 else {
                        MainViewController().resetStateButtonStar()
                        return
                    }
                    ScoreBoardData.timeNow -= 1
                } else {
                    guard ScoreBoardData.timeNow < ScoreBoardData.timeUserPreset else {
                        //if MainViewController().continueTimeSwitcher.state == .on { ScoreBoardData.timeUserPreset += ScoreBoardData.timeUserPreset }
                        if TimerFunctions.isCountdownState { ScoreBoardData.timeUserPreset += ScoreBoardData.timeUserPreset }
                        MainViewController().resetStateButtonStar()
                        return
                    }
                    ScoreBoardData.timeNow += 1
                }
                MainViewController().showTimeInLabel()
            }
        }
    }
    
    func stopTimer(){
        if timerStatus != nil {
            timerStatus?.invalidate()
            timerStatus = nil
        }
    }
    
}
