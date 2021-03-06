//
//  ConfigS3.swift
//  
//
//  Created by Alex Gavrikov on 2/16/21.
//

import Vapor

public struct ConfigS3 {
    var host: String
    var service: String
    var region: String
    var accessKey: String
    var secretKey: String
    public var bucketName: String
    
    public init(host: String = "storage.yandexcloud.net", service: String = "s3", region: String = "ru-central1", accessKey: String, secretKey: String, bucketName: String) {
        self.host = host
        self.service = service
        self.region = region
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.bucketName = bucketName
    }
    
    var url: String {
        get {
            return "https://\(self.host)"
        }
    }
}

struct ConfigS3Key: StorageKey {
    typealias Value = ConfigS3
}

extension Application {
    public var configS3: ConfigS3 {
        get {
            self.storage[ConfigS3Key.self] ?? .init(accessKey: "", secretKey: "", bucketName: "")
        }
        set {
            self.storage[ConfigS3Key.self] = newValue
        }
    }
}
