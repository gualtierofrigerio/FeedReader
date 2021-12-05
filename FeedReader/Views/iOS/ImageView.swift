//
//  ImageView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 30/03/21.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    var image:UIImage {
        imageLoader.image
    }
    
    
    init(withURL url:URL) {
        imageLoader = ImageLoader()
        imageLoader.load(url: url)
    }
    
    var body: some View {
        Self.makeImageView(withImage: image)
    }
}

fileprivate let testURL = URL(string:"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")!

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(withURL: testURL)
    }
}
