//
//  AlertView.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 10.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

class AlertWindow {
    
//    private let titleDefault = "Unable to write file"
//    private let messageDefault = """
//        There is no access to the directory for writing.
//        Give the program access to write files to disk:
//
//        System Preferences > Security and Privacy > Privacy > Files and Folders
//
//        Check the box for the program "ScoreBoard.app".
//
//        """
    
    func showAlert(title: String = "Error", message: String = "Something went wrong") {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
}
