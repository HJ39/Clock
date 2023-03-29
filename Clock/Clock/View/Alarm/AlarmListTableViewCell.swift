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
        label.font = .systemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: 레이블, 주기 표시할 레이블
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private func addNewAlarmUI(){
        addSubview(timeLabel)
        addSubview(descriptionLabel)
        
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
     
    }
    
    // MARK: 알람 데이터 입력하는 함수
    func inputText(time: String?, description: String?, index: Int, color: UIColor){
        addNewAlarmUI()
        self.timeLabel.text = time
        self.timeLabel.textColor = color
        
        if index == 0{
            self.timeLabel.font = .systemFont(ofSize: 30)
            
            descriptionLabel.text = nil
        }
        else{
            timeLabel.font = .systemFont(ofSize: 50)

            self.descriptionLabel.text = description
            self.descriptionLabel.textColor = color
        }
        
        
        
    }

    
}
