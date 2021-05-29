//
//  ViewWithActivityIndicator.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 29/05/21.
//

import SwiftUI

struct ViewWithActivityIndicator<Content:View>: View {
    @Binding var showActivityIndicator: Bool
    
    init(showIndicator: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        // need to set _showActivityIndicator as it is a @Binding 
        self._showActivityIndicator = showIndicator
        self.content = content
    }
    var body: some View {
        ZStack {
            content()
            if showActivityIndicator {
                VStack {
                    ProgressView()
                }
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .background(Color.primary.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    var content: () -> Content
}

struct ActivityIndicatorModifier: ViewModifier {
    @Binding var showActivityIndicator:Bool
    
    func body(content: Content) -> some View {
        ViewWithActivityIndicator(showIndicator: $showActivityIndicator) {
            content
        }
    }
}
