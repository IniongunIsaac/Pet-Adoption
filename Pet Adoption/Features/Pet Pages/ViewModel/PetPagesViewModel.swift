//
//  PetPagesViewModel.swift
//  Pet Adoption
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import Foundation
import Repository
import Entities
import RxSwift
import RxCocoa

class PetPagesViewModel: IPetPagesViewModel {
    
    let petAdoptionRepo: IPetAdoptionRepo
    
    init(petAdoptionRepo: IPetAdoptionRepo) {
        self.petAdoptionRepo = petAdoptionRepo
    }
    
    var petAdoptionResponse: PublishSubject<PetAdoptionResponse> = PublishSubject()
    var throwableError: PublishSubject<Error> = PublishSubject()
    fileprivate let disposeBag = DisposeBag()
    
    func getPetAdoptionData() {
        
        do {
            try petAdoptionRepo.getPetAdoptionData(jsonFileName: "pet_adoption", jsonFileExtension: "json").subscribe(onNext: { [weak self] ptAdptnRes in
                
                self?.petAdoptionResponse.onNext(ptAdptnRes)
                
            }, onError: { [weak self] error in
                
                self?.throwableError.onNext(error)
                
            }).disposed(by: disposeBag)
            
        } catch let error {
            throwableError.onNext(error)
        }
    }
    
}
