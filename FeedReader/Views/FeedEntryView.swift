//
//  FeedEntryView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import SwiftUI

struct FeedEntryView: View {
    var entry:FeedEntry
    var showFeedName:Bool
    var tapCategoryAction: () -> Void
    var tapOnView: () -> Void
    var toggleFavorite: () -> Void
    var isFavorite:Bool
    
    var body: some View {
        HStack {
            CustomImageView(url: entry.image)
                .frame(width:100, height:100)
            infoView
        }
    }
    
    private var infoView: some View {
        VStack(alignment: .leading) {
            Button {
                print("tap on view")
                tapOnView()
            } label: {
                Text(entry.title)
                HStack {
                    Text(entry.category)
                        .font(Font.caption)
                        .foregroundColor(.secondary)
                    if showFeedName {
                        Text(entry.feedName)
                            .font(Font.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button {
                        print("toggle favorite")
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

fileprivate let testEntry = FeedEntry(title: "title",
                                      urlString: "https://test",
                                      category: "",
                                      feedName: "Test")

struct FeedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        FeedEntryView(entry:testEntry,
                      showFeedName: false,
                      tapCategoryAction:{},
                      tapOnView: {},
                      toggleFavorite: {},
                      isFavorite: false)
    }
}
