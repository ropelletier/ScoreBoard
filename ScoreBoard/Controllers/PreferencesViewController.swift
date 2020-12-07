//
//  PreferencesViewController.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 06.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.removeObject(forKey: "bookmarkForDirecory")
        // выставляем директорию Downloads по умолчанию
        workDirectoryPath.url = WriteFilesToDisk().restoreBookmarksPathDirectory()?.appendingPathComponent("ScoreBoard Outputs")
        
        autoResetTimer.state = ScoreBoardData.shared.autoResetTimer ? .on : .off
    }
    
    @IBOutlet weak var workDirectoryPath: NSPathControl!
    @IBOutlet weak var autoResetTimer: NSButton!
    
    @IBAction func selectUserDirectory(_ sender: Any) {

        guard let userSelectedDirectoryUrl = SelectDirectoryWindow().selectDirectory() else { return }
        
        workDirectoryPath.url = userSelectedDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
        
        // сохранить закладку безопасности на будущее
        WriteFilesToDisk().saveBookmarksPathDirectory(userSelectedDirectoryUrl)
        
        WriteFilesToDisk().writeFile(.timer, .homeName, .awayName, .period, .homeGoal, .awayGoal)
    }
    
    @IBAction func setUserDirectory(_ sender: Any) {
        selectUserDirectory(self)
    }
    
    @IBAction func autoResetTimerCheckBox(_ sender: Any) {
        ScoreBoardData.shared.autoResetTimer = autoResetTimer.state == .on ? true : false
    }
    
    @IBAction func pressOKButtonPreferences(_ sender: Any) {
        view.window?.close()
    }
}
