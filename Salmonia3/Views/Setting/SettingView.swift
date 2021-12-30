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
            Form {
                Section(header: Text("SplatNet2"), content: {
                    HStack(content: {
                        Text("Nickname")
                        Spacer()
                        Text(service.connection.account?.nickname)
                            .foregroundColor(.secondary)
                    })
                    HStack(content: {
                        Text("PlayerId")
                        Spacer()
                        Text(service.connection.account?.credential.nsaid)
                            .foregroundColor(.secondary)
                    })
                    AccountView(manager: service.connection)
                })
                Section(content: {
                    NavigationLink(destination: SalmonStatsSetting(), label: {
                        Text("Salmon Stats")
                    })
                    NavigationLink(destination: SalmonStatPlusSetting(), label: {
                        Text("SalmonStat+")
                    })
                }, header: {
                    Text("External Services")
                })
                Section(header: Text("Appearances"), content: {
                    Toggle(isOn: $service.apperances.isDarkmode, label: {
                        Text("Using Dark Mode")
                    })
//                    NavigationLink(destination: FontStylePicker(), label: { Text("Font Style") })
                    ListStyleDialog()
                    ResultStyleDialog()
                    RefreshStyleDialog()
//                    FontStyleDialog()
                })
                Section(content: {
                    Button(action: {
                        service.addLatestShiftSchedule()
                    }, label: {
                        Text("Import shift schedule")
                    })
                }, header: {
                    
                })
                Section(header: Text("Application"), content: {
                    HStack(content: {
                        Text("API version")
                        Spacer()
                        Text(service.connection.version)
                            .foregroundColor(.secondary)
                    })
                    HStack(content: {
                        Text("App version")
                        Spacer()
                        Text(service.application.appVersion)
                            .foregroundColor(.secondary)
                    })
                })
            }
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
