//
//  CoopResultCollecton.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import SwiftUI

struct CoopResultCollection: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var main: CoreRealmCoop
    @State var isActive: Bool = false
    @State var isShowing: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink(destination: LoadingView(), isActive: $isActive) { EmptyView() }
            switch appManager.listStyle {
            case .legacy:
                PlainListStyleView
            case .inset:
                InsetListStyleView
            case .sidebar:
                SidebarListStyleView
            }
        }
        .navigationTitle(.TITLE_RESULT_COLLECTION)
    }
    
    var SidebarListStyleView: some View {
        List {
            ForEach(main.results) { shift in
                Section(header: CoopShift(shift: shift.phase)) {
                    ForEach(shift.results, id:\.self) { result in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: CoopResultView(result: result)) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            ResultOverview(result: result)
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .pullToRefresh(isShowing: $isShowing) { isActive.toggle() }
    }
    
    var PlainListStyleView: some View {
        List {
            ForEach(main.results) { shift in
                Section(header: CoopShift(shift: shift.phase)) {
                    ForEach(shift.results, id:\.self) { result in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: CoopResultView(result: result)) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            ResultOverview(result: result)
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .pullToRefresh(isShowing: $isShowing) { isActive.toggle() }
    }
    
    var InsetListStyleView: some View {
        List {
            ForEach(main.results) { shift in
                Section(header: CoopShift(shift: shift.phase)) {
                    ForEach(shift.results, id:\.self) { result in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: CoopResultView(result: result)) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            ResultOverview(result: result)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .pullToRefresh(isShowing: $isShowing) { isActive.toggle() }
        
    }
}

struct CoopResultCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopResultCollection()
    }
}

struct ResultOverview: View {
    @StateObject var result: RealmCoopResult
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text("\(result.indexOfResults)")
                .splatfont2(size: 12)
                .offset(y: -10)
            HStack(spacing: 0) {
                ResultJob
                Spacer()
                ResultGrade
                Spacer()
                ResultEggs
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var ResultGrade: some View {
        if result.isClear {
            return AnyView(
                HStack {
                    Text(SRGrade(rawValue: result.gradeId.value ?? 0)!.name)
                    Text("\(result.gradePoint.intValue)")
                    Text("↑").splatfont(.red, size: 14)
                }
                .splatfont(size: 14)
            )
        } else {
            return AnyView(
                HStack {
                    Text(SRGrade(rawValue: result.gradeId.value ?? 0)!.name)
                    Text("\(result.gradePoint.intValue)")
                    Text(result.gradePointDelta.intValue == 0 ? "→" : "↓")
                }
                .splatfont(.gray, size: 14)
            )
        }
    }
    
    var ResultJob: some View {
        if result.isClear {
            return AnyView(
                Text(.RESULT_CLEAR)
                    .splatfont(.green, size: 14)
                    .frame(width: 70)
            )
        } else {
            return AnyView(
                Text(.RESULT_DEFEAT)
                    .splatfont(.orange, size: 14)
                    .frame(width: 70)
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
