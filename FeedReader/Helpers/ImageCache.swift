//
//  ImageCache.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 08/05/21.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    func imageForURL(_ url:String) -> UIImage? {
        cache.first { record in
            record.url == url
        }?.image
    }
    
    func setImage(_ image:UIImage, forUrl url:String) {
        cache.append(ImageCacheRecord(url: url, image: image))
    }
    
    private var cache:[ImageCacheRecord] = []
    
    struct ImageCacheRecord {
        var url:String
        var image:UIImage
    }
}

