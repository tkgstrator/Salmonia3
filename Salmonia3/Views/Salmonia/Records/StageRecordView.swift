//
//  StageRecordView.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/23.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct StageRecordView: View {
    @EnvironmentObject var result: CoreRealmCoop
    
    var body: some View {
        PaginationView {
//            ForEach(result.records, id:\.self) { record in
                RecordView()
//            }
        }
    }
}

private struct RecordView: View {
    var body: some View {
        Text("Record")
    }
}

struct StageRecordView_Previews: PreviewProvider {
    static var previews: some View {
        StageRecordView()
    }
}
