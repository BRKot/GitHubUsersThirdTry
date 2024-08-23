//
//  User.swift
//  GitHubUsersThirdTry
//
//  Created by Databriz on 23/08/2024.
//

import Foundation

struct User: Codable{
    let id: Int
    let login: String
    var company: String?
    var name: String?
    var email: String?
    var blog: String?
    var location: String?
    var public_repos: Int?
    var folowers: Int?
    var imageData: Data?
    var bio: String?
    var avatar_url: String
}
