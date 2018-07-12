//
//  JSONFileMock.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

/// A json file mock. You have to include the path of the file that you want to return. It have to be in the `Public/` folder
/// An example of usage:
/// JSONFileMock(method: .GET, path: "api/users", file: "user-mock.json")
struct JSONFileMock: Mockable {
    
    let method: HTTPMethod
    let path: String
    let file: String
    
    func handleResponse(_ req: Request) throws -> Future<Response> {
        return try req.streamFile(at: DirectoryConfig.detect().workDir + "Public/" + self.file)
    }
}
