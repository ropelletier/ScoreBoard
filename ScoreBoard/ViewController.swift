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
        
        textFieldTimer.font = NSFont.monospacedDigitSystemFont(ofSize: 30, weight: .regular) // настройка шрифта таймера (одинаковая ширина символа)
        
        //UserDefaults.standard.register(defaults: ["pathToUserDirectory" : FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!])
        //UserDefaults.standard.removeObject(forKey: "bookmarkForDirecory")
        pathToWorkDirectory.url = restoreBookmarksPathDirectory() // выставляем директорию Downloads по умолчанию
        
        writeFilesToDisk(.homeName, .awayName, .period, .homeGoal, .awayGoal)
        
        sliderTimer.integerValue = timeUserPreset // возвращаем состояние слайдера до закрытия проги
        showTimeInLabel() //при запуске выставляем таймер по умолчанию + пишем файл с таймером
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
    @IBOutlet weak var continueTimeSwitcher: NSSwitch!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var swapScores: NSButton!
    @IBOutlet weak var sliderTimer: NSSlider!
    @IBOutlet weak var textFieldHomeName: NSTextField!
    @IBOutlet weak var textFieldAwayName: NSTextField!
    @IBOutlet weak var goalHome: NSSegmentedControl!
    @IBOutlet weak var goalAway: NSSegmentedControl!
    @IBOutlet weak var period: NSSegmentedControl!
    @IBOutlet weak var stepperSeconds: NSStepper!
    @IBOutlet weak var stepperMinutes: NSStepper!
    @IBOutlet weak var pathToWorkDirectory: NSPathControl!
    
    
// параметры по умолчанию
    var timeUserPreset: Int {
        get {
            UserDefaults.standard.register(defaults: ["timeUserPreset" : 900])
            return UserDefaults.standard.integer(forKey: "timeUserPreset")
        } set {
            UserDefaults.standard.set(newValue, forKey: "timeUserPreset")
        }
    }
    lazy var timeNow: Int = timeUserPreset
    var homeName: String = "Home"
    var awayName: String = "Away"
    var countGoalHome: Int = 0
    var countGoalAway: Int = 0
    var periodCount: Int = 1
    
    
    // MARK: - FUNCtions

// newWrite сохранить закладку
    func saveBookmarksPathDirectory(_ userDirectoryUrl:URL) {
        
        // открыть панель выбора файла
//        let panel = NSOpenPanel()
//        panel.canChooseDirectories = true
//        panel.canChooseFiles = false
//        panel.prompt = "Select"
//        guard panel.runModal() == NSApplication.ModalResponse.OK else { return }
//        guard let userDirectoryUrl = panel.url else { return }
        
        // добавить название папки к пути выбранному пользователем
        //pathDirectory.url = userDirectoryUrl.appendingPathComponent("ScoreBoard Outputs")
        //guard let userDirectoryUrl = pathDirectory.url else { return }
        
        // сохраняем закладку безопасности на будущее
        do {
            let bookmark = try userDirectoryUrl.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmark, forKey: "bookmarkForDirecory")
            print("закладка сохранилась успешно: \(userDirectoryUrl)")
        } catch { return }
    }
    
