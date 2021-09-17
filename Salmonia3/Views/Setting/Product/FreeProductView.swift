//
//  FreeProductView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/18.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI

struct FreeProductView: View {
    @EnvironmentObject var appManager: AppManager

    var body: some View {
        Form {
            Toggle(isOn: $appManager.isFree01, label: {
                LazyVStack(alignment: .leading, spacing: nil, pinnedViews: [], content: {
                    Text(.FEATURE_FREE_01)
                    Text(.FEATURE_FREE_01_DESC)
                        .splatfont2(size: 12)
                })
            })
            Toggle(isOn: $appManager.isFree02, label: {
                LazyVStack(alignment: .leading, spacing: nil, pinnedViews: [], content: {
                    Text(.FEATURE_FREE_02)
                    Text(.FEATURE_FREE_02_DESC)
                        .splatfont2(size: 12)
                })
            })
            Toggle(isOn: $appManager.isFree03, label: {
                LazyVStack(alignment: .leading, spacing: nil, pinnedViews: [], content: {
                    Text(.FEATURE_FREE_03)
                    Text(.FEATURE_FREE_03_DESC)
                        .splatfont2(size: 12)
                })
            })
        }
        .navigationTitle(.TITLE_FREE_PRODUCT)
        .splatfont2(size: 16)
    }
}

struct FreeProductView_Previews: PreviewProvider {
    static var previews: some View {
        FreeProductView()
    }
}
