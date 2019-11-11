//
//  Section.swift
//  Entities
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation

public struct Section: Codable {
    public let label: String
    public let elements: [Element]
}
