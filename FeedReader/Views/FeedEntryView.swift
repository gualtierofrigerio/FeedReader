//
//  FeedEntryView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import SwiftUI

struct FeedEntryView: View {
    var entry:FeedEntry
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
            Text(entry.category)
                .font(Font.caption)
                .foregroundColor(.secondary)
        }
    }
}

fileprivate let testEntry = FeedEntry(title: "title", urlString: "https://test", category: "")

struct FeedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedEntryView(entry:testEntry)
    }
}
