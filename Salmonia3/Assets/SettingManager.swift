//
//  SettingManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation

class AppManager {
    #warning("ダサいからそのうち消えるかも")
    public class func isLogin(isLogin: Bool) {
        UserDefaults.standard.setValue(isLogin, forKey: "isLogin")
    }
    
}
