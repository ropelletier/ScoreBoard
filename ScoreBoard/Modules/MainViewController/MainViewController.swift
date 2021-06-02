//
//  ViewController.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 27.12.2019.
//  Copyright © 2019 Vasily Petuhov. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSWindowDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var timerTextField: EditTextField!
    @IBOutlet weak var buttonStart: StartButton!
    @IBOutlet weak var isCountdown: NSSwitch!
    @IBOutlet weak var titleTimerMode: NSTextField!
    @IBOutlet weak var continueTimeSwitcher: NSSwitch!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var swapScores: NSButton!
    @IBOutlet weak var sliderTimer: NSSlider!
    @IBOutlet weak var textFieldForTimerSetting: NSTextField!
    @IBOutlet weak var homeNameTextField: EditTextField!
    @IBOutlet weak var awayNameTextField: EditTextField!
    @IBOutlet weak var goalHome: NSSegmentedControl!
    @IBOutlet weak var goalAway: NSSegmentedControl!
    @IBOutlet weak var period: NSSegmentedControl!
    @IBOutlet weak var redTipForNextPeriod: NSImageView!
    @IBOutlet weak var stepperSeconds: NSStepper!
    @IBOutlet weak var stepperMinutes: NSStepper!
    
    @IBOutlet weak var scoreBoardView: BasicSBTemplateView!
    
    let scoreboardData = ScoreBoardData.shared
    private var activityAppNap: NSObjectProtocol? //for disable/enable App Nap in macOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefaults() // load properties the main screen
        setCountsGoals()
        setTimeDefault() // restore default timer value
        showTimeInLabel() // show time + write timer file
        WriterFiles().writeToDisk(for: .homeName, .awayName, .period, .homeGoal, .awayGoal)
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self // delegate for windowWillClose()
    }
    
    func windowWillClose(_ notification: Notification) {
        saveDefaults() //save data before closing
        NSApplication.shared.terminate(nil)
    }
    
    // MARK: - Functions
    
    /// Save value timer from slider
    func setTimeDefault() {
        scoreboardData.timeUserPreset = sliderTimer.integerValue
        if isCountdown.state == .on {
            scoreboardData.timeNow = scoreboardData.timeUserPreset
        } else {
            scoreboardData.timeNow = 0
        }
    }
    
    func setCountsGoals() {
        goalHome.setLabel(
            scoreboardData.getCountGoalsString(for: .home),
            forSegment: 1
        )
        goalAway.setLabel(
            scoreboardData.getCountGoalsString(for: .away),
            forSegment: 1
        )
    }
    
    /// Show time in TextField
    func showTimeInLabel() {
        
        stepperSeconds.integerValue = scoreboardData.timeNow //сохраняет время для степперов
        stepperMinutes.integerValue = scoreboardData.timeNow
        
        let minutes:Int = scoreboardData.timeNow / 60
        let seconds:Int = scoreboardData.timeNow - (minutes*60)
        var minStr:String = "\(minutes)"
        var secStr:String = "\(seconds)"
        
        // проверки МИНУТ и СЕКУНД на отсутсвие нулей (0:45 -> 01:45)
        if minutes < 10 {
            minStr = "0" + minStr
        }
        if seconds < 10 {
            secStr = "0" + secStr
        }
        
        timerTextField.stringValue = minStr + ":" + secStr //вывод времени в формате 00:00 в поле
        scoreboardData.timerString = minStr + ":" + secStr //timerTextField.stringValue
        
        textFieldForTimerSetting.stringValue = isCountdown.state == .on ?
            "Timer setting (from \(sliderTimer.integerValue / 60):00 to 00:00)" :
            "Timer setting (from 00:00 to \(sliderTimer.integerValue / 60):00)"
    }
    
    func resetAllState(){
        resetStateButtonStar()
        setTimeDefault()
        showTimeInLabel()
        scoreboardData.countGoalHome = 0
        goalHome.setLabel(String(scoreboardData.countGoalHome), forSegment: 1)
        scoreboardData.countGoalAway = 0
        goalAway.setLabel(String(scoreboardData.countGoalAway), forSegment: 1)
        scoreboardData.periodCount = 1
        period.setLabel(String(scoreboardData.periodCount), forSegment: 1)
    }
    
    func resetStateButtonStar(){
        TimerFunctions.stopTimer()
        buttonStart.title = "START"
        timerTextField.textColor = .controlTextColor
    }
    
    // пользовательское время не должно быть больше чем установленный таймер, только если включен режим "футбол"
    func isAllowedChangeTime(newTime: Int) -> Bool {
        if continueTimeSwitcher.state == .on { return true }
        if scoreboardData.timeUserPreset >= newTime { return true }
        return false
    }
    
    // MARK: - Actions
    
    @IBAction func timeLabelAction(_ sender: Any) {
        focusToStartButton()
        ScoreBoardData.shared.menuIsEnabled = true
        
        // delete everything except digits
        var timeFromUser = Array(timerTextField.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        
        // timer before changes (for case 0)
        var minutesFromUser:Int = scoreboardData.timeNow / 60
        var secondsFromUser:Int = scoreboardData.timeNow - ((scoreboardData.timeNow / 60) * 60)
        
        switch timeFromUser.count {
        case 0:
            break
        case 1..<4:
            // if user entered less than 4 digits, then fill in the missing values with 0
            for i in 0..<(4 - timeFromUser.count) {
                timeFromUser.insert("0", at: i)
            }
            fallthrough
        
        case 4:
            minutesFromUser = Int (String (timeFromUser [0...1])) ?? 0
            secondsFromUser = Int (String (timeFromUser [2...3])) ?? 0
            
        default:
            // if user entered more than 4 digits, then use only 5 first digit (exemple: 152:12)
            minutesFromUser = Int (String (timeFromUser [0...2])) ?? 0
            secondsFromUser = Int (String (timeFromUser [3...4])) ?? 0
        }
        
        if isAllowedChangeTime(newTime: minutesFromUser * 60 + secondsFromUser) {
            scoreboardData.timeNow = (minutesFromUser * 60) + secondsFromUser
        }
        showTimeInLabel()
    }
    
    @IBAction func stepperSecondsAction(_ sender: Any) {
        guard isAllowedChangeTime(newTime: stepperSeconds.integerValue) else {
            stepperSeconds.integerValue -= 1 // change value back (stepper triggered before checking)
            return
        }
        scoreboardData.timeNow = stepperSeconds.integerValue
        showTimeInLabel()
    }
    
    @IBAction func stepperMinutesAction(_ sender: Any) {
        guard isAllowedChangeTime(newTime: stepperMinutes.integerValue) else {
            stepperMinutes.integerValue -= 60  // change value back (stepper triggered before checking)
            return
        }
        scoreboardData.timeNow = stepperMinutes.integerValue
        showTimeInLabel()
    }
    
    @IBAction func goalHomeAction(_ sender: Any) {
        switch goalHome.selectedSegment {
        case 0:
            guard scoreboardData.countGoalHome > 0 else { break }
            scoreboardData.countGoalHome -= 1
        
        case 2:
            scoreboardData.countGoalHome += 1
        
        case 3:
            scoreboardData.countGoalHome += 2
            
        case 4:
            scoreboardData.countGoalHome += 3
            
        default:
            return
        }
    
        goalHome.selectedSegment = 1
        goalHome.setLabel(
            scoreboardData.getCountGoalsString(for: .home),
            forSegment: 1
        )
    }
    
    @IBAction func goalAwayAction(_ sender: Any) {
        
        switch goalAway.selectedSegment {
        case 0:
            guard scoreboardData.countGoalAway > 0 else { break }
            scoreboardData.countGoalAway -= 1
        
        case 2:
            scoreboardData.countGoalAway += 1
        
        case 3:
            scoreboardData.countGoalAway += 2
            
        case 4:
            scoreboardData.countGoalAway += 3
            
        default:
            return
        }
    
        goalAway.selectedSegment = 1
        goalAway.setLabel(
            scoreboardData.getCountGoalsString(for: .away),
            forSegment: 1
        )
    }
    
    @IBAction func periodAction(_ sender: Any) {
        switch period.selectedSegment {
        case 0:
            guard scoreboardData.periodCount > 1 else { break }
            scoreboardData.periodCount -= 1
        
        case 2:
            scoreboardData.periodCount += 1
            
        default:
            return
        }
        
        period.selectedSegment = 1
        period.setLabel(String(scoreboardData.periodCount), forSegment: 1)
    }
    
    @IBAction func textFieldHomeNameAction(_ sender: Any) {
        scoreboardData.homeName = homeNameTextField.stringValue
        awayNameTextField.becomeFirstResponder()
    }
    
    @IBAction func textFieldAwayNameAction(_ sender: Any) {
        scoreboardData.awayName = awayNameTextField.stringValue
        deselectTextInTextFileds()
        focusToStartButton()
    }
    
    @IBAction func sliderTimerAction(_ sender: Any) {
        setTimeDefault()
        showTimeInLabel()
    }
    
    @IBAction func pushButtonStart(_ sender: Any) {
        deselectTextInTextFileds()
        focusToStartButton()
        
        if TimerFunctions.timerStatus == nil {
            TimerFunctions.startTimer()
            buttonStart.title = "PAUSE"
            timerTextField.textColor = .red
            
            // disable App Nap
            activityAppNap = ProcessInfo().beginActivity(
                options: .userInitiatedAllowingIdleSystemSleep,
                reason: "Run timer in background"
            )
            
        } else {
            resetStateButtonStar()
            
            // enable App Nap
            if let pinfo = activityAppNap {
                ProcessInfo().endActivity(pinfo)
            }
        }
    }
    
    @IBAction func switchTimerOnOff(_ sender: Any) {
        if isCountdown.state == .on {
            titleTimerMode.stringValue = "Countdown: ON"
            continueTimeSwitcher.state = .off
            continueTimeSwitcher.isEnabled = false
        } else {
            titleTimerMode.stringValue = "Countdown: OFF"
            continueTimeSwitcher.isEnabled = true
        }
        // смена времени на табло с сохранением пройденных секунд
        scoreboardData.timeNow = scoreboardData.timeUserPreset - scoreboardData.timeNow
        showTimeInLabel()
    }
    
    @IBAction func resetButtonPush(_ sender: Any) {
        resetAllState()
    }
    
    @IBAction func swapHomeAwayScores(_ sender: Any) {
        swap(&scoreboardData.homeName, &scoreboardData.awayName)
        homeNameTextField.stringValue = scoreboardData.homeName
        awayNameTextField.stringValue = scoreboardData.awayName
        
        swap(&scoreboardData.countGoalHome, &scoreboardData.countGoalAway)
        goalHome.setLabel(
            scoreboardData.getCountGoalsString(for: .home),
            forSegment: 1
        )
        goalAway.setLabel(
            scoreboardData.getCountGoalsString(for: .away),
            forSegment: 1
        )
    }
}
