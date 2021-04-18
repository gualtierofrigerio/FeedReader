//
//  FeedListEntry.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 17/04/21.
//

import Foundation

enum FeedListEntryType: String {
    case online = "online"
    case local = "local"
    case aggregated = "aggregated"
}

struct FeedListEntry {
    var name:String
    var url:String
    var type:FeedListEntryType
}

extension FeedListEntry {
    static func initWithDictionary(_ dictionary:[String:String]) -> Self? {
        guard let name = dictionary["name"],
              let url = dictionary["url"],
              let type = dictionary["type"] else { return nil }
        
        var entryType = FeedListEntryType.online
        if let typeFromString = FeedListEntryType(rawValue: type) {
            entryType = typeFromString
        }
        return FeedListEntry(name: name, url: url, type: entryType)
    }
    
    func toDictionary() -> [String:String] {
        ["name" : name, "url" : url, "type" : type.rawValue]
    }
}
