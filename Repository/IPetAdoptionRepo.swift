//
//  IPetAdoptionRepo.swift
//  Repository
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation
import RxSwift
import Entities

public protocol IPetAdoptionRepo {
    func getPetAdoptionData(jsonFileName: String, jsonFileExtension: String) throws -> Observable<PetAdoptionResponse>
}
