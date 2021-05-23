//
//  LoadingIndicator.swift
//  Salmonia3
//
//  Created by devonly on 2021/05/23.
//

import SwiftUI
import SwiftyAPNGKit

struct LoadingIndicator: View {
    @AppStorage("loadingIcon") var loadingIcon: LoadingType = .LOADING_SNOW
    var loading: Bool
    
    var body: some View {
        APNGView(named: loadingIcon.rawValue)
            .frame(width: 64, height: 64, alignment: .center)
            .opacity(loading ? 1.0 : 0.0)
            .onChange(of: loading) { value in
                log.verbose("LOADING \(loading)")
            }
    }
}

//struct LoadingIndicator_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingIndicator()
//    }
//}
