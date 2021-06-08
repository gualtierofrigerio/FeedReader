//
//  ImageCache.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 08/05/21.
//

import Foundation
import UIKit

typealias ImageCacheCompletion = (UIImage?) -> Void

class ImageCache {
    static let shared = ImageCache()
    
    func imageForURL(_ url:URL, completion: @escaping ImageCacheCompletion) {
        if let cachedImage = cache.first(where: { record in
            record.urlString == url.absoluteString
        }) {
            completion(cachedImage.image)
        }
        else {
            loadImage(url: url, completion: completion)
        }
    }
    
    @available(iOS 15.0, *)
    func imageForURLAsync(_ url: URL) async -> UIImage? {
        if let cachedImage = cache.first(where: { record in
            record.urlString == url.absoluteString
        }) {
            return cachedImage.image
        }
        else {
            return await loadImageAsync(url:url)
        }
    }
    
    // MARK: - Private
    private var cache:[ImageCacheRecord] = []
    private let cacheSize = 10
    
    private func imageFromData(_ data:Data) -> UIImage? {
        UIImage(data: data)
    }
    
    private func loadImage(url:URL, completion: @escaping ImageCacheCompletion) {
        RESTClient.loadData(atURL: url) { result in
            switch result {
            case .success(let data):
                if let image = self.imageFromData(data) {
                    completion(image)
                    self.setImage(image, forUrl: url.absoluteString)
                }
                else {
                    completion(nil)
                }
            case .failure(_ ):
                completion(nil)
            }
        }
    }
    
    @available(iOS 15.0, *)
    private func loadImageAsync(url: URL) async -> UIImage? {
        let result = await RESTClient.loadDataAsync(url: url)
        switch result {
        case .success(let data):
            if let image = self.imageFromData(data) {
                self.setImage(image, forUrl: url.absoluteString)
                return image
            }
        case .failure(_ ):
            print("error while loading image")
        }
        return nil
    }
    
    private func setImage(_ image:UIImage, forUrl url:String) {
        if cache.count >= cacheSize {
            cache.remove(at: 0)
            
        }
        cache.append(ImageCacheRecord(image: image, urlString: url))
    }
    
    // MARK: - ImageCacheRecord
    
    struct ImageCacheRecord {
        var image:UIImage
        var urlString:String
    }
}

