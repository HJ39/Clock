//
//  StopWatchController.swift
//  Clock
//
//  Created by 정호진 on 2023/03/26.
//

import Foundation
import UIKit

// MARK: 스톱워치 기능
final class StopWatchController: UIViewController{
    private var lapList: [String] = []
    private var leftText = "랩"
    private var rightText = "시작"
    private var timer: Timer?
    private var timerCount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIToView()
        
    }
    
    /*
     UI 코드
     */
    
    // MARK: 스톱워치 시간 표시할 라벨
    private lazy var digitalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "00:00.00"
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        label.font = .systemFont(ofSize: 100)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 랩 or 재설정 버튼
    private lazy var saveOrResetBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 25)
        btn.setTitle(leftText, for: .normal)
        if leftText == "랩"{
            btn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.2) /* #868e96 */
            btn.isEnabled = false
        }
        else{
            btn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.3) /* #868e96 */
        }
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = UIScreen.main.bounds.width/14
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clickeddSaveOrResetBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 시작, 정지 버튼
    private lazy var startAndStopBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 25)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle(rightText, for: .normal)
        if rightText == "시작"{
            btn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.2)
        }
        else{
            btn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.2)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = UIScreen.main.bounds.width/14
        btn.addTarget(self, action: #selector(clickeddstartAndStopBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var saveListTableView: UITableView = {
       let tableview = UITableView()
        tableview.backgroundColor = .white
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    
    /*
     UI Action & Add to View & AutoLayout 함수
     */
    
    // MARK: UI 등록하는 함수
    private func addUIToView(){
        self.view.addSubview(digitalLabel)
        self.view.addSubview(saveOrResetBtn)
        self.view.addSubview(startAndStopBtn)
        self.view.addSubview(saveListTableView)
        
        saveListTableView.delegate = self
        saveListTableView.dataSource = self
        saveListTableView.register(LapListTableViewCell.self, forCellReuseIdentifier: LapListTableViewCell.identifier)
        
        setAutoLayout()
    }
    
    // MARK: UI AutoLayout 설정하는 함수
    private func setAutoLayout(){
        NSLayoutConstraint.activate([
            self.digitalLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.digitalLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.width/4),
            
            
            self.saveOrResetBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.saveOrResetBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.saveOrResetBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/7),
            self.saveOrResetBtn.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/7),
            
            self.startAndStopBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.startAndStopBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.startAndStopBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/7),
            self.startAndStopBtn.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/7),
            
            self.saveListTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.saveListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.saveListTableView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
    }
    
    // MARK: 랩 or 재설정 버튼 눌렀을 때
    @objc
    private func clickeddSaveOrResetBtn(){
        
        if self.saveOrResetBtn.titleLabel?.text == "랩" && self.startAndStopBtn.titleLabel?.text == "중단"{
            // 기록 남아야함
            
        }
        else if self.saveOrResetBtn.titleLabel?.text == "재설정"{
            self.saveOrResetBtn.setTitle("랩", for: .normal)
            self.saveOrResetBtn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.2) /* #868e96 */
            self.saveOrResetBtn.isEnabled = false
            
            self.timerCount = 0
            self.digitalLabel.text = "00:00.00"
            
            self.startAndStopBtn.setTitle("시작", for: .normal)
            self.startAndStopBtn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.2)
        }
        
    }
    
    // MARK: 시작, 정지 버튼 눌렀을 때
    @objc
    private func clickeddstartAndStopBtn(_ sender: UIButton){
        if self.startAndStopBtn.titleLabel?.text == "시작"{
            self.startAndStopBtn.setTitle("중단", for: .normal)
            self.startAndStopBtn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.2)
            timerThread()
            self.saveOrResetBtn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.3) /* #868e96 */
            self.saveOrResetBtn.isEnabled = true
        }
        else if self.startAndStopBtn.titleLabel?.text == "중단"{
            self.startAndStopBtn.setTitle("시작", for: .normal)
            self.startAndStopBtn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.2)
            self.timer?.invalidate()
            
            self.saveOrResetBtn.setTitle("재설정", for: .normal)
        }
    }
    
    private func timerThread(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer in
            self.timerCount += timer.timeInterval
            
            
            DispatchQueue.main.async {
                let digit: Double = pow(10, 2) // 10의 3제곱
                let timerCount = floor(self.timerCount * digit) / digit
                print(timerCount)
                
                let minute = (Int)(fmod((timerCount/60), 60))
                let second = (Int)(fmod(timerCount, 60))
                let milliSecond = (Int)((timerCount - floor(timerCount))*100)
                print("minute \(second)")
                
                if milliSecond < 10 {
                    self.digitalLabel.text = "\(minute):0\(second).0\(milliSecond)"
                }
                if second < 10{
                    self.digitalLabel.text = "\(minute):0\(second).\(milliSecond)"
                }
                if minute < 10{
                    self.digitalLabel.text = "0\(minute):\(second).\(milliSecond)"
                }
            }
        })
        
    }
    
    
}

// MARK: 스톱워치 기록 tableView
extension StopWatchController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LapListTableViewCell.identifier, for: indexPath) as! LapListTableViewCell
        print(">>")
        cell.backgroundColor = .white
        cell.inputRecord(name: "랩1", record: "00000")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 2 }
}
