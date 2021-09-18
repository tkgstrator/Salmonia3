//
//  AppInformation.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/18.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

extension Setting.Sections {
    struct AppInformation: View {
        private let appVersion: String = "\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!))(\(String(describing: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!)))"
        private let xProductVersion: String = UserDefaults.standard.string(forKey: "xProductVersion") ?? "-"
        private let apiVersion: String = UserDefaults.standard.string(forKey: "apiVersion") ?? "-"
        
        var body: some View {
            Section(header: Text(.HEADER_APPLICATION).splatfont2(.safetyorange, size: 14)) {
                SettingMenu(title: .SETTING_APP_VERSION, value: appVersion)
                SettingMenu(title: .SETTING_API_VERSION, value: "\(xProductVersion)(\(apiVersion))")
            }
        }
    }

    struct AppInformation_Previews: PreviewProvider {
        static var previews: some View {
            AppInformation()
        }
    }
}

