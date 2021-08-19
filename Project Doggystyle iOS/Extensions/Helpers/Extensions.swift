//
//  Extensions.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 7/2/21.
//

/*
926: iPhone 12 Pro Max
896: iPhone 11 : iPhone 11 Pro Max
844: iPhone 12 : iPhone 12 Pro
812: 12 mini : iPhone 11 Pro : iPhone 12 Mini
736: iPhone 8 Plus
667: iPhone 8
*/

import Foundation
import UIKit
import AVFoundation
import Firebase
import DeviceCheck
import PhoneNumberKit

//MARK: - PUBLIC VARIABLES
var friends_array_phone_number = [String](),
    friends_internal_array_uid = [String](),
    
    //MARK: - Global Color Variables
    coreWhiteColor = UIColor(hex: 0xFFFFFF),
    coreBlackColor = UIColor(hex: 0x353535),
    
    coreGrayColor = UIColor(hex: 0x414141),
    coreLightGrayColor = UIColor(hex: 0xF0F0F0),
    coreRedColor = UIColor(hex: 0xFF0000),
    coreGreenColor = UIColor(hex: 0x00F87C),
    coreOrangeColor = UIColor(hex: 0xE25E12),
    coreBackgroundWhite = UIColor(hex: 0xF5F5F5),
    dmMainColor = UIColor(hex: 0x2777F6),
    dmSecondaryColor = UIColor(hex: 0x509CF9),
    dmTertiaryColor = UIColor(hex: 0x509CF9),
    phoneCallBlue = UIColor(hex: 0x2C324A),
    predictionsBlue = UIColor(hex: 0xA5C8FF),
    greyDateColor = UIColor(hex: 0x414141),
    recordCharcoalGrey = UIColor(hex: 0x4A4A4A),
    loadingBlueProgress = UIColor(hex: 0x0062FF),
    predictionGrey = UIColor(hex: 0x707070),
    dividerGrey = UIColor(hex: 0xEDEDED),
    imageBorderBlue = UIColor(hex: 0x1F5FC5),
    dsFlatBlack = UIColor(hex: 0x302F3C),
    dsButtonLightGrey = UIColor(hex: 0xEDEDED),
    dsTransparentOrange = UIColor(hex: 0xF7EAE3),
    dsGreyMedium = UIColor(hex: 0x7D7D7D),
    circleGrey = UIColor(hex: 0xE2E1E1),

    
    globalStatusBarHeight : CGFloat = 0.0,
    globalFooterHeight : CGFloat = 0.0,
    
    //FOR THE CHAT CONTROLLER, WHEN A USER SWIPES LEFT TO EXPOSE THE REPLY ARROW
    globalIsReplyExpanded : Bool = false,
    
    //MARK: - Global Fonts
    dsHeaderFont : String = "Poppins-Bold",
    dsSubHeaderFont : String = "Poppins-SemiBold",
    dsMediumFont : String = "Arboria-Medium",
    dsFontSymbols : String = "FontAwesome5Pro-Regular",
    
    rubikRegular : String = "Rubik-Regular",
    rubikItalic : String = "Rubik-Italic",
    rubikLight : String = "Rubik-Light",
    rubikLightItalic : String = "Rubik-LightItalic",
    rubikMedium : String = "Rubik-Medium",
    rubikMediumItalic : String = "Rubik-MediumItalic",
    rubikSemiBold : String = "Rubik-SemiBold",
    rubikSemiBoldItalic : String = "Rubik-SemiBoldItalic",
    rubikBold : String = "Rubik-Bold",
    rubikBoldItalic : String = "Rubik-BoldItalic",
    rubikExtraBold: String = "Rubik-ExtraBold",
    rubikExtraBoldItalic : String = "Rubik-ExtraBoldItalic",
    rubikBlack : String = "Rubik-Black",
    rubikBlackitalic : String = "Rubik-BlackItalic",
    
    //DEMO ADJUSTMENT SETTINGS
    globalFrostTransparency : CGFloat = 1.0,
    globalSpacingForChatCells : CGFloat = 12,
    globalMediaViewControllerBackgroundColor : UIColor = coreWhiteColor,
    
    photoSelectionPath = PhotoSelectionPath.fromOnboarding,
    onboardingPath = OnboardingPath.fromLogin,
    chatEntryPath = ChatEntryPath.fromMessagesController

 
