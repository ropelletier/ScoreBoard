//
//  AlertView.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 10.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

final class AlertWindow {
    
    func showAlert(title: String = "Error", message: String = "Something went wrong") {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
}
