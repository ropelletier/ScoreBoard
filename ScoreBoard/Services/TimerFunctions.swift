//
//  Timer.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 13.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

class TimerFunctions {
    
    static var timerStatus: Timer?
    
    static func startTimer(){
        let mainVC = NSApplication.shared.mainWindow?.windowController?.contentViewController as! MainViewController
        let scoreboardData = ScoreBoardData.shared
//        let delayResetTimer = 5.0
        
        if timerStatus == nil {
            timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                if mainVC.isCountdown.state == .on {
                    guard scoreboardData.timeNow > 0 else {
                        mainVC.resetStateButtonStar()
                        if scoreboardData.autoResetTimer {
                            //задержка перед обнулением таймера
//                            DispatchQueue.main.asyncAfter(deadline: .now() + delayResetTimer) {
                                mainVC.setTimeDefault()
                                mainVC.showTimeInLabel()
//                            }
                        }
                        return
                    }
                    scoreboardData.timeNow -= 1
                } else {
                    // остановить таймер если выключен режим "футбола", когда таймер не останавливается
                    if mainVC.continueTimeSwitcher.state == .off  {
                        guard scoreboardData.timeNow < scoreboardData.timeUserPreset else {
                            mainVC.resetStateButtonStar()
                            if scoreboardData.autoResetTimer {
                                //задержка перед обнулением таймера
//                                DispatchQueue.main.asyncAfter(deadline: .now() + delayResetTimer) {
                                    mainVC.setTimeDefault()
                                    mainVC.showTimeInLabel()
//                                }
                            }
                            return
                        }
                    }
                    scoreboardData.timeNow += 1
                }
                mainVC.showTimeInLabel()
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
