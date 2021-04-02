//: A Cocoa based Playground to present user interface

//import AppKit
//import PlaygroundSupport
//
//let nibFile = NSNib.Name("MyView")
//var topLevelObjects : NSArray?
//
//Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
//let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }
//
//// Present the view in Playground
//PlaygroundPage.current.liveView = views[0] as! NSView


import XCPlayground
import AppKit

let view = NSView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

XCPShowView(identifier: "view", view: view)

let txtf = NSTextField(frame: CGRect(x: 50, y: 50, width: 200, height: 50))

view.addSubview(txtf)

txtf.stringValue = "falling asleep at the keyboard..."

txtf.selectText(nil) // Ends editing and selects the entire contents of the text field

//var txt = txtf.currentEditor() // returns an NSText

//txt?.selectedRange // --> (0,33)
