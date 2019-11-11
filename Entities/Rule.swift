//
//  Rule.swift
//  Entities
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation

public struct Rule: Codable {
    public let condition: String
    public let value: String
    public let action: String
    public let otherwise: String
    public let targets: [String]
}
