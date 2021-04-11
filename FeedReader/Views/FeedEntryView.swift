//
//  FeedEntryView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import SwiftUI

struct FeedEntryView: View {
    var entry:FeedEntry
    var tapCategoryAction:() -> Void
    var body: some View {
        HStack {
            if let url = entry.image {
                ImageView(withURL: url)
            }
            VStack(alignment: .leading) {
                Text(entry.title)
                Button {
                    tapCategoryAction()
                } label: {
                    if let selectedCategory = entry.selectedCategory {
                        Text(selectedCategory)
                            .font(Font.caption)
                            .foregroundColor(.red)
                    }
                    else {
                        Text(entry.category)
                            .font(Font.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

fileprivate let testEntry = FeedEntry(title: "title", urlString: "https://test", category: "")

struct FeedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedEntryView(entry:testEntry, tapCategoryAction:{})
    }
}
