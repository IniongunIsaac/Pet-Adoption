//
//  PetAdoptionRemoteImpl.swift
//  Remote API
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation
import RxSwift
import Entities

public class PetAdoptionRemoteImpl: IPetAdoptionRemote {
    
    public init() {}
    
    public func getPetAdoptionData() throws -> Observable<PetAdoptionResponse> {
        
        do {
            return try Observable.just(PetAdoptionResponse.mapTo(jsonString: readJsonDataFile())!)
        } catch let error {
            throw error
        }
    }
    
    fileprivate func readJsonDataFile() throws -> String {
        let url = Bundle.init(for: PetAdoptionRemoteImpl.self).url(forResource: "pet_adoption", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            return try JSONSerialization.jsonObject(with: jsonData) as! String
        }
        catch let error {
            throw error
        }
    }
    
}
