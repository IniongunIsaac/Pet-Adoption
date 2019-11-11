//
//  PetPagesViewModel.swift
//  Pet Adoption
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation
import Entities
import RxSwift

protocol IPetPagesViewModel {
    
    var throwableError: PublishSubject<Error> { get }
    
    var petAdoptionResponse: PublishSubject<PetAdoptionResponse> { get }
    
    func getPetAdoptionData()
}
