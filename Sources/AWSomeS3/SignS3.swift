//
//  SignS3.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Vapor

public struct SignS3 {
    let application: Application
    let configS3: ConfigS3
    
    init(application: Application) {
        self.application = application
        self.configS3 = self.application.configS3
    }
    
    public func url(_ method: HTTPMethod, item: String) -> String {
        var preSign = PreSignedS3(method, item: item, with: self.configS3)
        preSign.sign()
        
        return preSign.url()
    }
}

extension Application {
    public var signS3: SignS3 {
        .init(application: self)
    }
}
