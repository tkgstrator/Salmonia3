//
//  CoopResultCollecton.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import SwiftUI

struct CoopResultCollection: View {
    @EnvironmentObject var main: CoreRealmCoop
    @State var isActive: Bool = false
    @State var isShowing: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: LoadingView(), isActive: $isActive) { EmptyView() }
            List {
                ForEach(main.results) { result in
                    NavigationLink(destination: CoopResult()) {
                        ResultOverview(result: result)
                    }
                    .disabled(true)
                }
            }
            .pullToRefresh(isShowing: $isShowing) {
                isActive.toggle()
            }
        }
        .navigationTitle("TITLE_RESULT_COLLECTION")
    }
}

struct CoopResultCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopResultCollection()
    }
}

struct ResultOverview: View {
    @ObservedObject var result: RealmCoopResult
    
    var body: some View {
        HStack {
            ResultJob
            Spacer()
            ResultEggs
        }
    }
    
    var ResultJob: some View {
        if result.isClear {
            return AnyView(
                Text("RESULT_CLEAR")
                    .splatfont(.green, size: 14)
            )
        } else {
            return AnyView(
                Text("RESULT_DEFEAT")
                    .splatfont(.orange, size: 14)
            )
        }
    }
    
    var ResultEggs: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image("goldenIkura").resize()
                Text("x\(result.goldenEggs.intValue)")
                    .frame(width: 50, height: 18, alignment: .leading)
            }
            HStack {
                Image("ikura").resize()
                Text("x\(result.powerEggs.intValue)")
                    .frame(width: 50, height: 18, alignment: .leading)
            }
        }
        .frame(width: 55)
        .splatfont2(size: 14)
    }
}


#warning("リザルトの詳細ビューはここだけどいまは無効化中")
// リザルトの詳細のビュー
private struct CoopResult: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("RESULT_VIEW")
            }
        }
        .navigationTitle("TITLE_RESULT")
    }
}
