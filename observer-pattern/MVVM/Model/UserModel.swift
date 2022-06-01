//
//  UserModel.swift
//  observer-pattern
//
//  Created by Victor Roldan on 30/05/22.
//

import Foundation

struct UserModel{
    let name : String
    let lastName : String
    
    static func getUsers() -> [UserModel]{
        return (1..<51).map({UserModel(name: "Victor", lastName: "Roldan \($0)")})
    }
}
