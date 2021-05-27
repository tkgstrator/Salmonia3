//
//  ImportingView.swift
//  Salmonia3
//
//  Created by devonly on 2021/04/18.
//

import SwiftUI
import Combine
import SalmonStats
import SplatNet2
import MBCircleProgressBar

struct ImportingView: View {
    @Environment(\.presentationMode) var present
    @State var task = Set<AnyCancellable>()
    @State var progressModel = MBCircleProgressModel(progressColor: .blue, emptyLineColor: .gray)
    @State var isPresented: Bool = false
    @State var apiError: SplatNet2.APIError?
    
    private func dismiss() {
        DispatchQueue.main.async { present.wrappedValue.dismiss() }
    }
    
    var body: some View {
        LoggingThread(progressModel: progressModel)
            .alert(isPresented: $isPresented) {
                Alert(title: Text(.ALERT_ERROR),
                      message: Text(apiError?.localizedDescription ?? LocalizableStrings.Key.ALERT_ERROR.rawValue.localized),
                      dismissButton: .default(Text(.BTN_DISMISS), action: { dismiss() }))
            }
        .onAppear(perform: importResultFromSalmonStats)
        .navigationTitle(.TITLE_LOGGING_THREAD)
    }
    
    private func importResultFromSalmonStats() {
        let dispatchQueue = DispatchQueue(label: "Network Publisher")

        // 情報がなければ何もせずエラーを返す
        guard let nsaid = SplatNet2.shared.playerId else {
            apiError = .empty
            isPresented.toggle()
            return
        }
        
        SalmonStats.shared.getMetadata(nsaid: nsaid)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { metadata in
                DispatchQueue.main.async {
                    let maxValue = CGFloat(metadata.map{ $0.results.clear + $0.results.fail }.reduce(0, +))
                    #if DEBUG
                    progressModel.configure(maxValue: maxValue)
                    #else
                    progressModel.configure(maxValue: maxValue)
                    #endif
                }
                for userdata in metadata {
                    #if DEBUG
                    let lastPageId: Int = Int((userdata.results.clear + userdata.results.fail) / 50) + 1
                    #else
                    let lastPageId: Int = Int((userdata.results.clear + userdata.results.fail) / 50) + 1
                    #endif
                    for pageId in Range(1 ... lastPageId) {
                        dispatchQueue.async {
                            SalmonStats.shared.getResults(nsaid: userdata.playerId, pageId: pageId)
                                .receive(on: dispatchQueue)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        print("FINISHED")
                                    case .failure(let error):
                                        apiError = error
                                        isPresented.toggle()
                                    }
                                }, receiveValue: { results in
                                    DispatchQueue.main.async {
                                        progressModel.addValue(value: CGFloat(results.count))
                                        RealmManager.addNewResultsFromSalmonStats(from: results, pid: nsaid)
                                    }
                                })
                                .store(in: &task)
                        }
                    }
                }
            })
            .store(in: &task)
    }
}

struct ImportingView_Previews: PreviewProvider {
    static var previews: some View {
        ImportingView()
    }
}

public struct ActivityIndicator: View {
    @State private var isAnimating: Bool = false
    public init() {}
    
    private func scale(_ index: Int) -> CGFloat {
        self.isAnimating ? 1 - CGFloat(index) * 0.2 : 0.2 + CGFloat(index) * 0.2
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ForEach(0 ..< 5) { index in
                Circle()
                    .fill(Color.red)
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                    //                    .scaleEffect(scale(index))
                    .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                                .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                                .repeatForever(autoreverses: false))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear{ isAnimating.toggle() }
    }
}
