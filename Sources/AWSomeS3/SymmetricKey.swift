//
//  SymmetricKey.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Crypto

extension SymmetricKey {
    init(stringKey: String) {
        var strKey = stringKey
        strKey.makeContiguousUTF8()
        let data = strKey.data(using: .utf8)!
        self.init(data: data)
    }
}
