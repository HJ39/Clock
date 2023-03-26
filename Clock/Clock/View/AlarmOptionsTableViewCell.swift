//
//  File.swift
//  Clock
//
//  Created by 정호진 on 2023/03/26.
//

import Foundation
import UIKit

final class AlarmOptionsTableViewCell: UITableViewCell{
    static let identifier = "AlarmOptionsTableViewCell"
    
    // MARK: 옵션 리스트 라벨
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font.withSize(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        return label
    }()
    
    // MARK: 다른 화면으로 이동하는 라벨
    private lazy var choicelabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font.withSize(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: 다른 화면으로 이동하는 라벨
    private lazy var inputText: UITextField = {
        let field = UITextField()
        field.placeholder = "알람"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    // MARK: index 0 번인 경우 실행
    private func case0Option(text: String){
        self.addSubview(choicelabel)
        choicelabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        choicelabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        choicelabel.text = text
    }
    
    // MARK: index 1 번인 경우 실행
    private func case1Option(text: String){
        self.addSubview(inputText)
        inputText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        inputText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    // MARK: index 2 번인 경우 실행
    private func case2Option(text: String){
        self.addSubview(choicelabel)
        choicelabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        choicelabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        choicelabel.text = text
    }
    
    // MARK: index 3 번인 경우 실행
    private func case3Option(text: String){
//        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    
    // MARK: tableview에서 전달 받은 데이터 적용
    func inputOptions(title: String, text: String, index: Int){
        label.text = title
        print(text)
        switch index{
        case 0:
            case0Option(text: text)
        case 1:
            case1Option(text: text)
        case 2:
            case2Option(text: text)
        case 3:
            case3Option(text: text)
        default:
            print("잘못된 접근입니다.")
        }
        
        
    }
    
}
