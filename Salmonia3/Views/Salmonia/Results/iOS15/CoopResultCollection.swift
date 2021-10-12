//
//  CoopResultCollecton.swift
//  Salmonia3
//
//  Created by tkgstrator on 3/14/21.
//

import SwiftUI
import SwiftUIX
import SwiftyUI
import SwiftUIRefresh


struct CoopResultCollection: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var main: CoreRealmCoop
    @State private var isActive: Bool = false
    @State private var isShowing: Bool = false
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var orientation: UIInterfaceOrientation = .portrait
    @State private var isPresented: Bool = false

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            let tableView = UITableView.appearance()
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
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
            .refreshable {
                isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented, onDismiss: {}, content: {
                LoadingView()
                    .environmentObject(appManager)
                    .environment(\.modalIsPresented, .constant(PresentationStyle($isPresented)))
            })
        } else {
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
            .present(isPresented: $isPresented, transitionStyle: .flipHorizontal, presentationStyle: .fullScreen, content: {
                LoadingView()
                    .environmentObject(appManager)
                    .environment(\.modalIsPresented, .constant(PresentationStyle($isPresented)))
            })
        }
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
