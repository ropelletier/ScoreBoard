//
//  ViewController.swift
//  ScoreBoard
//
//  Created by Василий Петухов on 27.12.2019.
//  Copyright © 2019 Vasily Petuhov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTimeDefault() // сразу запоминаем время по умолчанию
        showTimeInLabel() //при запуске выставляем таймер по умолчанию
        writeToDisk("all") //создаем папку + все файлы
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
        // MARK: - IBOutlet
    @IBOutlet weak var textFieldTimer: NSTextField!
    @IBOutlet weak var buttonStart: NSButton!
    @IBOutlet weak var switchTimerMode: NSSwitch!
    @IBOutlet weak var titleTimerMode: NSTextField!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var sliderTimer: NSSlider!
    @IBOutlet weak var textFieldHomeName: NSTextField!
    @IBOutlet weak var textFieldAwayName: NSTextField!
    @IBOutlet weak var goalHome: NSSegmentedControl!
    @IBOutlet weak var goalAway: NSSegmentedControl!
    @IBOutlet weak var period: NSSegmentedControl!
    @IBOutlet weak var stepperSeconds: NSStepper!
    @IBOutlet weak var stepperMinutes: NSStepper!
    
    //lazy var timeUserPreset:Int = sliderTimer.integerValue //900 секунд по умолчанию в свойствах слайдера
    //lazy var timeNow:Int = sliderTimer.integerValue //900 секунд по умолчанию в свойствах слайдера
    
    // параметры по умолчанию
    var timeUserPreset:Int = 900 //900 секунд по умолчанию в свойствах слайдера
    var timeNow:Int = 900 //900 секунд по умолчанию в свойствах слайдера
    var homeName:String = "Home"
    var awayName:String = "Away"
    var countGoalHome:Int = 0
    var countGoalAway:Int = 0
    var periodCount:Int = 1
    
    // MARK: - FUNCtions
    
    func writeToDisk(_ fileName:String) {
        
        do {
            if var userDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                userDirectory = userDirectory.appendingPathComponent("Трансляции/ScoreBoard Outputs")
                
                // проверка на существование папки (создаем если ее нет иначе пропускаем)
                if FileManager().fileExists(atPath: userDirectory.path) {
                } else {
                    try FileManager.default.createDirectory(at: userDirectory, withIntermediateDirectories: true, attributes: nil)
                }
                
                switch fileName {
                    case "time":
                        try textFieldTimer.stringValue.write(to: userDirectory.appendingPathComponent("Time.txt"), atomically: false, encoding: .utf8)
                
                    case "period":
                        try String(periodCount).write(to: userDirectory.appendingPathComponent("Period.txt"), atomically: false, encoding: .utf8)
                    
                    case "homeName":
                        try homeName.write(to: userDirectory.appendingPathComponent("HomeName.txt"), atomically: false, encoding: .utf8)
                    
                    case "awayName":
                        try awayName.write(to: userDirectory.appendingPathComponent("AwayName.txt"), atomically: false, encoding: .utf8)
                
                    case "homeGoal":
                        try String(countGoalHome).write(to: userDirectory.appendingPathComponent("HomeGoal.txt"), atomically: false, encoding: .utf8)
                    
                    case "awayGoal":
                        try String(countGoalAway).write(to: userDirectory.appendingPathComponent("AwayGoal.txt"), atomically: false, encoding: .utf8)
                    
                    case "all":
                        try textFieldTimer.stringValue.write(to: userDirectory.appendingPathComponent("Time.txt"), atomically: false, encoding: .utf8)
                        try String(periodCount).write(to: userDirectory.appendingPathComponent("Period.txt"), atomically: false, encoding: .utf8)
                        try homeName.write(to: userDirectory.appendingPathComponent("HomeName.txt"), atomically: false, encoding: .utf8)
                        try awayName.write(to: userDirectory.appendingPathComponent("AwayName.txt"), atomically: false, encoding: .utf8)
                        try String(countGoalHome).write(to: userDirectory.appendingPathComponent("HomeGoal.txt"), atomically: false, encoding: .utf8)
                        try String(countGoalAway).write(to: userDirectory.appendingPathComponent("AwayGoal.txt"), atomically: false, encoding: .utf8)
                    
                default:
                    let alert = NSAlert()
                    alert.messageText = "Invalid parameter"
                    alert.informativeText = "It was not possible to write the file, because the parameter is incorrectly specified: \(fileName)"
                    alert.addButton(withTitle: "OK")
                    alert.alertStyle = .warning
                    alert.runModal()
                }
            }
            
        } catch {
            let alert = NSAlert()
            alert.messageText = "Unable to write file"
            alert.informativeText = "There is no access to the directory for writing or the path is incorrect"
            alert.addButton(withTitle: "OK")
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
    
    //старая моя функция для записи файлов
//    func writeFileToDisk(nameFile:String, textToWrite:String) {
//        //if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//        if var dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
//            // если папки нет, записать не сможет
//            dir = dir.appendingPathComponent("ScoreBoard Outputs")
//            let fileURL = dir.appendingPathComponent(nameFile)
//
//            //writing
//            do {
//                try textToWrite.write(to: fileURL, atomically: false, encoding: .utf8)
//                //print(fileURL)
//                //print("записан файл")
//            }
//            catch {/* error handling here */
//               // print(fileURL)
//                print("не удалось записать файл: \(error)")
//            }
//                    //reading
//        //            do {
//        //                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
//        //            }
//        //            catch {/* error handling here */}
//        }
//
//    }
    
    // функция запоминает установленные параметры таймера из слайдера
    func setTimeDefault() {
        timeUserPreset = sliderTimer.integerValue
        if switchTimerMode.state == .on {
            timeNow = sliderTimer.integerValue
        } else {
            timeNow = 0
        }
    }
    
    // функция показывает время в поле (берет из таймера)
    func showTimeInLabel() -> Void {
        
        stepperSeconds.integerValue = timeNow //сохраняет время для степперов
        stepperMinutes.integerValue = timeNow
        
        let minutes:Int = timeNow / 60
        let seconds:Int = timeNow - (minutes*60)
        var minStr:String = "\(minutes)"
        var secStr:String = "\(seconds)"
            
        // проверки МИНУТ и СЕКУНД на отсутсвие нулей (0:45 -> 01:45)
        // МОЖНО через SWITCH сделать, чтобы значение отслеживать
        if minutes < 10 {
            minStr = "0" + minStr
        }
        if seconds < 10 {
            secStr = "0" + secStr
        }
        textFieldTimer.stringValue = minStr + ":" + secStr //вывод времени в формате 00:00 в поле
        //writeFileToDisk(nameFile:"Time.txt", textToWrite:textFieldTimer.stringValue)
        writeToDisk("time")
    }
    
    var timerStatus: Timer? //две функции для таймера (старт/стоп)
    func startTimer(){
      if timerStatus == nil {
            timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            (timer) in
                if self.switchTimerMode.state == .on {
                    
                        self.timeNow -= 1
                    if self.timeNow <= 0 {
                        //self.stopTimer()
                        self.resetStateButtonStar()
                    }
                    
                } else {
                    self.timeNow += 1
                    if self.timeNow >= self.timeUserPreset {
                        //self.stopTimer()
                        self.resetStateButtonStar()
                    }
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
        buttonStart.title = "START"
        textFieldTimer.textColor = .black
    }
    
    // Сброс всех параметров проги на умолчание
    func resetAllState(){
        resetStateButtonStar()
        setTimeDefault()
        showTimeInLabel()
        homeName = "Home"
        textFieldHomeName.stringValue = homeName
        awayName = "Away"
        textFieldAwayName.stringValue = awayName
        countGoalHome = 0
        goalHome.setLabel(String(countGoalHome), forSegment: 1)
        countGoalAway = 0
        goalAway.setLabel(String(countGoalAway), forSegment: 1)
        periodCount = 1
        period.setLabel(String(periodCount), forSegment: 1)
        writeToDisk("all")
    }
    
    // MARK: - ACTIONS
    
    @IBAction func timeLabelAction(_ sender: Any) {
        var timeFromUserInLabel = Array (textFieldTimer.stringValue.components(separatedBy:CharacterSet.decimalDigits.inverted)
            .joined()) //убирает все кроме цифр
        
        //надо сразу чистить массив чтобы не было лишнего .map .sort и тд
        
        // запоминает время до изменения
        var minutesFromUser:Int = timeNow / 60
        var secondsFromUser:Int = timeNow - ((timeNow / 60) * 60)
        
        
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
        timeNow = (minutesFromUser * 60) + secondsFromUser
        showTimeInLabel()
    }
    
    @IBAction func stepperSecondsAction(_ sender: Any) {
        timeNow = stepperSeconds.integerValue
        showTimeInLabel()
    }
    
    
    @IBAction func stepperMinutesAction(_ sender: Any) {
        timeNow = stepperMinutes.integerValue
        showTimeInLabel()
    }
    
    @IBAction func goalHomeAction(_ sender: Any) {
        if goalHome.selectedSegment == 0, countGoalHome > 0 {
            countGoalHome -= 1
        }
        if goalHome.selectedSegment == 2 || goalHome.selectedSegment == -1 { // -1 когда передается действие из меню (не нажатие)
            countGoalHome += 1
        }
        //writeFileToDisk(nameFile:"HomeScore.txt", textToWrite: String(countGoalHome))
        goalHome.setLabel(String(countGoalHome), forSegment: 1)
        writeToDisk("homeGoal")
    }
    
    @IBAction func goalAwayAction(_ sender: Any) {
        if goalAway.selectedSegment == 0, countGoalAway > 0 {
            countGoalAway -= 1
        }
        if goalAway.selectedSegment == 2  || goalAway.selectedSegment == -1 {
            countGoalAway += 1
        }
        //writeFileToDisk(nameFile:"AwayScore.txt", textToWrite: String(countGoalAway))
        goalAway.setLabel(String(countGoalAway), forSegment: 1)
        writeToDisk("awayGoal")
    }
    
    @IBAction func periodAction(_ sender: Any) {
        if period.selectedSegment == 0, periodCount > 1 {
            periodCount -= 1
        }
        if period.selectedSegment == 2  || period.selectedSegment == -1 {
            periodCount += 1
        }
        //writeFileToDisk(nameFile:"Period.txt", textToWrite: String(periodCount))
        period.setLabel(String(periodCount), forSegment: 1)
        writeToDisk("period")
    }
    
    @IBAction func textFieldHomeNameAction(_ sender: Any) {
        homeName = textFieldHomeName.stringValue
        //writeFileToDisk(nameFile:"HomeName.txt", textToWrite:textFieldHomeName.stringValue)
        writeToDisk("homeName")

    }
    
    @IBAction func textFieldAwayNameAction(_ sender: Any) {
        awayName = textFieldAwayName.stringValue
        //writeFileToDisk(nameFile:"AwayName.txt", textToWrite:textFieldAwayName.stringValue)
        writeToDisk("awayName")
    }
    
    @IBAction func sliderTimerAction(_ sender: Any) {
        setTimeDefault()
        showTimeInLabel()
    }
    
    @IBAction func pushButtonStart(_ sender: Any) {
        //sliderTimer.isEnabled = false
        if timerStatus == nil {
            buttonStart.title = "PAUSE"
            textFieldTimer.textColor = .red
            startTimer()
        } else {
            resetStateButtonStar()
        }
    }
    
    @IBAction func switchTimerOnOff(_ sender: Any) {
        if switchTimerMode.state == .on {
            titleTimerMode.stringValue = "Countdown: ON"
        } else {
            titleTimerMode.stringValue = "Countdown: OFF"
        }
        setTimeDefault()
        showTimeInLabel()
    }
    
    @IBAction func resetButtonPush(_ sender: Any) {
        resetAllState()
    }
    
// MARK:- Menu action
    
    @IBAction func startPauseTimerFromMenu(_ sender: Any) {
        pushButtonStart(self)
    }
    
    @IBAction func plus1SecFromMenu(_ sender: Any) {
        timeNow += 1
        showTimeInLabel()
    }
    
    @IBAction func minus1SecFromMenu(_ sender: Any) {
        timeNow -= 1
        showTimeInLabel()
    }
    
    @IBAction func plus1MinFromMenu(_ sender: Any) {
        timeNow += 60
        showTimeInLabel()
        //stepperMinutesAction.()
    }
    
    @IBAction func minus1MinFromMenu(_ sender: Any) {
        timeNow -= 60
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

