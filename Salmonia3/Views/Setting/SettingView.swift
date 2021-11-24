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
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SplatNet2"), content: {
                    HStack(content: {
                        Text("Nickname")
                        Spacer()
                        Text(appManager.account.nickname)
                            .foregroundColor(.secondary)
                    })
                    HStack(content: {
                        Text("PlayerId")
                        Spacer()
                        Text(appManager.account.nsaid)
                            .foregroundColor(.secondary)
                    })
                    AccountView(manager: appManager)
                    NavigationLink(destination: FireStatsSetting(), label: {
                        Text("FireStats")
                    })
                })
                Section(header: Text("Appearances"), content: {
                    Toggle(isOn: $appManager.apperances.isDarkmode, label: {
                        Text("Using Dark Mode")
                    })
                    NavigationLink(destination: FontStylePicker(), label: { Text("Font Style") })
                    ListStyleDialog()
                    ResultStyleDialog()
                    RefreshStyleDialog()
//                    FontStyleDialog()
                })
                Section(content: {
                    Button(action: {
                        appManager.addLatestShiftSchedule()
                    }, label: {
                        Text("Import shift schedule")
                    })
                }, header: {
                    
                })
                Section(header: Text("Application"), content: {
                    HStack(content: {
                        Text("API version")
                        Spacer()
                        Text(appManager.application.apiVersion)
                            .foregroundColor(.secondary)
                    })
                    HStack(content: {
                        Text("App version")
                        Spacer()
                        Text(appManager.application.appVersion)
                            .foregroundColor(.secondary)
                    })
                })
            }
            .navigationTitle("Setting")
        }
    }
}

private struct ListStyleDialog: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            HStack(content: {
                Text("List Style")
                Spacer()
                Text(appManager.apperances.listStyle.rawValue)
                    .foregroundColor(.secondary)
            })
        })
            .confirmationDialog(Text(appManager.apperances.listStyle.rawValue), isPresented: $isPresented, actions: {
                ForEach(AppManager.Appearances.ListStyle.allCases) { listStyle in
                    Button(action: {
                        appManager.apperances.listStyle = listStyle
                        appManager.objectWillChange.send()
                    }, label: { Text(listStyle.rawValue) })
                }
            })
    }
}

private struct ResultStyleDialog: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            HStack(content: {
                Text("Result Style")
                Spacer()
                Text(appManager.apperances.resultStyle.rawValue)
                    .foregroundColor(.secondary)
            })
        })
            .confirmationDialog(Text(appManager.apperances.resultStyle.rawValue), isPresented: $isPresented, actions: {
                ForEach(AppManager.Appearances.ResultStyle.allCases) { resultStyle in
                    Button(action: {
                        appManager.apperances.resultStyle = resultStyle
                        appManager.objectWillChange.send()
                    }, label: { Text(resultStyle.rawValue) })
                }
            })
    }
}

private struct RefreshStyleDialog: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            HStack(content: {
                Text("Refresh Style")
                Spacer()
                Text(appManager.apperances.refreshStyle.rawValue)
                    .foregroundColor(.secondary)
            })
        })
            .confirmationDialog(Text(appManager.apperances.refreshStyle.rawValue), isPresented: $isPresented, actions: {
                ForEach(AppManager.Appearances.RefreshStyle.allCases) { refreshStyle in
                    Button(action: {
                        appManager.apperances.refreshStyle = refreshStyle
                        appManager.objectWillChange.send()
                    }, label: { Text(refreshStyle.rawValue) })
                }
            })
    }
}

private struct FontStyleDialog: View {
    @EnvironmentObject var appManager: AppManager
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }, label: {
            Text("Font Style")
        })
            .confirmationDialog(Text(appManager.apperances.fontStyle.rawValue), isPresented: $isPresented, actions: {
                ForEach(FontStyle.allCases) { fontStyle in
                    Button(action: {
                        appManager.apperances.fontStyle = fontStyle
                        appManager.objectWillChange.send()
                    }, label: { Text(fontStyle.rawValue) })
                }
            })
    }
}

private struct FontStylePicker: View {
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        VStack(content: {
            Text("Select System Font")
            Text("システムフォントを選択してください")
            Picker(selection: $appManager.apperances.fontStyle, content: {
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
