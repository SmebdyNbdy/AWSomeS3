//
//  RequestS3.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Vapor

public struct RequestS3 {
    let application: Application
    let signerS3: SignerS3
    let configS3: ConfigS3
    
    init(application: Application) {
        self.application = application
        self.configS3 = self.application.configS3
        self.signerS3 = SignerS3(self.configS3)
    }
    
    private func getAmznNow() -> String {
        let now = Date()
        let dF = DateFormatter()
        dF.dateStyle = .short
        dF.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dF.string(from: now)
    }
    
    func getHeaders() -> HTTPHeaders {
        return HTTPHeaders([
            ("Accept", "application/json"),
            ("Host", "storage.yandexcloud.net"),
            ("x-amz-date", getAmznNow()),
            ("connection", "keep-alive"),
            ("Authorization", self.signerS3.authorization())
        ])
    }
}

extension Application {
    public var requestS3: RequestS3 {
        .init(application: self)
    }
}
