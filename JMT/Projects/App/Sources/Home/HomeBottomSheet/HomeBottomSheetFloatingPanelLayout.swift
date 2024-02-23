//
//  FloatingPanelLayout.swift
//  JMTeng
//
//  Created by PKW on 2024/01/24.
//

import Foundation
import FloatingPanel
import UIKit

class HomeBottomSheetFloatingPanelLayout: FloatingPanelLayout {
    
    var isExpandable: Bool = true
    var contentHeight: CGFloat = 0.0
    
    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .half
    }

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        if isExpandable {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 65, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(fractionalInset: 0.35, edge: .bottom, referenceGuide: .superview),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: 18, edge: .bottom, referenceGuide: .safeArea)
            ]
        } else {
            return [
                .half: FloatingPanelLayoutAnchor(absoluteInset: contentHeight, edge: .bottom, referenceGuide: .safeArea)
            ]
        }
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}


