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
        NavigationView {
            VStack {
                List(viewModel.feed.entries) { entry in
                    Button {
                        viewModel.userSelectedEntry(entry)
                    } label: {
                        FeedEntryView(entry:entry, tapCategoryAction: {
                            tapCategoryAction(entry: entry)
                        })
                    }
                }
                if showCategoryPicker {
                    categoryPicker
                }
            }.navigationTitle("Feed")
        }
        .sheet(isPresented: $viewModel.showSheet) {
            dynamicSheet
        }
        .alert(isPresented: $viewModel.showAlert) {
            dynamicAlert
        }
    }
    
    // MARK: - Private
    @State private var selectedCategory:String = ""
    @State private var selectedEntry:FeedEntry?
    @State private var showCategoryPicker = false
    
    @ViewBuilder private var categoryPicker: some View {
        VStack {
            Text("Select category")
            Picker(selection: $selectedCategory, label: Text("Select the category:")) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Text(category)
                }
            }.onChange(of: selectedCategory) { value in
                print("selected category \(value)")
                showCategoryPicker.toggle()
                if let entry = selectedEntry {
                    viewModel.userChangedCategory(category: selectedCategory, toEntry: entry)
                }
            }
        }
    }
    
    private var dynamicAlert: Alert {
        Alert(title: Text("Error"),
              message: Text(viewModel.errorMessage),
              dismissButton: .default(Text("Ok")))
    }
    
    @ViewBuilder private var dynamicSheet: some View {
        if let articleViewModel = viewModel.selectedArticleViewModel {
            ArticleView(viewModel:articleViewModel)
        }
        else {
            Text("Error while opening the requested article")
        }
    }
    
    private func tapCategoryAction(entry:FeedEntry) {
        showCategoryPicker.toggle()
        selectedEntry = entry
    }
}

struct ConsoleLogView:View {
    init(_ message:String) {
        print(message)
    }
    
    var body: some View {
        EmptyView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(viewModel: FeedViewModel())
    }
}
