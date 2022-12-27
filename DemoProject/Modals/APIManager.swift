//
//  APIManager.swift
//  DemoProject
//
//  Created by Ankush Sharma on 28/03/22.
//

import Foundation
import UIKit

protocol UserDetailService {
    func fetchUserDetailAPICall(compeletion: @escaping (Result<UserDetail, Error>) -> Void,username: String)
}

protocol FetchUserService {
    func fetchUserListAPICall(compeletion: @escaping (Result<[UserCore], Error>) -> Void,since: Int)
}

class APIManager: FetchUserService, UserDetailService {
    
    func fetchUserListAPICall (compeletion: @escaping (Result<[UserCore], Error>) -> Void, since: Int) {

        var request = URLRequest(url: URL(string: "https://api.github.com/users?since=\(since)")!)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        
        
        if !ReachabilityManager.isConnectedToNetwork() {
            UtilityFunctions.showAlert(message: "Internet is not available")
            return
        }
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode([UserCore].self, from: data!)
                compeletion(.success(responseModel))
            } catch {
                print("error")
            }
        })

        task.resume()
    }
    
    func fetchUserDetailAPICall (compeletion: @escaping (Result<UserDetail, Error>) -> Void, username: String) {

        var request = URLRequest(url: URL(string: "https://api.github.com/users/\(username)")!)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        
        
        if !ReachabilityManager.isConnectedToNetwork() {
            
            return
        }
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(UserDetail.self, from: data!)
                compeletion(.success(responseModel))
            } catch {
                print("error")
            }
        })

        task.resume()
    }
}
