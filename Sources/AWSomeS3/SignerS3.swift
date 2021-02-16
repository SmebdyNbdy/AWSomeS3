//
//  SignerS3.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Vapor

public struct SignerS3 {
    let configs: ConfigS3
    
    public init(_ configS3: ConfigS3) {
        self.configs = configS3
    }
    
    private func getNow() -> String{
        let now = Date()
        let dF = DateFormatter()
        dF.dateStyle = .short
        dF.timeStyle = .none
        dF.dateFormat = "yyyyMMdd"
        return dF.string(from: now)
    }
    
    private func signature() -> String {
        let URIenc = URI.init(string: configs.url + configs.bucketName + "/" + "object")
        let _ = URIenc.string
        
        let key1st = "AWS4" + self.configs.secretKey
        let key2nd = HMACWorker(key: key1st, data: getNow()).string()
        let key3rd = HMACWorker(key: key2nd, data: self.configs.region).string()
        let key4th = HMACWorker(key: key3rd, data: self.configs.service).string()
        let key5th = HMACWorker(key: key4th, data: "aws4_request").string()
        
        return "Signature=\(key5th)"
    }
    
    func authorization() -> String {
        let part1 = "AWS4-HMAC-SHA256"
        let part2 = "Credential=\(self.configs.accessKey)/\(getNow())/\(self.configs.region)/\(self.configs.service)/aws4_request,"
        let part3 = "SignedHeaders=accept;host;x-amz-date,"
        let part4 = self.signature()
        
        return "\(part1) \(part2) \(part3) \(part4)"
    }
}

