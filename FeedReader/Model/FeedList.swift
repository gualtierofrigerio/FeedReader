//
//  FeedList.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 15/04/21.
//

import Foundation

enum FeedListEntryType: String {
    case online
    case local
    case aggregated
}

struct FeedListEntry {
    var name:String
    var url:String
    var type:FeedListEntryType
}

struct FeedList {
    var entries:[FeedListEntry]
}

extension FeedList {
    mutating func addEntry(_ entry:FeedListEntry) {
        entries.append(entry)
    }
}

