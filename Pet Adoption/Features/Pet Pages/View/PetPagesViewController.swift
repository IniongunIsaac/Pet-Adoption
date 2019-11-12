//
//  PetPagesViewController.swift
//  Pet Adoption
//
//  Created by Isaac Iniongun on 11/11/2019.
//  Copyright © 2019 InGroups. All rights reserved.
//

import UIKit
import Alertift
import RxSwift
import Entities

private let reuseIdentifier = "CellId"

class PetPagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let disposeBag = DisposeBag()
    
    var petPagesViewModel: IPetPagesViewModel?
    
    var petAdoptionResponse: PetAdoptionResponse? = nil
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Prev", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainColor, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, petAdoptionResponse!.pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = petAdoptionResponse!.pages.count
        pc.currentPageIndicatorTintColor = .mainColor
        pc.pageIndicatorTintColor = .gray
        return pc
    }()
    
    lazy var petLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString(string: petAdoptionResponse!.name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])
        
        label.attributedText = attributedText
        
        return label
    }()
    
    fileprivate func setupPageTitle() {
        
        view.addSubview(petLabel)
        
        NSLayoutConstraint.activate([
            petLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            petLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PetPageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.isPagingEnabled = true
        
        setObservers()
        
        petPagesViewModel?.getPetAdoptionData()
    }
    
    fileprivate func setObservers() {
        setPetAdoptionDataObserver()
        setThrowableErrorObserver()
    }
    
    fileprivate func setPetAdoptionDataObserver() {
        petPagesViewModel?.petAdoptionResponse.bind { [weak self] petAdoptionData in
            self?.petAdoptionResponse = petAdoptionData
            self?.setupPageTitle()
            self?.setupBottomControls()
        }.disposed(by: disposeBag)
    }
    
    fileprivate func setThrowableErrorObserver() {
        petPagesViewModel?.throwableError.bind { [weak self] error in
            self?.showAlert(message: error.localizedDescription, alertType: .error)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func showAlert(message: String, alertType: AlertType = .error) {
        
        let alertImage: UIImage? = alertType == .success ? UIImage(named: "success") : UIImage(named: "error")
        
        Alertift.alert(title: "", message: message)
            .image(alertImage, imageTopMargin: .belowRoundCorner)
            .action(.default("Dismiss"))
            .show(on: self)
    }

}

// MARK: UICollectionViewDataSource

extension PetPagesViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petAdoptionResponse!.pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PetPageCollectionViewCell
        
        cell.page = petAdoptionResponse!.pages[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { _ in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { (_) in
            
        }
    }
    
}
