//
//  AppearanceInfo.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/04.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

extension Setting.Sections {
    struct Appearance: View {
        @EnvironmentObject var appManager: AppManager
        @State var actionSheetItem: ActionSheet?
        @State var actionsItem: [ActionSheet] = [
            ActionSheet(title: Text(.SETTING_LISTSTYLE),
                        message: Text(.TEXT_CHOOSE_STYLE),
                        buttons: ResultListStyle.allCases.map({ style in
                                                                .default(Text(style.rawValue.localized), action: { style.setValue() } )})
                            + [.cancel()]),
            ActionSheet(title: Text(.SETTING_RESULTSTYLE),
                        message: Text(.TEXT_CHOOSE_STYLE),
                        buttons: ResultStyle.allCases.map({ style in
                                                            .default(Text(style.rawValue.localized), action: { style.setValue() } )})
                            + [.cancel()]),
        ]
        
        var body: some View {
            Section(header: Text(.HEADER_APPEARANCE).splatfont2(.safetyorange, size: 14)) {
                Toggle(LocalizableStrings.Key.SETTING_DARKMODE.rawValue.localized, isOn: $appManager.isDarkMode)
                HStack(alignment: .center, spacing: nil, content: {
                    Text(.SETTING_LISTSTYLE)
                    Spacer()
                    Button(action: { actionSheetItem = actionsItem[0] }, label: {
                        Text(appManager.listStyle.rawValue.localized)
                    })
                })
                HStack(alignment: .center, spacing: nil, content: {
                    Text(.SETTING_RESULTSTYLE)
                    Spacer()
                    Button(action: { actionSheetItem = actionsItem[1] }, label: {
                        Text(appManager.resultStyle.rawValue.localized)
                    })
                })
                .actionSheet(item: $actionSheetItem, content: { action in
                    action
                })
            }
        }
    }
}

extension ActionSheet: Identifiable {
    public var id: UUID { UUID() }
}


//struct AppearanceInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        AppearanceInfo()
//    }
//}
