//
//  PreferencesViewController.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 06.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

final class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var workDirectoryPath: NSPathControl!
    @IBOutlet weak var autoResetTimer: NSButton!
    @IBOutlet weak var addZeroToGoalsOutlet: NSButton!

    private let fileWriter = FileWriter()
    private var scoreBoardData = ScoreBoardData.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.removeObject(forKey: "bookmarkForDirecory")
        // выставляем директорию Downloads по умолчанию
        workDirectoryPath.url = fileWriter.restoreBookmarksPathDirectory()?.appendingPathComponent("ScoreBoard Outputs")
        
        autoResetTimer.state = ScoreBoardData.shared.autoResetTimer ? .on : .off
        addZeroToGoalsOutlet.state = ScoreBoardData.shared.addZeroToGoalsCounts ? .on : .off
    }
    
    override func viewWillAppear() {
        setupAppearance()
    }
    
    // MARK:  - IBActions
    
    @IBAction func selectUserDirectory(_ sender: Any) {

        guard let userSelectedDirectoryUrl = SelectDirectoryWindow().selectDirectory() else { return }
        
        workDirectoryPath.url = userSelectedDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
        
        // сохранить закладку безопасности на будущее
        fileWriter.saveBookmarksPathDirectory(userSelectedDirectoryUrl)
        
        fileWriter.writeToDisk(for: .timer, .homeName, .awayName, .period, .homeGoal, .awayGoal)
    }
    
    @IBAction func setUserDirectory(_ sender: Any) {
        selectUserDirectory(self)
    }
    
    @IBAction func autoResetTimerCheckBox(_ sender: Any) {
        scoreBoardData.autoResetTimer = autoResetTimer.state == .on ? true : false
    }
    
    @IBAction func addZeroToGoalCounts(_ sender: Any) {
        scoreBoardData.addZeroToGoalsCounts = addZeroToGoalsOutlet.state == .on ? true : false
    }
    
    @IBAction func pressOKButtonPreferences(_ sender: Any) {
        view.window?.close()
    }
}

// MARK:  - Private
private extension PreferencesViewController {
    func setupAppearance() {
        
        // disable resizzable window by double tap or drag mouse (.insert for enable)
        view.window?.styleMask.remove(.resizable)
        
        let resizeButton = view.window?.standardWindowButton(.zoomButton)
        resizeButton?.isEnabled = false
        
        let minimizeButton = view.window?.standardWindowButton(.miniaturizeButton)
        minimizeButton?.isEnabled = false
        
        // setup size and position Preferences Window
        if let mainWindowFrame = scoreBoardData.mainVC?.view.window?.frame {
            let mainWindowOrigin = mainWindowFrame.origin
 
            var ofSetOrigin: CGFloat {
                let mainWindowHeight = mainWindowFrame.size.height
                let preferencesWindowHeight = view.window?.frame.height ?? 200
                return (mainWindowHeight - preferencesWindowHeight) / 2
            }
            
            view.window?.setFrameOrigin(CGPoint(
                x: mainWindowOrigin.x,
                y: mainWindowOrigin.y + ofSetOrigin
            ))
        }
    }
}