var globalPetDataSource = [DoggyProfileDataSource]()

class fileUPloader : NSObject {
    
   static func upload(localFilePath : URL, completion : @escaping (_ isComplete : Bool, _ urlToStoreInDatabase : String)->()) {
        
            let storageRef = Storage.storage().reference()
            
            guard let user_uid = Auth.auth().currentUser?.uid else {return}
            
            let randomUUID = NSUUID().uuidString
            
            let storageReference = storageRef.child("vaccine_files").child(user_uid).child(randomUUID)
            
            let uploadTask = storageReference.putFile(from: localFilePath, metadata: nil)

            uploadTask.observe(.failure) { snapshot in
                print("FAILED HERE ONE")
                completion(false, "nil")
                return
            }
                
            uploadTask.observe(.progress) { snapshot in
                let percentComplete = Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                print("PROGRESS: ", CGFloat(percentComplete))
            }
            
            uploadTask.observe(.success) { snapshot in

                storageReference.downloadURL { (url, error) in
                    
                    if error != nil {
                        print(error?.localizedDescription as Any, "Error 1")
                        print("ERROR RAN")
                        completion(false, "nil")
                        return
                    }
                    
                    guard let safeUrl = url else {return}
                    print("Uploaded audio clip successfully to Firebase Storage")
                    completion(true, "\(safeUrl)")
                    
                }
            }
        }
    }


enum TextFieldImageSide {
    case left
    case right
}

extension UITextField {
    func setUpImage(imageName: String, on side: TextFieldImageSide) {
        let imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 20, height: 20))
        if let imageWithSystemName = UIImage(systemName: imageName) {
            imageView.image = imageWithSystemName.withRenderingMode(.alwaysOriginal).withTintColor(dsFlatBlack.withAlphaComponent(0.4))
        } else {
            imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal).withTintColor(dsFlatBlack.withAlphaComponent(0.4))
        }
        
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        imageContainerView.addSubview(imageView)
        
        switch side {
        case .left:
            leftView = imageContainerView
            leftViewMode = .always
        case .right:
            rightView = imageContainerView
            rightViewMode = .always
        }
    }
}

class CustomTextField: UITextField {

    let padding = UIEdgeInsets(top: 15, left: 25, bottom: 0, right: 0);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}



class CustomPasswordTextField: UITextField {

    let padding = UIEdgeInsets(top: 15, left: 25, bottom: 0, right: 70);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


class PhoneTextFieldWithPadding: PhoneNumberTextField {

    let padding = UIEdgeInsets(top: 15, left: 25, bottom: 0, right: 0);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class CustomTextFieldMaps: TextFieldWithImage {

    let padding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 50);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

public enum CurrentDevice {
    
    case iPhone8
    case iPhone8Plus
    
    case iPhone11
    case iPhone11Pro
    case iPhone11Promax

    case iPhone12Mini
    case iPhone12
    case iPhone12Pro
    case iPhone12ProMax
    
}

//
//func determineDeviceType () {
//    
//    /*
//    926: iPhone 12 Pro Max
//    896: iPhone 11 : iPhone 11 Pro Max
//    844: iPhone 12 : iPhone 12 Pro
//    812: 12 mini : iPhone 11 Pro
//    736: iPhone 8 Plus
//    667: iPhone 8
//    */
//    
//    let screenHeight = UIScreen.main.bounds.height
//    
//    switch screenHeight {
//    
//    case 926: CurrentDevice.iPhone12ProMax
//    case 896:
//    case 844:
//    case 812:
//    case 736:
//    case 667:
//    default: print("no phone found")
//    }
//}



//MARK: - URLS/KEYS/TONES
struct Statics {
    
    //MARK: - URLS AND LINKS FOR DUV MESSENGER
    static let  TERMS_OF_SERVICE : String = "https://doggystyle.ca"
    static let  PRIVACY_POLICY : String = "https://doggystyle.ca"
    
