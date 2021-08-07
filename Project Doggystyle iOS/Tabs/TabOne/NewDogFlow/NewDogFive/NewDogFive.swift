//
//  NewDogFive.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/6/21.
//

import Foundation
import UIKit


class NewDogFive : UIViewController {
    
    var headerContainer : UIView = {
        
        let hc = UIView()
        hc.translatesAutoresizingMaskIntoConstraints = false
        hc.backgroundColor = .clear
        hc.isUserInteractionEnabled = false
        
        return hc
    }()
    
    lazy var cancelButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor.dsOrange
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let basicDetailsLabel : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "Confirm <name> details"
        nl.font = UIFont(name: dsHeaderFont, size: 24)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    lazy var confirmButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("Confirm", for: UIControl.State.normal)
        cbf.titleLabel?.font = UIFont.init(name: dsHeaderFont, size: 18)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = coreBlackColor
        cbf.backgroundColor = coreOrangeColor
        cbf.layer.cornerRadius = 15
        cbf.layer.masksToBounds = true
        cbf.tintColor = coreWhiteColor
        cbf.addTarget(self, action: #selector(self.handleNextButton), for: .touchUpInside)
        
        return cbf
        
    }()
    
    let mainContainer : UIView = {

        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = coreWhiteColor
        wc.isUserInteractionEnabled = true
        wc.layer.masksToBounds = true
        wc.layer.cornerRadius = 20
        wc.clipsToBounds = false
        wc.layer.masksToBounds = false
        wc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        wc.layer.shadowOpacity = 0.05
        wc.layer.shadowOffset = CGSize(width: 2, height: 3)
        wc.layer.shadowRadius = 9
        wc.layer.shouldRasterize = false
       return wc

    }()
    
    let dogImage : UIImageView = {
        
        let di = UIImageView()
        di.translatesAutoresizingMaskIntoConstraints = false
        di.backgroundColor = coreOrangeColor.withAlphaComponent(0.2)
        di.contentMode = .scaleAspectFill
        di.isUserInteractionEnabled = true
        di.layer.masksToBounds = true
        
       return di
    }()
    
    lazy var pencilIconButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .pencilAlt), for: .normal)
        cbf.addTarget(self, action: #selector(self.handlePencilButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let k9Name : UILabel = {
        
        let nl = UILabel()
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.backgroundColor = .clear
        nl.text = "<name>"
        nl.font = UIFont(name: dsSubHeaderFont, size: 18)
        nl.textColor = coreBlackColor
        nl.textAlignment = .left
        nl.adjustsFontSizeToFitWidth = true
        
        return nl
    }()
    
    let containerForSize : UIView = {
        
        let cfs = UIView()
        cfs.translatesAutoresizingMaskIntoConstraints = false
        cfs.backgroundColor = coreWhiteColor
        
       return cfs
    }()
    
    lazy var newDogCollection : NewDogFiveCollectionview = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let ndc = NewDogFiveCollectionview(frame: .zero, collectionViewLayout: layout)
        ndc.newDogFive = self
       return ndc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.headerContainer)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.basicDetailsLabel)
        self.view.addSubview(self.mainContainer)
        self.view.addSubview(self.confirmButton)
        
        self.mainContainer.addSubview(self.dogImage)
        self.mainContainer.addSubview(self.k9Name)
        self.mainContainer.addSubview(self.pencilIconButton)
        self.mainContainer.addSubview(self.containerForSize)
        self.mainContainer.addSubview(self.newDogCollection)


        self.headerContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.headerContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.headerContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.headerContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.cancelButton.centerYAnchor.constraint(equalTo: self.headerContainer.centerYAnchor, constant: 0).isActive = true
        self.cancelButton.leftAnchor.constraint(equalTo: self.headerContainer.leftAnchor, constant: 11).isActive = true
        self.cancelButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.cancelButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.basicDetailsLabel.topAnchor.constraint(equalTo: self.cancelButton.bottomAnchor, constant: 25).isActive = true
        self.basicDetailsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.basicDetailsLabel.sizeToFit()
        
        self.confirmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        self.confirmButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.confirmButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.mainContainer.topAnchor.constraint(equalTo: self.basicDetailsLabel.bottomAnchor, constant: 20).isActive = true
        self.mainContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.mainContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.mainContainer.bottomAnchor.constraint(equalTo: self.confirmButton.topAnchor, constant: -30).isActive = true
        
        self.dogImage.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 21).isActive = true
        self.dogImage.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 27).isActive = true
        self.dogImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.dogImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        self.dogImage.layer.cornerRadius = 48/2
        
        self.k9Name.centerYAnchor.constraint(equalTo: self.dogImage.centerYAnchor, constant: 0).isActive = true
        self.k9Name.leftAnchor.constraint(equalTo: self.dogImage.rightAnchor, constant: 10).isActive = true
        self.k9Name.sizeToFit()
        
        self.pencilIconButton.topAnchor.constraint(equalTo: self.mainContainer.topAnchor, constant: 21).isActive = true
        self.pencilIconButton.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: -27).isActive = true
        self.pencilIconButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.pencilIconButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.containerForSize.topAnchor.constraint(equalTo: self.dogImage.bottomAnchor, constant: 10).isActive = true
        self.containerForSize.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 0).isActive = true
        self.containerForSize.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: 0).isActive = true
        self.containerForSize.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -10).isActive = true
        
        self.newDogCollection.topAnchor.constraint(equalTo: self.dogImage.bottomAnchor, constant: 10).isActive = true
        self.newDogCollection.leftAnchor.constraint(equalTo: self.mainContainer.leftAnchor, constant: 0).isActive = true
        self.newDogCollection.rightAnchor.constraint(equalTo: self.mainContainer.rightAnchor, constant: 0).isActive = true
        self.newDogCollection.bottomAnchor.constraint(equalTo: self.mainContainer.bottomAnchor, constant: -10).isActive = true

        
        
        
        
        
        
        
        
        
        
        
        
        
        
     
        
    }
    
    @objc func handlePencilButton() {
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNextButton() {
        
        let newDogSix = NewDogSix()
        newDogSix.modalPresentationStyle = .fullScreen
        newDogSix.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(newDogSix, animated: true)
        
    }
}
