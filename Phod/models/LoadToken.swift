//
//  LoadToken.swift
//  Phod
//
//  Created by 鳥山彰仁 on 2022/11/12.
//


import Foundation
import KeychainAccess

struct LoadToken {
    func loadAccessToken() -> String {
        var token = ""
        let keychain = Keychain(service: Constants.shared.service)
        guard let accessToken = keychain["access_token"] else {
            print("NO TOKEN")
            return ""
        }
        token = accessToken
        return token
    }
}
