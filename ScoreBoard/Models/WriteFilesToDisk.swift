//
//  File.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 10.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Cocoa
//import Foundation

class WriteFilesToDisk {
    
    // перечисление файлов для записи
    enum FilesToWrite {
        case timer, homeName, awayName, period, homeGoal, awayGoal
    }
    
    // запись файлов
    func writeFilesToDisk(_ fileToWrite: FilesToWrite...) {
        do {
            if var userDirectoryUrl = restoreBookmarksPathDirectory() {
                userDirectoryUrl = userDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
                
                // проверка - существование каталога на диске
                if !FileManager().fileExists(atPath: userDirectoryUrl.path) {
                    try FileManager.default.createDirectory(at: userDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
                }
                
                var text: String
                var fileName: String
                
                for file in fileToWrite {
                    switch file {
                    case .timer:
                        text = ScoreBoardData.timerString
                        //text = MainViewController().textFieldTimer.stringValue
                        fileName = "Timer.txt"
                    case .homeName:
                        text = ScoreBoardData.homeName
                        fileName = "Home_Name.txt"
                    case .awayName:
                        text = ScoreBoardData.awayName
                        fileName = "Away_Name.txt"
                    case .period:
                        text = String(ScoreBoardData.periodCount)
                        fileName = "Period.txt"
                    case .homeGoal:
                        text = String(ScoreBoardData.countGoalHome)
                        fileName = "HomeGoal.txt"
                    case .awayGoal:
                        text = String(ScoreBoardData.countGoalAway)
                        fileName = "AwayGoal.txt"
                    }
                    // запись нужного файла
                    try text.write(to: userDirectoryUrl.appendingPathComponent(fileName), atomically: false, encoding: .utf8)
                }
            }
        } catch {
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
    
    // сохранить закладку
    func saveBookmarksPathDirectory(_ userDirectoryUrl:URL) {
        
        // добавить название папки к пути выбранному пользователем
        //pathDirectory.url = userDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
        //guard let userDirectoryUrl = pathDirectory.url else { return }
        
        // сохраняем закладку безопасности на будущее
        do {
            let bookmark = try userDirectoryUrl.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmark, forKey: "bookmarkForDirecory")
            
//            print("закладка сохранилась успешно: \(userDirectoryUrl)")
            
        } catch { return }
    }
    
    // восстановить закладку
    func restoreBookmarksPathDirectory() -> URL? {
        guard let bookmark = UserDefaults.standard.data(forKey: "bookmarkForDirecory")
            else { return FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first } // каталог downloads по умолчанию
        var bookmarkDataIsStale: ObjCBool = false
        
        do {
            let userDirectoryUrl = try (NSURL(resolvingBookmarkData: bookmark, options: [.withoutUI, .withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale) as URL)
            
            if bookmarkDataIsStale.boolValue { return nil }
            
            guard userDirectoryUrl.startAccessingSecurityScopedResource() else { return nil }
            
//            print("закладка открыта успешно: \(userDirectoryUrl)")
            
            return userDirectoryUrl
            
        } catch { return nil }
    }
    
}
