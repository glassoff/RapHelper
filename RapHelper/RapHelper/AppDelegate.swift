//
//  AppDelegate.swift
//  RapHelper
//
//  Created by Dmitry Ryumin on 28/10/2016.
//  Copyright © 2016 aviasales. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var db: FMDatabase?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupDb()

        let testString = "Ве'дь мы' вы'ступаем си'льно, бу'дто че'люсть питека'нтропа"

        let ending = RhythmGenerator.ending(with: testString)

        let rhyme = RhymeFinder.find(ending, db: db!)

        print(rhyme)

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

    
    func setupDb() {
        let fileDbName = "words"
        let fileDbExtension = "db"
        
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileDbURL = baseURL.appendingPathComponent(fileDbName + "." + fileDbExtension)
        
        if FileManager.default.fileExists(atPath: fileDbURL.path) == false {
            let fileURLInBundle = Bundle.main.url(forResource: fileDbName, withExtension: fileDbExtension)
            try! FileManager.default.copyItem(at: fileURLInBundle!, to: fileDbURL)
        }
        
        guard let db = FMDatabase(path: fileDbURL.path) else {
            print("unable to create database")
            return
        }
        
        guard db.open() else {
            print("Unable to open database")
            return
        }
        
        self.db = db
    }

}

