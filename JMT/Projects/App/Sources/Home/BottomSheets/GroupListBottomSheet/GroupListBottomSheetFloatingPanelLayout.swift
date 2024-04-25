//
//  GroupListBottomSheetFloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 2024/03/02.
//

import Foundation

import Foundation
import FloatingPanel


class GroupListBottomSheetFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanelPosition {
        return .bottom
    }
    
    var initialState: FloatingPanelState {
        return .half
    }
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5 , edge: .bottom, referenceGuide: .safeArea),
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}
