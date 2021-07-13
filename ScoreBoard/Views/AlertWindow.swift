//
//  AlertView.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 10.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

final class AlertWindow {
    
    func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    func showAccessToDiskAlert() {
        let title = """
            No access for writing files!
            Select any directory to enable writing.
            """
        let message = """
            Or allow access to the \"Downloads\" folder for the \"ScoreBoard.app\".
            [System Preferences > Security and Privacy > Privacy > Files and Folders > Turn on the checkbox]
            """
        
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "Select directory") // 1-st button
        alert.addButton(withTitle: "Open System Preferences") // 2-nd Button
        alert.addButton(withTitle: "Cancel") // 3-rd Button
        alert.alertStyle = .critical
        
        // show gif instructions in accessoryView
        if let image = NSImage(named: "GetAccessToDiskGIF") {
            let imageView = NSImageView(frame: NSRect(origin: CGPoint(x: 0, y: 0), size: image.size))
            imageView.image = image
            imageView.alignment = .center
            alert.accessoryView = imageView
        }
        
        let response = alert.runModal() // for check press buttons
        
        switch response {
        case .alertFirstButtonReturn:
            guard let userSelectedDirectoryUrl = SelectDirectoryWindow().selectDirectory() else { return }
            FileWriter().saveBookmarksPathDirectory(userSelectedDirectoryUrl)
            FileWriter().writeToDisk(for: .timer, .homeName, .awayName, .period, .homeGoal, .awayGoal)
        
        case .alertSecondButtonReturn:
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_DownloadsFolder")  {
                NSWorkspace.shared.open(url)
            }
        
        default:
            break
        }
    }
}
