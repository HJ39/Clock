//
//  CustomSongButton.swift
//  Clock
//
//  Created by 정호진 on 2023/04/12.
//

import Foundation
import UIKit

final class CustomSongButton: UIButton{
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        super.init(frame: CGRect.zero)
        addUI()
    }
    
    // MARK: 이름 라벨
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "타이머 종료 시"
        label.textColor = .white
        return label
    }()
    
    // MARK: 선택한 노래 라벨
    private lazy var songLabel: UILabel = {
        let label = UILabel()
        label.text = "전파 탐지기 >"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Add UI to Button
    private func addUI(){
        self.addSubview(nameLabel)
        self.addSubview(songLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            
            self.songLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.songLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
        ])
    }
    
    func choice(text: String){
        addUI()
        self.songLabel.text = text
    }
    
    
}
