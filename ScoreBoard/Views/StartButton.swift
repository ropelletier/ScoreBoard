//
//  StartButton.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 06.05.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Cocoa

final class StartButton: NSButton {

    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        if resignFirstResponder {
            // remove keyEquivalent when focus move from button
            self.keyEquivalent = ""
        }
        return resignFirstResponder
    }
}
