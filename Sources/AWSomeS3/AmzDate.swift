//
//  AmzDate.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Foundation

extension Date {
    public func xAmzDate(full: Bool) -> String{
        let dF = DateFormatter()
        dF.dateStyle = .short
        dF.timeZone = TimeZone(secondsFromGMT: 0)
        if (!full) {
            dF.timeStyle = .none
            dF.dateFormat = "yyyyMMdd"
        } else {
            dF.dateStyle = .short
            dF.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        }
        
        return dF.string(from: self)
    }
}
