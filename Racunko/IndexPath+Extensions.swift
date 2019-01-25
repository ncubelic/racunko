//
//  IndexPath+Extensions.swift
//  Racunko
//
//  Created by Nikola on 25/01/2019.
//  Copyright © 2019 Nikola. All rights reserved.
//

import Foundation

enum IndexPathType {
    case row
    case section
}

extension IndexPath {
    
    func adding(_ type: IndexPathType, _ value: Int) -> IndexPath {
        switch type {
        case .row:
            return IndexPath(row: self.row + 1, section: self.section)
        case .section:
            return IndexPath(row: self.row, section: self.section + 1)
        }
    }
}
