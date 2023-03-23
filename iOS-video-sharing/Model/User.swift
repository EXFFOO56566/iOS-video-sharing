//
//  User.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/13.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class User: NSObject {
    
    @objc var fullName: String?
    @objc var email: String?
    @objc var profileImageUrl: String?
    @objc var userName: String?
    @objc var userId: String?
    @objc var phone: String?
    
    @objc var followers: [String: Any]?
    
    @objc var blocked: [String: Any]?

}