    static let  SUPPORT_EMAIL_ADDRESS : String = "support@.com"
    static let  FAQS : String = "https://www..com"
    static let  APP_STORE_URL : String = "https://"
    
    static let GOOGLE_SIGN_IN : String = "google"
    static let EMAIL_SIGN_IN : String = "email"
    
    static let PAW_ANIMATION : String = "paw_animation"
    
}

extension UICollectionView {
    
    var centerPoint : CGPoint {
        
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y - 40.0)
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UIImageView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

class ColorToHex {
    
    static func convert(color: UIColor) -> String {
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
    
}

class GrabUsersHexColor {
    
    static func withUID(passedUID : String, completion : @escaping(_ returnedHexColorString : String) -> (Void))  {
        
        let path = Database.database().reference().child("all_users").child(passedUID)
        
        path.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
            
            if snap.exists() {
                
                let JSON = snap.value as? [String : Any] ?? ["nil" : "nil"]
                
                let hexColor = JSON["profile_hex_color"] as? String ?? "nil"
                
                completion(hexColor)
                
            } else {
                completion("nil")
            }
        }
    }
}

extension String {
    
    func grabUserInitialsFromName(passedString : String) -> String {
        
        if passedString.isEmpty {
            return "PI"
        }
        
        let nameSplice = passedString.split(separator: " ")
        
        if nameSplice.count > 0 {
            
            if nameSplice.count == 1 {
                
                let spliceOne = nameSplice[0]
                let prefixOne = spliceOne.prefix(1)
                return "\(prefixOne)"
                
            } else {
                
                let spliceOne = nameSplice[0]
                let spliceTwo = nameSplice[1]
                
                let prefixOne = spliceOne.prefix(1)
                let prefixTwo = spliceTwo.prefix(1)
                
                return "\(prefixOne)\(prefixTwo)"
                
            }
            
        } else {
            return "PI"
        }
    }
}

extension UILabel {
    var actualNumberOfLines: Int {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0, index = 0, lineRange = NSMakeRange(0, 1)
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}

//REMOVE DUPLICATES FROM AN ARRAY
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

//MARK: - STRING EXTENSION FOR STRING HEIGHTS AND WIDTHS
extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}


//MARK: - GRAB SPECIFIC WORDS FROM A STRING
extension StringProtocol {
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}

//MARK: - Firebase helpers
class AuthCheckUsers : NSObject {
    
    static func authCheck(completion : @escaping (_ hasAuth : Bool)->()) {
        
        if let user_uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("all_users").child(user_uid).child("users_firebase_uid")
            
            ref.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
                
                if snap.exists() {
                    print("SNappy", snap.value as? String ?? "none-here")
                    completion(true)
                } else {
                    completion(false)
                }
                
            } withCancel: { (error) in
                completion(false)
            }
        } else {
            completion(false)
        }
    }
}

extension  CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}

extension UIView {
    func translate(_ translation: CGPoint) {
        let destination = center + translation
        let minX = frame.width/2
        let minY = frame.height/2
        let maxX = superview!.frame.width-minX
        let maxY = superview!.frame.height-minY
        center = CGPoint(
            x: min(maxX, max(minX, destination.x)),
            y: min(maxY - 80 ,max(minY + 30, destination.y)))
    }
}

//MARK: - Firebase helpers
class ProfileImageFetch : NSObject {
    
    static func image(completion : @escaping (_ icComplete : Bool, _ imageUrl : String)->()) {
        
        if let user_uid = Auth.auth().currentUser?.uid {
            
            let ref = Database.database().reference().child("all_users").child(user_uid).child("profile_image")
            
            ref.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
                
                ref.keepSynced(true)
                
                if snap.exists() {
                    
                    let image_url = snap.value as? String ?? "nil"
                    
                    completion(true, image_url)
                } else {
                    completion(false, "nil")
                    return
                }
                
            } withCancel: { (error) in
                
                completion(false, "nil")
                
            }
            
        } else {
            
            completion(false, "nil")
            
        }
    }
}

