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
    @EnvironmentObject var main: CoreRealmCoop
    @State var playerName: String = ""
    
    var body: some View {
        List {
            ForEach(!playerName.isEmpty ? main.players.filter("nickname CONTAINS %@", playerName) : main.players) { player in
                NavigationLink(destination: PlayerResultsView(player: player)) {
                    PlayerOverview(player: player)
                }
            }
        }
        .navigationTitle(.TITLE_PLAYER_COLLECTION)
        .navigationSearchBar({
            SearchBar("ユーザ名", text: $playerName)
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
        .listStyle(PlainListStyle())
        .navigationTitle(nickname)
    }
}

struct PlayerOverview: View {
    @StateObject var player: RealmPlayer
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM/dd HH:mm"
        return dateFormatter
    }
    
    var body: some View {
        HStack {
            URLImage(url: URL(string: player.thumbnailURL)!) { image in image.resizable().clipShape(Circle()) }
                .frame(width: 70, height: 70)
            Spacer()
            Text(player.nickname)
                .splatfont2(size: 18)
            Spacer()
            VStack(alignment: .trailing) {
                Text(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(player.lastMatchedTime))))
            }
            .splatfont2(size: 16)
        }
        
    }
}

struct CoopPlayerCollection_Previews: PreviewProvider {
    static var previews: some View {
        CoopPlayerCollection()
    }
}
