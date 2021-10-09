//
//  CoopResultCollecton.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/14/21.
//

import SwiftUI
import SwiftUIX
import SwiftyUI

struct CoopResultCollection: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var main: CoreRealmCoop
    @State private var isActive: Bool = false
    @State private var isShowing: Bool = false
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var orientation: UIInterfaceOrientation = .portrait
    @State private var isPresented: Bool = false

    var body: some View {
        Group {
            switch appManager.listStyle {
            case .default:
                DefaultListStyleView
            case .plain:
                PlainListStyleView
            case .grouped:
                GroupedListStyleView
            case .legacy:
                LegacyListStyleView
            case .inset:
                InsetListStyleView
            case .sidebar:
                SidebarListStyleView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(.TITLE_RESULT_COLLECTION)
        .pullToRefresh(isShowing: $isShowing, onRefresh: {
            isPresented.toggle()
            isShowing = false
        })
        .onDisappear {
            isShowing = false
        }
        
        .present(isPresented: $isPresented, transitionStyle: .flipHorizontal, presentationStyle: .fullScreen, content: {
            LoadingView()
                .environmentObject(appManager)
                .environment(\.modalIsPresented, .constant(PresentationStyle($isPresented)))
        })
    }
    
    private var LegacyListStyleView: some View {
        PaginationView(axis: .horizontal, transitionStyle: .scroll, showsIndicators: true) {
            ForEach(main.result) { result in
                CoopResultSimpleView(result: result)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var SidebarListStyleView: some View {
        List {
            ForEach(main.results) { shift in
                Section(header: CoopShiftView().environment(\.coopshift, shift.phase)) {
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
    }
    
    private var PlainListStyleView: some View {
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
    }
    
    private var GroupedListStyleView: some View {
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
        .listStyle(GroupedListStyle())
    }
    
    private var DefaultListStyleView: some View {
        List {
            ForEach(main.results) { shift in
                Section(header: CoopShiftView().environment(\.coopshift, shift.phase)) {
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
        .listStyle(DefaultListStyle())
    }
    
    private var InsetListStyleView: some View {
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
                .offset(y: 0)
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
                    Text(GradeType(rawValue: result.gradeId.intValue)!.localizedName)
                    Text("\(result.gradePoint.intValue)")
                    Text("↑").splatfont(.red, size: 14)
                }
                .splatfont(size: 14)
            )
        } else {
            return AnyView(
                HStack {
                    Text(GradeType(rawValue: result.gradeId.intValue)!.localizedName)
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
                    .splatfont(.green, size: 13)
                    .frame(width: 60)
            )
        } else {
            return AnyView(
                Text(.RESULT_DEFEAT)
                    .splatfont(.safetyorange, size: 13)
                    .frame(width: 60)
            )
        }
    }
    
    var ResultEggs: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(Egg.golden).resize()
                Text("x\(result.goldenEggs)")
                    .splatfont2(size: 15)
                    .frame(width: 45, height: 22, alignment: .leading)
            }
            HStack {
                Image(Egg.power).resize()
                Text("x\(result.powerEggs)")
                    .splatfont2(size: 15)
                    .frame(width: 50, height: 22, alignment: .leading)
            }
        }
        .frame(width: 50)
    }
}
