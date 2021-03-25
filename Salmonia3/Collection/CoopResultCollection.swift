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
                ForEach(main.results, id:\.self) { result in
                    NavigationLink(destination: CoopResultView(result: result)) {
                        ResultOverview(result: result)
                    }
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
        HStack(spacing: 0) {
            ResultJob
            Spacer()
            ResultGrade
            Spacer()
            ResultEggs
        }
        .frame(maxWidth: .infinity)
    }
    
    var ResultGrade: some View {
        if result.isClear {
            return AnyView(
                HStack {
                    Text(SRGrade(rawValue: result.gradeId.value ?? 0)!.name)
                    Group {
                        Text("\(result.gradePoint.intValue)")
                        Text("↑").splatfont(.red, size: 14)
                    }
                }
                .splatfont(size: 14)
            )
        } else {
            return AnyView(
                HStack {
                    Text(SRGrade(rawValue: result.gradeId.value ?? 0)!.name)
                    Group {
                        Text("\(result.gradePoint.intValue)")
                        Text(result.gradePointDelta.intValue == 0 ? "→" : "↓")
                    }
                }
                .splatfont(.gray, size: 14)
            )
        }
    }
    
    var ResultJob: some View {
        if result.isClear {
            return AnyView(
                Text("RESULT_CLEAR")
                    .splatfont(.green, size: 14)
                    .frame(width: 50)
            )
        } else {
            return AnyView(
                Text("RESULT_DEFEAT")
                    .splatfont(.orange, size: 14)
                    .frame(width: 50)
            )
        }
    }
    
    var ResultEggs: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image("49c944e4edf1abee295b6db7525887bd").resize()
                Text("x\(result.goldenEggs.intValue)")
                    .frame(width: 50, height: 18, alignment: .leading)
            }
            HStack {
                Image("f812db3e6de0479510cd02684131e15a").resize()
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
