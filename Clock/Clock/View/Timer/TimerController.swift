//
//  TimerController.swift
//  Clock
//
//  Created by 정호진 on 2023/04/12.
//

import Foundation
import UIKit

final class TimerController: UIViewController{
    private var checkStart: Bool = false
    private var timer: Timer?
    private var timerCount: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addUIToView()
    }
    
    /*
     UI 코드
     */
    
    // MARK: 시간 설정할 datePicker
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .white
        return picker
    }()
    
    // MARK: 종료 시 노래 선택하는 박스
    private lazy var songBtn: CustomSongButton = {
        let btn = CustomSongButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.5)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(clickedSongBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 취소 버튼
    private lazy var resetBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitle("취소", for: .normal)
        btn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.2) /* #868e96 */
        btn.isEnabled = false
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = view.safeAreaLayoutGuide.layoutFrame.width/12
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clickedResetBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 시작, 재개, 일시정지 버튼
    private lazy var startAndStopBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("시작", for: .normal)
        btn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.3)    /// 초록
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = UIScreen.main.bounds.width/12
        btn.addTarget(self, action: #selector(clickedStartAndStopBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 시간 단위 라벨
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.text = "00:"
        label.textColor = .red
        label.font = .systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 분 단위 라벨
    private lazy var minuteLabel: UILabel = {
        let label = UILabel()
        label.text = "00:"
        label.textColor = .red
        label.font = .systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 초 단위 라벨
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textColor = .red
        label.font = .systemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 시, 분, 초 담는 stack view
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hourLabel,minuteLabel,secondLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    /*
     UI Action & Add to View & AutoLayout 함수
     */
    
    // MARK: Add UI To View
    private func addUIToView(){
        if !checkStart{
            self.view.addSubview(datePicker)
        }
        else{
            self.view.addSubview(timeStack)
        }
        
        self.view.addSubview(songBtn)
        self.view.addSubview(resetBtn)
        self.view.addSubview(startAndStopBtn)
        
        setAutoLayout()
    }
    
    // MARK: 화면 구성
    private func setAutoLayout(){
        
        if !checkStart{
            NSLayoutConstraint.activate([
                self.datePicker.topAnchor.constraint(equalTo: self.view.topAnchor,constant: view.safeAreaLayoutGuide.layoutFrame.size.height/5),
                self.datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.datePicker.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.height/5),
            ])
        }
        else{
            NSLayoutConstraint.activate([
                self.timeStack.topAnchor.constraint(equalTo: self.view.topAnchor,constant: view.safeAreaLayoutGuide.layoutFrame.size.height/5),
                self.timeStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.timeStack.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.height/5),
            ])
        }
        
        NSLayoutConstraint.activate([
            self.resetBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.resetBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.resetBtn.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width/6),
            self.resetBtn.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width/6),
            
            self.startAndStopBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.startAndStopBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.startAndStopBtn.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width/6),
            self.startAndStopBtn.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width/6),
            
            self.songBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.songBtn.topAnchor.constraint(equalTo: self.resetBtn.bottomAnchor, constant: 30),
            self.songBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.songBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.songBtn.heightAnchor.constraint(equalToConstant: self.view.safeAreaLayoutGuide.layoutFrame.width / 9)
        ])
        
    }
    
    // MARK: 노래 선택하는 버튼 눌렀을 때
    @objc
    private func clickedSongBtn(){
        
    }
    
    // MARK: 취소 버튼 눌렀을 때
    @objc
    private func clickedResetBtn(){
        self.resetBtn.isEnabled = false
        self.resetBtn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.2) /* #868e96 */
        self.startAndStopBtn.setTitle("시작", for: .normal)
        self.startAndStopBtn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.3)   /// 초록
        self.checkStart = false
        self.timeStack.removeFromSuperview()
        timer?.invalidate()
        timerCount = 0
        addUIToView()
    }
    
    // MARK: 시작, 일시정지, 재개 버튼 눌렀을 때
    @objc
    private func clickedStartAndStopBtn(){
        self.checkStart = true
        self.datePicker.removeFromSuperview()
        addUIToView()
        if self.startAndStopBtn.titleLabel?.text == "시작"{
            self.resetBtn.isEnabled = true
            timerThread()
            self.resetBtn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.3) /* #868e96 */
            self.startAndStopBtn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.3)   /// 빨강
            self.startAndStopBtn.setTitle("일시정지", for: .normal)
        }
        else if self.startAndStopBtn.titleLabel?.text == "일시정지"{
            self.startAndStopBtn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.3)   /// 초록
            self.startAndStopBtn.setTitle("재개", for: .normal)
            timer?.invalidate()
        }
        else if self.startAndStopBtn.titleLabel?.text == "재개"{
            self.startAndStopBtn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.3)   /// 빨강
            self.startAndStopBtn.setTitle("일시정지", for: .normal)
            timerThread()
        }
    }
    
    // MARK: 선택한 시간 변환
    private func formatTime() -> Int{
        let settingTime = self.datePicker.date
    
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "HH:mm:ss"
        
        let settingTimeformat = date.string(from: settingTime)
        print(settingTimeformat)
        let settingString = settingTimeformat.split(separator: ":")
        
        var formattingTime = 0
        formattingTime += (Int(settingString[0])! * 3600)
        formattingTime += (Int(settingString[1])! * 60)
        formattingTime += Int(settingString[2])!
        
        if formattingTime == 0{
            formattingTime = 60
        }
        return formattingTime
    }
    
    // MARK: 타이머 돌리는 스레드 함수
    private func timerThread(){
        let formattingTime = formatTime()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer in
            self.timerCount += timer.timeInterval
            
            DispatchQueue.main.async {
                let digit: Double = pow(10, 2) // 10의 3제곱
                let timerCount = Double(formattingTime) - (floor(self.timerCount * digit) / digit)
                
                if timerCount == 0{
                    timer.invalidate()
                }
                
                let hour = (Int)(fmod(timerCount/60/60, 60))
                let minute = (Int)(fmod((timerCount/60), 60))
                let second = (Int)(fmod(timerCount, 60))

                
                var strHour: String = "\(hour)"
                var strMinute: String = "\(minute)"
                var strSecond: String = "\(second)"
                
                if second < 10{
                    strSecond = "0\(second)"
                }
                if minute < 10{
                    strMinute = "0\(minute)"
                }
                if hour < 10{
                    strHour = "0\(hour)"
                }
                
                self.hourLabel.text = "\(strHour):"
                self.minuteLabel.text = "\(strMinute):"
                self.secondLabel.text = "\(strSecond)"
                
            }
        })
        
    }
    
    
}
