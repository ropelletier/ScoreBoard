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
    
    static var timerString: String = "00:00"
    
    static var homeName: String {
        get {
            //UserDefaults.standard.register(defaults: ["homeName" : "Home"])
            if UserDefaults.standard.string(forKey: "homeName") != nil {
                return UserDefaults.standard.string(forKey: "homeName") ?? "Home"
            } else {return "Home"}
        } set {
            UserDefaults.standard.set(newValue, forKey: "homeName")
        }
    }
    
    static var awayName: String {
           get {
               return UserDefaults.standard.string(forKey: "awayName") ?? "Away"
           } set {
               UserDefaults.standard.set(newValue, forKey: "awayName")
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


