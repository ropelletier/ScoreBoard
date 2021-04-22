//
//  File.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 10.07.2020.
//  Copyright © 2020 Vasily Petuhov. All rights reserved.
//

import Foundation

final class WriterFiles {
    
    private let scoreboardData = ScoreBoardData.shared
    
    enum FilesList {
        case timer, homeName, awayName, period, homeGoal, awayGoal
    }
    
    func writeToDisk(for files: FilesList...) {
        do {
            if var userDirectoryUrl = restoreBookmarksPathDirectory() {
                userDirectoryUrl = userDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
                
                // проверка - существование каталога на диске
                if !FileManager().fileExists(atPath: userDirectoryUrl.path) {
                    try FileManager.default.createDirectory(at: userDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
                }
                
                var text: String
                var fileName: String
                
                for file in files {
                    switch file {
                    case .timer:
                        text = scoreboardData.timerString
                        fileName = "Timer.txt"
                    case .homeName:
                        text = scoreboardData.homeName
                        fileName = "Home_Name.txt"
                    case .awayName:
                        text = scoreboardData.awayName
                        fileName = "Away_Name.txt"
                    case .period:
                        text = String(scoreboardData.periodCount)
                        fileName = "Period.txt"
                    case .homeGoal:
                        text = String(scoreboardData.countGoalHome)
                        fileName = "HomeGoal.txt"
                    case .awayGoal:
                        text = String(scoreboardData.countGoalAway)
                        fileName = "AwayGoal.txt"
                    }

                    try text.write(to: userDirectoryUrl.appendingPathComponent(fileName), atomically: false, encoding: .utf8)
                }
            }
        } catch {
            
            let title = "Unable to write file"
            let message = """
                There is no access to the directory for writing.
                Give the program access to write files to disk:
                
                System Preferences > Security and Privacy > Privacy > Files and Folders
                
                Check the box for the program "ScoreBoard.app".
                
                """
            
            AlertWindow().showAlert(title: title, message: message) // передавать текст ошибки и рекомендации
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
            
        } catch {
            let title = "saveBookmarksPathDirectory"
            let message = "Dont saved BookmarksPathDirectory"
            
            AlertWindow().showAlert(title: title, message: message) // передавать текст ошибки и рекомендации
        }
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
            
        } catch {
            let title = "restoreBookmarksPathDirectory"
            let message = "Dont load BookmarksPathDirectory"
            
            AlertWindow().showAlert(title: title, message: message) // передавать текст ошибки и рекомендации
            
            return nil
        }
    }
    
}
