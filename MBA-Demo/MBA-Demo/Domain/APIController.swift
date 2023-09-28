//
//  APIController.swift
//  MBA-Demo
//
//  Created by Moonbeom KWON on 2023/09/28.
//

import Foundation
import MBAkit

// JSON-server : https://www.npmjs.com/package/json-server
// json-server --watch db.json --port 8888
enum APIController {
    static let shared = API(with: API.APIDomainInfo(scheme: "http",
                                                    host: "localhost",
                                                    port: 8888))
}

extension APIController {
    enum Path: APIPath {
        case userInfoList

        var pathString: String {
            switch self {
            case .userInfoList:
                return "/user_info"
            }
        }
        
        var parameters: [String: String]? {
            switch self {
            case .userInfoList:
                return nil
            }
        }
    }
}
