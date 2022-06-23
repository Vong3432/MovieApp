//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 28/05/2022.
//

import Foundation
import UIKit
import StripeCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        StripeAPI.defaultPublishableKey = Keys.stripePublishToken
        
        // Handle testing
        let env = ProcessInfo.processInfo.environment
        if let uiTests = env["UITESTS"], uiTests == "1" {
            // reset auth status
            try? FileManager().removeItem(at: FileManager.getDocumentsDirectory().appendingPathComponent(.movieDBSessionID))
            UserDefaults.standard.set(false, forKey: .authenticated) //logout
            UserDefaults.standard.set("en", forKey: .localePreference) //reset to eng for testing
        }
        
        return true
    }
    
    // This method handles opening custom URL schemes (for example, "your-app://stripe-redirect")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = StripeAPI.handleURLCallback(with: url)
        if (stripeHandled) {
            return true
        } else {
            // This was not a Stripe url – handle the URL normally as you would
        }
        return false
    }
    
    // This method handles opening universal link URLs (for example, "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool  {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = StripeAPI.handleURLCallback(with: url)
                if (stripeHandled) {
                    return true
                } else {
                    // This was not a Stripe url – handle the URL normally as you would
                }
            }
        }
        return false
    }
}