// newWrite восстановить закладку
    func restoreBookmarksPathDirectory() -> URL? {
        guard let bookmark = UserDefaults.standard.data(forKey: "bookmarkForDirecory")
            else { return FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first } // каталог downloads по умолчанию
        var bookmarkDataIsStale: ObjCBool = false
        
        do {
           let userDirectoryUrl = try (NSURL(resolvingBookmarkData: bookmark, options: [.withoutUI, .withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale) as URL)
            
            if bookmarkDataIsStale.boolValue { return nil }
            
            guard userDirectoryUrl.startAccessingSecurityScopedResource() else { return nil }
            
            print("закладка открыта успешно: \(userDirectoryUrl)")
            return userDirectoryUrl
            
        } catch { return nil }
    }
    
// newWrite перечисление файлов для записи
    enum FilesToWrite {
        case timer, homeName, awayName, period, homeGoal, awayGoal
    }
    
// newWrite запись файлов
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
                    text = textFieldTimer.stringValue
                    fileName = "Timer.txt"
                    case .homeName:
                       text = homeName
                       fileName = "Home_Name.txt"
                    case .awayName:
                       text = awayName
                       fileName = "Away_Name.txt"
                    case .period:
                       text = String(periodCount)
                       fileName = "Period.txt"
                    case .homeGoal:
                       text = String(countGoalHome)
                       fileName = "HomeGoal.txt"
                    case .awayGoal:
                       text = String(countGoalAway)
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
    
    
//    func writeToDisk(_ fileName:String) {
//        do {
//            //if var userDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
//            if var userDirectory = userDirectoryDefault {
//            //if var userDirectory = restoreFileAccess(with: UserDefaults.standard.data(forKey: "bookmarkData")!) {
//                userDirectory = userDirectory.appendingPathComponent("ScoreBoard Outputs")
//
//                // проверка на существование папки (создаем если ее нет иначе пропускаем)
//                if FileManager().fileExists(atPath: userDirectory.path) {
//                } else {
//                    try FileManager.default.createDirectory(at: userDirectory, withIntermediateDirectories: true, attributes: nil)
//                }
//
//                switch fileName {
//                    case "time":
//                        try textFieldTimer.stringValue.write(to: userDirectory.appendingPathComponent("Time.txt"), atomically: false, encoding: .utf8)
//
//                    case "period":
//                        try String(periodCount).write(to: userDirectory.appendingPathComponent("Period.txt"), atomically: false, encoding: .utf8)
//
//                    case "homeName":
//                        try homeName.write(to: userDirectory.appendingPathComponent("HomeName.txt"), atomically: false, encoding: .utf8)
//
//                    case "awayName":
//                        try awayName.write(to: userDirectory.appendingPathComponent("AwayName.txt"), atomically: false, encoding: .utf8)
//
//                    case "homeGoal":
//                        try String(countGoalHome).write(to: userDirectory.appendingPathComponent("HomeGoal.txt"), atomically: false, encoding: .utf8)
//
//                    case "awayGoal":
//                        try String(countGoalAway).write(to: userDirectory.appendingPathComponent("AwayGoal.txt"), atomically: false, encoding: .utf8)
//
//                    case "all":
//                        try textFieldTimer.stringValue.write(to: userDirectory.appendingPathComponent("Time.txt"), atomically: false, encoding: .utf8)
//                        try String(periodCount).write(to: userDirectory.appendingPathComponent("Period.txt"), atomically: false, encoding: .utf8)
//                        try homeName.write(to: userDirectory.appendingPathComponent("HomeName.txt"), atomically: false, encoding: .utf8)
//                        try awayName.write(to: userDirectory.appendingPathComponent("AwayName.txt"), atomically: false, encoding: .utf8)
//                        try String(countGoalHome).write(to: userDirectory.appendingPathComponent("HomeGoal.txt"), atomically: false, encoding: .utf8)
//                        try String(countGoalAway).write(to: userDirectory.appendingPathComponent("AwayGoal.txt"), atomically: false, encoding: .utf8)
//
//                default:
//                    let alert = NSAlert()
//                    alert.messageText = "Invalid parameter"
//                    alert.informativeText = "It was not possible to write the file, because the parameter is incorrectly specified: \(fileName)"
//                    alert.addButton(withTitle: "OK")
//                    alert.alertStyle = .warning
//                    alert.runModal()
//                }
//            }
//
//        } catch {
//            let alert = NSAlert()
//            alert.messageText = "Unable to write file"
//            alert.informativeText = """
//            There is no access to the directory for writing.
//            Give the program access to write files to disk:
//
//            System Preferences > Security and Privacy > Privacy > Files and Folders
//
//            Check the box for the program "ScoreBoard.app".
//
//            """
//            alert.addButton(withTitle: "OK")
//            alert.alertStyle = .warning
//            alert.runModal()
//        }
//    }
    
    // функция запоминает установленные параметры таймера из слайдера
    func setTimeDefault() {
        timeUserPreset = sliderTimer.integerValue
        if switchTimerMode.state == .on {
            //timeNow = sliderTimer.integerValue // зачем снова опрашивать слайдер? но так можно
            timeNow = timeUserPreset
        } else {
            timeNow = 0
        }
    }
    
    // функция показывает время в поле (берет из таймера)
    func showTimeInLabel() {
        
        stepperSeconds.integerValue = timeNow //сохраняет время для степперов
        stepperMinutes.integerValue = timeNow

        let minutes:Int = timeNow / 60
        let seconds:Int = timeNow - (minutes*60)
        var minStr:String = "\(minutes)"
        var secStr:String = "\(seconds)"
            
        // проверки МИНУТ и СЕКУНД на отсутсвие нулей (0:45 -> 01:45)
        if minutes < 10 {
            minStr = "0" + minStr
        }
        if seconds < 10 {
            secStr = "0" + secStr
        }
        textFieldTimer.stringValue = minStr + ":" + secStr //вывод времени в формате 00:00 в поле
        writeFilesToDisk(.timer) // это команда дублируется часто в других местах...
    }
    
    var timerStatus: Timer? //две функции для таймера (старт/стоп)
    func startTimer(){
      if timerStatus == nil {
            timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            (timer) in
                if self.switchTimerMode.state == .on {
                    guard self.timeNow > 0 else {
                        self.resetStateButtonStar()
                        return
                    }
                    self.timeNow -= 1
                } else {
                    guard self.timeNow < self.timeUserPreset else {
                        if self.continueTimeSwitcher.state == .on { self.timeUserPreset += self.timeUserPreset }
                        self.resetStateButtonStar()
                        return
                    }
                    self.timeNow += 1
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
//        homeName = "Home"
//        textFieldHomeName.stringValue = homeName
//        awayName = "Away"
//        textFieldAwayName.stringValue = awayName
        countGoalHome = 0
        goalHome.setLabel(String(countGoalHome), forSegment: 1)
        countGoalAway = 0
        goalAway.setLabel(String(countGoalAway), forSegment: 1)
        periodCount = 1
        period.setLabel(String(periodCount), forSegment: 1)
        writeFilesToDisk(.homeName, .awayName, .period, .homeGoal, .awayGoal)
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
        goalHome.setLabel(String(countGoalHome), forSegment: 1)
        writeFilesToDisk(.homeGoal)
    }
    
    @IBAction func goalAwayAction(_ sender: Any) {
        if goalAway.selectedSegment == 0, countGoalAway > 0 {
            countGoalAway -= 1
        }
        if goalAway.selectedSegment == 2  || goalAway.selectedSegment == -1 {
            countGoalAway += 1
        }
        goalAway.setLabel(String(countGoalAway), forSegment: 1)
        writeFilesToDisk(.awayGoal)
    }
    
    @IBAction func periodAction(_ sender: Any) {
        if period.selectedSegment == 0, periodCount > 1 {
            periodCount -= 1
        }
        if period.selectedSegment == 2  || period.selectedSegment == -1 {
            periodCount += 1
        }
        period.setLabel(String(periodCount), forSegment: 1)
        writeFilesToDisk(.period)
    }
    
    @IBAction func textFieldHomeNameAction(_ sender: Any) {
        homeName = textFieldHomeName.stringValue
        writeFilesToDisk(.homeName)
    }
    
    @IBAction func textFieldAwayNameAction(_ sender: Any) {
        awayName = textFieldAwayName.stringValue
        writeFilesToDisk(.awayName)
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
            continueTimeSwitcher.state = .off
            continueTimeSwitcher.isEnabled = false
        } else {
            titleTimerMode.stringValue = "Countdown: OFF"
            continueTimeSwitcher.isEnabled = true
        }
        timeNow = timeUserPreset - timeNow  // смена времени на табло с сохранением пройденных секунд
        showTimeInLabel()
    }
    
    @IBAction func selectUserDirectory(_ sender: Any) {
        guard let userDirectoryUrl = pathToWorkDirectory.url else { return }
        saveBookmarksPathDirectory(userDirectoryUrl)
    }
    
    @IBAction func resetButtonPush(_ sender: Any) {
        resetAllState()
    }
    
    @IBAction func swapHomeAwayScores(_ sender: Any) {
        swap(&homeName, &awayName)
        textFieldHomeName.stringValue = homeName
        textFieldAwayName.stringValue = awayName
        swap(&countGoalHome, &countGoalAway)
        goalHome.setLabel(String(countGoalHome), forSegment: 1)
        goalAway.setLabel(String(countGoalAway), forSegment: 1)
        writeFilesToDisk(.homeName, .awayName, .homeGoal, .awayGoal)
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
        guard timeNow > 0 else { return }
        timeNow -= 1
        showTimeInLabel()
    }
    
    @IBAction func plus1MinFromMenu(_ sender: Any) {
        timeNow += 60
        showTimeInLabel()
        //stepperMinutesAction.()
    }
    
    @IBAction func minus1MinFromMenu(_ sender: Any) {
        guard timeNow > 60 else { return }
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

