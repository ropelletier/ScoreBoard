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
        WorkDirectoryPath.url = MainViewController().restoreBookmarksPathDirectory()?.appendingPathComponent("ScoreBoard Outputs")
    }
    
    @IBOutlet weak var WorkDirectoryPath: NSPathControl!
    
    @IBAction func selectUserDirectory(_ sender: Any) {
        // открыть панель выбора файла
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = "Select"
        guard panel.runModal() == NSApplication.ModalResponse.OK else { return }
        guard let userDirectoryUrl = panel.url else { return }
        
        // добавить название папки к пути выбранному пользователем
        WorkDirectoryPath.url = userDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
        
        // сохранить закладку безопасности на будущее
        MainViewController().saveBookmarksPathDirectory(userDirectoryUrl)
    }
    
    @IBAction func setUserDirectory(_ sender: Any) {
        selectUserDirectory(self)
    }
    
    @IBAction func pressOKButtonPreferences(_ sender: Any) {
        view.window?.close()
    }
}
