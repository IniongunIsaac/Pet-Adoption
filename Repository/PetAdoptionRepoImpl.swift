//
//  PetAdoptionRepoImpl.swift
//  Repository
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation
import RxSwift
import Entities
import Remote_API

public struct PetAdoptionRepoImpl: IPetAdoptionRepo {
    
    public init(petAdoptionRemote: IPetAdoptionRemote) {
        self.petAdoptionRemote = petAdoptionRemote
    }
    
    public let petAdoptionRemote: IPetAdoptionRemote
    
    public func getPetAdoptionData() throws -> Observable<PetAdoptionResponse> {
        return try petAdoptionRemote.getPetAdoptionData()
    }
    
}
