//
//  ViewController.swift
//  Clock
//
//  Created by 정호진 on 2023/03/26.
//

import UIKit

class AlarmController: UIViewController {
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmListTableViewCell.self, forCellReuseIdentifier: AlarmListTableViewCell.identifer)
        return tableView
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
        
        /// table View 등록
        scrollView.addSubview(addAlarmTableView)
        setAutoLayout()
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
            
            /// tableview AutoLayout
            self.addAlarmTableView.topAnchor.constraint(equalTo: self.label.bottomAnchor,constant: 10),
            self.addAlarmTableView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -10),
            self.addAlarmTableView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 10),
            self.addAlarmTableView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: -10),
        ])
    }

    
    // MARK: 알림 추가 버튼 눌렀을 때
    @objc private func clickedPlusBtn(){
        let addAlarm = AddAlarmOptionsController()
        addAlarm.modalPresentationStyle = .formSheet
        addAlarm.delegate = self
        self.scrollView.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 20/255, alpha: 1)
        self.present(addAlarm, animated: true)
    }
    
}

// MARK: 설정한 알람 정보를 가져옴
extension AlarmController: SendNewAlarm{
    func mustSend(color: UIColor) {
        self.scrollView.backgroundColor = color
        self.addAlarmTableView.backgroundColor = color
    }
    
    func sendNewAlarm(time: Date, label: String?, soundSong: String, reAlarmCheck: Bool) {
        print("success")
    }
}

// MARK: 저장된 알람들 표시할 테이블 뷰
extension AlarmController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifer, for: indexPath) as! AlarmListTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1}
}
