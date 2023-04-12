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
    private var lapList: [Double] = []
    private var lapListReverse: [Double] = []
    private var leftText = "랩"
    private var rightText = "시작"
    private var timer: Timer?
    private var timerCount: Double = 0 ///  실제 돌아가는 타이머
    private var recordTime: Double = 0  /// 기록 재는 타이머, 소수점 2번째 자리
    private var maxTerm: Double = 0  /// 간격 최댓값
    private var minTerm: Double = Double(MAXFLOAT)    /// 간격 최솟값
    private var colorList: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIToView()
    }
    
    /*
     UI 코드
     */
    
    // MARK: 스톱워치 시간 표시할 라벨
    private lazy var minuteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "00:"
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        label.font = .systemFont(ofSize: 70)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 스톱워치 시간 표시할 라벨
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "00."
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        label.font = .systemFont(ofSize: 70)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 스톱워치 시간 표시할 라벨
    private lazy var milisecondlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "00"
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        label.font = .systemFont(ofSize: 70)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [minuteLabel, secondLabel, milisecondlLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: 랩 or 재설정 버튼
    private lazy var saveOrResetBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitle(leftText, for: .normal)
        if leftText == "랩"{
            btn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.3) /* #868e96 */
        }
        else{
            btn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.4) /* #868e96 */
        }
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = UIScreen.main.bounds.width/12
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clickeddSaveOrResetBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 시작, 정지 버튼
    private lazy var startAndStopBtn: UIButton = {
       let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle(rightText, for: .normal)
        if rightText == "시작"{
            btn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.3)
        }
        else{
            btn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.3)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = UIScreen.main.bounds.width/12
        btn.addTarget(self, action: #selector(clickeddstartAndStopBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: 스톱워치 기록
    private lazy var saveListTableView: UITableView = {
       let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        tableview.separatorColor = .gray
        tableview.backgroundColor = .black
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    
    /*
     UI Action & Add to View & AutoLayout 함수
     */
    
    // MARK: UI 등록하는 함수
    private func addUIToView(){
        self.view.addSubview(labelStackView)
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
            self.labelStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.labelStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.width/4),
            self.labelStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3),
            
            self.saveOrResetBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.saveOrResetBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.saveOrResetBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            self.saveOrResetBtn.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            
            self.startAndStopBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.startAndStopBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.startAndStopBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            self.startAndStopBtn.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/6),
            
            self.saveListTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.saveListTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 10),
            self.saveListTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -10),
            self.saveListTableView.topAnchor.constraint(equalTo: startAndStopBtn.bottomAnchor,constant: 10),
            self.saveListTableView.topAnchor.constraint(equalTo: saveOrResetBtn.bottomAnchor,constant: 10),
            self.saveListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//            self.saveListTableView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        
    }
    
    // MARK: 랩 or 재설정 버튼 눌렀을 때
    @objc
    private func clickeddSaveOrResetBtn(){
        
        if self.saveOrResetBtn.titleLabel?.text == "랩" && self.startAndStopBtn.titleLabel?.text == "중단"{
            // 기록 남아야함
            self.lapList.append(self.recordTime)
            self.lapListReverse = self.lapList.reversed()
            setColor()
            self.saveListTableView.reloadData()
        }
        else if self.saveOrResetBtn.titleLabel?.text == "재설정" {
            self.saveOrResetBtn.setTitle("랩", for: .normal)
            self.saveOrResetBtn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.3) /* #868e96 */
            
            self.timerCount = 0
            self.lapList = []
            self.maxTerm = 0
            self.minTerm = Double(MAXFLOAT)
            self.recordTime = 0
            self.colorList = []
            
            self.minuteLabel.text = "00:"
            self.secondLabel.text = "00."
            self.milisecondlLabel.text = "00"
            self.saveListTableView.reloadData()
            
            self.startAndStopBtn.setTitle("시작", for: .normal)
            self.startAndStopBtn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.3)
        }
        
    }
    
    // MARK: 시작, 정지 버튼 눌렀을 때
    @objc
    private func clickeddstartAndStopBtn(_ sender: UIButton){
        if self.startAndStopBtn.titleLabel?.text == "시작"{
            self.startAndStopBtn.setTitle("중단", for: .normal)
            self.startAndStopBtn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.3)
            timerThread()
            self.saveOrResetBtn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.4) /* #868e96 */
            self.saveOrResetBtn.setTitle("랩", for: .normal)
        }
        else if self.startAndStopBtn.titleLabel?.text == "중단"{
            self.startAndStopBtn.setTitle("시작", for: .normal)
            self.startAndStopBtn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.3)
            self.timer?.invalidate()
            
            self.saveOrResetBtn.setTitle("재설정", for: .normal)
        }
    }
    
    // MARK: 타이머 돌리는 스레드 함수
    private func timerThread(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { timer in
            self.timerCount += timer.timeInterval
            
            
            DispatchQueue.main.async {
                let digit: Double = pow(10, 2) // 10의 3제곱
                let timerCount = floor(self.timerCount * digit) / digit
                self.recordTime = timerCount
                
                let minute = (Int)(fmod((timerCount/60), 60))
                let second = (Int)(fmod(timerCount, 60))
                let milliSecond = (Int)((timerCount - floor(timerCount))*100)

                
                var strMinute: String = "\(minute)"
                var strSecond: String = "\(second)"
                var strMilliSecond: String = "\(milliSecond)"
                
                if milliSecond < 10 {
                    strMilliSecond = "0\(milliSecond)"
                }
                if second < 10{
                    strSecond = "0\(second)"
                }
                if minute < 10{
                    strMinute = "0\(minute)"
                }
                
                self.minuteLabel.text = "\(strMinute):"
                self.secondLabel.text = "\(strSecond)."
                self.milisecondlLabel.text = "\(strMilliSecond)"
            }
        })
        
    }
    
    // MARK: 색깔 결정하는 함수, 최소: 초록, 최대: 빨강
    private func setColor(){
        self.colorList = []
        for index in 0..<self.lapListReverse.count{
            var color: UIColor = .white
            if index > 0{
                if self.maxTerm <= self.lapListReverse[index - 1] - self.lapListReverse[index]{
                    maxTerm = self.lapListReverse[index - 1] - self.lapListReverse[index]
                    color = .red
                }
                if self.minTerm >= self.lapListReverse[index - 1] - self.lapListReverse[index]{
                    minTerm = self.lapListReverse[index - 1] - self.lapListReverse[index]
                    color = .green
                }
            }
            self.colorList.append(color)
        }
        
    }
    
}

// MARK: 스톱워치 기록 tableView
extension StopWatchController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LapListTableViewCell.identifier, for: indexPath) as! LapListTableViewCell
        
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        
        cell.inputRecord(name: "랩\(self.lapListReverse.count - indexPath.row)",
                         record: "\(self.lapListReverse[indexPath.row])",
                         color: colorList[indexPath.row])
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.lapList.count }
}
