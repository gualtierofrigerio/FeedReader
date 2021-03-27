//
//  FeedTopicHelper.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import CoreML
import NaturalLanguage
import Foundation

class FeedTopicHelper {
    
    func getTopic(forText text:String) -> String? {
        topicClassifier?.predictedLabel(for: text) 
    }
    
    // MARK: - Private
    
    private lazy var topicClassifier: NLModel? = {
        if let topicClassifier = try? AppleTopics(configuration: MLModelConfiguration()).model,
           let model = try? NLModel(mlModel: topicClassifier) {
            return model
        }
        return nil
    }()
}
