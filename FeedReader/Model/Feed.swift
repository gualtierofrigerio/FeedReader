//
//  Feed.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import Foundation

struct Feed {
    var entries:[FeedEntry]
}

extension Feed {
    static func createFromArray(_ array: [[String:String]]) -> Self {
        let feedTopicHelper = FeedTopicHelper()
        var entries:[FeedEntry] = []
        for element in array {
            if let title = element["title"],
               let url = element["link"] {
                let topic = feedTopicHelper.getTopic(forText: title) ?? ""
                let entry = FeedEntry(title: title, url: url, category: topic)
                entries.append(entry)
            }
        }
        return Feed(entries: entries)
    }
}

struct FeedEntry {
    var title:String
    var url:String
    var category:String
}

extension FeedEntry:Identifiable {
    var id: String {
        title
    }
}
