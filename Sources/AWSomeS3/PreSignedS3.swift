//
//  PreSignedS3.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Vapor

extension String {
    var appendLF: String {
        get {
            return self + "\n"
        }
    }
}

public struct PreSignedS3 {
    let configs: ConfigS3
    //let itemKey: String
    let method: HTTPMethod
    var replOccr: String
    let now: Date
    let LF = "\u{0a}"
    var urlComponents: URLComponents
    
    public init(_ method: HTTPMethod, item itemKey: String, with configS3: ConfigS3) {
        self.configs = configS3
        self.method = method
        self.now = Date()
        
        self.urlComponents = URLComponents()
        self.urlComponents.path = "/\(self.configs.bucketName)/\(itemKey)"
        self.urlComponents.host = self.configs.host
        self.replOccr = ""
        self.setParams()
    }
    
    private mutating func setParams() {
        let algorithm = URLQueryItem(name: "X-Amz-Algorithm",
                                     value: "AWS4-HMAC-SHA256")
        let credential = URLQueryItem(name: "X-Amz-Credential",
                                      value: "\(self.configs.accessKey)%2F\(self.now.xAmzDate(full: false))%2F\(self.configs.region)%2F\(self.configs.service)%2Faws4_request")
        let date = URLQueryItem(name: "X-Amz-Date",
                                value: self.now.xAmzDate(full: true))
        let expires = URLQueryItem(name: "X-Amz-Expires",
                                   value: "172800")
        let signedHeaders = URLQueryItem(name: "X-Amz-SignedHeaders",
                                         value: "host")
        
        self.urlComponents.queryItems = [algorithm, credential, date, expires, signedHeaders]
        print(self.urlComponents.query!)
    }
    
    private func buildCanonical() -> String {
        /*return """
            \(self.method.string)
            \(self.urlComponents.path)
            \(self.urlComponents.query!)
            host:\(self.urlComponents.host!)
            
            host
            UNSIGNED-PAYLOAD
            """*/
        let retval = self.method.string.appendLF
            + self.urlComponents.path.appendLF
            + (self.urlComponents.query!).appendLF
            + "host:" + (self.urlComponents.host ?? "").appendLF
            + "".appendLF
            + "host".appendLF
            + "UNSIGNED-PAYLOAD"
        
        print(retval)
        return retval
    }
    
    ///X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=\(self.configs.accessKey)%2F\(self.now.xAmzDate(full: false))%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=\(self.now.xAmzDate(full: true))&X-Amz-Expires=172800&X-Amz-SignedHeaders=host
    
    private func generateKey() -> SymmetricKey {
        let key1st = "AWS4" + self.configs.secretKey
        let key2nd = HMACWorker(key: key1st, data: self.now.xAmzDate(full: false)).asKey()
        let key3rd = HMACWorker(symmKey: key2nd, data: self.configs.region).asKey()
        let key4th = HMACWorker(symmKey: key3rd, data: self.configs.service).asKey()
        let key5th = HMACWorker(symmKey: key4th, data: "aws4_request").asKey()
        
        return key5th
    }
    
    private func SHA256hex(_ string: String) -> String {
        var canonicalHash = SHA256()
        let canonicalReq = Data(string.utf8)
        print(string)
        canonicalHash.update(data: canonicalReq)
        let hash = canonicalHash.finalize()
        print(hash.hexEncodedString())
        return hash.hexEncodedString()
    }
    
    private func generateString() -> String {
        let retval = "AWS4-HMAC-SHA256".appendLF
            + self.now.xAmzDate(full: true).appendLF
            + ("\(self.now.xAmzDate(full: false))/\(self.configs.region)/\(self.configs.service)/aws4_request").appendLF
            + SHA256hex(buildCanonical())
        
        print(retval)
        return retval
    }
    
    public mutating func sign() {
        let signature = HMACWorker(symmKey: self.generateKey(), data: self.generateString())
        let signValue = signature.message.hexEncodedString()
        
        self.urlComponents.queryItems!.append(URLQueryItem(name: "X-Amz-Signature", value: signValue))
    }
    
    public func url() -> String {
        return "https://" + self.urlComponents.host! + self.urlComponents.path + "?\(self.urlComponents.query!)"
    }
}

