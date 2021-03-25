//
//  MBCirlceProgress.swift
//  Salmonia3
//
//  Created by Devonly on 3/13/21.
//

import Foundation
import SwiftUI

struct MBCircleProgressBar: View {
    @Binding var data: ProgressData
    @State var lineWidth: CGFloat
    @State var color: [Color] = [.red, .blue]
    @State var size: CGFloat
    
    var body: some View {
        Group {
            ZStack {
                Circle().stroke(Color.gray, lineWidth: lineWidth)
                    .opacity(0.1)
                Group {
                    Circle()
                        .trim(from: 0, to: data.progress)
                        .stroke(color[0], lineWidth: lineWidth)
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .trim(from: 0, to: data.progress >= 1.0 ? data.progress - 1.0 : 0.0)
                        .stroke(color[1], lineWidth: lineWidth)
                        .rotationEffect(.degrees(-90))
                }
                .opacity(0.8)
                .overlay(
                    VStack {
                        Text(String(data.progress.round) + "%")
                        Text(data.progress > 1.0 ? "LOG_UPLOAD" : "LOG_DOWNLOAD")
                    }
                    .font(.custom("Roboto Mono", size: 20)))
            }
            .animation(.easeOut(duration: 0.2))
            .padding(.all, 20)
            .frame(height: size)
        }
    }
}

#warning("これもっとかっこよく書きたい")
struct ProgressData {
    var progress: CGFloat = 0.0 // 進行度を表す値
    var localizedDescription: String? // 現在の状態を出力
    var errorCode: Int? // エラーコード
    var errorDescription: String? // エラーの内容
}

private extension CGFloat {
    var round: Double {
        let value: Double = self > 1.0 ? Double(self) - 1.0 : Double(self)
        return Double(Int(value * 10000)) / Double(100)
    }
}
