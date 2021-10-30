//
//  ResultCollectionView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/24.
//

import SwiftUI
import SwiftUIX
import RealmSwift
import Alamofire

struct ResultCollectionView: View {
    @EnvironmentObject var appManager: AppManager
    @ObservedResults(RealmCoopResult.self, sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)) var results
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(results) { result in
                    NavigationLinker(destination: ResultView(result), label: {
                        ResultOverview(result)
                    })
                }
            })
                .listStyle(.plain)
                .refreshable {
                    isPresented.toggle()
                }
                .onAppear {
                    isPresented = false
                }
                .fullScreenCover(isPresented: $isPresented, onDismiss: { isPresented = false }, content: {
                    LoadingView()
                        .environmentObject(appManager)
                })
                .navigationTitle("Results")
        })
            .overlay(refreshButton, alignment: .bottomTrailing)
    }
    
    var refreshButton: some View {
        Button(action: { isPresented.toggle() }, label: { Image(.refresh).resizable().aspectRatio(contentMode: .fit).frame(width: 35) })
            .buttonStyle(GrowingButtonStyle())
            .visible(appManager.apperances.refreshStyle == .button)
            .padding()
    }
}

struct ResultCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCollectionView()
    }
}

struct NavigationLinker<Destination: View, Label: View>: View {
    let destination: Destination
    let label: () -> Label
    
    init(destination: Destination, label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    var body: some View {
        ZStack(content: {
            NavigationLink(destination: destination, label: {
                EmptyView()
            })
                .opacity(0.0)
            label()
        })
    }
}
