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
        
        showTimeInLabel() //при запуске выставляем таймер по умолчанию
        
        //получение нажатия кнопки в меню
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("menuPushStart"), object: nil, queue: OperationQueue.main){
//            (notification) in
//            //self.startTimer()
//            //self.resetStateButtonStar()
//            //self.pushButtonStart(self)
//            print("Hello")
//        }
        
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
        // MARK: - IBOutlet
    @IBOutlet weak var textFieldTimer: NSTextField!
    @IBOutlet weak var buttonStart: NSButton!
    @IBOutlet weak var switchTimer: NSSwitch!
    @IBOutlet weak var titleForTimer: NSTextField!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var sliderTimer: NSSlider!
    @IBOutlet weak var textFieldHomeName: NSTextField!
    @IBOutlet weak var textFieldAwayName: NSTextField!
    @IBOutlet weak var goalHome: NSSegmentedControl!
    @IBOutlet weak var goalAway: NSSegmentedControl!
    @IBOutlet weak var period: NSSegmentedControl!
    
    // тестовая кнопка
    @IBOutlet weak var testButton: NSButtonCell!
    
    @IBAction func TestButtonPush(_ sender: Any) {
        // создает каталог, но не везде где я хочу
        do {
            //try FileManager.default.createDirectory(atPath: "Downloads/ScoreBoard Outputs/", withIntermediateDirectories: true, attributes: nil)
           
            //try FileManager.default.createDirectory(atPath: "./ScoreBoard Outputs/", withIntermediateDirectories: true, attributes: nil)
            
           // try FileManager.default.createDirectory(atPath: "~/Documents/Трансляции", withIntermediateDirectories: true, attributes: nil)
            
            
            //let myDirectory = FileManager.default.homeDirectoryForCurrentUser // домашняя папка пользователя
            //var myDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // папка документов
            
            if var userDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                userDirectory = userDirectory.appendingPathComponent("Трансляции/ScoreBoard Outputs")
                
                // если использовать тип 'URL'
                try FileManager.default.createDirectory(at: userDirectory, withIntermediateDirectories: true, attributes: nil)
                
                // если использовать адрес в виде String
                //try FileManager.default.createDirectory(atPath: "ScoreBoard Outputs", withIntermediateDirectories: true, attributes: nil)
                
                print (userDirectory)
                
            }
            
            let userDirectory1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            
            //let directoryProgramm = "ScoreBoard Outputs"
            //let directoryForWrite = userDirectory.appendingPathComponent(directoryProgramm)
            
            
            //print (userDirectory1)
            
            
            //let userDirectory1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            //print (userDirectory1)
            
        } catch {
            print("ошибка создания: \(error)")
        }
    }
    
    
    lazy var timeUserPreset:Int = sliderTimer.integerValue //900 секунд по умолчанию в свойствах слайдера
    lazy var timeNow:Int = sliderTimer.integerValue //900 секунд по умолчанию в свойствах слайдера
    
    //var homeName:String = "Home" // нужны ли эти переменные?
    //var awayName:String = "Away"
    
    var countGoalHome:Int = 0
    var countGoalAway:Int = 0
    var periodCount:Int = 0
    
    // MARK: - FUNCtions
    
    func writeFileToDisk(nameFile:String, textToWrite:String) {
        //в настройках проекта нужно дать доступ на запись в каталоги
        //if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        if var dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
            // если папки нет, записать не сможет
            dir = dir.appendingPathComponent("ScoreBoard Outputs")
            let fileURL = dir.appendingPathComponent(nameFile)
                   
            //writing
            do {
                try textToWrite.write(to: fileURL, atomically: false, encoding: .utf8)
                //print(fileURL)
                //print("записан файл")
            }
            catch {/* error handling here */
               // print(fileURL)
                print("не удалось записать файл: \(error)")
            }
                    //reading
        //            do {
        //                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
        //            }
        //            catch {/* error handling here */}
        }
        
    }
    
    // функция запоминает установленные параметры таймера из слайдера
    func setTimeDefault() {
        timeUserPreset = sliderTimer.integerValue
        if switchTimer.state == .on {
            timeNow = sliderTimer.integerValue
        } else {
            timeNow = 0
        }
    }
    
    // функция показывает время в поле (берет из таймера)
    func showTimeInLabel() -> Void {
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
        //writeFileToDisk(nameFile:"Time.txt", textToWrite:textFieldTimer.stringValue)
    }
    
    var timerStatus: Timer? //две функции для таймера (старт/стоп)
        func startTimer(){
          if timerStatus == nil {
                timerStatus = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                (timer) in
                    if self.switchTimer.state == .on {
                        
                            self.timeNow -= 1
                        if self.timeNow <= 0 {
                            self.stopTimer()
                        }
                        
                    } else {
                        self.timeNow += 1
                        if self.timeNow >= self.timeUserPreset {
                            self.stopTimer()
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
        buttonStart.state = .off
        buttonStart.title = "START"
    }
    
    // MARK: - ACTIONS
    
    @IBAction func timeLabelAction(_ sender: Any) {
        var timeFromUserInLabel = Array (textFieldTimer.stringValue.components(separatedBy:CharacterSet.decimalDigits.inverted)
            .joined()) //убирает все кроме цифр
        
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
        
        
       // let timeFromUserInLabel = Array (textFieldTimer.stringValue)
        
        
        //let timeFromUserInLabel = Int(textFieldTimer.stringValue) ?? timeUserPreset
        //let characters = Array(string)

        
    }
    
    @IBAction func goalHomeAction(_ sender: Any) {
        
        if goalHome.selectedSegment == 0 {
            countGoalHome -= 1
            if countGoalHome < 0 {countGoalHome = 0} //проверка, чтобы не был счет отрицательным
            goalHome.setLabel(String(countGoalHome), forSegment: 1)
        }
        if goalHome.selectedSegment == 2 {
            countGoalHome += 1
            goalHome.setLabel(String(countGoalHome), forSegment: 1)
        }
        //writeFileToDisk(nameFile:"HomeScore.txt", textToWrite: String(countGoalHome))
    }
    
    @IBAction func goalAwayAction(_ sender: Any) {
        
        if goalAway.selectedSegment == 0 {
            countGoalAway -= 1
            if countGoalAway < 0 {countGoalAway = 0} //проверка, чтобы не был счет отрицательным
            goalAway.setLabel(String(countGoalAway), forSegment: 1)
        }
        if goalAway.selectedSegment == 2 {
            countGoalAway += 1
            goalAway.setLabel(String(countGoalAway), forSegment: 1)
        }
        //writeFileToDisk(nameFile:"AwayScore.txt", textToWrite: String(countGoalAway))
    }
    
    @IBAction func periodAction(_ sender: Any) {
        
        if period.selectedSegment == 0 {
            periodCount -= 1
            if periodCount < 1 {periodCount = 1} //проверка, чтобы не был счет отрицательным
            period.setLabel(String(periodCount), forSegment: 1)
        }
        if period.selectedSegment == 2 {
            periodCount += 1
            period.setLabel(String(periodCount), forSegment: 1)
        }
        //writeFileToDisk(nameFile:"Period.txt", textToWrite: String(periodCount))
    }
    
    @IBAction func textFieldHomeNameAction(_ sender: Any) {
        //homeName = textFieldHomeName.stringValue //  нужна ли отдельная переменная?
        //writeFileToDisk(nameFile:"HomeName.txt", textToWrite:textFieldHomeName.stringValue)

    }
    
    @IBAction func textFieldAwayNameAction(_ sender: Any) {
        //awayName = textFieldAwayName.stringValue
        //writeFileToDisk(nameFile:"AwayName.txt", textToWrite:textFieldAwayName.stringValue)
    }
    
    @IBAction func textFieldTimerAction(_ sender: Any) {
        // сделать +/- 1 сек по клавишам вверх/вниз (горячие клавиши)
        //self.timeNow = textFieldTimer.integerValue
        //showTimeInLabel()
    }
    
    @IBAction func sliderTimerAction(_ sender: Any) {
        setTimeDefault()
        showTimeInLabel()
    }
    
    @IBAction func pushButtonStart(_ sender: Any) {
        //sliderTimer.isEnabled = false
        if buttonStart.state == .on {
            buttonStart.title = "PAUSE"
            startTimer()
        } else {
            resetStateButtonStar()
        }
    }
    
    @IBAction func switchTimerOnOff(_ sender: Any) {
        if switchTimer.state == .on {
            titleForTimer.stringValue = "Обратный отсчет: ВКЛ"
        } else {
            titleForTimer.stringValue = "Обратный отсчет: ВЫКЛ"
        }
        setTimeDefault()
        showTimeInLabel()
    }
    
    @IBAction func resetButtonPush(_ sender: Any) {
        resetStateButtonStar()
        setTimeDefault()
        showTimeInLabel()
        //sliderTimer.isEnabled = true
    }
    


}

