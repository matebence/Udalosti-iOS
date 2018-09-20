//
//  Reachability.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import SystemConfiguration

public class Pripojenie {
    
    class func spojenieExistuje() -> Bool {
        print("Metoda spojenieExistuje bola vykonana")

        var adresa = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        adresa.sin_len = UInt8(MemoryLayout.size(ofValue: adresa))
        adresa.sin_family = sa_family_t(AF_INET)
        
        let pripojenie = withUnsafePointer(to: &adresa) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var moznosti: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(pripojenie!, &moznosti) == false {
            return false
        }
        
        let pripojenieExistuje = (moznosti.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let stavSpojenia = (moznosti.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let status = (pripojenieExistuje && !stavSpojenia)
        
        return status
    }
}
