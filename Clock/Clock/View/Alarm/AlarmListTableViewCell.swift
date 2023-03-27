//
//  AlarmListTableViewCell.swift
//  Clock
//
//  Created by 정호진 on 2023/03/27.
//

import Foundation
import UIKit

final class AlarmListTableViewCell: UITableViewCell{
    static let identifer = "AlarmListTableViewCell"
    
    // MARK: 시간 표시할 라벨
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return label
    }()
    
    // MARK: 레이블, 주기 표시할 레이블
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    // MARK: '알람 표시 라벨'
    private lazy var alarmLabel: UILabel = {
        let label = UILabel()
        label.text = "알람"
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    private func addUI(){
        addSubview(alarmLabel)
        alarmLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        alarmLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
    }
    
    private func addNewAlarmUI(){
        addSubview(descriptionLabel)
        addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
    }
    // MARK: 알람 데이터 입력하는 함수
    func inputText(time: String?, description: String?, index: Int){
        
        switch index{
        case 0:
            addUI()
        default:
            addNewAlarmUI()
            self.timeLabel.text = time
            self.descriptionLabel.text = description
        }
        
    }

    
}
