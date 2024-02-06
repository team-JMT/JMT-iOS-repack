//
//  RegistrationRestaurantMenuBottomSheetFloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import FloatingPanel
import UIKit

class RegistrationRestaurantTypeBottomSheetFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] { // 가능한 floating panel: 현재 full, half만 가능하게 설정
        return [
            .full: FloatingPanelLayoutAnchor(fractionalInset: 1.0, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.3
    }
}

