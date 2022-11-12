//
//  GetToken.swift
//  Phod
//
//  Created by 鳥山彰仁 on 2022/11/12.
//

import Foundation

struct GetToken: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
