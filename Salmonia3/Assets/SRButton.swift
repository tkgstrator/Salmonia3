//
//  Button.swift
//  Salmonia3
//
//  Created by Devonly on 2021/03/11.
//

import SwiftUI

struct _Button: View {
    let action
    var body: some View {
        Button(action: {}/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        _Button()
    }
}
