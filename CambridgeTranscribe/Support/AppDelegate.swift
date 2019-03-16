//
//  AppDelegate.swift
//  CambridgeTranscribe
//
//  Created by Viet Duc Nguyen on 10.03.19.
//  Copyright © 2019 Viet Duc Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        let lectures = [LectureDocument(id: "cs106", shortName: "CS106", name: "Machine Intelligence", color: .turquoise)]
        let lectureStore = LectureStore.lectures
        try! lectureStore.save(lectures)
        
        let fragments = [
            TranscriptFragment(content: "Frequency is the number of occurrences of a repeating event per unit of time. It is also referred to as temporal frequency, which emphasizes the contrast to spatial frequency and angular frequency. The period is the duration of time of one cycle in a repeating event, so the period is the reciprocal of the frequency. For example: if a newborn baby's heart beats at a frequency of 120 times a minute, its period—the time interval between beats—is half a second.", isFavourite: false, tags: [TranscriptTag(name: .marking, range: NSRange(location: 0, length: 5)), TranscriptTag(name: .keyword, range: NSRange(location: 10, length: 5))]),
            TranscriptFragment(content: "Frequency is an important parameter used in science and engineering to specify the rate of oscillatory and vibratory phenomena, such as mechanical vibrations, audio signals, radio waves, and light.", isFavourite: true)
                         ];
        let transcript = TranscriptDocument(id:"test-01", title: "CS107 Programming Paradigms", sequence: 6, fragments: fragments, lectureId: "cs106")
        let store = TranscriptStore.transcripts
        try! store.save(transcript)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

