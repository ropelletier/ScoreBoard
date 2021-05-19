//
//  Timer.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 13.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

final class TimerFunctions {
    
    static var timerStatus: Timer? = nil
    
    static func startTimer(){
        let mainVC = ScoreBoardData.shared.mainVC
        let scoreboardData = ScoreBoardData.shared
        
        if timerStatus == nil {
            timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                if mainVC?.isCountdown.state == .on {
                    guard scoreboardData.timeNow > 0 else {
                        mainVC?.resetStateButtonStar()
                        if scoreboardData.autoResetTimer {
                                mainVC?.setTimeDefault()
                                mainVC?.showTimeInLabel()
                        }
                        return
                    }
                    scoreboardData.timeNow -= 1
                } else {
                    // остановить таймер если выключен режим "футбола", когда таймер не останавливается
                    if mainVC?.continueTimeSwitcher.state == .off  {
                        guard scoreboardData.timeNow < scoreboardData.timeUserPreset else {
                            mainVC?.resetStateButtonStar()
                            if scoreboardData.autoResetTimer {
                                    mainVC?.setTimeDefault()
                                    mainVC?.showTimeInLabel()
                            }
                            return
                        }
                    }
                    scoreboardData.timeNow += 1
                }
                mainVC?.showTimeInLabel()
            }
        }
    }
    
    static func stopTimer(){
        if timerStatus != nil {
            timerStatus?.invalidate()
            timerStatus = nil
        }
    }
    
}
