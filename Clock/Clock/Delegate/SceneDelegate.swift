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
        
        /// 알람 뷰
        let alarmView = AlarmController()
        alarmView.tabBarItem.title = "알람"
        alarmView.tabBarItem.image = UIImage(systemName: "alarm.fill")
        
        /// 스톱워치 뷰
        let stopWatchView = StopWatchController()
        stopWatchView.tabBarItem.title = "스톱워치"
        stopWatchView.tabBarItem.image = UIImage(systemName: "stopwatch.fill")
        
        /// 타이머 뷰
        let timerView = TimerController()
        timerView.tabBarItem.title = "타이머"
        timerView.tabBarItem.image = UIImage(systemName: "timer")
        
        let viewControllers = [worldClockView, alarmView, stopWatchView, timerView]
        tabBarController.setViewControllers(viewControllers, animated: true)
        
    }



}

