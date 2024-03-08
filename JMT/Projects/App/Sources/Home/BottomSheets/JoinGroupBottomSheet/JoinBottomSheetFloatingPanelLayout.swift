//
//  JoinBottomSheetFloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 2024/03/01.
//

import Foundation
import FloatingPanel

class JoinBottomSheetFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(absoluteInset: 314, edge: .bottom, referenceGuide: .safeArea),
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