class ConvertSecondsToHMS : NSObject {
    
    static func secondsToHoursMinutesSeconds(seconds : Int) -> String {
        
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        var secondsString : String = ""
        var minutesString : String = ""
        var hoursString : String = ""
        
        //SECONDS
        if seconds < 10 {
            secondsString = "0\(seconds)"
        } else {
            secondsString = "\(seconds)"
        }
        
        //MINUTES
        if hours < 10 {
            hoursString = "0\(hours)"
        } else {
            hoursString = "\(hours)"
        }
        
        //HOURS
        if minutes < 10 {
            minutesString = "0\(minutes)"
        } else {
            minutesString = "\(minutes)"
        }
        
        if hours < 1 {
            let timeString = "\(minutesString):\(secondsString)"
            return timeString
        } else {
            let timeString = "\(hoursString):\(minutesString):\(secondsString)"
            return timeString
        }
    }
}

//MARK: - Firebase helpers
class ProfileImageFetchWithUID : NSObject {
    
    static func image(passedUID : String, completion : @escaping (_ icComplete : Bool, _ imageUrl : String, _ profileHexColor : String, _ usersName : String)->()) {
        
        if Auth.auth().currentUser?.uid != nil {
            
            let ref = Database.database().reference().child("all_users").child(passedUID)
            
            ref.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
                
                if snap.exists() {
                    
                    ref.keepSynced(true)
                    
                    let JSON = snap.value as? [String : Any] ?? ["":""]
                    
                    let profileImage = JSON["profile_image"] as? String ?? "nil"
                    let profileHexColor = JSON["profile_hex_color"] as? String ?? "nil"
                    let usersName = JSON["users_name"] as? String ?? "nil"
                    
                    completion(true, profileImage, profileHexColor, usersName)
                    
                } else {
                    completion(false, "false", "false", "false")
                    return
                }
                
            } withCancel: { (error) in
                
                completion(false, "false", "false", "false")
                
            }
            
        } else {
            
            completion(false, "false", "false", "false")
            
        }
    }
}

class GrabUsersFullNameWithUUID : NSObject {
    
    static func name(passedUid : String, completion : @escaping(_ isComplete : Bool, _ name : String)->()) {
        
        let database = Database.database().reference()
        
        if Auth.auth().currentUser?.uid != nil {
            
            let ref = database.child("all_users").child(passedUid).child("users_name")
            
            ref.observeSingleEvent(of: .value) { (snap : DataSnapshot) in
                
                ref.keepSynced(true)
                
                if snap.exists() {
                    
                    let name = snap.value as? String ?? ""
                    completion(true, name)
                }
                
            }
        } else {
            completion(false, "")
        }
    }
}

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text!))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font as Any, range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

class GrabUsersFullName : NSObject {
    
    static func name() -> String? {
        
        if Auth.auth().currentUser?.uid != nil {
            
            let usersName = Auth.auth().currentUser?.displayName
            
            return usersName
            
        } else {
            return "nil"
        }
    }
}

extension UILabel {
    
    func wordColoring (fullText : String , changeText : [String], changeTextTwo : [String], colorOne : UIColor, colorTwo : UIColor, fontOne : String, fontTwo : String, sizeOne : CGFloat, sizeTwo : CGFloat) {
        
        print("Change text is: \(changeText)")
        
        let strNumber: NSString = fullText as NSString
        
        var range = NSRange()
        
        var attribute = NSMutableAttributedString()
        
        attribute = NSMutableAttributedString.init(string: fullText)
        
        for i in changeText {
            
            range = (strNumber).range(of: i)
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: colorOne , range: range)
            
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontOne, size: sizeOne)!, range: range)
            
        }
        
        for orange in changeTextTwo {
            
            range = (strNumber).range(of: orange)
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: colorTwo , range: range)
            
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: fontTwo, size: sizeTwo)!, range: range)
            
        }
        
        self.attributedText = attribute
        
    }
}

extension UIImageView {
    
