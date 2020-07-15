//
//  ScoreBoard.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 08.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Foundation

class ScoreBoardData {
    
    static var timeUserPreset: Int {
        get {
            UserDefaults.standard.register(defaults: ["timeUserPreset" : 900])
            return UserDefaults.standard.integer(forKey: "timeUserPreset")
        } set {
            UserDefaults.standard.set(newValue, forKey: "timeUserPreset")
        }
    }
    
    static var timeNow: Int = timeUserPreset
    
    static var timerString: String = "00:00" {
        didSet {
            WriteFilesToDisk().writeFile(.timer)
        }
    }
    
    static var homeName: String {
        get {
            return UserDefaults.standard.string(forKey: "homeName") ?? "Home"
        } set {
            UserDefaults.standard.set(newValue, forKey: "homeName")
            WriteFilesToDisk().writeFile(.homeName)
        }
    }
    
    static var awayName: String {
        get {
            return UserDefaults.standard.string(forKey: "awayName") ?? "Away"
        } set {
            UserDefaults.standard.set(newValue, forKey: "awayName")
            WriteFilesToDisk().writeFile(.awayName)
        }
    }
    
    static var countGoalHome: Int = 0 {
        didSet{
            WriteFilesToDisk().writeFile(.homeGoal)
        }
    }
    
    static var countGoalAway: Int = 0 {
        didSet{
            WriteFilesToDisk().writeFile(.awayGoal)
        }
    }
    
    static var periodCount: Int = 1 {
        didSet{
            WriteFilesToDisk().writeFile(.period)
        }
    }
    
}


