//
//  EditTextField.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 07.03.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Cocoa

class EditTextField: NSTextField {
    private let scoreboardData = ScoreBoardData.shared

    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        if becomeFirstResponder {
            scoreboardData.menuIsEnabled = false
        }
        return becomeFirstResponder
    }
    
    // select all text when tap in TextField
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if let textEditor = currentEditor() {
            scoreboardData.menuIsEnabled = false
            textEditor.selectAll(self)
        }
    }
    
}
