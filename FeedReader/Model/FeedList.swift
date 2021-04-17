//
//  FeedList.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 15/04/21.
//

import Foundation

struct FeedList {
    var entries:[FeedListEntry]
}

extension FeedList {
    static func initWithArray(_ array:[[String:String]]) -> Self {
        let entries = array.compactMap({ element in
            FeedListEntry.initWithDictionary(element)
        })
        return FeedList(entries: entries)
    }
    
    func toArray() -> [[String:String]] {
        entries.map {$0.toDictionary()}
    }
}

extension FeedList {
    mutating func addEntry(_ entry:FeedListEntry) {
        entries.append(entry)
    }
}

