//
//  ErrorManager.swift
//  App
//
//  Created by José Estela on 10/7/18.
//

import Foundation
import Vapor

struct MockError: Equatable, Hashable {
    
    fileprivate let path: String
    fileprivate let status: HTTPResponseStatus
    fileprivate let timesToFail: Int?
    fileprivate let probabilityToFail: Float?
    
    var hashValue: Int {
        return self.path.hashValue
    }
    
    init(path: String, status: HTTPResponseStatus, every timesToFail: Int) {
        self.path = path
        self.status = status
        self.probabilityToFail = nil
        self.timesToFail = timesToFail
    }
    
    init(path: String, status: HTTPResponseStatus, probability: Float) {
        self.path = path
        self.status = status
        self.timesToFail = nil
        self.probabilityToFail = probability
    }
    
    static func == (lhs: MockError, rhs: MockError) -> Bool {
        return lhs.path == rhs.path
    }
}

class ErrorManager {
    
    // MARK: - Private attributes
    
    private var errors = Set<MockError>()
    private var requestErrored: [MockError: Int] = [:]
    
    // MARK: - Public methods
    
    func register(_ error: MockError) {
        self.errors.insert(error)
    }
    
    func handle(mock: Mockable, on req: Request) throws -> Future<Response> {
        guard let error = self.errors.filter({ $0.path == mock.path }).first else {
            return try mock.handleResponse(req)
        }
        if let probabilityToFail = error.probabilityToFail, probabilityToFail < 1.0 {
            let number = Int(arc4random_uniform(100))
            if number < Int(probabilityToFail * 100) {
                throw Abort(error.status)
            }
        } else if let timesToFail = error.timesToFail, timesToFail > 0 {
            let errored = self.requestErrored[error] ?? 0
            if timesToFail > errored {
                self.requestErrored[error] = errored + 1
            } else {
                self.requestErrored[error] = 0
                throw Abort(error.status)
            }
        }
        return try mock.handleResponse(req)
    }
}
