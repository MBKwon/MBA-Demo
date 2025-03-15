//
//  APIOpenLibrary.swift
//  MBA-book-browser
//
//  Created by Moonbeom KWON on 2/25/25.
//

import Foundation
import MBAkit_url_session

class APIOpenLibrary {
    
    // document : "https://developers.google.com/books/docs/v1/using?hl=en#PerformingSearch"
    private lazy var session: API = {
        API(with: .init(scheme: "https",
                        host: "www.googleapis.com"))
    }()
    
    enum APIType: APIPath {
        
        case search(text: String, startIndex: Int?)
        
        var method: API.HTTPMethod {
            switch self {
            case .search:
                return .get
            }
        }
        
        var pathString: String {
            switch self {
            case .search:
                return "/books/v1/volumes"
            }
        }
        
        var parameters: [String: String]? {
            switch self {
            case .search(let text, let startIndex):
                var paramDic = [
                    "q": text,
                    "maxResults": "40"
                ]
                if let startIndex = startIndex {
                    paramDic["startIndex"] = "\(startIndex)"
                }
                return paramDic
            }
        }
    }
}
 
extension APIOpenLibrary {
    func request(with type: APIType) async -> Result<ResponseType, Error> {
        return await session.request(path: type, method: type.method)
    }
}

