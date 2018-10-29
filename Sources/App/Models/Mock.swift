//
//  Mock.swift
//  App
//
//  Created by Eduardo González on 29/10/2018.
//

import Foundation
import Vapor

struct Mock: Mockable {
    let method: HTTPMethod
    let path: String
    let code: Int
    let payload: Data?
    let headers: [String: String]?
    
    init<T: Codable>(method: HTTPMethod, path: String, code: Int, model: T, headers: [String: String]? = nil) {
        self.method = method
        self.path = path
        self.code = code
        self.payload = try? JSONEncoder().encode(model)
        self.headers = headers
    }
    
    init(method: HTTPMethod, path: String, code: Int, file: String, headers: [String: String]? = nil) {
        self.method = method
        self.path = path
        self.code = code
        self.payload = dataFrom(file: file)
        self.headers = headers
    }
    init(method: HTTPMethod, path: String, code: Int, headers: [String: String]? = nil) {
        self.method = method
        self.path = path
        self.code = code
        self.payload = nil
        self.headers = headers
    }
    
}

private func dataFrom(file: String) -> Data? {
    let path = DirectoryConfig.detect().workDir + "Public/" + file
    return try? Data(contentsOf: URL(fileURLWithPath: path))
}