    func loadImageGeneralUse(_ urlString: String, completion : @escaping (_ isComplete : Bool)->()) {
        
        self.image = UIImage()
        
        guard let url = URL(string: urlString) else {return}
        
        self.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground]) { (image, error, imageCacheType, imageUrl) in
            
            if error != nil {
                print("failed load")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

// CALCULATES SIZE FOR CELL IN COLLECTIONVIEWS - USED IN THE COMMENTS CONTROLLER
public func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// CALCULATES SIZE FOR CELL IN COLLECTIONVIEWS - USED IN THE COMMENTS CONTROLLER
public func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

enum PhotoSelectionPath {
    
    case fromOnboarding
    case fromSettings
}


enum OnboardingPath {
    
    case fromLogin
    case fromRegistration
}


enum ChatEntryPath {
    
    case fromMessagesController
    case fromAddFriendsController
}

//Example usage(The 0x is a defined prefix, the hex value comes after): var customColorYellow = UIColor(hex: 0xFECF41)
extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
    }
}

extension UIDevice {
    static func vibrateLight() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

extension UIDevice {
    static func vibrateMedium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

extension UIDevice {
    static func vibrateHeavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}

class EnvironemntModeHelper : NSObject {
    
    static func isCurrentEnvironmentDebug() -> Bool {
        
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}

class FontLister : NSObject {
    
    static func enumerateFonts()
    {
        for fontFamily in UIFont.familyNames
        {
            print("Font family name = \(fontFamily as String)")
            for fontName in UIFont.fontNames(forFamilyName: fontFamily as String)
            
            {
                print("- Font name = \(fontName)")
            }
        }
    }
}

//Sets tappable hyper-links in (NSMutableAttributedString)'s Strings - *SPECIFICALLY FOR UITEXTVIEWS ONLY*
extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        
        if foundRange.location != NSNotFound {
          
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)

            print("found the link NSMutableAttributedString helper")
            return true
        }
        print("can not find the link NSMutableAttributedString helper")
        return false
    }
}

//REMOVES THE FIRST CHARACTER OF A STRING BY CHOMPING :)
extension String {
    var chomp : String {
        mutating get {
            self.remove(at: self.startIndex)
            return self
        }
    }
}

//HEX Color value
extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
        
    }
}

//Money currency conversion
extension Double {
    func formatnumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .currency
        return formater.string(from: NSNumber(value: self))!
    }
}


//Money currency conversion
extension Double {
    func formatnumberForGraph() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .currencyAccounting
        return formater.string(from: NSNumber(value: self))!
    }
}

extension Float {
    func formatnumber() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .currency
        return formater.string(from: NSNumber(value: self))!
    }
}

//Radian Conversions - 3D
extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

//Reverse conversions - 3d
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

//removes all white spaces before, after and in between from a string
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

//FILTTERS STRINGS FOR NUMERIC VALUES ONLY
extension String {
    var numbers: String {
        return String(filter { "0"..."9" ~= $0 })
    }
}

//OPENS URLS AS STRINGS
extension UIView {
    
    func openUrl(passedUrlString : String) {
        
        guard let developerWebsiteUrl = URL(string: passedUrlString) else {return}
        
        if UIApplication.shared.canOpenURL(developerWebsiteUrl) {
            
            return UIApplication.shared.open(developerWebsiteUrl, options: [:], completionHandler: nil)
            
        }
        
    }
    
}

class AlertControllerCompletion : NSObject {
    
    static func handleAlertWithCompletion(title : String, message : String, completion : @escaping (_ isFinished : Bool)->()) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOne = UIAlertAction(title: "Ok", style: .default) { (action) in
            completion(true)
        }
        
        alertController.addAction(actionOne)
        
