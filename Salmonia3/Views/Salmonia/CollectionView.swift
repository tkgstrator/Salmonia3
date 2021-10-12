//
//  CollectionView.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/03.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftUIX
import SwiftUIRefresh
import SwiftyUI

struct CollectionView: View {
    @EnvironmentObject var appManager: AppManager
    @State var collectionType: CollectionType = .result
    
    enum CollectionType: Int, CaseIterable {
        case result
        case wave
        case player
        
        mutating func toggle() {
            self = CollectionType(rawValue: (self.rawValue + 1) % 3)!
        }
    }
    
    var anonymousButton: some View {
        Button(action: {
            appManager.isFree03.toggle()
        }, label: {
            Image(systemName: "person")
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
        .foregroundColor(!appManager.isFree03 ? .blue : .gray)
    }
    
    var toggleButton: some View {
        Button(action: {
            collectionType.toggle()
        }, label: {
            Image(systemName: "switch.2")
                .resizable()
                .aspectRatio(contentMode: .fit)
        })
    }
    
    var body: some View {
        NavigationView {
            switch collectionType {
            case .result:
                CoopResultCollection()
                    .navigationBarItems(leading: anonymousButton, trailing: toggleButton)
            case .wave:
                CoopWaveCollection()
                    .navigationBarItems(trailing: toggleButton)
            case .player:
                CoopPlayerCollection()
                    .navigationBarItems(trailing: toggleButton)
            }
        }
        .navigationViewStyle(SplitNavigationViewStyle())
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
