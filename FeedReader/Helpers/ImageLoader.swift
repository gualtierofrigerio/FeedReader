//
//  ImageLoader.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 30/03/21.
//

import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var data = Data()
    
    func load(url:URL) {
        loadImage(fromURL: url)
    }
    
    func load(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        loadImage(fromURL: url)
    }
    
    // MARK: - Private
    private var cancellable:AnyCancellable?
    
    private func loadImage(fromURL url:URL) {
        cancellable = RESTClient.loadData(atURL: url)
            .replaceError(with: Data())
            .receive(on: RunLoop.main)
            .assign(to: \.data, on: self)
    }
}
