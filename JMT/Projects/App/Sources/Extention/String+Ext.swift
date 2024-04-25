//
//  String+Ext.swift
//  JMTeng
//
//  Created by PKW on 3/10/24.
//

import Foundation
import UIKit

extension String {
    func splitByHashTag() -> [String] {
        let components = self.split(separator: "#").map({"#" + $0}).filter({ !$0.isEmpty })
        return components
    }
}
