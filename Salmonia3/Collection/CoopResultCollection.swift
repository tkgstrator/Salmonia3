//
//  CoopResultCollecton.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import SwiftUI

struct CoopResultCollection: View {
    @EnvironmentObject var main: CoreRealmCoop
    
    var body: some View {
        List {
            ForEach(main.results) { result in
                NavigationLink(destination: LoadingView()) {
                    Text("RESULT_VIEW")
                }
            }
        }
    }
}

struct CoopResultCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopResultCollection()
    }
}
