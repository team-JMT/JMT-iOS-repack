//
//  FilterBottomSheetFloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 2024/01/26.
//

import Foundation
import FloatingPanel
import UIKit

class FilterBottomSheetFloatingPanelLayout: FloatingPanelLayout {
    
    var tbHeight: CGFloat = 0
    
    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] { // 가능한 floating panel: 현재 full, half만 가능하게 설정
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: tbHeight, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: tbHeight + 110 + 32 + 24 + 16, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.3
    }
}

