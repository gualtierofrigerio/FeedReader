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
    
    @available(*, deprecated, message: "Prefer async alternative instead")
    class func loadData(atURL url:URL, completion: @escaping (Result<Data, Error>) -> Void) {
        Task {
            do {
                let result = try await loadData(atURL: url)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    class func loadData(atURL url:URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(with: .failure(error))
                    return
                }
                if let data = data {
                    continuation.resume(with: .success(data))
                }
            }
            task.resume()
        }
    }
    
    @available(iOS 15.0, macOS 12.0, *)
    class func loadDataAsync(url: URL) async -> Result<Data, Error> {
        let request = URLRequest(url: url)
        guard let data = try? await URLSession.shared.data(for: request,
                                                           delegate: nil)  else {
            return .failure(RESTClientError.generic("error while requesting url"))
        }
        return .success(data.0)
    }
}
