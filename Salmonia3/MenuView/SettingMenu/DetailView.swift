//
//  DetailView.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/19.
//

import SwiftUI
import LocalAuthentication

struct DetailView: View {
    @Environment(\.presentationMode) var present
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = false
    @State var isToggle: [Bool] = Array(repeating: false, count: 2)
    @State var isWarning: Bool = false
    @State var isAuthorized: Bool = false
    @State var messageTitle: String = ""
    
    var body: some View {
        Form {
            Toggle(LocalizableStrings.Key.SETTING_RE_SIGN_IN.rawValue.localized, isOn: $isToggle[0])
                .onChange(of: isToggle[0]) { value in
                    messageTitle = LocalizableStrings.Key.TEXT_RE_SIGN_IN.rawValue.localized
                    if value { isWarning = value }
                }
            Toggle(LocalizableStrings.Key.SETTING_ERASE_DATA.rawValue.localized, isOn: $isToggle[1])
                .onChange(of: isToggle[1]) { value in
                    messageTitle = LocalizableStrings.Key.TEXT_ERASE_DATA.rawValue.localized
                    if value { isWarning = value }
                }
        }
        .onAppear(perform: authorizeWithBiometrics)
        .alert(isPresented: $isWarning) {
            Alert(title: Text(.TEXT_CONFIRM),
                  message: Text(messageTitle),
                  primaryButton: .default(Text(.BTN_CONFIRM),
                                          action: { changeState() }),
                  secondaryButton: .destructive(Text(.BTN_CANCEL),
                                                action: { isToggle = Array(repeating: false, count: 2)})
            )
        }
        .disabled(!isAuthorized)
        .font(.custom("Splatfont2", size: 16))
        .navigationTitle(.TITLE_SETTINGS)
    }
    
    private func authorizeWithBiometrics() {
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: LocalizableStrings.Key.AUTHORIZED_WITH_BIOMETRICS.rawValue.localized) { (success, error) in
                if success { isAuthorized.toggle() }
            }
        } else {
            LAContext().evaluatePolicy(.deviceOwnerAuthentication, localizedReason: LocalizableStrings.Key.AUTHORIZED_WITH_PASSCODE.rawValue.localized) { (success, error) in
                if success { isAuthorized.toggle() }
            }
        }
    }
    
    private func changeState() {
        guard let index = isToggle.firstIndex(of: true) else { return }
        switch index {
        case 0:
            isFirstLaunch.toggle()
        case 1:
            try? RealmManager.eraseAllRecord()
        default:
            break
        }
        isToggle = Array(repeating: false, count: 2)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
