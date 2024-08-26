import Foundation
import UIKit

class UsersPresenter{
    
    var view: UsersView?
    var users: [User] = []
    var selectedUser:((String)->Void)?
    
    
    init(view: UsersView) {
        self.view = view
    }
    
    func setupUI(){
        refreshUsers()
    }
    
    var numberCell: Int{
        return users.count
    }
    
    func refreshUsers(){
        let apiClient = APIClient<[User]>()
        let endPoint = UserEndPoint.users
        
        apiClient.createRequest(url: "\(endPoint.baseUrl)\(endPoint.endPoint)") { [self] users, error in
            guard let users = users, error == nil else {
                self.handleError(error: String(describing: error))
                return
            }
            self.handleSuccesLoadUsers(users: users)
        }
    }
    
    func loadAddInformation(usersLogin: [String]){
        let apiClient = APIClient<FullUserInformation>()
        for user in usersLogin{
            let endPoint = UserEndPoint.users
            apiClient.createRequest(url: "\(endPoint.baseUrl)users/\(user)") { addInformation, error in
                guard let user = addInformation, error == nil else {
                    self.handleError(error: String(describing: error))
                    return
                }
                self.handleSuccesLoadAddInformation(user: user)
            }
        }
    }
    
    func loadAvatars(urls: [String]){
        let apiClient = APIClient<Int>()
        for (index, imageUrl) in urls.enumerated(){
            apiClient.loadImage(url: imageUrl) { data, error in
                guard let data = data, error == nil else {
                    return
                }
                self.users[index].imageData = data
                DispatchQueue.main.async{
                    self.view?.configureAvatars(indexCell: index, userInformation: self.users[index])
                }
            }
        }
    }
    
    func handleError(error: String){
        
    }
    
    
    
    func handleSuccesLoadUsers(users: [User]){
        self.users = users

        DispatchQueue.main.async {
            self.view?.refreshCollectionView()
        }
        self.loadAddInformation(usersLogin: users.map{$0.login})
        self.loadAvatars(urls: users.map({$0.avatar_url}))
    }
    
    func handleSuccesLoadAddInformation(user: FullUserInformation){
        if let index = self.users.firstIndex(where: {$0.id == user.id}){
            users[index].folowers = user.followers
            users[index].public_repos = user.public_repos
            DispatchQueue.main.async{
                self.view?.configureCell(indexCell: index, userInformation: self.users[index])
            }
        }
    }
    
    func getUserData(row: Int) -> User?{
        guard users.count > row else { return nil}
        return users[row]
    }
    
    func selectedCell(index: Int){
        print(users[index].login)
        selectedUser!(users[index].login)
    }
}
