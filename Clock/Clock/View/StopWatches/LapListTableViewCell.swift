//
//  LapListTableViewCell.swift
//  Clock
//
//  Created by 정호진 on 2023/03/29.
//

import Foundation
import UIKit

final class LapListTableViewCell: UITableViewCell{
    static let identifier = "LapListTableViewCell"
    
    // MARK: 기록 이름 ex) 랩1, 랩 2
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 시간 기록
    private lazy var record: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        return label
    }()
    
    // MARK: UI 적용
    private func addUI(){
        self.addSubview(nameLabel)
        self.addSubview(record)
        
        self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20).isActive = true
        
        self.record.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.record.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
    }
    
    // MARK: 데이터 입력 받아 라벨에 적용
    func inputRecord(name: String, record: String, color: UIColor){
        addUI()
        self.nameLabel.text = name
        self.record.text = record
        self.nameLabel.textColor = color
        self.record.textColor = color
    }
    
}
