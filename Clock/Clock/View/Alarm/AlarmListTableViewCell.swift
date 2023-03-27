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
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
        
        return label
    }()
    
    // MARK: 레이블, 주기 표시할 레이블
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
        return label
    }()
    
    // MARK: 데이터 입력하는 함수
    func inputText(time: String, description: String){
        self.timeLabel.text = time
        self.descriptionLabel.text = description
    }
    
}
