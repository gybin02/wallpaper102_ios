//
//  Item.swift
//  BeautifulWallpaperApp
//
//  Created by yd-sz-dn0588 on 2025/3/3.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
