//
//  FeedReaderApp.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import SwiftUI

@main
struct FeedReaderApp: App {
    let feedURLString = "https://www.macworld.co.uk/latest/rss"
    
    var body: some Scene {
        WindowGroup {
            FeedView(viewModel: FeedViewModel(withURLString: feedURLString))
        }
    }
}
