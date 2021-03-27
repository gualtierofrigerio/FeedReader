//
//  ContentView.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 27/03/21.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel:FeedViewModel
    var body: some View {
        VStack {
            Text("Feed")
            List(viewModel.feed.entries) { entry in
                FeedEntryView(entry:entry)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(viewModel: FeedViewModel())
    }
}
