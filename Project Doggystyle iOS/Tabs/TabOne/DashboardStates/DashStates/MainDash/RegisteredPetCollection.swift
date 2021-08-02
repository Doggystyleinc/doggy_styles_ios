//
//  RegisteredPetCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/1/21.
//

import Foundation
import UIKit


class RegisteredPetCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let petID = "petID"
    var dashMainView : DashMainView?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        self.register(PetCollectionFeeder.self, forCellWithReuseIdentifier: self.petID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.petID, for: indexPath) as! PetCollectionFeeder
        cell.registeredPetCollection = self
        return cell
        
    }
    
    @objc func handleAddDog(sender : UIButton) {
        print("called two")
        self.dashMainView?.dashboardController?.handleNewDogFlow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PetCollectionFeeder : UICollectionViewCell {
    
    var registeredPetCollection : RegisteredPetCollection?
    
    lazy var addDogImage : UIButton = {
        
        let vi = UIButton(type: .system)
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.backgroundColor = .clear
        vi.contentMode = .scaleAspectFit
        vi.isUserInteractionEnabled = true
        let image = UIImage(named: "add_dog_logo_image")?.withRenderingMode(.alwaysOriginal)
        vi.setBackgroundImage(image, for: .normal)
        vi.layer.masksToBounds = true
        vi.layer.cornerRadius = 40
        vi.backgroundColor = coreOrangeColor.withAlphaComponent(0.1)
        vi.layer.borderWidth = 2
        vi.layer.borderColor = coreWhiteColor.cgColor
        vi.addTarget(self, action: #selector(self.handleAddDog), for: .touchUpInside)
        
       return vi
    }()
    
    let nameLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Add"
        hl.font = UIFont(name: dsHeaderFont, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .center
        hl.textColor = coreOrangeColor
        
        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.addDogImage)
        self.addSubview(self.nameLabel)
        
        self.addDogImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.addDogImage.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        self.addDogImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.addDogImage.widthAnchor.constraint(equalToConstant: 80).isActive = true

        self.nameLabel.topAnchor.constraint(equalTo: self.addDogImage.bottomAnchor, constant: 0).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
    }
    
    @objc func handleAddDog(sender : UIButton) {
        print("called one")
        self.registeredPetCollection?.handleAddDog(sender:sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
