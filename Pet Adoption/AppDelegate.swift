//
//  AppDelegate.swift
//  Pet Adoption
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import UIKit
import Swinject
import Remote_API
import Repository

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    let container: Container = {
        
        let container = Container()
        container.register(IPetAdoptionRemote.self) { _ in PetAdoptionRemoteImpl() }
        
        container.register(IPetAdoptionRepo.self) { r in
            PetAdoptionRepoImpl(petAdoptionRemote: r.resolve(IPetAdoptionRemote.self)!)
        }
        
        container.register(IPetPagesViewModel.self) { r in
            PetPagesViewModel(petAdoptionRepo: r.resolve(IPetAdoptionRepo.self)!)
        }
        
        container.register(PetPagesViewController.self) { r in
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            let petPagesController = PetPagesViewController(collectionViewLayout: flowLayout)
            
            petPagesController.petPagesViewModel = r.resolve(IPetPagesViewModel.self)
            
            return petPagesController
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = container.resolve(PetPagesViewController.self)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

