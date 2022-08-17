//
//  SettingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftyUI
import SplatNet2

struct SettingView: View {
    @EnvironmentObject var service: AppService
    /// リザルト強制取得モード
    @AppStorage("APP_FORCE_FETCH_RESULTS") var forceFetchResults: Bool = true

    var body: some View {
        Form(content: {
            SettingView_Application()
            Toggle(isOn: $forceFetchResults, label: {
                Text("強制リザルト全件アップロード")
            })
        })
        .navigationTitle("Setting")

        .font(systemName: .Splatfont2, size: 16)
    }
}

private struct ListStyleDialog: View {
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            HStack(content: {
                Text("List Style")
                Spacer()
                Text(service.apperances.listStyle.rawValue)
                    .foregroundColor(.secondary)
            })
        })
        .confirmationDialog(Text(service.apperances.listStyle.rawValue), isPresented: $isPresented, actions: {
            ForEach(AppService.Appearances.ListStyle.allCases) { listStyle in
                Button(action: {
                    service.apperances.listStyle = listStyle
                    service.objectWillChange.send()
                }, label: { Text(listStyle.rawValue) })
            }
        })
    }
}

private struct ResultStyleDialog: View {
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            HStack(content: {
                Text("Result Style")
                Spacer()
                Text(service.apperances.resultStyle.rawValue)
                    .foregroundColor(.secondary)
            })
        })
        .confirmationDialog(Text(service.apperances.resultStyle.rawValue), isPresented: $isPresented, actions: {
            ForEach(AppService.Appearances.ResultStyle.allCases) { resultStyle in
                Button(action: {
                    service.apperances.resultStyle = resultStyle
                    service.objectWillChange.send()
                }, label: { Text(resultStyle.rawValue) })
            }
        })
    }
}

private struct RefreshStyleDialog: View {
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            HStack(content: {
                Text("Refresh Style")
                Spacer()
                Text(service.apperances.refreshStyle.rawValue)
                    .foregroundColor(.secondary)
            })
        })
        .confirmationDialog(Text(service.apperances.refreshStyle.rawValue), isPresented: $isPresented, actions: {
            ForEach(AppService.Appearances.RefreshStyle.allCases) { refreshStyle in
                Button(action: {
                    service.apperances.refreshStyle = refreshStyle
                    service.objectWillChange.send()
                }, label: { Text(refreshStyle.rawValue) })
            }
        })
    }
}

private struct FontStyleDialog: View {
    @EnvironmentObject var service: AppService
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            Text("Font Style")
        })
        .confirmationDialog(Text(service.apperances.fontStyle.rawValue), isPresented: $isPresented, actions: {
            ForEach(FontStyle.allCases) { fontStyle in
                Button(action: {
                    service.apperances.fontStyle = fontStyle
                    service.objectWillChange.send()
                }, label: { Text(fontStyle.rawValue) })
            }
        })
    }
}

private struct FontStylePicker: View {
    @EnvironmentObject var service: AppService
    
    var body: some View {
        VStack(content: {
            Text("Select System Font")
            Text("システムフォントを選択してください")
            Picker(selection: $service.apperances.fontStyle, content: {
                ForEach(FontStyle.allCases) { font in
                    Text(font.rawValue)
                        .font(systemName: font, size: 16)
                        .tag(font)
                }
            }, label: { Text("Font Style") })
            .pickerStyle(.inline)
        })
        .navigationTitle("Font Style")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(AppService())
    }
}
