//
//  NetworkMonitor.swift
//  Project Doggystyle
//
//  Created by Charlie Arcodia on 5/11/21.
//

import Network
import Foundation

//MARK:- SHARED INSTANCE
class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private var status: NWPath.Status = .requiresConnection
    let monitor = NWPathMonitor()
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            //MARK:- SATISFIED
            if path.status == .satisfied {
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("HANDLE_SERVICE_SATISFIED"), object: nil)
                }
                
                //MARK:- UNSATISFIED
            } else if path.status == .unsatisfied {
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("HANDLE_SERVICE_UNSATISIFED"), object: nil)
                }
                
                //MARK:- REQUIRES CONNECTION
            } else if path.status == .requiresConnection {
                
                DispatchQueue.main.async {
                    print("requiresConnection!")
                    NotificationCenter.default.post(name: NSNotification.Name("HANDLE_SERVICE_UNSATISIFED"), object: nil)
                }
                
            } else {
                print("HIT THE ELSE FOR NETWORK")
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
