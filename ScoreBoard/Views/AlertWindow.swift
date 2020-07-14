//
//  AlertView.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 10.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

class AlertWindow {
    
    func showAlert() {
        let alert = NSAlert()
        alert.messageText = "Unable to write file"
        alert.informativeText = """
        There is no access to the directory for writing.
        Give the program access to write files to disk:
        
        System Preferences > Security and Privacy > Privacy > Files and Folders
        
        Check the box for the program "ScoreBoard.app".
        
        """
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
}
