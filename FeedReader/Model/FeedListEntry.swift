//
//  FeedListEntry.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 17/04/21.
//

import Foundation

enum FeedListEntryType: String {
    case online = "online"
    case favorites = "favorites"
    case aggregated = "aggregated"
}

struct FeedListEntry {
    var name:String
    var url:String
    var type:FeedListEntryType
    var aggregated:[FeedListEntry]?
}

extension FeedListEntry {
    static func initWithDictionary(_ dictionary:[String:Any]) -> Self? {
        guard let name = dictionary["name"] as? String,
              let url = dictionary["url"] as? String,
              let type = dictionary["type"] as? String else { return nil }
        
        var entryType = FeedListEntryType.online
        if let typeFromString = FeedListEntryType(rawValue: type) {
            entryType = typeFromString
        }
        var aggregated:[FeedListEntry] = []
        if let aggr = dictionary["aggregated"] as? [[String:Any]] {
            aggregated = aggr.compactMap {
                FeedListEntry.initWithDictionary($0)
            }
        }
        return FeedListEntry(name: name, url: url, type: entryType, aggregated: aggregated)
    }
    
    func toDictionary() -> [String:Any] {
        var aggregatedArray:[[String:Any]] = []
        if let agr = aggregated {
            aggregatedArray = agr.map{ $0.toDictionary() }
        }
        return ["name" : name, "url" : url, "type" : type.rawValue, "aggregated" : aggregatedArray] as [String : Any]
    }
}
