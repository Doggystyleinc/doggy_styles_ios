//
//  ServicesCollectionSubview.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/16/21.
//


import Foundation
import UIKit

class ServicesCollectionview : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let servicesID = "servicesID"
    
    var servicesController : ServicesController?
    
    var arrayOfIndexPaths = [IndexPath]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = coreBackgroundWhite
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
        self.delegate = self
        self.isPrefetchingEnabled = false
        self.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.canCancelContentTouches = false
        self.contentInsetAdjustmentBehavior = .never
        self.delaysContentTouches = true
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
        
        self.register(ServicesFeeder.self, forCellWithReuseIdentifier: self.servicesID)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Servicable.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let currentIndex = indexPath
        
        if self.arrayOfIndexPaths.contains(currentIndex) {
            
        let feeder = Servicable.allCases[indexPath.item]
    
        let serviceDescription = feeder.description.2
        
        let textToSize = serviceDescription,
        size = CGSize(width: UIScreen.main.bounds.width - 110, height: 2000),
        options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let estimatedFrame = NSString(string: textToSize).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: rubikItalic, size: 14)!], context: nil)
        
            var estimatedHeight = estimatedFrame.height
            
            if estimatedHeight < 35 {
                estimatedHeight = 90 + 70 + 25
            } else {
                estimatedHeight += 140 + 25
            }
            
            return CGSize(width: UIScreen.main.bounds.width, height: estimatedHeight)
        
        } else {
            
            return CGSize(width: UIScreen.main.bounds.width, height: 90.0)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = self.dequeueReusableCell(withReuseIdentifier: self.servicesID, for: indexPath) as! ServicesFeeder

            cell.servicesCollectionview = self
        
            let feeder = Servicable.allCases[indexPath.item]
        
            let serviceName = feeder.description.0
            let serviceCost = feeder.description.1
            let serviceDescription = feeder.description.2

            cell.headerLabel.text = "\(serviceName)"
            cell.costLabel.text = "\(serviceCost)"
            cell.descriptionLabel.text = "\(serviceDescription)"
        
        if self.arrayOfIndexPaths.contains(indexPath) {
            
            cell.descriptionLabel.isHidden = false
            cell.bottomArrow.isHidden = false
            cell.engageShadow(shouldEngage: true)
            
        } else {
            
            cell.descriptionLabel.isHidden = true
            cell.bottomArrow.isHidden = true
            cell.engageShadow(shouldEngage: false)
        }
        
        switch serviceName {
        
        case "Wash & Groom" :
            cell.iconImageView.titleLabel?.font = UIFont.fontAwesome(ofSize: 19, style: .solid)
            cell.iconImageView.setTitle(String.fontAwesomeIcon(name: .shower), for: .normal)
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
                self.servicesController?.view.layoutIfNeeded()
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ServicesFeeder : UICollectionViewCell {
    
    var servicesCollectionview : ServicesCollectionview?
    
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
        
        let iv = UIButton(type : .system)
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
    
    let descriptionLabel : UILabel = {
        
        let hl = UILabel()
        hl.translatesAutoresizingMaskIntoConstraints = false
        hl.backgroundColor = coreWhiteColor
        hl.text = "this is the description here"
        hl.font = UIFont(name: rubikItalic, size: 14)
        hl.numberOfLines = -1
        hl.textAlignment = .left

        return hl
    }()
    
    let bottomArrow : UIButton = {
        
        let ba = UIButton(type: .system)
        ba.translatesAutoresizingMaskIntoConstraints = false
        ba.contentMode = .scaleAspectFill
        ba.backgroundColor = .clear
        ba.isUserInteractionEnabled = false
        ba.titleLabel?.font = UIFont.fontAwesome(ofSize: 21, style: .solid)
        ba.setTitle(String.fontAwesomeIcon(name: .chevronUp), for: .normal)
        ba.tintColor = coreOrangeColor
        
       return ba
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
        self.mainContainer.addSubview(self.descriptionLabel)
        self.mainContainer.addSubview(self.bottomArrow)

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
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 80).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 25).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -25).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -55).isActive = true
        
        self.bottomArrow.centerXAnchor.constraint(equalTo: self.mainContainer.centerXAnchor, constant: 0).isActive = true
        self.bottomArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.bottomArrow.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.bottomArrow.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -10).isActive = true

    }
    
    @objc func handleMainContainerTaps(sender : UITapGestureRecognizer) {
        
        if let tappableArea = sender.view {
            self.servicesCollectionview?.handleSelection(sender:tappableArea)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
