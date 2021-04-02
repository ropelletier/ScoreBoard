//
//  EditTextField.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 07.03.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Cocoa

class EditTextField: NSTextField {
    
    private var symbols = [String]()
    private var keys = [NSEvent.ModifierFlags]()

    

    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        if becomeFirstResponder {
            print("\(self.description) - becomeFirstResponder")
//            print(NSApp.menu?.item(withTitle: "Game counters")?.keyEquivalent)
//            NSApp.menu?.item(at: 3)?.submenu?.item(at: 0)?.keyEquivalent = key
//            print(NSApp.menu?.item(at: 3)?.submenu?.item(at: 0)?.keyEquivalent = "")
//            NSApp.menu = fullMenu!
            manageMenus()
        }
        return becomeFirstResponder
    }

    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        if resignFirstResponder {
            print("\(self) - resignFirstResponder")
//            key = (NSApp.menu?.item(at: 3)?.submenu?.item(at: 0)!.keyEquivalent)!
//            manageMenus()
        }
        return resignFirstResponder
    }
    
    // select all text when tap in TextField
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if let textEditor = currentEditor() {
            textEditor.selectAll(self)
        }
    }
    
    private final func manageMenus(){
        let  mainMenu =  NSApplication.shared.mainMenu

        if let editMenu = mainMenu?.item(at: 3)?.submenu {
            
//            editMenu.items[2].keyEquivalentModifierMask = [NSEvent.ModifierFlags.command]
//            editMenu.items[2].keyEquivalent = "O"
            
            for item in editMenu.items{
                print(item.title)
//                item.
                symbols.append(item.keyEquivalent)
                keys.append(item.keyEquivalentModifierMask)
            }
            
            symbols.map { print($0) }
            keys.map { print($0) }
//            print(keys)
//            for item in editMenu.items{
//                  item.isEnabled = true
//              }
        }
    }
    
}
