//
//  GrabDeviceID.swift
//  Project Doggystyle iOS
//
//  Created by Stanley Miller on 6/21/21.
//

import UIKit
import DeviceCheck

class GrabDeviceID : NSObject {
   
  static func getID(completion: @escaping (_ isSuccess : Bool, _ deviceID : String)->()) {
     
    DCDevice.current.generateToken { (data, error) in
      if error != nil {
        completion(false, "device_id")
        return
      }
       
      guard let data = data else {
        completion(false, "device_id")
        return
      }
       
      let token = data.base64EncodedString()
      completion(true, token)
      return
    }
  }
}
