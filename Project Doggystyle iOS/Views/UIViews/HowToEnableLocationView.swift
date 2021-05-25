//
//  HowToEnableLocationView.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 5/25/21.
//

import UIKit

class HowToEnableLocationView: UIView {
    private let stepOneImage = UIImage(named: "Apple Settings App Icon")!
    private let stepTwoImage = UIImage(named: "SettingsPrivacyImage")!
    private let stepThreeImage = UIImage(named: "SettingsLocationServices")!
    private let stepThreeAImage = UIImage(named: "SettingsEnableLocationServices")!
    private let stepFourImage = UIImage(named: "SettingsAppName")!
    private let stepFiveImage = UIImage(named: "SettingsEnableWhileUsing")!
    private let stepFiveAImage = UIImage(named: "SettingsEnablePreciseLocation")!
    private var didRemove = false
    
    private let tutorialView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 16.0
        return view
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel(frame: .zero)
        title.text = "How To Enable Location Services"
        title.font = UIFont.robotoBold(size: 18)
        title.textColor = .headerColor
        title.textAlignment = .center
        return title
    }()
    
    private var stepOne: UILabel!
    private var stepOneExplanation: UILabel!
    private var stepOneImageView: UIImageView!
    
    private var stepTwo: UILabel!
    private var stepTwoExplanation: UILabel!
    private var stepTwoImageView: UIImageView!
    
    private var stepThree: UILabel!
    private var stepThreeExplanation: UILabel!
    private var stepThreeImageView: UIImageView!
    private var stepThreeAImageView: UIImageView!
    
    private var stepFour: UILabel!
    private var stepFourExplanation: UILabel!
    private var stepFourImageView: UIImageView!
    
    private var stepFive: UILabel!
    private var stepFiveExplanation: UILabel!
    private var stepFiveImageView: UIImageView!
    private var stepFiveAImageView: UIImageView!
    
    private let nextButton: DSButton = {
        let button = DSButton(titleText: "Next", backgroundColor: .systemBlue, titleColor: .white)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    private let backButton: DSButton = {
        let button = DSButton(titleText: "Close", backgroundColor: .lightGray, titleColor: .white)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.layoutStepOne()
        self.layoutStepTwo()
        self.layoutStepThree()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Layout Views
extension HowToEnableLocationView {
    private func layoutStepOne() {
        self.addSubview(tutorialView)
        tutorialView.top(to: self, offset: 140)
        tutorialView.bottom(to: self, offset: -140)
        tutorialView.right(to: self, offset: -20)
        tutorialView.left(to: self, offset: 20)
        
        tutorialView.addSubview(titleLabel)
        titleLabel.top(to: tutorialView, offset: 20)
        titleLabel.left(to: tutorialView, offset: 20)
        titleLabel.right(to: tutorialView, offset: -20)
        
        stepOne = stepLabel(with: "Step 1.")
        tutorialView.addSubview(stepOne)
        stepOne.topToBottom(of: titleLabel, offset: 26.0)
        stepOne.left(to: titleLabel)
        stepOne.right(to: titleLabel)
        
        stepOneExplanation = explanationLabel(with: "Tap your Settings app.")
        tutorialView.addSubview(stepOneExplanation)
        stepOneExplanation.topToBottom(of: stepOne, offset: 10)
        stepOneExplanation.left(to: stepOne, offset: 10)
        
        stepOneImageView = imageView(withImage: stepOneImage)
        tutorialView.addSubview(stepOneImageView)
        stepOneImageView.height(30)
        stepOneImageView.width(30)
        stepOneImageView.leftToRight(of: stepOneExplanation, offset: 10)
        stepOneImageView.centerY(to: stepOneExplanation)
        
        //bottom buttons
        //button tap redirects to Settings app
        tutorialView.addSubview(nextButton)
        nextButton.height(44)
        nextButton.width(140)
        nextButton.right(to: titleLabel)
        nextButton.bottom(to: tutorialView, offset: -20)
        
        tutorialView.addSubview(backButton)
        backButton.height(44)
        backButton.width(140)
        backButton.left(to: titleLabel)
        backButton.top(to: nextButton)
    }
    
    private func layoutStepTwo() {
        stepTwo = stepLabel(with: "Step 2.")
        tutorialView.addSubview(stepTwo)
        stepTwo.topToBottom(of: stepOneExplanation, offset: 30.0)
        stepTwo.left(to: titleLabel)
        stepTwo.right(to: titleLabel)
        
        stepTwoExplanation = explanationLabel(with: "Select Privacy.")
        tutorialView.addSubview(stepTwoExplanation)
        stepTwoExplanation.topToBottom(of: stepTwo, offset: 10)
        stepTwoExplanation.left(to: stepTwo, offset: 10)
        
        stepTwoImageView = imageView(withImage: stepTwoImage)
        tutorialView.addSubview(stepTwoImageView)
        stepTwoImageView.topToBottom(of: stepTwoExplanation, offset: 10.0)
        stepTwoImageView.height(30)
        stepTwoImageView.left(to: stepTwoExplanation)
        stepTwoImageView.right(to: titleLabel)
    }
    
    private func layoutStepThree() {
        stepThree = stepLabel(with: "Step 3.")
        tutorialView.addSubview(stepThree)
        stepThree.topToBottom(of: stepTwoImageView, offset: 30.0)
        stepThree.left(to: titleLabel)
        stepThree.right(to: titleLabel)
        
        stepThreeExplanation = explanationLabel(with: "Next, select Location Services.\nMake sure Location Services is enabled.")
        tutorialView.addSubview(stepThreeExplanation)
        stepThreeExplanation.topToBottom(of: stepThree, offset: 10)
        stepThreeExplanation.left(to: stepThree, offset: 10)
        stepThreeExplanation.right(to: titleLabel, offset: -10)
        
        stepThreeImageView = imageView(withImage: stepThreeImage)
        tutorialView.addSubview(stepThreeImageView)
        stepThreeImageView.topToBottom(of: stepThreeExplanation, offset: 10.0)
        stepThreeImageView.height(30)
        stepThreeImageView.left(to: stepThreeExplanation)
        stepThreeImageView.right(to: titleLabel)
        
        stepThreeAImageView = imageView(withImage: stepThreeAImage)
        tutorialView.addSubview(stepThreeAImageView)
        stepThreeAImageView.topToBottom(of: stepThreeImageView, offset: 10.0)
        stepThreeAImageView.height(30)
        stepThreeAImageView.left(to: stepThreeExplanation)
        stepThreeAImageView.right(to: titleLabel)
    }
    
    private func layoutStepFour() {
        stepFour = stepLabel(with: "Step 4.")
        tutorialView.addSubview(stepFour)
        stepFour.topToBottom(of: titleLabel, offset: 26.0)
        stepFour.left(to: titleLabel)
        stepFour.right(to: titleLabel)
        
        stepFourExplanation = explanationLabel(with: "Scroll down, select the Doggystyle section.")
        tutorialView.addSubview(stepFourExplanation)
        stepFourExplanation.topToBottom(of: stepFour, offset: 10)
        stepFourExplanation.left(to: stepFour, offset: 10)
        stepFourExplanation.right(to: titleLabel)
        
        stepFourImageView = imageView(withImage: stepFourImage)
        tutorialView.addSubview(stepFourImageView)
        stepFourImageView.topToBottom(of: stepFourExplanation, offset: 10.0)
        stepFourImageView.height(30)
        stepFourImageView.left(to: stepFourExplanation)
        stepFourImageView.right(to: titleLabel)
    }
    
    private func layoutStepFive() {
        stepFive = stepLabel(with: "Step 5.")
        tutorialView.addSubview(stepFive)
        stepFive.topToBottom(of: stepFourImageView, offset: 30.0)
        stepFive.left(to: titleLabel)
        stepFive.right(to: titleLabel)
        
        stepFiveExplanation = explanationLabel(with: "Lastly, select \"While Using the App\".\nEnable Precise Location for best results.")
        tutorialView.addSubview(stepFiveExplanation)
        stepFiveExplanation.topToBottom(of: stepFive, offset: 10)
        stepFiveExplanation.left(to: stepFive, offset: 10)
        stepFiveExplanation.right(to: titleLabel)
        
        stepFiveImageView = imageView(withImage: stepFiveImage)
        tutorialView.addSubview(stepFiveImageView)
        stepFiveImageView.topToBottom(of: stepFiveExplanation, offset: 10.0)
        stepFiveImageView.height(30)
        stepFiveImageView.left(to: stepFiveExplanation)
        stepFiveImageView.right(to: titleLabel)
        
        stepFiveAImageView = imageView(withImage: stepFiveAImage)
        tutorialView.addSubview(stepFiveAImageView)
        stepFiveAImageView.topToBottom(of: stepFiveImageView, offset: 10.0)
        stepFiveAImageView.height(30)
        stepFiveAImageView.left(to: stepFiveImageView)
        stepFiveAImageView.right(to: titleLabel)
    }
}

//MARK: - @objc Functions
extension HowToEnableLocationView {
    @objc private func didTapNext() {
        if nextButton.titleLabel?.text == "Open Settings?".uppercased() {
            openSettings()
        }
        
        guard didRemove == false else { return }
        removeFirstSteps()
        addSecondSteps()
        backButton.setTitle("Back".uppercased(), for: .normal)
        nextButton.setTitle("Open Settings?".uppercased(), for: .normal)
        nextButton.titleLabel?.font = UIFont.robotoBold(size: 15)
    }
    
    @objc private func didTapBack() {
        if backButton.titleLabel?.text == "Close".uppercased() {
            UIView.animate(withDuration: 0.50) {
                self.alpha = 0.0
            } completion: { _ in
                self.removeFromSuperview()
            }

        }
        
        guard didRemove == true else { return }
        removeSecondSteps()
        addFirstSteps()
        backButton.setTitle("Close".uppercased(), for: .normal)
        nextButton.setTitle("Next".uppercased(), for: .normal)
        nextButton.titleLabel?.font = UIFont.robotoBold(size: 18)
    }
    
    @objc private func openSettings() {
        print(#function)
    }
}

//MARK: - Helpers
extension HowToEnableLocationView {
    private func removeFirstSteps() {
        let firstStepViews = [stepOne, stepOneExplanation, stepOneImageView, stepTwo, stepTwoExplanation, stepTwoImageView, stepThree, stepThreeExplanation, stepThreeImageView, stepThreeAImageView]
        
        for item in firstStepViews {
            item?.removeFromSuperview()
        }
        
        didRemove = true
    }
    
    private func addFirstSteps() {
        layoutStepOne()
        layoutStepTwo()
        layoutStepThree()
        didRemove = false
    }
    
    private func addSecondSteps() {
        layoutStepFour()
        layoutStepFive()
    }
    
    private func removeSecondSteps() {
        let secondStepViews = [stepFour, stepFourExplanation, stepFourImageView, stepFive, stepFiveExplanation, stepFiveImageView, stepFiveAImageView]
        
        for item in secondStepViews {
            item?.removeFromSuperview()
        }
    }
    
    private func stepLabel(with text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.robotoMedium(size: 17)
        label.textColor = .textColor
        return label
    }
    
    private func explanationLabel(with text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.robotoRegular(size: 16)
        label.textColor = .textColor
        return label
    }
    
    private func imageView(withImage image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 3.0
        imageView.layer.borderWidth = 0.3
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }
}
