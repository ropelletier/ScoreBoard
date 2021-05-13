//
//  ScoreBoard.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 08.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

enum Team {
    case home, away
}

final class ScoreBoardData {
    
    private init() {}
    static let shared = ScoreBoardData()
    
    private lazy var writerFiles = WriterFiles()
    
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
            writerFiles.writeToDisk(for: .timer)
        }
    }
    
    var homeName: String {
        get {
            return UserDefaults.standard.string(forKey: "homeName") ?? "Home"
        } set {
            UserDefaults.standard.set(newValue, forKey: "homeName")
            writerFiles.writeToDisk(for: .homeName)
        }
    }
    
    var awayName: String {
        get {
            return UserDefaults.standard.string(forKey: "awayName") ?? "Away"
        } set {
            UserDefaults.standard.set(newValue, forKey: "awayName")
            writerFiles.writeToDisk(for: .awayName)
        }
    }
    
    var countGoalHome: Int = 0 {
        didSet{
            writerFiles.writeToDisk(for: .homeGoal)
        }
    }
    
    var countGoalAway: Int = 0 {
        didSet{
            writerFiles.writeToDisk(for: .awayGoal)
        }
    }
    
    func getCountGoalsString(for team: Team) -> String {
        let countGoals: Int
        
        switch team {
        case .home:
            countGoals = countGoalHome
        case .away:
            countGoals = countGoalAway
        }
        
        let countGoalsString = addZeroToGoalsCounts ?
            String(format: "%02d", countGoals) :
            String(countGoals)
        
        return countGoalsString
    }
    
    var periodCount: Int = 1 {
        didSet{
            writerFiles.writeToDisk(for: .period)
        }
    }
    
    var autoResetTimer: Bool {
        get {
            UserDefaults.standard.register(defaults: ["autoResetTimer" : false])
            return UserDefaults.standard.bool(forKey: "autoResetTimer")
        } set {
            UserDefaults.standard.set(newValue, forKey: "autoResetTimer")
        }
    }
    
    var addZeroToGoalsCounts: Bool {
        get {
            UserDefaults.standard.register(defaults: ["addZeroToGoalsCounts" : false])
            return UserDefaults.standard.bool(forKey: "addZeroToGoalsCounts")
        } set {
            UserDefaults.standard.set(newValue, forKey: "addZeroToGoalsCounts")
            writerFiles.writeToDisk(for: .homeGoal, .awayGoal)
            
            if let mainWindow = NSApplication.shared.windows.first(where: { $0.windowController?.contentViewController is MainViewController }) {
                let mainVC = mainWindow.windowController?.contentViewController as? MainViewController
                mainVC?.setCountsGoals()
            }
        }
    }
    
    var menuIsEnabled: Bool = true
}


