//
//  FeedReaderMacApp.swift
//  FeedReaderMac
//
//  Created by Gualtiero Frigerio on 01/11/21.
//

import SwiftUI

@main
struct FeedReaderMacApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SelectFeed(viewModel: SelectFeedViewModel())
            }
        }
    }
}
