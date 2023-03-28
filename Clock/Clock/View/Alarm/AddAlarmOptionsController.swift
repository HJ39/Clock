//
//  AddAlarmOptions.swift
//  Clock
//
//  Created by 정호진 on 2023/03/26.
//

import Foundation
import UIKit

// MARK: 알람 추가 화면
final class AddAlarmOptionsController: UIViewController{
    private let optionList = ["반복", "레이블", "사운드", "다시 알림"]
    private let chooseList = ["안 함 >", "", "전파 탐지기 >", ""]
    private var alarmTime: Date?    /// 시간
    private var repeatDay: String?  /// 반복 요일
    private var alarmLabel: String? /// 레이블
    private var soundSong: String?  /// 사운드
    private var checkReAlarm: Bool = true   ///다시 알림기능
    
    var delegate: SendNewAlarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        addToView()
    }
    
    /*
     UI 코드
     */
    
    // MARK: Label 추가
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "알람 추가"
        label.textColor = .white
        label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 취소 버튼
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitle("취소", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clickedCancelBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 저장 버튼
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.orange, for: .normal)
        btn.setTitle("저장", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clickedSaveBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 시간 선택하는 UI
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "ko-KR")
        picker.timeZone = .autoupdatingCurrent
        picker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.alarmTime = picker.date
        return picker
    }()
    
    // MARK: 알림 추가하는 옵션 tableview
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        tableview.layer.cornerRadius = 10
        tableview.isScrollEnabled = false
        tableview.register(AlarmOptionsTableViewCell.self, forCellReuseIdentifier: AlarmOptionsTableViewCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    // MARK: 다시 알림 Switch
    private lazy var reAlarmSwitch: UISwitch = {
       let checkSwitch = UISwitch()
        checkSwitch.isOn = true
        checkSwitch.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        return checkSwitch
    }()
    
    
    
    /*
     UI Action & Add to View & AutoLayout 함수
     */
    
    // MARK: 뷰에 UI 추가하는 함수
    private func addToView(){
        self.view.addSubview(label)
        self.view.addSubview(cancelBtn)
        self.view.addSubview(saveBtn)
        self.view.addSubview(datePicker)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setAutoLayout()
    }
    
    // MARK: AutoLayout 설정하는 함수
    private func setAutoLayout(){
        NSLayoutConstraint.activate([
            /// Label AutoLayout
            label.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 10),
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            /// 취소 버튼 AutoLayout
            cancelBtn.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 10),
            cancelBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 10),
            
            /// 저장 버튼 AutoLayout
            saveBtn.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 10),
            saveBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -10),
            
            /// datapicker AutoLayout
            datePicker.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 10),
            datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/5),
            
            /// tableview AutoLayout
            tableView.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            tableView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/7)
        ])
    }
    
    // MARK: 시간 선택할 때 실행되는 함수
    @objc
    private func handleDatePicker(_ sender: UIDatePicker){
        self.alarmTime = sender.date
        
    }
    
    // MARK: Switch 변경시 실행되는 함수
    @objc
    private func handleSwitch(_ sender: UISwitch){
        if sender.isOn{
            checkReAlarm = true
        }
        else{
            checkReAlarm = false
        }
    }
    
    // MARK: 저장 버튼 누르면 실행
    @objc
    private func clickedSaveBtn(){
        self.soundSong = "전파 탐지기"
        self.repeatDay = "안 함"

        guard let alarmTime = self.alarmTime else { return }
        guard let repeatDay = self.repeatDay else { return }
        guard let soundSong = self.soundSong else { return }

        self.dismiss(animated: true)
        
        DispatchQueue.main.async {
            self.delegate?.mustSend(color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
            self.delegate?.sendNewAlarm(time: alarmTime, repeatDay: repeatDay, label: self.alarmLabel, soundSong: soundSong, reAlarmCheck: self.checkReAlarm)
        }
        
    }
    
    // MARK: 취소 버튼 누르면 실행
    @objc
    private func clickedCancelBtn(){
        alarmLabel = nil
        alarmTime = nil
        checkReAlarm = true
        self.delegate?.mustSend(color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
        self.dismiss(animated: true)
    }
    
}

// MARK: tableview 옵션 설정
extension AddAlarmOptionsController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmOptionsTableViewCell.identifier, for: indexPath) as! AlarmOptionsTableViewCell
        
        cell.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        /// 다시 알림 스위치 기능
        if indexPath.row == 3 {
            cell.accessoryView = reAlarmSwitch
            cell.inputOptions(title: optionList[indexPath.row], text: chooseList[indexPath.row], index: indexPath.row)
        }
        else{
            cell.inputOptions(title: optionList[indexPath.row], text: chooseList[indexPath.row], index: indexPath.row)
            cell.inputText.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return optionList.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return tableView.frame.height/4 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddAlarmOptionsController: UITextFieldDelegate{
    // MARK: 알람 레이블을 모두 입력하고 확인을 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.alarmLabel = textField.text
        return true
    }
    
    // MARK: textfield를 입력하고 키보드가 내려갈 때 실행되는 함수
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.alarmLabel = textField.text
        return true
    }
}

// MARK: 알림 설정한 옵션들을 전송하는 프로토콜
//@objc
protocol SendNewAlarm{
    
    /// optional 타입으로 저장 버튼 누르는 경우에만 실행
   func sendNewAlarm(time: Date, repeatDay: String, label: String?, soundSong: String, reAlarmCheck: Bool)
    
    /// 취소 버튼으로 화면이 꺼지는 경우 실행
    func mustSend(color: UIColor)
}
