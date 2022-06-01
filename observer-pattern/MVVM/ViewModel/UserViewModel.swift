//
//  UserViewModel.swift
//  observer-pattern
//
//  Created by Victor Roldan on 30/05/22.
//

import Foundation
import Combine

class UserViewModel{
    var userList : [UserModel] = []
    var reloadData = PassthroughSubject<Void, Error>()
    @Published var isLoading : Bool?
    
    func getUsers(){
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.userList = UserModel.getUsers()
            self.reloadData.send()
            self.isLoading = false
        }
    }
}
