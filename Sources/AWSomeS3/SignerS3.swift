//
//  SignerS3.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Vapor

public struct SignerS3 {
    let configs: ConfigS3
    let itemKey: String
    let method: HTTPMethod
    let now: Date
    let bodyHash: String
    let LF = "\u{0a}"
    
    public init(_ method: HTTPMethod, item itemKey: String, with configS3: ConfigS3, bodyHash: String) {
        self.configs = configS3
        self.method = method
        self.itemKey = itemKey
        self.bodyHash = bodyHash
        self.now = Date()
    }
    
    public func getHeaders() -> HTTPHeaders {
        return HTTPHeaders([
            ("accept", "application/json"),
            ("host", self.configs.url.replacingOccurrences(of: "https://", with: "")),
            ("x-amz-date", self.now.xAmzDate(full: true))
        ])
    }
    
    private func buildCanonical() -> String {
        var headers = ""
        self.getHeaders().forEach { (name: String, value: String) in
            headers += "\(name):\(value)\(self.LF)"
        }
        var headerList = ""
        self.getHeaders().forEach { (name: String, value: String) in
            headerList += "\(name);"
        }
        headerList = String(headerList.dropLast())
        return "\(self.method.string)\(self.LF)/\(self.configs.bucketName)/\(self.itemKey)\(self.LF)\(self.LF)\(headers)\(self.LF)\(headerList)\(self.LF)\(self.bodyHash)"
    }
    
    private func credentials() -> String {
        return "\(self.now.xAmzDate(full: false))/\(self.configs.region)/\(self.configs.service)/aws4_request"
    }
    
    private func generateKey() -> String {
        
        let key1st = "AWS4" + self.configs.secretKey
        let key2nd = HMACWorker(key: key1st, data: self.now.xAmzDate(full: false)).asKey()
        let key3rd = HMACWorker(symmKey: key2nd, data: self.configs.region).asKey()
        let key4th = HMACWorker(symmKey: key3rd, data: self.configs.service).asKey()
        let key5th = HMACWorker(symmKey: key4th, data: "aws4_request").asKey()
        let loggr = Logger(label: "s4")
        loggr.info(Logger.Message(stringLiteral: self.generateString()))
        let key6th = HMACWorker(symmKey: key5th, data: self.generateString())
        loggr.info(Logger.Message(stringLiteral: key6th.message.hex))
        
        return "Signature=\(key6th.message.hex)"
    }
    
    private func generateString() -> String {
        var canonHash = SHA256()
        canonHash.update(data: buildCanonical().data(using: .utf8)!)
        let hashedReq = canonHash.finalize().hex
        return "AWS4-HMAC-SHA256\(self.LF)\(self.now.xAmzDate(full: true))\(self.LF)\(self.credentials())\(self.LF)\(hashedReq)"
    }
    
    public func getURI() -> URI {
        return URI(string: "\(configs.url)/\(configs.bucketName)/\(self.itemKey)")
    }
    
    public func authorization() -> String {
        let loggar = Logger(label: "signer")
        loggar.info(Logger.Message(stringLiteral: self.buildCanonical()))
        
        var headerList = ""
        self.getHeaders().forEach { (name: String, value: String) in
            headerList += "\(name);"
        }
        headerList = String(headerList.dropLast())
        
        let part1 = "AWS4-HMAC-SHA256"
        let part2 = "Credential=\(self.configs.accessKey)/\(self.credentials()),"
        let part3 = "SignedHeaders=\(headerList),"
        let part4 = self.generateKey()
        
        return "\(part1) \(part2) \(part3) \(part4)"
    }
}

