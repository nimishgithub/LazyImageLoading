//
//  AppDelegate.swift
//  FlickrImageSearch
//
//  Created by Nimish Sharma on 22/08/20.
//  Copyright © 2020 Nimish Sharma. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
      launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      configureAppearance()
      return true
    }
    
    func configureAppearance() {
      UISearchBar.appearance().tintColor = .themeBlue
      UINavigationBar.appearance().tintColor = .themeBlue
    }


}

