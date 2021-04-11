//
//  Feed.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import Foundation

struct Feed {
    var entries:[FeedEntry]
    
    mutating func updateCategory(category:String, forEntry entry:FeedEntry) {
        for i in 0..<entries.count {
            if entries[i].title == entry.title {
                var newEntry = entries[i]
                newEntry.selectedCategory = category
                entries[i] = newEntry
                break
            }
        }
    }
}

extension Feed {
    static func createFromArray(_ array: [XMLDictionary]) -> Self {
        let feedTopicHelper = FeedTopicHelper()
        var entries:[FeedEntry] = []
        for element in array {
            if let elementTitle = element["title"] as? XMLElement,
               let elementLink = element["link"] as? XMLElement {
                let title = elementTitle.value
                let url = elementLink.value
                let topic = feedTopicHelper.getTopic(forText: title) ?? ""
                var entry = FeedEntry(title: title, urlString: url, category: topic)
                if let elementEnclosure = element["enclosure"] as? XMLElement,
                   let imageUrlString = elementEnclosure.attributes["url"] {
                    let imageUrl = URL(string: imageUrlString)
                    entry.image = imageUrl
                }
                
                entries.append(entry)
            }
        }
        return Feed(entries: entries)
    }
}

