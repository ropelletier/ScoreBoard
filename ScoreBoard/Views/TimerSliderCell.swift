//
//  TimerSliderCell.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 14.07.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Cocoa

class TimerSliderCell: NSSliderCell {
    
    let scoreBoardData = ScoreBoardData.shared
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawKnob() {
        super.drawKnob()
        addFilter()
    }
    
    private func addFilter() {
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(CIColor(cgColor: NSColor.gray.cgColor), forKey: "inputColor0")
        
        var shouldChangeKnobSliderColor: Bool {
            !scoreBoardData.autoResetTimer && scoreBoardData.timerIsFinished
        }
    
        let color = shouldChangeKnobSliderColor ?
            NSColor.red.cgColor :
            NSColor.white.cgColor
        
        // color of slider
//        colorFilter.setValue(CIColor(cgColor: color), forKey: "inputColor0")
        // color of knob
        colorFilter.setValue(CIColor(cgColor: color), forKey: "inputColor1")
        
        controlView?.contentFilters = [colorFilter]
    }
}
