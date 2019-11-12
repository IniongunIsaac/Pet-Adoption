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
    
    public func getPetAdoptionData(jsonFileName: String, jsonFileExtension: String) throws -> Observable<PetAdoptionResponse> {
        do {
            let url = Bundle.main.url(forResource: jsonFileName, withExtension: jsonFileExtension)!
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            return try Observable.just(JSONDecoder().decode(PetAdoptionResponse.self, from: data))
        } catch let error {
            throw error
        }
    }
    
    fileprivate func readJsonDataFile() throws -> String {
        let url = Bundle.main.url(forResource: "pet_adoption", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let response = try JSONSerialization.jsonObject(with: jsonData) as! [String : Any]
            print(response)
            return "\(response)"
        }
        catch let error {
            throw error
        }
    }
    
}
