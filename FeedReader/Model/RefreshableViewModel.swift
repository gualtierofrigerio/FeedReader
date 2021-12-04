//
//  RefreshableViewModel.swift
//  FeedReader
//
//  Created by Gualtiero Frigerio on 04/05/21.
//

import Foundation
import Combine
import UIKit

class RefreshableViewModel: ObservableObject {
    func offsetChanged(_ newOffset:CGFloat) {
        if newOffset > 50 {
            if let action = refreshAction {
                action()
            }
        }
    }
    
    func registerRefreshAction(_ action: @escaping (() -> Void)) {
        refreshAction = action
    }
    
    private var refreshAction:(() -> Void)?
}
