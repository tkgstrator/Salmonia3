//
//  SettingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/19.
//

import SwiftUI
import SwiftyUI
import SplatNet2

struct SettingView: View {
    @EnvironmentObject var service: AppManager
    
    var body: some View {
        NavigationView {
            Form(content: {
                Section(content: {
                    HSContent(title: "USER.NICKNAME", content: service.account?.nickname)
                    HSContent(title: "USER.PLAYERID", content: service.account?.credential.nsaid)
                    HSContent(title: "USER.IKSMSESSION", content: service.account?.credential.iksmSession)
                    AccountView(manager: service.connection)
                }, header: {
                    Text("SplatNet2")
                })
                Section(content: {
                    NavigationLink(destination: SalmonStatsSetting(), label: {
                        Text("Salmon Stats")
                    })
                    NavigationLink(destination: SalmonStatPlusSetting(), label: {
                        Text("Salmon Stats+")
                    })
                }, header: {
                    Text("Salmon Stats")
                })
                Section(content: {
                    Toggle(isOn: $service.apperances.isDarkmode, label: {
                        Text("SETTING.DARKMODE")
                    })
                }, header: {
                    Text("SETTING.APPEARANCES")
                })
                Section(content: {
                    HSContent(title: "USER.APPVERSION", content: service.application.appVersion)
                    HSContent(title: "USER.APIVERSION", content: service.connection.version)
                }, header: {
                    Text("SETTING.APPLICATION")
                })
            })
                .navigationTitle("Setting")
        }
        .navigationViewStyle(SplitNavigationViewStyle())
    }
}

private struct ListStyleDialog: View {
    @EnvironmentObject var service: AppManager
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
                ForEach(AppManager.Appearances.ListStyle.allCases) { listStyle in
                    Button(action: {
                        service.apperances.listStyle = listStyle
                        service.objectWillChange.send()
                    }, label: { Text(listStyle.rawValue) })
                }
            })
    }
}

private struct ResultStyleDialog: View {
    @EnvironmentObject var service: AppManager
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
                ForEach(AppManager.Appearances.ResultStyle.allCases) { resultStyle in
                    Button(action: {
                        service.apperances.resultStyle = resultStyle
                        service.objectWillChange.send()
                    }, label: { Text(resultStyle.rawValue) })
                }
            })
    }
}

private struct RefreshStyleDialog: View {
    @EnvironmentObject var service: AppManager
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
                ForEach(AppManager.Appearances.RefreshStyle.allCases) { refreshStyle in
                    Button(action: {
                        service.apperances.refreshStyle = refreshStyle
                        service.objectWillChange.send()
                    }, label: { Text(refreshStyle.rawValue) })
                }
            })
    }
}

private struct FontStyleDialog: View {
    @EnvironmentObject var service: AppManager
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
    @EnvironmentObject var service: AppManager
    
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
    }
}
