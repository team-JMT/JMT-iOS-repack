//
//  SortFloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 3/7/24.
//

import Foundation
import FloatingPanel

class SortFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(absoluteInset: 228, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
