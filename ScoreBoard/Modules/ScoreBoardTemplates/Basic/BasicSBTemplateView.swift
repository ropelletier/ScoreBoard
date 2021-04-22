//
//  BasicSBTemplateView.swift
//  TestImage
//
//  Created by Василий Петухов on 08.01.2021.
//  Copyright © 2021 Vasily Petuhov. All rights reserved.
//

import Cocoa

//@IBDesignable
class BasicSBTemplateView: NSView {
    
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var backgroundImg: NSImageView!
    @IBOutlet weak var homeNameLabel: NSTextField!
    @IBOutlet weak var awayNameLabel: NSTextField!
    @IBOutlet weak var goalsHome: NSTextField!
    @IBOutlet weak var goalsAway: NSTextField!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var periodLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // v1 for xib
        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: .init(String(describing: type(of: self))), bundle: bundle)!
        nib.instantiate(withOwner: self, topLevelObjects: nil)
        
        // v2 for xib
//        Bundle.main.loadNibNamed("ScoreBoardView", owner: self, topLevelObjects: nil)
        addSubview(contentView)
    }
}
