//
//  ScoreBoard.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 08.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Foundation

class ScoreBoardData {
    
    private init() {}
    static let instance = ScoreBoardData()
    
    var timeUserPreset: Int {
        get {
            UserDefaults.standard.register(defaults: ["timeUserPreset" : 900])
            return UserDefaults.standard.integer(forKey: "timeUserPreset")
        } set {
            UserDefaults.standard.set(newValue, forKey: "timeUserPreset")
        }
    }
    
    lazy var timeNow: Int = timeUserPreset
    
    var timerString: String = "00:00" {
        didSet {
            WriteFilesToDisk().writeFile(.timer)
        }
    }
    
    var homeName: String {
        get {
            return UserDefaults.standard.string(forKey: "homeName") ?? "Home"
        } set {
            UserDefaults.standard.set(newValue, forKey: "homeName")
            WriteFilesToDisk().writeFile(.homeName)
        }
    }
    
    var awayName: String {
        get {
            return UserDefaults.standard.string(forKey: "awayName") ?? "Away"
        } set {
            UserDefaults.standard.set(newValue, forKey: "awayName")
            WriteFilesToDisk().writeFile(.awayName)
        }
    }
    
    var countGoalHome: Int = 0 {
        didSet{
            WriteFilesToDisk().writeFile(.homeGoal)
        }
    }
    
    var countGoalAway: Int = 0 {
        didSet{
            WriteFilesToDisk().writeFile(.awayGoal)
        }
    }
    
    var periodCount: Int = 1 {
        didSet{
            WriteFilesToDisk().writeFile(.period)
        }
    }
    
}


