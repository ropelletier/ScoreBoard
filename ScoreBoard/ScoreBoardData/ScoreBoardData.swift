//
//  ScoreBoard.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 08.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

final class ScoreBoardData {
    
    enum Team {
        case home, away
    }
    
    private init() {}
    static let shared = ScoreBoardData()
    
    private lazy var writerFiles = FileWriter()
    
    var menuIsEnabled: Bool = true
    
    var autoResetTimer: Bool {
        get {
            UserDefaults.standard.register(defaults: ["autoResetTimer" : true])
            return UserDefaults.standard.bool(forKey: "autoResetTimer")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "autoResetTimer")
        }
    }
    
    var addZeroToGoalsCounts: Bool {
        get {
            UserDefaults.standard.register(defaults: ["addZeroToGoalsCounts" : false])
            return UserDefaults.standard.bool(forKey: "addZeroToGoalsCounts")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "addZeroToGoalsCounts")
            writerFiles.writeToDisk(for: .homeGoal, .awayGoal)
            mainVC?.setCountsGoals()
        }
    }
    
    var addSuffixToPeriodCount: Bool {
        get {
            UserDefaults.standard.register(defaults: ["addSuffixToPeriodCount" : false])
            return UserDefaults.standard.bool(forKey: "addSuffixToPeriodCount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "addSuffixToPeriodCount")
            writerFiles.writeToDisk(for: .period)
            mainVC?.setCountPeriod()
        }
    }
    
    var timeUserPreset: Int {
        get {
            UserDefaults.standard.register(defaults: ["timeUserPreset" : 900])
            return UserDefaults.standard.integer(forKey: "timeUserPreset")
        }
        set {
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
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "homeName")
            writerFiles.writeToDisk(for: .homeName)
        }
    }
    
    var awayName: String {
        get {
            return UserDefaults.standard.string(forKey: "awayName") ?? "Away"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "awayName")
            writerFiles.writeToDisk(for: .awayName)
        }
    }
    
    var countGoalHome: Int = 0 {
        didSet{
            writerFiles.writeToDisk(for: .homeGoal)
//            mainVC?.setCountsGoals() 
        }
    }
    
    var countGoalAway: Int = 0 {
        didSet{
            writerFiles.writeToDisk(for: .awayGoal)
//            mainVC?.setCountsGoals()
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
            mainVC?.setCountPeriod()
            mainVC?.redTipForNextPeriod.isHidden = true
        }
    }
    
    func getPeriodCountString() -> String {
        guard periodCount != 0 else { return "OT" }
        guard addSuffixToPeriodCount else { return String(periodCount) }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        formatter.locale = Locale(identifier: "en_US")
        
        let countWithSuffix = formatter.string(from: NSNumber(value: periodCount)) ?? String(periodCount)
        return countWithSuffix
    }
    
    var mainVC: MainViewController? {
        if let mainWindow = NSApplication.shared.windows.first(where: { $0.windowController?.contentViewController is MainViewController }) {
            
            return mainWindow.windowController?.contentViewController as? MainViewController
        } else {
            return nil
        }
    }
}


