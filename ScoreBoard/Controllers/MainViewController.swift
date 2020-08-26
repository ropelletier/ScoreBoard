//
//  ViewController.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 27.12.2019.
//  Copyright © 2019 Vasily Petuhov. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UserDefaults.standard.removeObject(forKey: "homeName")
        
        sliderTimer.integerValue = ScoreBoardData.timeUserPreset // возвращаем состояние слайдера до закрытия проги
        homeNameTextField.stringValue = ScoreBoardData.homeName
        awayNameTextField.stringValue = ScoreBoardData.awayName
        
        if isCountdown.state == .on {
            TimerFunctions.isCountdownState = true
        } else { TimerFunctions.isCountdownState = false }
        
        showTimeInLabel() //при запуске выставляем таймер по умолчанию + пишем файл с таймером
        
        timerTextField.font = NSFont.monospacedDigitSystemFont(ofSize: 30, weight: .regular) // настройка шрифта таймера (одинаковая ширина символа)
        
        WriteFilesToDisk().writeFile(.homeName, .awayName, .period, .homeGoal, .awayGoal)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
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
    @IBOutlet weak var homeNameTextField: NSTextField!
    @IBOutlet weak var awayNameTextField: NSTextField!
    @IBOutlet weak var goalHome: NSSegmentedControl!
    @IBOutlet weak var goalAway: NSSegmentedControl!
    @IBOutlet weak var period: NSSegmentedControl!
    @IBOutlet weak var stepperSeconds: NSStepper!
    @IBOutlet weak var stepperMinutes: NSStepper!
    
    
    // MARK: - FUNCtions
    
    // функция запоминает установленные параметры таймера из слайдера
    func setTimeDefault() {
        ScoreBoardData.timeUserPreset = sliderTimer.integerValue
        if isCountdown.state == .on {
            ScoreBoardData.timeNow = ScoreBoardData.timeUserPreset
        } else {
            ScoreBoardData.timeNow = 0
        }
    }
    
    // функция показывает время в поле (берет из таймера)
    func showTimeInLabel() {
        
        stepperSeconds.integerValue = ScoreBoardData.timeNow //сохраняет время для степперов
        stepperMinutes.integerValue = ScoreBoardData.timeNow
        
        let minutes:Int = ScoreBoardData.timeNow / 60
        let seconds:Int = ScoreBoardData.timeNow - (minutes*60)
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
        ScoreBoardData.timerString = minStr + ":" + secStr //timerTextField.stringValue
    }
    
    var timerStatus: Timer?
    func startTimer(){
        if timerStatus == nil {
            timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                if self.isCountdown.state == .on {
                    guard ScoreBoardData.timeNow > 0 else {
                        self.resetStateButtonStar()
                        return
                    }
                    ScoreBoardData.timeNow -= 1
                } else {
                    // остановить таймер если выключен режим "футбола" (продолжать отсчет)
                    if self.continueTimeSwitcher.state == .off  {
                        guard ScoreBoardData.timeNow < ScoreBoardData.timeUserPreset else {
                            self.resetStateButtonStar()
                            return
                        }
                    }
                    ScoreBoardData.timeNow += 1
                }
                self.showTimeInLabel()
            }
        }
    }
    
    func stopTimer(){
        if timerStatus != nil {
            timerStatus?.invalidate()
            timerStatus = nil
        }
    }
    
    // Сброс кнопки СТАРТ на начальное значение + остановка таймера
    func resetStateButtonStar(){
        stopTimer()
        //TimerFunctions().stopTimer()
        buttonStart.title = "START"
        timerTextField.textColor = .black
    }
    
    // Сброс всех параметров проги на умолчание
    func resetAllState(){
        resetStateButtonStar()
        setTimeDefault()
        showTimeInLabel()
        //        homeName = "Home"
        //        textFieldHomeName.stringValue = homeName
        //        awayName = "Away"
        //        textFieldAwayName.stringValue = awayName
        ScoreBoardData.countGoalHome = 0
        goalHome.setLabel(String(ScoreBoardData.countGoalHome), forSegment: 1)
        ScoreBoardData.countGoalAway = 0
        goalAway.setLabel(String(ScoreBoardData.countGoalAway), forSegment: 1)
        ScoreBoardData.periodCount = 1
        period.setLabel(String(ScoreBoardData.periodCount), forSegment: 1)
    }
    
    // клик мышкой
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
    
    // MARK: - ACTIONS
    
    @IBAction func timeLabelAction(_ sender: Any) {
        var timeFromUserInLabel = Array(timerTextField.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()) //убирает все кроме цифр
        
        // запоминает время до изменения
        var minutesFromUser:Int = ScoreBoardData.timeNow / 60
        var secondsFromUser:Int = ScoreBoardData.timeNow - ((ScoreBoardData.timeNow / 60) * 60)
        
        if timeFromUserInLabel.count < 3 { //проверка на количество цифр, не меннее 3-ех (минуты:секунды), иначе ,будет краш проги
            showTimeInLabel()
        }
        
        if timeFromUserInLabel.count >= 4 { // если пользователь ввел 4 или больше знаков
            minutesFromUser = Int (String (timeFromUserInLabel [0...1]))!
            secondsFromUser = Int (String (timeFromUserInLabel [2...3]))!
        }
        
        if timeFromUserInLabel.count == 3 { // если пользователь ввел 3 знака
            timeFromUserInLabel.insert("0", at: 0)
            minutesFromUser = Int (String (timeFromUserInLabel [0...1]))!
            secondsFromUser = Int (String (timeFromUserInLabel [2...3]))!
        }
        
        ScoreBoardData.timeNow = (minutesFromUser * 60) + secondsFromUser
        showTimeInLabel()
    }
    
    @IBAction func stepperSecondsAction(_ sender: Any) {
        ScoreBoardData.timeNow = stepperSeconds.integerValue
        showTimeInLabel()
    }
    
    @IBAction func stepperMinutesAction(_ sender: Any) {
        ScoreBoardData.timeNow = stepperMinutes.integerValue
        showTimeInLabel()
    }
    
    @IBAction func goalHomeAction(_ sender: Any) {
        if goalHome.selectedSegment == 0, ScoreBoardData.countGoalHome > 0 {
            ScoreBoardData.countGoalHome -= 1
        }
        if goalHome.selectedSegment == 2 || goalHome.selectedSegment == -1 { // -1 когда передается действие из меню (не нажатие)
            ScoreBoardData.countGoalHome += 1
        }
        goalHome.setLabel(String(ScoreBoardData.countGoalHome), forSegment: 1)
    }
    
    @IBAction func goalAwayAction(_ sender: Any) {
        if goalAway.selectedSegment == 0, ScoreBoardData.countGoalAway > 0 {
            ScoreBoardData.countGoalAway -= 1
        }
        if goalAway.selectedSegment == 2  || goalAway.selectedSegment == -1 {
            ScoreBoardData.countGoalAway += 1
        }
        goalAway.setLabel(String(ScoreBoardData.countGoalAway), forSegment: 1)
    }
    
    @IBAction func periodAction(_ sender: Any) {
        if period.selectedSegment == 0, ScoreBoardData.periodCount > 1 {
            ScoreBoardData.periodCount -= 1
        }
        if period.selectedSegment == 2  || period.selectedSegment == -1 {
            ScoreBoardData.periodCount += 1
        }
        period.setLabel(String(ScoreBoardData.periodCount), forSegment: 1)
    }
    
    @IBAction func textFieldHomeNameAction(_ sender: Any) {
        ScoreBoardData.homeName = homeNameTextField.stringValue
        awayNameTextField.becomeFirstResponder()
    }
    
    @IBAction func textFieldAwayNameAction(_ sender: Any) {
        ScoreBoardData.awayName = awayNameTextField.stringValue
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

        //sliderTimer.isEnabled = false
        if timerStatus == nil {
            buttonStart.title = "PAUSE"
            timerTextField.textColor = .red
            startTimer()
            //TimerFunctions().startTimer()
        } else {
            resetStateButtonStar()
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
        ScoreBoardData.timeNow = ScoreBoardData.timeUserPreset - ScoreBoardData.timeNow
        showTimeInLabel()
    }
    
    @IBAction func resetButtonPush(_ sender: Any) {
        resetAllState()
    }
    
    @IBAction func swapHomeAwayScores(_ sender: Any) {
        swap(&ScoreBoardData.homeName, &ScoreBoardData.awayName)
        homeNameTextField.stringValue = ScoreBoardData.homeName
        awayNameTextField.stringValue = ScoreBoardData.awayName
        swap(&ScoreBoardData.countGoalHome, &ScoreBoardData.countGoalAway)
        goalHome.setLabel(String(ScoreBoardData.countGoalHome), forSegment: 1)
        goalAway.setLabel(String(ScoreBoardData.countGoalAway), forSegment: 1)
    }
    
    // MARK:- Menu action
    
    @IBAction func startPauseTimerFromMenu(_ sender: Any) {
        pushButtonStart(self)
    }
    
    @IBAction func plus1SecFromMenu(_ sender: Any) {
        ScoreBoardData.timeNow += 1
        showTimeInLabel()
    }
    
    @IBAction func minus1SecFromMenu(_ sender: Any) {
        guard ScoreBoardData.timeNow > 0 else { return }
        ScoreBoardData.timeNow -= 1
        showTimeInLabel()
    }
    
    @IBAction func plus1MinFromMenu(_ sender: Any) {
        ScoreBoardData.timeNow += 60
        showTimeInLabel()
        //stepperMinutesAction.()
    }
    
    @IBAction func minus1MinFromMenu(_ sender: Any) {
        guard ScoreBoardData.timeNow > 60 else { return }
        ScoreBoardData.timeNow -= 60
        showTimeInLabel()
    }
    
    @IBAction func resetAllStateFromMenu(_ sender: Any) {
        resetButtonPush(self)
    }
    
    @IBAction func plus1GoalHomeFromMenu(_ sender: Any) {
        goalHomeAction(self)
    }
    
    @IBAction func plus1GoalAwayFromMenu(_ sender: Any) {
        goalAwayAction(self)
    }
    
    @IBAction func plus1PeriodFromMenu(_ sender: Any) {
        periodAction(self)
    }
    
    
}

