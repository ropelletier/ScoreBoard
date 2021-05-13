//
//  Extension_mainVC.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 03.04.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Cocoa

extension MainViewController: NSUserInterfaceValidations {
    
    // Disable menu items (when active EditTextField)
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
    
        switch item.action {
        case #selector(plus1GoalHomeFromMenu(_:)),
             #selector(plus2GoalHomeFromMenu(_:)),
             #selector(plus3GoalHomeFromMenu(_:)),
             #selector(plus1GoalAwayFromMenu(_:)),
             #selector(plus2GoalAwayFromMenu(_:)),
             #selector(plus3GoalAwayFromMenu(_:)):
            
            return ScoreBoardData.shared.menuIsEnabled
            
        default:
            return true
        }
    }
}
