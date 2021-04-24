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
    var toggleFavorite:() -> Void
    var isFavorite:Bool
    
    var body: some View {
        HStack {
            if let url = entry.image {
                ImageView(withURL: url)
            }
            VStack(alignment: .leading) {
                Text(entry.title)
                HStack {
                    Text(entry.category)
                        .font(Font.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button {
                        toggleFavorite()
                    } label: {
                        if isFavorite {
                            Image(systemName: "heart.fill")
                        }
                        else {
                            Image(systemName: "heart")
                        }
                    }
                }
            }
        }
    }
}

fileprivate let testEntry = FeedEntry(title: "title", urlString: "https://test", category: "")

struct FeedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedEntryView(entry:testEntry, tapCategoryAction:{}, toggleFavorite: {}, isFavorite: false)
    }
}
