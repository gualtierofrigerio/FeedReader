//
//  ImageLoader.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 30/03/21.
//

import Combine
import Foundation
import UIKit

class ImageLoader: ObservableObject {
    @Published var image = UIImage()
    
    func load(url:URL) {
        loadImage(fromURL: url)
    }
    
    func load(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        loadImage(fromURL: url)
    }
    
    // MARK: - Private
    private var imageCache = ImageCache.shared
    private var loaded = false
    
    private func loadImage(fromURL url:URL) {
        imageCache.imageForURL(url) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
