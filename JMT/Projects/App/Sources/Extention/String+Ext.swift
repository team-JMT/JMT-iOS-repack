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
        let components = self.split(separator: "#")
        return components.map(String.init).filter { !$0.isEmpty }
    }
}
