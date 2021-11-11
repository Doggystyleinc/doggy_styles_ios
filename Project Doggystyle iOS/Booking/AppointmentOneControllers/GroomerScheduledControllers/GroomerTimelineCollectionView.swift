//
//  GroomerTimelineCollectionView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/11/21.
//


import Foundation
import UIKit

class GroomerTimeLineCheckList : UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let checklistID = "checklistID"
    
    var groomerTimeLineController : GroomerTimeLineController?
    
    var arrayOfSelections = [IndexPath]()
    
    let descriptionNames : [String] = ["Doggystylist en route", "Doggystylist arrived", "Rex has arrived at the van", "Grooming (65 mins)", "Finishing up", "Pick up Rex from the van"]
    let subHeaderDescription : [String] = ["Stephanie will arrive at 3:40pm", "Picking up Rex now", "Getting ready to get Doggystyled!", "Rex is now being groomed!", "15 minutes remaining in appointment", "Rex is ready to strut his Doggy self!"]

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
        
        self.register(ChecklistCollectionFeeder.self, forCellWithReuseIdentifier: self.checklistID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.descriptionNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 95)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: self.checklistID, for: indexPath) as! ChecklistCollectionFeeder
        
        cell.groomerTimeLineCheckList = self
        
        let headerLabel = self.descriptionNames[indexPath.item]
        let subHeaderLabel = self.subHeaderDescription[indexPath.item]

        cell.descriptionLabel.text = headerLabel
        cell.subDescriptionLabel.text = subHeaderLabel

        if !self.arrayOfSelections.contains(indexPath) {
            cell.selectionButton.setTitle("", for: .normal)
            cell.descriptionLabel.textColor = coreBlackColor
        } else {
            cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 23, style: .solid)
            cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .checkCircle), for: .normal)
            cell.selectionButton.setTitleColor(coreOrangeColor, for: .normal)
            cell.descriptionLabel.textColor = coreBlackColor.withAlphaComponent(0.5)
        }
        
      
        switch headerLabel {
        
        case "Doggystylist en route" :
            
            cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .road), for: .normal)
            cell.selectionButton.setTitleColor(dsFlatBlack.withAlphaComponent(0.4), for: .normal)
            
        case "Doggystylist arrived" :
            
            cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .mapPin), for: .normal)
            cell.selectionButton.setTitleColor(dsFlatBlack.withAlphaComponent(0.4), for: .normal)
            
        case "Rex has arrived at the van" :
            
            cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .paw), for: .normal)
            cell.selectionButton.setTitleColor(dsFlatBlack.withAlphaComponent(0.4), for: .normal)
            
        case "Grooming (65 mins)" :
            
            cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .shower), for: .normal)
            cell.selectionButton.setTitleColor(dsFlatBlack.withAlphaComponent(0.4), for: .normal)
            
        case "Finishing up" :
            
            cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .starAndCrescent), for: .normal)
            cell.selectionButton.setTitleColor(dsFlatBlack.withAlphaComponent(0.4), for: .normal)
            
        case "Pick up Rex from the van" :
            
            cell.selectionButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            cell.selectionButton.setTitle(String.fontAwesomeIcon(name: .dog), for: .normal)
            cell.selectionButton.setTitleColor(dsFlatBlack.withAlphaComponent(0.4), for: .normal)
            
        default: print("nothing here")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleSelectionButton(sender : UIButton) {
        
        let selectedButtonCell = sender.superview as! UICollectionViewCell
        guard let indexPath = self.indexPath(for: selectedButtonCell) else {return}
        
        if !self.arrayOfSelections.contains(indexPath) {
            self.arrayOfSelections.append(indexPath)
            
        } else {
           if let indexOf = self.arrayOfSelections.firstIndex(of: indexPath) {
            self.arrayOfSelections.remove(at: indexOf)
            }
        }
        
        DispatchQueue.main.async {
            self.reloadItems(at: [indexPath])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChecklistCollectionFeeder : UICollectionViewCell {
    
    var groomerTimeLineCheckList : GroomerTimeLineCheckList?
    
    lazy var mainContainer : UIButton = {
        
        let mc = UIButton()
        mc.translatesAutoresizingMaskIntoConstraints = false
        mc.backgroundColor = coreWhiteColor
        mc.clipsToBounds = false
        mc.layer.masksToBounds = false
        mc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        mc.layer.shadowOpacity = 0.05
        mc.layer.shadowOffset = CGSize(width: 2, height: 3)
        mc.layer.shadowRadius = 9
        mc.layer.shouldRasterize = false
        mc.layer.cornerRadius = 20
        mc.addTarget(self, action: #selector(self.handleSelectionTap(sender:)), for: .touchUpInside)
        
       return mc
    }()
    
    lazy var selectionButton : UIButton = {
        
        let cbf = UIButton()
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.contentMode = .scaleAspectFill
        cbf.backgroundColor = selectionGrey
        cbf.layer.masksToBounds = true
        cbf.layer.borderWidth = 5
        cbf.layer.borderColor = selectionGrey.cgColor
        cbf.isUserInteractionEnabled = false
        
        return cbf
        
    }()
    
    let descriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = ""
        thl.font = UIFont(name: rubikSemiBold, size: 18)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    let subDescriptionLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = ""
        thl.font = UIFont(name: rubikRegular, size: 14)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = coreBlackColor
        return thl
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.addViews()
        
    }
    
    
    func addViews() {
        
        self.addSubview(self.mainContainer)
        
        self.mainContainer.addSubview(self.selectionButton)
        self.mainContainer.addSubview(self.descriptionLabel)
        self.mainContainer.addSubview(self.subDescriptionLabel)

        self.mainContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.mainContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.mainContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.mainContainer.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        self.selectionButton.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 20).isActive = true
        self.selectionButton.centerYAnchor.constraint(equalTo: self.mainContainer.centerYAnchor, constant: 0).isActive = true
        self.selectionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.selectionButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.selectionButton.layer.cornerRadius = 20
        
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.selectionButton.rightAnchor, constant: 20).isActive = true
        self.descriptionLabel.centerYAnchor.constraint(equalTo: self.mainContainer.centerYAnchor, constant: -12).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -20).isActive = true
        self.descriptionLabel.sizeToFit()
        
        self.subDescriptionLabel.leftAnchor.constraint(equalTo: self.selectionButton.rightAnchor, constant: 20).isActive = true
        self.subDescriptionLabel.centerYAnchor.constraint(equalTo: self.mainContainer.centerYAnchor, constant: 12).isActive = true
        self.subDescriptionLabel.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -20).isActive = true
        self.subDescriptionLabel.sizeToFit()
        

    }
    
    @objc func handleSelectionTap(sender : UIButton) {
        
        self.groomerTimeLineCheckList?.handleSelectionButton(sender : sender)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
