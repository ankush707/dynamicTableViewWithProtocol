//
//  ViewModels.swift
//  DemoProject
//
//  Created by Ankush Sharma on 28/03/22.
//

import Foundation
import UIKit

protocol ListingOutput: AnyObject {
    func updateView(user: [UserCore]?)
}

class ListingViewModel {
    
    weak var listingOutput: ListingOutput?
    private var fetchUserService: FetchUserService
    
    init(fetchUserService: FetchUserService) {
        self.fetchUserService = fetchUserService
    }
    
    func fetchUserList(since: Int) {
        fetchUserService.fetchUserListAPICall(compeletion: { [weak self] result  in
            switch result {
            case .success(let user):
                self?.listingOutput?.updateView(user: user)
            case .failure:
                print("Failure")
                self?.listingOutput?.updateView(user: nil)
            }
        }, since: since)

    }
    
}

//detail View Models

protocol DetailOutput: AnyObject {
    func updateView(user: UserDetail?)
}

class DetailViewModel {
    
    weak var detailOutput: DetailOutput?
    private var userDetailService: UserDetailService
    
    init(userDetailService: UserDetailService) {
        self.userDetailService = userDetailService
    }
    
    func fetchUserDeatil(username: String) {
        userDetailService.fetchUserDetailAPICall(compeletion: { [weak self] result  in
            switch result {
            case .success(let user):
                self?.detailOutput?.updateView(user: user)
            case .failure:
                print("Failure")
                self?.detailOutput?.updateView(user: nil)
            }
        }, username: username)

    }
    
}
