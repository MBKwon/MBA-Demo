//
//  UserInfo.swift
//  MBA-Demo
//
//  Created by Moonbeom KWON on 2023/09/28.
//

import Foundation

struct UserInfo: Decodable {
    let name: String
    let age: Int
    
    enum CodingKeys: CodingKey {
        case name
        case age
    }
}
