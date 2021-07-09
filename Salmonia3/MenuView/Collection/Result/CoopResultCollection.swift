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
    @State private var isActive: Bool = false
    @State private var isShowing: Bool = false
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var orientation: UIInterfaceOrientation = .portrait
    
    var body: some View {
        ZStack {
            NavigationLink(destination: LoadingView(), isActive: $isActive) { EmptyView() }
            switch appManager.listStyle {
            case .default:
                PlainListStyleView
            case .legacy:
                LegacyListStyleView
            case .inset:
                InsetListStyleView
            case .sidebar:
                SidebarListStyleView
            }
        }
        .navigationTitle(.TITLE_RESULT_COLLECTION)
    }
    
    private var LegacyListStyleView: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: Array(repeating: .init(.fixed(geometry.size.height)), count: 1), alignment: .center, spacing: 0, pinnedViews: []) {
                    ForEach(main.result.indices) { index in
                        CoopResultSimpleView(result: main.result[index])
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                }
            }
            .paging(geometry: geometry, index: $index, offset: $offset, orientation: $orientation)
        }
    }
    
    private var SidebarListStyleView: some View {
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
        .pullToRefresh(isShowing: $isShowing) { isActive.toggle() }
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
                    Text(SRGrade(rawValue: result.gradeId.intValue)!.name)
                    Text("\(result.gradePoint.intValue)")
                    Text("↑").splatfont(.red, size: 14)
                }
                .splatfont(size: 14)
            )
        } else {
            return AnyView(
                HStack {
                    Text(SRGrade(rawValue: result.gradeId.intValue)!.name)
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

fileprivate extension ScrollView {
    func paging(geometry: GeometryProxy, index: Binding<Int>, offset: Binding<CGFloat>, orientation: Binding<UIInterfaceOrientation>) -> some View {
        return self
            .content.offset(x: offset.wrappedValue)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                guard let status = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
                if !UIDevice.current.orientation.isFlat {
                    if (orientation.wrappedValue.isPortrait != status.isPortrait) || (orientation.wrappedValue.isLandscape != status.isLandscape) {
                        offset.wrappedValue = -(geometry.size.height + (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)) * CGFloat(index.wrappedValue)
                        orientation.wrappedValue = status
                    }
                }
            }
            .gesture(DragGesture()
                        .onChanged({ value in
                            offset.wrappedValue = value.translation.width - geometry.size.width * CGFloat(index.wrappedValue)
                        })
                        .onEnded({ value in
                            let scrollThreshold = geometry.size.width / 2
                            if value.predictedEndTranslation.width < -scrollThreshold {
                                index.wrappedValue = min(index.wrappedValue + 1, 4)
                            } else if value.predictedEndTranslation.width > scrollThreshold {
                                index.wrappedValue = max(index.wrappedValue - 1, 0)
                            }
                            withAnimation {
                                offset.wrappedValue = -geometry.size.width * CGFloat(index.wrappedValue)
                            }
                        })
            )
    }
}
