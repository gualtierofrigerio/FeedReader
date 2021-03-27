//
//  XMLHelper.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import Foundation
import Combine

typealias XMLArrayDictionary = [[String:String]]

class XMLHelper:NSObject {
    func parseXML(atURL url:URL, elementName:String) -> AnyPublisher<XMLArrayDictionary, Never>? {
        guard let parser = XMLParser(contentsOf: url) else { return nil }
        elementNameToGet = elementName
        parser.delegate = self
        parser.parse()
        return $results.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private var currentDictionary:[String:String]?
    private var currentElementName:String?
    private var elementNameToGet:String = ""
    @Published private var results:XMLArrayDictionary = []
    
    private func addCurrentDictionaryToResults() {
        if let currentDictionary = currentDictionary {
            results.append(currentDictionary)
        }
        currentDictionary = nil
    }
    
    private func addString(_ string:String, forKey key:String) {
        if let currentValue = currentDictionary?[key] {
            currentDictionary?[key] = currentValue + string
        }
        else {
            currentDictionary?[key] = string
        }
    }
    
    private func newDictionary() {
        currentDictionary = [:]
    }
    
    
}

extension XMLHelper: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElementName = nil
        if elementName == elementNameToGet {
            newDictionary()
        }
        else if currentDictionary != nil {
            currentElementName = elementName
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == elementNameToGet {
            addCurrentDictionaryToResults()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let key = currentElementName {
            addString(string, forKey: key)
        }
    }
}
