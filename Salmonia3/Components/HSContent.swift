//
//  HSContent.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/31.
//

import SwiftUI

struct HSContent: View {
//    let title: () -> Title
    let title: LocalizedStringKey
    let alignment: VerticalAlignment
    let spacing: CGFloat?
    let comment: StaticString?
//    let content: () -> Content
    let content: String
    
    init<T: LosslessStringConvertible>(
        title: LocalizedStringKey,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        content: Optional<T>,
        comment: StaticString? = nil)
    {
        self.title = title
        self.alignment = alignment
        self.spacing = spacing
        self.comment = comment
        self.content = {
            guard let content = content else {
                return "-"
            }
            return String(content)
        }()
    }
    
    var body: some View {
        HStack(alignment: alignment, spacing: spacing, content: {
            Text(title, comment: comment)
            Spacer()
            Text(content)
                .foregroundColor(.secondary)
                .lineLimit(1)
        })
    }
}

//struct HSContent_Previews: PreviewProvider {
//    static var previews: some View {
//        HSContent()
//    }
//}
