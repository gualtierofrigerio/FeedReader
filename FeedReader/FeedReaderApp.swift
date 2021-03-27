//
//  FeedReaderApp.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import SwiftUI

@main
struct FeedReaderApp: App {
    var body: some Scene {
        WindowGroup {
            FeedView(viewModel: FeedViewModel())
        }
    }
}
