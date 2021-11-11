//
//  GroomingTimeline.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 11/11/21.
//

import Foundation
import UIKit


class GroomerTimeLineController : UIViewController {
    
    lazy var backButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.backgroundColor = .clear
        cbf.tintColor = coreOrangeColor
        cbf.contentMode = .scaleAspectFill
        cbf.titleLabel?.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        cbf.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        cbf.addTarget(self, action: #selector(self.handleBackButton), for: UIControl.Event.touchUpInside)
        return cbf
        
    }()
    
    let startingLabel : UILabel = {
        
        let thl = UILabel()
        thl.translatesAutoresizingMaskIntoConstraints = false
        thl.textAlignment = .left
        thl.text = "Grooming Timeline"
        thl.font = UIFont(name: dsHeaderFont, size: 24)
        thl.numberOfLines = 1
        thl.adjustsFontSizeToFitWidth = true
        thl.textColor = dsFlatBlack
        return thl
        
    }()
    
    lazy var checklistCollectionview : GroomerTimeLineCheckList = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let clcv = GroomerTimeLineCheckList(frame: .zero, collectionViewLayout: layout)
        clcv.translatesAutoresizingMaskIntoConstraints = false
        clcv.groomerTimeLineController = self
        
       return clcv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = coreBackgroundWhite
        self.addViews()
        
    }
    
    func addViews() {
        
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.startingLabel)
        self.view.addSubview(self.checklistCollectionview)

        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 54).isActive = true
        
        self.startingLabel.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 23).isActive = true
        self.startingLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.startingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.startingLabel.sizeToFit()
     
        self.checklistCollectionview.topAnchor.constraint(equalTo: self.startingLabel.bottomAnchor, constant: 20).isActive = true
        self.checklistCollectionview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.checklistCollectionview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.checklistCollectionview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

    }
    
    @objc func handleReadyToGroom() {
        
    }
    
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
