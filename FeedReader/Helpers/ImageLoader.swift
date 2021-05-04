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
    var data:Data = Data() {
        willSet {
            if let img = UIImage(data: newValue) {
                image = img
                loaded = true
            }
        }
    }
    @Published var image = UIImage()
    
    func load(url:URL) {
        loadImage(fromURL: url)
    }
    
    func load(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        loadImage(fromURL: url)
    }
    
    // MARK: - Private
    private var cancellable:AnyCancellable?
    private var loaded = false
    
    private func loadImage(fromURL url:URL) {
        if loaded == false {
            cancellable = RESTClient.loadData(atURL: url)
                .replaceError(with: Data())
                .receive(on: RunLoop.main)
                .assign(to: \.data, on: self)
        }
        else {
            print(" already loaded ")
        }
    }
}
