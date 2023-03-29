//
//  ViewController.swift
//  Clock
//
//  Created by 정호진 on 2023/03/26.
//

import UIKit

class AlarmController: UIViewController {
    private var alarmList: [NewAlarmInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        /// UI 등록
        addTableView()
    }
    
    /*
     UI 코드
     */
    
    // MARK: 알람 추가하는 버튼
    private lazy var plusBtn: UIButton = {
        let size = UIScreen.main.bounds.width/20
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))

        btn.tintColor = UIColor.orange
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.addTarget(self, action: #selector(clickedPlusBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 새롭게 추가되는 알람들 표시할 테이블 뷰
    private lazy var addAlarmTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AlarmListTableViewCell.self, forCellReuseIdentifier: AlarmListTableViewCell.identifer)
        return tableView
    }()
    
 
    
    /*
     UI Action & Add to View & AutoLayout 함수
     */

    
    // MARK: View에 tableview 추가하는 함수
    private func addTableView(){
        ///  알림 추가 버튼 등록
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusBtn)
        
        /// table View 등록
        self.view.addSubview(addAlarmTableView)
        addAlarmTableView.delegate = self
        addAlarmTableView.dataSource = self
        setTableViewAutoLayout()
    }

    // MARK: TableView AutoLayout 설정
    private func setTableViewAutoLayout(){
        NSLayoutConstraint.activate([
            /// table view Layout
            self.addAlarmTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.addAlarmTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.addAlarmTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.addAlarmTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
    
    // MARK: 알림 추가 버튼 눌렀을 때
    @objc
    private func clickedPlusBtn(){
        let addAlarm = AddAlarmOptionsController()
        addAlarm.modalPresentationStyle = .pageSheet
        addAlarm.delegate = self
        
        self.view.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 20/255, alpha: 1)
        self.addAlarmTableView.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 20/255, alpha: 1)
        
        present(addAlarm, animated: true)
    }
    
    // MARK: Switch 변경시 실행되는 함수
    @objc
    private func changedSwitch(_ sender: UISwitch){
        if sender.isOn{
            self.alarmList[sender.tag].color = .white
        }
        else{
            self.alarmList[sender.tag].color = .gray
        }
        self.addAlarmTableView.reloadData()
    }
    
}

// MARK: 설정한 알람 정보를 가져옴
extension AlarmController: SendNewAlarm {
    
    /// 취소 버튼이나 저장버튼 누른 경우 가져옴
    func mustSend(color: UIColor) {
        self.view.backgroundColor = color
        self.addAlarmTableView.backgroundColor = color
    }
    
    /// 저장 버튼 누른 경우 데이터를 가져옴
    func sendNewAlarm(time: Date, repeatDay: String?, label: String?, soundSong: String, reAlarmCheck: Bool,index: Int?) {
 
        if index == nil{
            self.alarmList.append(NewAlarmInfo(alarmTime: time,
                                               repeatDay: repeatDay,
                                               alarmLabel: label,
                                               soundSong: soundSong,
                                               checkReAlarm: reAlarmCheck,
                                               color: .white))
        }
        else{
            self.alarmList[index!].alarmTime = time
            self.alarmList[index!].repeatDay = repeatDay
            self.alarmList[index!].alarmLabel = label
            self.alarmList[index!].soundSong = soundSong
            self.alarmList[index!].checkReAlarm = reAlarmCheck
            self.alarmList[index!].color = .white
        }
        self.addAlarmTableView.reloadData()
    }
}

// MARK: 저장된 알람들 표시할 테이블 뷰
extension AlarmController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifer, for: indexPath) as! AlarmListTableViewCell
        let index = indexPath.row - 1
        cell.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        cell.selectionStyle = .none
        var description = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        
        
        switch indexPath.row {
        case 0:
            cell.inputText(time: "알람", description: nil,index: indexPath.row,color: .white)
            cell.accessoryView = .none
        default:
            let dateString = dateFormatter.string(from: self.alarmList[index].getAlarmTime()!)
            
            if self.alarmList[index].getAlarmLabel() == nil{
                description = "\(self.alarmList[index].getAlarmrepeatDay() ?? "안 함")"
            }
            else{
                description = "\(self.alarmList[index].getAlarmLabel() ?? ""), \(self.alarmList[index].getAlarmrepeatDay() ?? "안 함")"
            }
            
            /// 데이터 삽입
            cell.inputText(time: dateString,
                           description: description,
                           index: indexPath.row,
                           color: self.alarmList[index].getColor()!)
            
            /// UISwitch 생성
            let switchView = UISwitch(frame: .zero)
            
            if self.alarmList[index].getColor() == .white{
                /// switch 초기화면 버튼이 누르지 않은 채로
                switchView.setOn(true, animated: true)
            }
            
            /// swtichView tag 지정
            switchView.tag = indexPath.row - 1
            /// switchView addTarget 지정
            switchView.addTarget(self, action: #selector(self.changedSwitch), for: .valueChanged)
            /// cell accessoryView를 switchView로 지정
            cell.accessoryView = switchView
            
            description = ""
        }
        
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height
        
        if indexPath.row == 0 {
            return height/10
        }
        
        return height/8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row - 1
        
        if indexPath.row > 0{
            let addAlarm = AddAlarmOptionsController()
            addAlarm.modalPresentationStyle = .pageSheet
            addAlarm.delegate = self
            addAlarm.alarmTime = self.alarmList[index].getAlarmTime()
            addAlarm.repeatDay = self.alarmList[index].getAlarmrepeatDay()
            addAlarm.alarmLabel = self.alarmList[index].getAlarmLabel()
            addAlarm.soundSong = self.alarmList[index].getAlarmSong()
            addAlarm.checkReAlarm = self.alarmList[index].getAlarmReAlarm()!
            addAlarm.updateIndex = indexPath.row - 1
            
            self.view.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 20/255, alpha: 1)
            self.addAlarmTableView.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 20/255, alpha: 1)
            
            present(addAlarm, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.alarmList.count + 1 }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
}

struct NewAlarmInfo{
     var alarmTime: Date?    /// 시간
     var repeatDay: String?  /// 반복 요일
     var alarmLabel: String? /// 레이블
     var soundSong: String?  /// 사운드
     var checkReAlarm: Bool? ///다시 알림기능
    var color: UIColor? /// 색
    
    init(alarmTime: Date?, repeatDay: String?, alarmLabel: String?, soundSong: String?, checkReAlarm: Bool?,color: UIColor?) {
        self.alarmTime = alarmTime
        self.repeatDay = repeatDay
        self.alarmLabel = alarmLabel
        self.soundSong = soundSong
        self.checkReAlarm = checkReAlarm
        self.color = color
    }
    
    func getAlarmTime() -> Date? { return alarmTime }
    
    func getAlarmrepeatDay() -> String? {return repeatDay}
    
    func getAlarmLabel() -> String? { return alarmLabel }
    
    func getAlarmSong() -> String? { return soundSong }
    
    func getAlarmReAlarm() -> Bool? { return checkReAlarm }
    
    func getColor() -> UIColor? {return color}
}
