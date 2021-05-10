//
//  RESTClient.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 06/04/21.
//

import Foundation
import Combine

enum RESTClientError:Error {
    case generic(String)
}

class RESTClient {
    class func loadData(atURL url:URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .mapError { error in
                RESTClientError.generic(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    class func loadData(atURL url:URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
