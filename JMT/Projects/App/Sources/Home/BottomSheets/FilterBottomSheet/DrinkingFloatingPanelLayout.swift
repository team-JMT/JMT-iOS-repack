//
//  DrinkingFloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 3/7/24.
//

import Foundation
import FloatingPanel

class DrinkingFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] =
    
    [
        .half: FloatingPanelLayoutAnchor(absoluteInset: 240 + 110, edge: .bottom, referenceGuide: .safeArea)
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
