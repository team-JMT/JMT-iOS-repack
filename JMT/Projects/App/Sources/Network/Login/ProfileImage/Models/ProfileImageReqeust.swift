//
//  ProfileImageReqeust.swift
//  App
//
//  Created by PKW on 2024/01/16.
//

import Foundation

struct ProfileImageReqeust: Encodable {
    let imageStr: String
}

struct CurrentLoginInfoRequest: Encodable {
    let token: String
}
