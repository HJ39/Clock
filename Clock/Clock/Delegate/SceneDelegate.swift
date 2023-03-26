//
//  SceneDelegate.swift
//  Clock
//
//  Created by 정호진 on 2023/03/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        /// 세계 시계
        let worldClockView = WorldClockController()
        worldClockView.tabBarItem.title = "세계 시계"
        
        worldClockView.tabBarItem.image = UIImage(systemName: "globe")
        worldClockView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.lightGray], for: .normal)
        
        worldClockView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.orange], for: .selected)
        
        /// 알람 뷰
        let alarmView = AlarmController()
        let navigation = UINavigationController(rootViewController: alarmView)
        alarmView.tabBarItem.title = "알람"
        alarmView.tabBarItem.image = UIImage(systemName: "alarm.fill")
        alarmView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.lightGray], for: .normal)
        alarmView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.orange], for: .selected)
        
        /// 스톱워치 뷰
        let stopWatchView = StopWatchController()
        stopWatchView.tabBarItem.title = "스톱워치"
        stopWatchView.tabBarItem.image = UIImage(systemName: "stopwatch.fill")
        stopWatchView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.lightGray], for: .normal)
        
        stopWatchView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.orange], for: .selected)
        
        /// 타이머 뷰
        let timerView = TimerController()
        timerView.tabBarItem.title = "타이머"
        timerView.tabBarItem.image = UIImage(systemName: "timer")
        timerView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.lightGray], for: .normal)
        
        timerView.tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.orange], for: .selected)
        
        
        tabBarController.tabBar.tintColor = .lightGray
        let viewControllers = [worldClockView, navigation, stopWatchView, timerView]
        tabBarController.setViewControllers(viewControllers, animated: true)
    }



}

