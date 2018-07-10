//
//  JSONFileMock.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

struct JSONFileMock: Mockable {
    
    let method: HTTPMethod
    let path: String
    let file: String
    
    func handleResponse(_ req: Request) throws -> Future<Response> {
        return try req.streamFile(at: DirectoryConfig.detect().workDir + "Public/" + self.file)
    }
}
