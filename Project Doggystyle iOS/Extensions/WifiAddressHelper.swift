//
//  WifiAddressHelper.swift
//  Project Doggystyle iOS
//
//  Created by Charlie Arcodia on 10/27/21.
//

/*
 UASGE EXAMPLE FOR EXTRACTING THE IP ADDRESS OF THE USERS DEVICE
 if let addr = getWiFiAddress() {
     print(addr)
 } else {
     print("No WiFi address")
 }
 */

import Foundation
import UIKit

func getWiFiAddress() -> String? {
    
    var address : String?

    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }

    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        
        let interface = ifptr.pointee

        let addrFamily = interface.ifa_addr.pointee.sa_family
        
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

            let name = String(cString: interface.ifa_name)
            if  name == "en0" {

                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                
                address = String(cString: hostname)
                
            }
        }
    }
    
    freeifaddrs(ifaddr)

    return address
}
