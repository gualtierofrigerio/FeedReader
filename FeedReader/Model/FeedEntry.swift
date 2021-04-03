//
//  FeedEntry.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 31/03/21.
//

import Foundation

struct FeedEntry {
    var title:String
    var urlString:String
    var category:String
    var image:URL?
    
    var url:URL? {
        let string = urlString.replacingOccurrences(of: "\n", with: "")
        return URL(string: string)
    }
}

extension FeedEntry:Identifiable {
    var id: String {
        title
    }
}
