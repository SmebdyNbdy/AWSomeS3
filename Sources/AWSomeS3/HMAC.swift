//
//  HMAC.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Crypto

struct HMACWorker {
    let message: HMAC<SHA256>.MAC
    
    init(key: String, data: String) {
        let symmKey = SymmetricKey(stringKey: key)
        let messageData = data.data(using: .utf8)!
        
        var hmac = HMAC<SHA256>.init(key: symmKey)
        hmac.update(data: messageData)
        self.message = hmac.finalize()
    }
    
    func string() -> String {
        return self.message.description.replacingOccurrences(of: "HMAC with SHA256: ", with: "")
    }
}
