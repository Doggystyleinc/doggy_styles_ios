//
//  ShareExtension.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/19/21.
//

import Foundation
import Firebase
import AudioToolbox

class ShareFunctionHelper : NSObject {
    
    static func handleShareSheet(passedURLString : String, passedView : UIView, completion : @escaping(_ passingView : UIActivityViewController)->()) {
     
        var videoActivityItem : NSURL?
        
        var activityViewController : UIActivityViewController?
        
        if let url = NSURL(string: passedURLString) {
            
            videoActivityItem = url
            
            activityViewController = UIActivityViewController(
                activityItems: [videoActivityItem as Any], applicationActivities: nil)
          
            activityViewController?.popoverPresentationController?.sourceView = (passedView)
            
            activityViewController?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            activityViewController?.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            activityViewController?.excludedActivityTypes = [
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]
            
            if let activity = activityViewController {
                completion(activity)
            }
        }
    }
}
