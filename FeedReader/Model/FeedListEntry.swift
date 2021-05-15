//
//  FeedListEntry.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 17/04/21.
//

import Foundation

indirect enum FeedListEntryType: Equatable {
    case online
    case favorites
    case aggregated([FeedListEntryType])
}

extension FeedListEntryType: CustomStringConvertible {
    var description: String {
        switch self {
        case .online:
            return "online"
        case .favorites:
            return "favorites"
        case .aggregated:
            return "aggregated"
        }
    }
}

extension FeedListEntryType {
    static func fromString(_ string:String) -> Self? {
        switch string {
        case "online":
            return .online
        case "favorites":
            return .favorites
        case "aggregated":
            return .aggregated([])
        default:
            return nil
        }
    }
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
        if let typeFromString = FeedListEntryType.fromString(type) {
            entryType = typeFromString
        }
        return FeedListEntry(name: name, url: url, type: entryType)
    }
    
    func toDictionary() -> [String:String] {
        ["name" : name, "url" : url, "type" : type.description]
    }
}