        if let topViewController = UIApplication.getTopMostViewController() {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: - TOP VIEW CONTROLLER METHOD
extension UIApplication {
    
    class func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}

//24 HOUR TIME TO CHECK FOR DARK MODE - DARKEN BETWEEN THE HOURS OF 6PM THROUGH 6AM
extension UIView {
    
    func isNightTimeModeEnabled() -> Bool {
        
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        
        switch currentHour {
        
        case 6..<18 : return false
            
        default : return true
            
        }
    }
}


//ADDS THE SUFFIX FOR THE DAY OF THE MONTH EX: PASS 1 AND RETURNS 1ST AS A STRING OR 3 AND RETURNS 3RD AS A STRING
extension Int {
    
    func dayOfWeekSuffix(passedDayAsInt : Int) -> String {
        
        switch passedDayAsInt {
        
        case 1 :
            return "\(passedDayAsInt)st"
        case 2 :
            return "\(passedDayAsInt)nd"
        case 3 :
            return "\(passedDayAsInt)rd"
        case 4 :
            return "\(passedDayAsInt)th"
        case 5 :
            return "\(passedDayAsInt)th"
        case 6 :
            return "\(passedDayAsInt)th"
        case 7 :
            return "\(passedDayAsInt)th"
        case 8 :
            return "\(passedDayAsInt)th"
        case 9 :
            return "\(passedDayAsInt)th"
        case 10 :
            return "\(passedDayAsInt)th"
        case 11 :
            return "\(passedDayAsInt)th"
        case 12 :
            return "\(passedDayAsInt)th"
        case 13 :
            return "\(passedDayAsInt)th"
        case 14 :
            return "\(passedDayAsInt)th"
        case 15 :
            return "\(passedDayAsInt)th"
        case 16 :
            return "\(passedDayAsInt)th"
        case 17 :
            return "\(passedDayAsInt)th"
        case 18 :
            return "\(passedDayAsInt)th"
        case 19 :
            return "\(passedDayAsInt)th"
        case 20 :
            return "\(passedDayAsInt)th"
        case 21 :
            return "\(passedDayAsInt)st"
        case 22 :
            return "\(passedDayAsInt)nd"
        case 23 :
            return "\(passedDayAsInt)rd"
        case 24 :
            return "\(passedDayAsInt)th"
        case 25 :
            return "\(passedDayAsInt)th"
        case 26 :
            return "\(passedDayAsInt)th"
        case 27 :
            return "\(passedDayAsInt)th"
        case 28 :
            return "\(passedDayAsInt)th"
        case 29 :
            return "\(passedDayAsInt)th"
        case 30 :
            return "\(passedDayAsInt)th"
        case 31 :
            return "\(passedDayAsInt)st"
            
        default :
            
            return "\(passedDayAsInt)th"
        }
        
    }
    
}

//EXTENSION FOR MAKING A GRADIENT - JUST ADD COLOR ONE AND COLOR TWO AND APPLY IT TO THE UIVIEW
extension UIView {
    
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor) {
        
        clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        print(gradientLayer.frame)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}

extension Int {
    
    func square() -> Int {
        
        return self * self
    }
}

extension String {
    
    var twoFractionDigits: String {
        
        let styler = NumberFormatter()
        styler.minimumFractionDigits = 2
        styler.maximumFractionDigits = 2
        styler.numberStyle = .currency
        let converter = NumberFormatter()
        converter.decimalSeparator = "."
        
        if let result = converter.number(from: self) {
            return styler.string(for: result) ?? ""
        }
        
        return ""
    }
}

class PulseLayerAnimation {
    
    //PULSES ANY CALAYER
    static func pulseProperties(pulseLayer : CAShapeLayer, toValue : CGFloat, duration : Double, repeatCount : Float) {
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = toValue
        animation.autoreverses = true
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = false
        
        pulseLayer.add(animation, forKey: "arbitrary")
        
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension Date {
    
    func timePassed(numericDates: Bool) -> String {
        
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        
        nameFormatter.dateFormat = "EEEE"
        
        let secondsBetween: TimeInterval = currentDate.timeIntervalSince(self as Date)
        let numberOfDays = Int(secondsBetween / 86400)
        
        let currentWeekDayName = nameFormatter.string(from: currentDate)
        let passedWeekDayName = nameFormatter.string(from: self)
        
        //CHECK FOR TODAY - GIVE EXACT TIME
        if currentWeekDayName == passedWeekDayName {
            
            nameFormatter.amSymbol = "am"
            nameFormatter.pmSymbol = "pm"
            nameFormatter.dateFormat = "hh:mm a"
            let name = nameFormatter.string(from: self)
            return name
            
            //CHECK FOR THE LAST WEEK - GIVE WEEK DAY NAME
        } else if numberOfDays <= 7 {
            
            return passedWeekDayName
            
            //IF BEYOND A WEEK, GIVE THE FULL DATE
        } else {
            nameFormatter.dateFormat = "MMM dd, yyyy"
            let name = nameFormatter.string(from: self)
            return name
        }
    }
}

extension Date {
    
    func getTimeAsDouble() -> String {
        
        let calendar = Calendar.current,
            components = calendar.dateComponents([.day, .month, .year], from: self),
            year = components.year ?? 0,
            month = components.month ?? 0,
            day = components.day ?? 0
        
        var stringDay = String(day)
        var stringmonth = String(month)
        
        if stringDay.count == 1 {
            stringDay = "0\(stringDay)"
        }
        
        if stringmonth.count == 1 {
            stringmonth = "0\(stringmonth)"
        }
        
        let stringerDate = "\(year)\(stringmonth)\(stringDay)"
        
        return stringerDate
    }
}

extension Date {
    
    func collectionDate() -> String {
        
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        
        nameFormatter.dateFormat = "EEEE"
        
        let secondsBetween: TimeInterval = currentDate.timeIntervalSince(self as Date)
        let numberOfDays = Int(secondsBetween / 86400)
        
        let passedWeekDayName = nameFormatter.string(from: self)
        let currentWeekDayName = nameFormatter.string(from: currentDate)
        
        
        if currentWeekDayName == passedWeekDayName && numberOfDays == 0 {
            
            return "Today"
            
        } else if numberOfDays <= 7 {
            
            return passedWeekDayName
            
            //IF BEYOND A WEEK, GIVE THE FULL DATE
        } else {
            
            nameFormatter.dateFormat = "MMM dd, yyyy"
            let name = nameFormatter.string(from: self)
            return name
        }
    }
}

extension Date {
    
    func getTimeFromDate() -> String {
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.amSymbol = "am"
        timeFormatter.pmSymbol = "pm"
        timeFormatter.dateFormat = "hh:mm a"
        let time = timeFormatter.string(from: self)
        return time
        
    }
}

extension Date {
    
    func timePassedFullFormat(numericDates: Bool) -> String {
        
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        
        nameFormatter.dateFormat = "EEEE"
        
        let secondsBetween: TimeInterval = currentDate.timeIntervalSince(self as Date)
        let numberOfDays = Int(secondsBetween / 86400)
        
        let currentWeekDayName = nameFormatter.string(from: currentDate)
        let passedWeekDayName = nameFormatter.string(from: self)
        
        //CHECK FOR TODAY - GIVE EXACT TIME
        if currentWeekDayName == passedWeekDayName {
            
            nameFormatter.amSymbol = "am"
            nameFormatter.pmSymbol = "pm"
            nameFormatter.dateFormat = "hh:mm a"
            let name = nameFormatter.string(from: self)
            return name
            
            //CHECK FOR THE LAST WEEK - GIVE WEEK DAY NAME
        } else if numberOfDays <= 7 {
            
            return passedWeekDayName
            
            //IF BEYOND A WEEK, GIVE THE FULL DATE
        } else {
            nameFormatter.dateFormat = "MMM dd, yyyy"
            let name = nameFormatter.string(from: self)
            return name
        }
    }
}

class PhoneNumberFormatter : NSObject {
    
    static func formattedNumber(number: String, count : Int) -> String {
        
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var mask : String = ""
        //TAKES INTO ACCOUNT THE AREA CODE FOR FORMATTING 10 - NO AREA CODE AND 11 - IS AN AREA CODE
        if count == 10 {
            mask = "XXX-XXX-XXXX"
        } else if count == 11 {
            mask = "X-XXX-XXX-XXXX"
        } else {
            mask = "XXX-XXX-XXXX"
        }
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        
        return result
    }
    
}


