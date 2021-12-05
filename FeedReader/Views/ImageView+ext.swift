//
//  ImageView+ext.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 01/11/21.
//

import SwiftUI

extension ImageView {
    static func empty() -> some View {
        Image(systemName: "newspaper")
            .font(Font.largeTitle)
            .padding()
    }
    
    #if os(iOS)
    static func makeImageView(withImage image:UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    #endif
}
