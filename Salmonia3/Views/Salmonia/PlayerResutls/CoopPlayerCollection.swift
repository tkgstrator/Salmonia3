//
//  CoopPlayerCollection.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/06/07.
//

import SwiftUI
import SwiftUIX
import SwiftyUI
import RealmSwift
import URLImage

struct CoopPlayerCollection: View {
    @ObservedResults(RealmPlayer.self, filter: NSPredicate(format: "lastMatchedTime!=0"), sortDescriptor: SortDescriptor(keyPath: "lastMatchedTime", ascending: false)) var players
    @State var playerName: String = ""
    
    var body: some View {
        List {
            ForEach(players) { player in
                ZStack(content: {
                    NavigationLink(destination: PlayerResultsView(player: player)) {
                        EmptyView()
                    }
                    .opacity(0.0)
                    PlayerOverview(player: player)
                })
            }
        }
        .navigationTitle(.TITLE_PLAYER_COLLECTION)
        .navigationSearchBar({
            SearchBar("ユーザ名", text: $playerName, onEditingChanged: { _ in
                $players.filter = NSPredicate(format: "nickname CONTAINS %@", argumentArray: [playerName])
            })
            .searchBarStyle(.prominent)
            .onCancel {
                playerName.removeAll()
            }
        })
        .navigationSearchBarHiddenWhenScrolling(true)
    }
}

struct PlayerResultsView: View {
    var nsaid: String
    var nickname: String
    var main: [UserCoopResult] = []

    // イニシャライザ
    init(player: RealmPlayer) {
        self.nsaid = player.nsaid
        self.nickname = player.nickname
        self.main = RealmManager.shared.shiftResults(nsaid: nsaid)
    }

    // イニシャライザ
    init(player: RealmPlayerResult) {
        self.nsaid = player.pid
        self.nickname = player.name.stringValue
        self.main = RealmManager.shared.shiftResults(nsaid: nsaid)
    }
    
    var body: some View {
        List {
            ForEach(main) { shift in
                Section(header: CoopShift(shift: shift.phase, results: shift.results)) {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(nickname)
    }
}

struct PlayerOverview: View {
    let player: RealmPlayer
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM/dd"
        return dateFormatter
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: nil, content: {
                    URLImage(url: URL(string: player.thumbnailURL)!) { image in image.resizable().clipShape(Circle()) }
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                    Text(player.nickname)
                        .splatfont2(size: 16)
                })
                HStack(content: {
                    Text(.LAST_MATCHED_TIME)
                    Text(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(player.lastMatchedTime))))
                })
                .splatfont2(size: 14)
            })
            Spacer()
            VStack(alignment: .trailing, content: {
                #if DEBUG
                Text("RANKED_COUNT_\(player.rankedCount)")
                #endif
                Text("RESULT_MATCHING_\(String(player.matching))")
            })
            .splatfont2(size: 14)
        })
    }
}

struct CoopPlayerCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopPlayerCollection()
    }
}
