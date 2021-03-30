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
    var selectedEntry:FeedEntry?
    
    init() {
        if let url = Bundle.main.url(forResource: "test", withExtension: "xml") {
            let xmlHelper = XMLHelper()
            let publisher = xmlHelper.parseXML(atURL: url, elementName: "item")
            cancellable = publisher.sink { xmlArrayDictionary in
                if let xmlArrayDictionary = xmlArrayDictionary,
                   let array = xmlArrayDictionary["item"] as? [[String:String]] {
                    self.feed = Feed.createFromArray(array)
                    //self.test(url:url)
                }
            }
        }
    }
    
    func test(url:URL) {
        let xmlHelper = XMLHelper()
        let publisher = xmlHelper.parseXML(atURL: url, elementName: nil)
        cancellable = publisher.sink { xmlArrayDictionary in
            if let xmlArrayDictionary = xmlArrayDictionary {
                print(xmlArrayDictionary)
                if let jsonObject = try? JSONSerialization.data(withJSONObject: xmlArrayDictionary, options: .prettyPrinted) {
                    let jsonString = String(data: jsonObject, encoding: .utf8)
                    print(jsonString!)
                }
            }
        }
    }
    
    // MARK: - Private
    private var cancellable:AnyCancellable?
}
