//
//  PetAdoptionResponse.swift
//  Entities
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation

public struct PetAdoptionResponse: Codable {
    public let id: String
    public let name: String
    public let pages: [Page]
}
