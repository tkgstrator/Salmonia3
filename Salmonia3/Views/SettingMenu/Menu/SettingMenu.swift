//
//  SettingMenu.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/04.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct SettingMenu: View {
    let title: String
    let value: String
    
    init(title: LocalizableStrings.Key, value: Optional<Any>) {
        self.title = title.rawValue.localized
        self.value = value.stringValue
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

//struct SettingMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingMenu()
//    }
//}
