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
    
    private lazy var tesetLabel: UILabel = {
       let label = UILabel()
        label.text = "dafsfas"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
            self.view.addSubview(tesetLabel)
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
                self.tesetLabel.topAnchor.constraint(equalTo: self.view.topAnchor,constant: view.safeAreaLayoutGuide.layoutFrame.size.height/5),
                self.tesetLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.tesetLabel.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.height/5),
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
        self.tesetLabel.removeFromSuperview()
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
            self.resetBtn.backgroundColor = UIColor(red: 134/255, green: 142/255, blue: 150/255, alpha: 0.3) /* #868e96 */
            self.startAndStopBtn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.3)   /// 빨강
            self.startAndStopBtn.setTitle("일시정지", for: .normal)
        }
        else if self.startAndStopBtn.titleLabel?.text == "일시정지"{
            self.startAndStopBtn.backgroundColor = UIColor(red: 30/255, green: 200/255, blue: 30/255, alpha: 0.3)   /// 초록
            self.startAndStopBtn.setTitle("재개", for: .normal)
        }
        else if self.startAndStopBtn.titleLabel?.text == "재개"{
            self.startAndStopBtn.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 30/255, alpha: 0.3)   /// 빨강
            self.startAndStopBtn.setTitle("일시정지", for: .normal)
        }
    }
    
}
