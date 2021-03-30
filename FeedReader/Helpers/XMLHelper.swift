//
//  XMLHelper.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import Foundation
import Combine

typealias XMLDictionary = [String:Any]

class XMLHelper:NSObject {
    func parseXML(atURL url:URL,
                  elementName:String?,
                  completion:@escaping (XMLDictionary?) -> Void) {
        guard let parser = XMLParser(contentsOf: url) else {
            completion(nil)
            return
        }
        self.completion = completion
        var helperParser:XMLParserDelegate
        if let elementName = elementName {
            helperParser = ParserSpecificElement(elementName: elementName, completion:completion)
        }
        else {
            helperParser = ParserAllTags(completion: completion)
        }
        parser.delegate = helperParser
        parser.parse()
    }
    
    @available(iOS 13.0, *)
    func parseXML(atURL url:URL, elementName:String?) -> AnyPublisher<XMLDictionary?, Never> {
        let subject = CurrentValueSubject<XMLDictionary?, Never>(nil)
        parseXML(atURL: url, elementName: elementName) { arrayDictionary in
            subject.send(arrayDictionary)
        }
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private var completion:((XMLDictionary?) -> Void)?
}

// MARK: - ParserSpecificElement

fileprivate class ParserSpecificElement:NSObject, XMLParserDelegate {
    init(elementName:String, completion:@escaping (XMLDictionary?) -> Void) {
        self.elementNameToGet = elementName
        self.completion = completion
    }
    
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
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if let elementNameToGet = elementNameToGet {
            let dictionary = [elementNameToGet : results]
            completion(dictionary)
        }
    }

    // MARK: - Private
    
    private var completion:(XMLDictionary?) -> Void
    private var currentDictionary:[String:String]?
    private var currentElementName:String?
    private var elementNameToGet:String?
    private var results:[XMLDictionary] = []
    
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

// MARK: - ParserAllTags

fileprivate class ParserAllTags:NSObject, XMLParserDelegate {
    
    init(completion:@escaping (XMLDictionary?) -> Void) {
        self.completion = completion
    }
    
    private var completion:(XMLDictionary?) -> Void
    private var currentDictionary:XMLDictionary = [:]
    private var currentElementName:String = ""
    private var rootDictionary:XMLDictionary = [:]
    private var stack:[XMLDictionary] = []
    
    /// Add a dictionary to an existing one
    /// If the key is already in the dictionary we need to create an array
    /// - Parameters:
    ///   - dictionary: the dictionary to add
    ///   - toDictionary: the dictionary where the given dictionary will be added
    ///   - key: the key
    /// - Returns: the dictionary passed as toDictionary with the new value added
    private func addDictionary(_ dictionary:XMLDictionary, toDictionary:XMLDictionary,
                                      key:String) -> XMLDictionary {
        var returnDictionary = toDictionary
        if let array = returnDictionary[key] as? Array<XMLDictionary> {
            var newArray = array
            newArray.append(dictionary)
            returnDictionary[key] = newArray
        }
        else if let dictionary = returnDictionary[key] as? XMLDictionary {
            var array:[XMLDictionary] = [dictionary]
            array.append(dictionary)
            returnDictionary[key] = array
        }
        else {
            returnDictionary[key] = dictionary
        }
        return returnDictionary
    }
    
    // MARK: - XMLParserDelegate
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        stack.append(currentDictionary)
        currentDictionary = [:]
        currentElementName = elementName
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        var parentDictionary = stack.removeLast()
        parentDictionary = addDictionary(currentDictionary, toDictionary: parentDictionary, key: elementName)
        currentDictionary = parentDictionary
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if string == "\n" {
            return
        }
        if let currentString = currentDictionary[currentElementName] as? String {
            currentDictionary[currentElementName] = currentString + string
        }
        else {
            currentDictionary[currentElementName] = string
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion(currentDictionary)
    }
}
