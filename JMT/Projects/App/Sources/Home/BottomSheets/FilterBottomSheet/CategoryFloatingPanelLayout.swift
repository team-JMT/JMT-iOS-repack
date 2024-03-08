//
//  CategoryFloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 3/7/24.
//

import Foundation
import FloatingPanel

class CategoryFloatingPanelLayout: FloatingPanelLayout {
    
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] =
    
    [
        .full: FloatingPanelLayoutAnchor(fractionalInset: 0.95, edge: .bottom, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
    ]
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
