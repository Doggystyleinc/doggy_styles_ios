//
//  SelectServiceDropDownCollection.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/20/21.
//


import Foundation
import UIKit


class ServicesDropDownCollection : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let dropServices = "dropServices"
    
    var appointmentOne : AppointmentOne?
    
    var arrayOfIndexPaths = [IndexPath]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        self.register(ServicesDropDownFeeder.self, forCellWithReuseIdentifier: self.dropServices)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Servicable.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 90.0)

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = self.dequeueReusableCell(withReuseIdentifier: self.dropServices, for: indexPath) as! ServicesDropDownFeeder

        cell.servicesDropDownCollection = self
    
        let feeder = Servicable.allCases[indexPath.item]
    
        let serviceName = feeder.description.0
        let serviceCost = feeder.description.1

        cell.headerLabel.text = "\(serviceName)"
        cell.costLabel.text = "\(serviceCost)"
        
        if self.arrayOfIndexPaths.contains(indexPath) {
            
            cell.engageShadow(shouldEngage: true)
            
        } else {
            
            if serviceName != "Wash & Groom" {
            cell.engageShadow(shouldEngage: false)
            }
        }
    
        switch serviceName {
        
        case "Wash & Groom" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .shower), for: .normal)
            cell.engageShadow(shouldEngage: true)
            cell.costLabel.text = "-"
        case "Dematting" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .rulerCombined), for: .normal)
        case "Deshedding" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .chair), for: .normal)
        case "Bath" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .bath), for: .normal)
        case "Haircut" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .handScissors), for: .normal)
        case "Teeth Cleaning" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .tooth), for: .normal)
        case "Nail Trimming" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .journalWhills), for: .normal)
        case "Ear Cleaning" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .ambulance), for: .normal)
        default: print("default")
        
        }
      

            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @objc func handleSelection(sender : UIView) {

        let selectedButtonCell = sender.superview as! UICollectionViewCell
        
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        if !self.arrayOfIndexPaths.contains(indexPath) {
            
            self.arrayOfIndexPaths.append(indexPath)
            
        } else if self.arrayOfIndexPaths.contains(indexPath) {
            
            if let index = self.arrayOfIndexPaths.firstIndex(of: indexPath) {
                
                self.arrayOfIndexPaths.remove(at: index)
                
            }
        }
        
        UIDevice.vibrateLight()
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                
                self.reloadItems(at: [indexPath])
                self.appointmentOne?.view.layoutIfNeeded()
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ServicesDropDownFeeder : UICollectionViewCell {
    
    var servicesDropDownCollection : ServicesDropDownCollection?
    
    lazy var mainContainer : UIView = {
        
        let mc = UIView()
        mc.translatesAutoresizingMaskIntoConstraints = false
        mc.backgroundColor = coreWhiteColor
        mc.clipsToBounds = false
        mc.layer.masksToBounds = false
        mc.layer.shadowColor = coreOrangeColor.cgColor
        mc.layer.shadowOpacity = 0.05
        mc.layer.shadowOffset = CGSize(width: 2, height: 3)
        mc.layer.shadowRadius = 9
        mc.layer.shouldRasterize = false
        mc.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        mc.layer.borderWidth = 1.0
        mc.layer.cornerRadius = 15
        mc.isUserInteractionEnabled = true
        mc.layer.masksToBounds = false
        mc.layer.shadowOpacity = 0.35
        mc.layer.shadowOffset = CGSize(width: 0, height: 0)
        mc.layer.shadowRadius = 4
        mc.layer.shouldRasterize = false
        mc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleMainContainerTaps(sender:))))
        
       return mc
    }()
  
    let iconImageView : UIButton = {
        
        let iv = UIButton(type: .system)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = dividerGrey
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.isUserInteractionEnabled = false
        iv.tintColor = coreBlackColor

       return iv
    }()
    
    let headerLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "Wash & groom"
        hl.font = UIFont(name: rubikMedium, size: 18)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false

        return hl
    }()
    
    let costLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = .clear
        hl.text = "$149"
        hl.font = UIFont(name: rubikRegular, size: 16)
        hl.numberOfLines = 1
        hl.adjustsFontSizeToFitWidth = true
        hl.textAlignment = .left
        hl.isUserInteractionEnabled = false

        return hl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    func engageShadow(shouldEngage : Bool) {
        
        if shouldEngage {
            self.mainContainer.layer.shadowColor = coreOrangeColor.cgColor
            self.mainContainer.layer.borderColor = coreOrangeColor.cgColor
        } else {
            self.mainContainer.layer.shadowColor = UIColor .clear.cgColor
            self.mainContainer.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        }
    }
    
    func addViews() {
        
        self.addSubview(self.mainContainer)
        self.addSubview(self.iconImageView)
        self.addSubview(self.headerLabel)
        self.addSubview(self.costLabel)
        
        self.mainContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.mainContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.mainContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.mainContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        self.iconImageView.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 25).isActive = true
        self.iconImageView.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 20).isActive = true
        self.iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.costLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -25).isActive = true
        self.costLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.costLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor).isActive = true
        self.costLabel.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: 0).isActive = true
        
        self.headerLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 10).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.costLabel.leftAnchor, constant: -10).isActive = true
        self.headerLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor).isActive = true
        self.headerLabel.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor).isActive = true

    }
    
    @objc func handleMainContainerTaps(sender : UITapGestureRecognizer) {
        
        if let tappableArea = sender.view {
            self.servicesDropDownCollection?.handleSelection(sender:tappableArea)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
