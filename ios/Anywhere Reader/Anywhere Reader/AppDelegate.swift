//
//  AppDelegate.swift
//  Anywhere Reader
//
//  Created by Samantha Gatt on 11/6/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        NotificationCenter.default.addObserver(self, selector: #selector(scrapeSharedArticle), name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuth), name: NSNotification.Name.FBSDKAccessTokenDidChange, object: nil)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Calls the 'activate' method to log an app event for use in analytics and advertising reporting.
        AppEventsLogger.activate(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let sharedUserDefaults = UserDefaults(suiteName: "group.com.lambdaschool.AnywhereReader")
        if let url = sharedUserDefaults?.string(forKey: "sharedURL") {
            ArticleController.shared.scrape(with: url) { (error) in
                if let error = error {
                    NSLog("Error with scraping from safari extension: \(error)")
                    return
                }
                sharedUserDefaults?.dictionaryRepresentation().keys.forEach { sharedUserDefaults?.removeObject(forKey: $0) }
            }
        }
    }
    
    
    // MARK: - Facebook authentication
    
    @objc func handleAuth() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        
        var controller: UIViewController?
        if let _ = AccessToken.current  {
            controller = mainStoryboard.instantiateInitialViewController()
        } else {
            controller = authStoryboard.instantiateInitialViewController()
        }
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }
}

