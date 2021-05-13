//
//  SelectDirectoryWindow.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 13.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa

final class SelectDirectoryWindow {
    func selectDirectory() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = "Select"
        guard panel.runModal() == NSApplication.ModalResponse.OK else { return nil }
        guard let userDirectoryUrl = panel.url else { return nil }
        return userDirectoryUrl
    }
}
