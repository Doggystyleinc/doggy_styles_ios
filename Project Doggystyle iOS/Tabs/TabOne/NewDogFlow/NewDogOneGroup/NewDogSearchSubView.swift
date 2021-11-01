//
//  NewDogSearchSubView.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/11/21.
//

import Foundation
import UIKit


class NewDogSearchBreedSubview : UIView, UITextFieldDelegate {
    
    var newDogOne : NewDogOne?,
        breedHeightAnchor : NSLayoutConstraint?,
        dogBreedJsonGrabber = DogBreed(),
        dogBreedJson : [String] = [],
        predictionString : String = "",
        currentBreedArray : [String] = [String](),
        centerConstraint : NSLayoutConstraint?,
        topConstraint : NSLayoutConstraint?
    
    lazy var breedTableView : NewDogTableView = {
        
        let mc = NewDogTableView(frame: .zero, style: .plain)
        mc.newDogSearchBreedSubview = self
        return mc
        
    }()
    
    lazy var breedTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.placeholder = "Breed"
        etfc.textAlignment = .left
        etfc.backgroundColor = coreWhiteColor
        etfc.textColor = UIColor .darkGray.withAlphaComponent(1.0)
        etfc.font = UIFont(name: rubikRegular, size: 18)
        etfc.allowsEditingTextAttributes = false
        etfc.autocorrectionType = .no
        etfc.delegate = self
        etfc.layer.masksToBounds = true
        etfc.keyboardAppearance = UIKeyboardAppearance.light
        etfc.returnKeyType = UIReturnKeyType.default
        etfc.leftViewMode = .always
        
        let image = UIImage(named: "magnifyingGlass")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView()
        imageView.contentMode = .center
        etfc.contentMode = .center
        imageView.image = image
        etfc.leftView = imageView
        
        etfc.clipsToBounds = false
        etfc.layer.masksToBounds = false
        etfc.layer.shadowColor = coreBlackColor.withAlphaComponent(0.8).cgColor
        etfc.layer.shadowOpacity = 0.05
        etfc.layer.shadowOffset = CGSize(width: 2, height: 3)
        etfc.layer.shadowRadius = 9
        etfc.layer.shouldRasterize = false
        etfc.layer.borderColor = dividerGrey.withAlphaComponent(0.2).cgColor
        etfc.layer.borderWidth = 1.0
        etfc.layer.cornerRadius = 10
        
        etfc.addTarget(self, action: #selector(handleSearchTextFieldChange(textField:)), for: .editingChanged)
        
        return etfc
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor (white: 1.0, alpha: 1.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alpha = 0
        
        self.breedTextField.setUpImage(imageName: "magnifyingGlass", on: .left)
        self.breedTextField.textContentType = UITextContentType(rawValue: "")
        self.dogBreedJson = self.dogBreedJsonGrabber.dogBreedJSON
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.breedTextField)
        self.addSubview(self.breedTableView)
        
        self.centerConstraint = self.breedTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        self.centerConstraint?.isActive = true
        
        self.breedTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.breedTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.breedTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.breedTableView.topAnchor.constraint(equalTo: self.breedTextField.bottomAnchor, constant: 10).isActive = true
        self.breedTableView.leftAnchor.constraint(equalTo: self.breedTextField.leftAnchor, constant: 0).isActive = true
        self.breedTableView.rightAnchor.constraint(equalTo: self.breedTextField.rightAnchor, constant: 0).isActive = true
        self.breedHeightAnchor = self.breedTableView.heightAnchor.constraint(equalToConstant: 48.0)
        self.breedHeightAnchor?.isActive = true
    }
    
    func moveConstraints() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.centerConstraint?.constant = -UIScreen.main.bounds.height / 2.7
            self.layoutIfNeeded()
            
        } completion: { complete in
            
            self.breedTextField.becomeFirstResponder()
            
        }
    }
    
    @objc func handleSearchTextFieldChange(textField: UITextField) {
        
        guard let breedSafeText = self.breedTextField.text else {return}
        
        let safeText = breedSafeText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if safeText.count == 0 {
            
            UIView.animate(withDuration: 0.45) {
                
                self.breedTableView.newDogArray.removeAll()
                self.currentBreedArray.removeAll()
                self.breedHeightAnchor?.constant = 0.0
                self.breedTableView.superview?.layoutIfNeeded()
                
            }
            
            DispatchQueue.main.async {
                self.breedTableView.reloadData()
            }
            
        } else {
            
            let currentEnteredText = safeText
            self.listBreeds(passedText: currentEnteredText)
            
        }
    }
    
    func listBreeds(passedText : String) {
        
        let matchingTerms = self.dogBreedJson.filter({
            $0.range(of: passedText, options: .caseInsensitive) != nil
        })
        
        if matchingTerms.count > 0 {
            
            self.predictionString = matchingTerms[0]
            
            if self.currentBreedArray.count > 4 && !self.currentBreedArray.contains(self.predictionString) {
                
                self.currentBreedArray.insert(self.predictionString, at: 0)
                self.currentBreedArray.removeLast()
                
                self.breedTableView.newDogArray.insert(self.predictionString, at: 0)
                self.breedTableView.newDogArray.removeLast()
                
                DispatchQueue.main.async {
                    self.breedTableView.reloadData()
                }
                
                UIView.animate(withDuration: 0.15) {
                    self.breedHeightAnchor?.constant = (CGFloat(self.currentBreedArray.count) * 48.0)
                }
                
            } else if !self.currentBreedArray.contains(self.predictionString) {
                
                self.currentBreedArray.append(self.predictionString)
                self.breedTableView.newDogArray.append(self.predictionString)
                
                DispatchQueue.main.async {
                    self.breedTableView.reloadData()
                }
                
                UIView.animate(withDuration: 0.15) {
                    self.breedHeightAnchor?.constant = (CGFloat(self.currentBreedArray.count) * 48.0)
                }
            }
            
        } else {
            
            self.predictionString = ""
            self.currentBreedArray.removeAll()
            self.breedTableView.newDogArray.removeAll()
            self.breedHeightAnchor?.constant = 0.0
            
            DispatchQueue.main.async {
                self.breedTableView.reloadData()
            }
            UIView.animate(withDuration: 0.25) {
                self.breedHeightAnchor?.constant = 0.0
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
