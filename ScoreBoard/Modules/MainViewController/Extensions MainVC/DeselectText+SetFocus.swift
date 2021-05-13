//
//  File.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 22.04.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Cocoa

extension MainViewController {
    override func mouseDown(with: NSEvent) {
//        NSApp.mainWindow?.makeFirstResponder(nil) // Deselect all elements
        deselectTextInTextFileds()
        focusToStartButton()
    }
    
    /// Deselect text in NSTextFiled fields, focus is not associated with selection
    /// (focus is on the button, but the command name is selected)
    func deselectTextInTextFileds() {
        homeNameTextField.abortEditing()
        awayNameTextField.abortEditing()
        
        ScoreBoardData.shared.menuIsEnabled = true
        
        // deselect all text in Range
        //        homeNameTextField.currentEditor()?.selectedRange = NSMakeRange(0, 0)
        //        awayNameTextField.currentEditor()?.selectedRange = NSMakeRange(0, 0)
    }
    
    /// Send focus to StartButton
    func focusToStartButton() {
        buttonStart.window?.makeFirstResponder(buttonStart)
    
        // set keyEquivalent `return` when button focused
        // delay for keyEquivalent for did not press button immediately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.buttonStart.keyEquivalent = "\r"
        }
    }
}
