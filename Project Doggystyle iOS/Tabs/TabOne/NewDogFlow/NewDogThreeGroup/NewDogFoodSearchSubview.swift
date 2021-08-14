//
//  NewDogFoodSearchSubview.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 8/12/21.
//


import Foundation
import UIKit

class NewDogFoodSubview : UIView, UITextFieldDelegate {
    
    var newDogThree : NewDogThree?,
        treatHeightAnchor : NSLayoutConstraint?,
        dogFoodJsonGrabber = DogFoodHelper(),
        dogFoodJson : [String] = [],
        predictionString : String = "",
        currentFoodArray : [String] = [String](),
        centerConstraint : NSLayoutConstraint?,
        topConstraint : NSLayoutConstraint?
    
    lazy var foodTableView : NewDogFoodTableView = {
        
        let mc = NewDogFoodTableView()
        mc.newDogFoodSubview = self
        return mc
        
    }()
    
    lazy var breedTextField : UITextField = {
        
        let etfc = UITextField()
        etfc.translatesAutoresizingMaskIntoConstraints = false
        etfc.placeholder = "Food"
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
        
        self.dogFoodJson = self.dogFoodJsonGrabber.dogFoodJSON
        
        self.addViews()
        
    }
    
    func addViews() {
        
        self.addSubview(self.breedTextField)
        self.addSubview(self.foodTableView)
        
        self.centerConstraint = self.breedTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        self.centerConstraint?.isActive = true
        
        self.breedTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        self.breedTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.breedTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.foodTableView.topAnchor.constraint(equalTo: self.breedTextField.bottomAnchor, constant: 10).isActive = true
        self.foodTableView.leftAnchor.constraint(equalTo: self.breedTextField.leftAnchor, constant: 0).isActive = true
        self.foodTableView.rightAnchor.constraint(equalTo: self.breedTextField.rightAnchor, constant: 0).isActive = true
        self.treatHeightAnchor = self.foodTableView.heightAnchor.constraint(equalToConstant: 48.0)
        self.treatHeightAnchor?.isActive = true
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
                
                self.foodTableView.newDogFoodArray.removeAll()
                self.currentFoodArray.removeAll()
                self.treatHeightAnchor?.constant = 48.0
                self.foodTableView.superview?.layoutIfNeeded()
                
            }
            
            DispatchQueue.main.async {
                self.foodTableView.reloadData()
            }
            
        } else {
            
            let currentEnteredText = safeText
            self.listBreeds(passedText: currentEnteredText)
            
        }
    }
    
    
    func listBreeds(passedText : String) {
        
        let matchingTerms = self.dogFoodJson.filter({
            $0.range(of: passedText, options: .caseInsensitive) != nil
        })
        
        if matchingTerms.count > 0 {
            
            self.predictionString = matchingTerms[0]
            
            if self.currentFoodArray.count > 4 && !self.currentFoodArray.contains(self.predictionString) {
                
                self.currentFoodArray.insert(self.predictionString, at: 0)
                self.currentFoodArray.removeLast()
                
                self.foodTableView.newDogFoodArray.insert(self.predictionString, at: 0)
                self.foodTableView.newDogFoodArray.removeLast()
                
                DispatchQueue.main.async {
                    self.foodTableView.reloadData()
                }
                
                UIView.animate(withDuration: 0.15) {
                    self.treatHeightAnchor?.constant = (CGFloat(self.currentFoodArray.count) * 48.0) + 48.0
                }
                
            } else if !self.currentFoodArray.contains(self.predictionString) {
                
                self.currentFoodArray.append(self.predictionString)
                self.foodTableView.newDogFoodArray.append(self.predictionString)
                
                DispatchQueue.main.async {
                    self.foodTableView.reloadData()
                }
                
                UIView.animate(withDuration: 0.15) {
                    self.treatHeightAnchor?.constant = (CGFloat(self.currentFoodArray.count) * 48.0) + 48.0
                }
            }
            
        } else {
            
            self.predictionString = ""
            self.currentFoodArray.removeAll()
            self.foodTableView.newDogFoodArray.removeAll()
            self.treatHeightAnchor?.constant = 48.0
            
            DispatchQueue.main.async {
                self.foodTableView.reloadData()
            }
            UIView.animate(withDuration: 0.25) {
                self.treatHeightAnchor?.constant = 48.0
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
