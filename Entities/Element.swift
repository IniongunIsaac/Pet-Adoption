//
//  Element.swift
//  Entities
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation

public struct Element: Codable {
    
    public let type: String?
    public let file: String?
    public let uniqueId: String?
    public let label: String?
    public let isMandatory: Bool?
    public let keyboard: String?
    public let formattedNumeric: String?
    public let mode: String?
    public let rules: [Rule?]
    
    enum CodingKeys: String, CodingKey{
        case type, file, uniqueId = "unique_id", label, isMandatory, keyboard, formattedNumeric, mode, rules
    }
    
    public init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decodeIfPresent(String.self, forKey: .type)
        file = try container.decodeIfPresent(String.self, forKey: .file)
        uniqueId = try container.decodeIfPresent(String.self, forKey: .uniqueId)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        isMandatory = try container.decodeIfPresent(Bool.self, forKey: .isMandatory)
        keyboard = try container.decodeIfPresent(String.self, forKey: .keyboard)
        formattedNumeric = try container.decodeIfPresent(String.self, forKey: .formattedNumeric)
        mode = try container.decodeIfPresent(String.self, forKey: .mode)
        rules = try container.decode([Rule?].self, forKey: .rules)
        
    }
}
