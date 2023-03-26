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
    
    private lazy var label: UILabel = {
       let label = UILabel()
        label.text = "알람"
        label.textColor = .white
        label.font = UIFont(name: "Al Nile", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        scrollView.addSubview(label)
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
            
            
            
        ])
        
        
        
    }
    
    // MARK: 알림 추가 버튼 눌렀을 때
    @objc private func clickedPlusBtn(){
        let addAlarm = AddAlarmOptionsController()
        addAlarm.modalPresentationStyle = .formSheet
        self.present(addAlarm, animated: true)
    }
    
}

