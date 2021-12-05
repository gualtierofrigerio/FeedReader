//
//  ImageLoader.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 30/03/21.
//

import Combine
import Foundation

#if os(iOS)

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
    
    private func loadImage(fromURL url:URL) {
        if #available(iOS 15.0, *) {
            Task.init {
                if let image = await self.imageCache.imageForURLAsync(url) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            
        } else {
            imageCache.imageForURL(url) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
        
    }
}
#endif

#if os(macOS)

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    /// Load an image at the given URL
    /// - Parameter url: The image URL
    func load(url: URL) {
        loadImage(fromURL: url)
    }
    
    /// Load an image from a given string
    /// - Parameter urlString: The string representing the image URL
    func load(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        loadImage(fromURL: url)
    }
    
    private func loadImage(fromURL url:URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

#endif
