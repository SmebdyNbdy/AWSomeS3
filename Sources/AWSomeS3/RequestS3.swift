//
//  RequestS3.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Vapor

public struct RequestS3 {
    let application: Application
    let configS3: ConfigS3
    
    init(application: Application) {
        self.application = application
        self.configS3 = self.application.configS3
    }
    
    public func sign(_ method: HTTPMethod, item: String, body: Data?) -> HTTPHeaders {
        var signer: SignerS3
        var hasher = SHA256()
        hasher.update(data: body ?? Data())
        let bodyHash = hasher.finalize().hex
        signer = SignerS3(method, item: item, with: self.configS3, bodyHash: bodyHash)
        var myHeaders = signer.getHeaders()
        myHeaders.replaceOrAdd(name: "Connection", value: "keep-alive")
        myHeaders.replaceOrAdd(name: "Authorization", value: signer.authorization())
        return myHeaders
    }
}

extension Application {
    public var requestS3: RequestS3 {
        .init(application: self)
    }
}
