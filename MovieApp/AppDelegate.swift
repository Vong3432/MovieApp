//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 28/05/2022.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Handle testing
        let env = ProcessInfo.processInfo.environment
        if let uiTests = env["UITESTS"], uiTests == "1" {
            // reset auth status
            UserDefaults.standard.set(false, forKey: .authenticated) //logout
        }
        
        return true
    }
}
