//
//  ViewController.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 27.12.2019.
//  Copyright © 2019 Vasily Petuhov. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSWindowDelegate {
    
    let scoreboardData = ScoreBoardData.shared
    var activityAppNap: NSObjectProtocol? //for disable/enable App Nap in macOS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clear all UserDefaults
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }        
        loadDefaults() // initial setup of the main screen
        setTimeDefault() // restore default timer value
        showTimeInLabel() // show time + write timer file
        WriteFilesToDisk().writeFile(.homeName, .awayName, .period, .homeGoal, .awayGoal) // write other files
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self // delegate for windowWillClose()
    }
    
    func windowWillClose(_ notification: Notification) {
        saveDefaults() //save data before closing
        NSApplication.shared.terminate(nil)
    }
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var timerTextField: NSTextField!
    @IBOutlet weak var buttonStart: NSButton!
    @IBOutlet weak var isCountdown: NSSwitch!
    @IBOutlet weak var titleTimerMode: NSTextField!
    @IBOutlet weak var continueTimeSwitcher: NSSwitch!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var swapScores: NSButton!
    @IBOutlet weak var sliderTimer: NSSlider!
    @IBOutlet weak var textFieldForTimerSetting: NSTextField!
    @IBOutlet weak var homeNameTextField: NSTextField!
    @IBOutlet weak var awayNameTextField: NSTextField!
    @IBOutlet weak var goalHome: NSSegmentedControl!
    @IBOutlet weak var goalAway: NSSegmentedControl!
    @IBOutlet weak var period: NSSegmentedControl!
    @IBOutlet weak var stepperSeconds: NSStepper!
    @IBOutlet weak var stepperMinutes: NSStepper!
    
    
    // MARK: - Functions
    
    // функция запоминает установленные параметры таймера из слайдера
    func setTimeDefault() {
        scoreboardData.timeUserPreset = sliderTimer.integerValue
        if isCountdown.state == .on {
            scoreboardData.timeNow = scoreboardData.timeUserPreset
        } else {
            scoreboardData.timeNow = 0
        }
    }
    
    // функция показывает время в поле (берет из таймера)
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
    
    // старый таймер (вынесен в файл TimerFunctions)
    //    var timerStatus: Timer?
    //    func startTimer(){
    //        if timerStatus == nil {
    //            timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
    //                if self.isCountdown.state == .on {
    //                    guard self.scoreboardData.timeNow > 0 else {
    //                        self.resetStateButtonStar()
    //                        self.setTimeDefault()
    //                        self.showTimeInLabel()
    //                        return
    //                    }
    //                    self.scoreboardData.timeNow -= 1
    //                } else {
    //                    // остановить таймер если выключен режим "футбола", когда таймер не останавливается
    //                    if self.continueTimeSwitcher.state == .off  {
    //                        guard self.scoreboardData.timeNow < self.scoreboardData.timeUserPreset else {
    //                            self.resetStateButtonStar()
    //                            self.setTimeDefault()
    //                            self.showTimeInLabel()
    //                            return
    //                        }
    //                    }
    //                    self.scoreboardData.timeNow += 1
    //                }
    //                self.showTimeInLabel()
    //            }
    //        }
    //    }
    //
    //    func stopTimer(){
    //        if timerStatus != nil {
    //            timerStatus?.invalidate()
    //            timerStatus = nil
    //        }
    //    }
    
    
    // Сброс всех параметров проги на умолчание
    func resetAllState(){
        resetStateButtonStar()
        setTimeDefault()
        showTimeInLabel()
        //        homeName = "Home"
        //        textFieldHomeName.stringValue = homeName
        //        awayName = "Away"
        //        textFieldAwayName.stringValue = awayName
        scoreboardData.countGoalHome = 0
        goalHome.setLabel(String(scoreboardData.countGoalHome), forSegment: 1)
        scoreboardData.countGoalAway = 0
        goalAway.setLabel(String(scoreboardData.countGoalAway), forSegment: 1)
        scoreboardData.periodCount = 1
        period.setLabel(String(scoreboardData.periodCount), forSegment: 1)
    }
    
    // Сброс кнопки СТАРТ на начальное значение + остановка таймера
    func resetStateButtonStar(){
        //        stopTimer()
        TimerFunctions.stopTimer()
        //TimerFunctions().stopTimer()
        buttonStart.title = "START"
        timerTextField.textColor = .controlTextColor
    }
    
    // click mouse in window for deselect text
    override func mouseDown(with: NSEvent) {
        //NSApp.mainWindow?.makeFirstResponder(nil) //снять выделения со всех элементов окна
        buttonStart.window?.makeFirstResponder(buttonStart)
        deselectTextInTextFileds()
    }
    
    //отменить выделение текста в полях NSTextFiled, так как фокус не связан с выделением (фокус на кнопке, а выделено назавание команды)
    func deselectTextInTextFileds() {
        homeNameTextField.currentEditor()?.selectedRange = NSMakeRange(0, 0)
        awayNameTextField.currentEditor()?.selectedRange = NSMakeRange(0, 0)
    }
    
    // пользовательское время не должно быть больше чем установленный таймер, только если включен режим "футбол"
    private func isAllowedChangeTime(newTime: Int) -> Bool {
        if continueTimeSwitcher.state == .on { return true }
        if scoreboardData.timeUserPreset >= newTime { return true }
        return false
    }
    
    // MARK: - Actions
    
    @IBAction func timeLabelAction(_ sender: Any) {
        buttonStart.window?.makeFirstResponder(buttonStart)
        
        // delete everything except digits
        var timeFromUserInLabel = Array(timerTextField.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
        
        // timer before changes
        var minutesFromUser:Int = scoreboardData.timeNow / 60
        var secondsFromUser:Int = scoreboardData.timeNow - ((scoreboardData.timeNow / 60) * 60)
        
        // if the user entered less than 4 digits, then fill in the missing values with 0
        if timeFromUserInLabel.count < 4 {
            for i in 0..<(4 - timeFromUserInLabel.count) {
                timeFromUserInLabel.insert("0", at: i)
            }
        }
        
        minutesFromUser = Int (String (timeFromUserInLabel [0...1])) ?? 0
        secondsFromUser = Int (String (timeFromUserInLabel [2...3])) ?? 0
    
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
        if goalHome.selectedSegment == 0, scoreboardData.countGoalHome > 0 {
            scoreboardData.countGoalHome -= 1
        }
        
        if goalHome.selectedSegment == 2 || goalHome.selectedSegment == -1 { // -1 когда передается действие из меню (не нажатие)
            scoreboardData.countGoalHome += 1
        }
        if goalHome.selectedSegment == 3 {
            scoreboardData.countGoalHome += 2
        }
        if goalHome.selectedSegment == 4 {
            scoreboardData.countGoalHome += 3
        }
        goalHome.selectedSegment = 1
        goalHome.setLabel(String(scoreboardData.countGoalHome), forSegment: 1)
    }
    
    @IBAction func goalAwayAction(_ sender: Any) {
        
        if goalAway.selectedSegment == 0, scoreboardData.countGoalAway > 0 {
            scoreboardData.countGoalAway -= 1
        }
        
        if goalAway.selectedSegment == 2  || goalAway.selectedSegment == -1 { // -1 когда передается действие из меню (не нажатие)
            scoreboardData.countGoalAway += 1
        }
        if goalAway.selectedSegment == 3 {
            scoreboardData.countGoalAway += 2
        }
        if goalAway.selectedSegment == 4 {
            scoreboardData.countGoalAway += 3
        }
        goalAway.selectedSegment = 1
        goalAway.setLabel(String(scoreboardData.countGoalAway), forSegment: 1)
    }
    
    @IBAction func periodAction(_ sender: Any) {
        if period.selectedSegment == 0, scoreboardData.periodCount > 1 {
            scoreboardData.periodCount -= 1
        }
        if period.selectedSegment == 2  || period.selectedSegment == -1 {
            scoreboardData.periodCount += 1
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
        buttonStart.window?.makeFirstResponder(buttonStart)
        deselectTextInTextFileds()
    }
    
    @IBAction func sliderTimerAction(_ sender: Any) {
        setTimeDefault()
        showTimeInLabel()
    }
    
    @IBAction func pushButtonStart(_ sender: Any) {
        buttonStart.window?.makeFirstResponder(buttonStart)
        deselectTextInTextFileds()
        
        if TimerFunctions.timerStatus == nil {
//            sliderTimer.isEnabled = false
            TimerFunctions.startTimer()
            buttonStart.title = "PAUSE"
            timerTextField.textColor = .red
            
            // disable App Nap
            activityAppNap = ProcessInfo().beginActivity(options: .userInitiatedAllowingIdleSystemSleep, reason: "Run timer in background")
            
        } else {
//            sliderTimer.isEnabled = true
            resetStateButtonStar()
            
            // enable App Nap
            if let pinfo = activityAppNap { ProcessInfo().endActivity(pinfo) }
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
        goalHome.setLabel(String(scoreboardData.countGoalHome), forSegment: 1)
        goalAway.setLabel(String(scoreboardData.countGoalAway), forSegment: 1)
    }
    
    // MARK:- Menu action
    
    @IBAction func startPauseTimerFromMenu(_ sender: Any) {
        pushButtonStart(self)
    }
    
    @IBAction func plus1SecFromMenu(_ sender: Any) {
        guard isAllowedChangeTime(newTime: scoreboardData.timeNow + 1) else { return }
        scoreboardData.timeNow += 1
        showTimeInLabel()
    }
    
    @IBAction func minus1SecFromMenu(_ sender: Any) {
        guard scoreboardData.timeNow > 0 else { return }
        scoreboardData.timeNow -= 1
        showTimeInLabel()
    }
    
    @IBAction func plus1MinFromMenu(_ sender: Any) {
        guard isAllowedChangeTime(newTime: scoreboardData.timeNow + 60) else { return }
        scoreboardData.timeNow += 60
        showTimeInLabel()
    }
    
    @IBAction func minus1MinFromMenu(_ sender: Any) {
        guard scoreboardData.timeNow >= 60 else { return }
        scoreboardData.timeNow -= 60
        showTimeInLabel()
    }
    
    @IBAction func resetAllStateFromMenu(_ sender: Any) {
        resetButtonPush(self)
    }
    
    @IBAction func plus1GoalHomeFromMenu(_ sender: Any) {
        goalHome.selectedSegment = 2
        goalHomeAction(self)
    }
    
    @IBAction func plus1GoalAwayFromMenu(_ sender: Any) {
        goalAway.selectedSegment = 2
        goalAwayAction(self)
    }
    
    @IBAction func plus1PeriodFromMenu(_ sender: Any) {
        period.selectedSegment = 2
        periodAction(self)
    }
    
    
}

