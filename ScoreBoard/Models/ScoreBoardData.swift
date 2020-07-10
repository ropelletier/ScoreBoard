//
//  ScoreBoard.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 08.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Foundation

class ScoreBoardData {
    // параметры по умолчанию
    static var timeUserPreset: Int {
        get {
            UserDefaults.standard.register(defaults: ["timeUserPreset" : 900])
            return UserDefaults.standard.integer(forKey: "timeUserPreset")
        } set {
            UserDefaults.standard.set(newValue, forKey: "timeUserPreset")
        }
    }
    static var timeNow: Int = timeUserPreset
    static var timerString: String = "00:00"
    static var homeName: String = "Home"
    static var awayName: String = "Away"
    static var countGoalHome: Int = 0
    static var countGoalAway: Int = 0
    static var periodCount: Int = 1
}


