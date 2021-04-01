//
//  SettingManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI

class AppManager {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true


    public class func erase() {
        UserDefaults.standard.setValue(false, forKey: "isLogin")
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        #warning("継承してるからこれいらないのでは疑惑")
        try? RealmManager.eraseAllRecord()
    }
    
    public class func configure(oauthToken: String, oauthVerifier: String) {
        UserDefaults.standard.setValue(oauthToken, forKey: "oauthToken")
        UserDefaults.standard.setValue(oauthVerifier, forKey: "oauthVerifier")
    }
    
    public class func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "apiToken")
    }
    
    
}
