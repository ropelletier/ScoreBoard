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
        WorkDirectoryPath.url = WriteFilesToDisk().restoreBookmarksPathDirectory()?.appendingPathComponent("ScoreBoard Outputs")
    }
    
    @IBOutlet weak var WorkDirectoryPath: NSPathControl!
    
    @IBAction func selectUserDirectory(_ sender: Any) {

        guard let userSelectedDirectoryUrl = SelectDirectoryWindow().selectDirectory() else { return }
        
        WorkDirectoryPath.url = userSelectedDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
        
        // сохранить закладку безопасности на будущее
        WriteFilesToDisk().saveBookmarksPathDirectory(userSelectedDirectoryUrl)
    }
    
    @IBAction func setUserDirectory(_ sender: Any) {
        selectUserDirectory(self)
    }
    
    @IBAction func pressOKButtonPreferences(_ sender: Any) {
        view.window?.close()
    }
}
