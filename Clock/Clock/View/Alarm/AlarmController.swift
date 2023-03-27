//
//  ViewController.swift
//  Clock
//
//  Created by 정호진 on 2023/03/26.
//

import UIKit

class AlarmController: UIViewController {
    private var alarmList: [NewAlarmInfo] = []
    private var checkAlarm: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// UI 등록
        addUI()
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

    // MARK: Scroll View UI
    private lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .black
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = true
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    // MARK: '알람' 라벨 표시
    private lazy var label: UILabel = {
       let label = UILabel()
        label.text = "알람"
        label.textColor = .white
        label.font = UIFont(name: "Al Nile", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 새롭게 추가되는 알람들 표시할 테이블 뷰
    private lazy var addAlarmTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AlarmListTableViewCell.self, forCellReuseIdentifier: AlarmListTableViewCell.identifer)
        return tableView
    }()
    
    // MARK: 알림 On/Off Switch
    private lazy var checkTurnOnOffAlarm: UISwitch = {
       let checkSwitch = UISwitch()
        checkSwitch.isOn = true
        checkSwitch.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        return checkSwitch
    }()
    
    /*
     UI Action & Add to View & AutoLayout 함수
     */
    
    // MARK: View에 UI 추가하는 함수
    private func addUI(){
        ///  알림 추가 버튼 등록
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusBtn)
        
        /// scroll view 등록
        self.view.addSubview(self.scrollView)
        
        /// scrollView 아래 라벨 등록
        scrollView.addSubview(label)
        
        
        setAutoLayout()
    }
    
    // MARK: View에 tableview 추가하는 함수
    private func addTableView(){
        /// table View 등록
        scrollView.addSubview(addAlarmTableView)
        addAlarmTableView.delegate = self
        addAlarmTableView.dataSource = self
        
        setTableViewAutoLayout()
    }
    
    // MARK: UI AutoLayout 설정
    private func setAutoLayout(){
        NSLayoutConstraint.activate([
            /// ScrollView AutoLayout
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor),

            /// label AutoLayout
            self.label.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0),
            self.label.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 10),
            
        ])
    }

    // MARK: TableView AutoLayout 설정
    private func setTableViewAutoLayout(){
        NSLayoutConstraint.activate([
            /// tableview AutoLayout
            self.addAlarmTableView.topAnchor.constraint(equalTo: self.label.bottomAnchor,constant: 10),
            self.addAlarmTableView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -10),
            self.addAlarmTableView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 10),
            self.addAlarmTableView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: -10),
        ])
    }
    
    // MARK: 알림 추가 버튼 눌렀을 때
    @objc
    private func clickedPlusBtn(){
        let addAlarm = AddAlarmOptionsController()
        addAlarm.modalPresentationStyle = .formSheet
        addAlarm.delegate = self
        self.scrollView.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 20/255, alpha: 1)
        self.present(addAlarm, animated: true)
    }
    
    // MARK: Switch 변경시 실행되는 함수
    @objc
    private func handleSwitch(_ sender: UISwitch){
        if sender.isOn{
            checkAlarm = true
        }
        else{
            checkAlarm = false
        }
    }
    
    
}

// MARK: 설정한 알람 정보를 가져옴
extension AlarmController: SendNewAlarm{
    
    /// 취소 버튼이나 저장버튼 누른 경우 가져옴
    func mustSend(color: UIColor) {
        self.scrollView.backgroundColor = color
        self.addAlarmTableView.backgroundColor = color
    }
    
    /// 저장 버튼 누른 경우 데이터를 가져옴
    func sendNewAlarm(time: Date, repeatDay: String, label: String?, soundSong: String, reAlarmCheck: Bool) {
        self.alarmList.append(NewAlarmInfo(alarmTime: time,
                                           alarmLabel: label,
                                           soundSong: soundSong,
                                           checkReAlarm: reAlarmCheck))
        print(time)
        print(reAlarmCheck)
        addTableView()
        addAlarmTableView.reloadData()
    }
}

// MARK: 저장된 알람들 표시할 테이블 뷰
extension AlarmController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Called")
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifer, for: indexPath) as! AlarmListTableViewCell
        cell.accessoryView = checkTurnOnOffAlarm
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let dateString = dateFormatter.string(from: self.alarmList[indexPath.row].getAlarmTime()!)
        let description = "\(String(describing: self.alarmList[indexPath.row].getAlarmLabel())), \(String(describing: self.alarmList[indexPath.row].getAlarmrepeatDay()))"
        print("descript \(description)")
        cell.inputText(time: dateString, description: description)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { print("called \(self.alarmList.count)"); return self.alarmList.count }
}

struct NewAlarmInfo{
    private var alarmTime: Date?    /// 시간
    private var repeatDay: String?  /// 반복 요일
    private var alarmLabel: String? /// 레이블
    private var soundSong: String?  /// 사운드
    private var checkReAlarm: Bool? ///다시 알림기능
    
    init(alarmTime: Date? = nil,repeatDay: String? = nil, alarmLabel: String? = nil, soundSong: String? = nil, checkReAlarm: Bool? = nil) {
        self.alarmTime = alarmTime
        self.repeatDay = repeatDay
        self.alarmLabel = alarmLabel
        self.soundSong = soundSong
        self.checkReAlarm = checkReAlarm
    }
    
    func getAlarmTime() -> Date? { return alarmTime }
    
    func getAlarmrepeatDay() -> String? {return repeatDay}
    
    func getAlarmLabel() -> String? { return alarmLabel }
    
    func getAlarmSong() -> String? { return soundSong }
    
    func getAlarmReAlarm() -> Bool? { return checkReAlarm }
}
