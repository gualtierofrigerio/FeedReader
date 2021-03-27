//
//  FeedViewModel.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import Combine
import Foundation

class FeedViewModel:ObservableObject {
    @Published var feed:Feed = Feed(entries: [])
    
    init() {
        if let url = Bundle.main.url(forResource: "test", withExtension: "xml") {
            let xmlHelper = XMLHelper()
            if let publisher = xmlHelper.parseXML(atURL: url, elementName: "item") {
                cancellable = publisher.sink { xmlArrayDictionary in
                    self.feed = Feed.createFromArray(xmlArrayDictionary)
                }
            }
        }
    }
    
    // MARK: - Private
    private var cancellable:AnyCancellable?
}
