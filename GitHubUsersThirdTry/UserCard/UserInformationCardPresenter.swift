import Foundation
import UIKit

class UserInformationCardPresenter{
    
    var selectedUser:((String)->Void)?
    
    var view: UserInformationCardView?
    var users: [User] = []
    var userLogin: String
    var userInfo: User?
    
    
    init(view: UserInformationCardView,
         userLogin: String) {
        self.view = view
        self.userLogin = userLogin
    }
    
    func setupUI(){
        self.view?.configureTitle(title: self.userLogin)
        self.view?.setupCollectionView()
        refreshUsers()
        refreshUser()
    }
    
    var numberCell: Int{
        return users.count
    }
    
    func refreshUser(){
        let apiClient = APIClient<User>()
        let endPoint = UserEndPoint.users
        
        apiClient.createRequest(url: "\(endPoint.baseUrl)\(endPoint.endPoint)/\(self.userLogin)") { [self] user, error in
            guard let user = user, error == nil else {
                self.handleError(error: String(describing: error))
                return
            }
            
            self.handleSuccesLoadUser(user: user)
        }
    }
    
    func handleSuccesLoadUser(user: User){
        self.userInfo = user
        DispatchQueue.main.async {
            self.view?.configureUserCard(userInfo: user)
        }
        loadUserAvatar()
    }
    
    func loadUserAvatar(){
        let apiClient = APIClient<Data>()
        guard let avatarUrl = self.userInfo?.avatar_url else {
            return
        }
        apiClient.loadImage(url: avatarUrl) { data, error in
            guard let data = data, error == nil else {
                return
            }
            self.userInfo?.imageData = data
            DispatchQueue.main.async{
                self.view?.configureUserAvatar(userAvatar: data)
            }
        }
    }
    
    func refreshUsers(){
        let apiClient = APIClient<[User]>()
        let endPoint = UserEndPoint.users
        
        apiClient.createRequest(url: "\(endPoint.baseUrl)\(endPoint.endPoint)/\(userLogin)/followers") { [self] users, error in
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
        let semaphore = DispatchSemaphore(value: 0)
        self.users = users

        DispatchQueue.main.async {
            self.view?.refreshCollectionView()
            semaphore.signal()
        }
        
        semaphore.wait()
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
    
    func configure(cell: UserCell, indexPath: IndexPath){
        let user = users[indexPath.row]
        cell.loginLabel.text = user.login
        if let countFolowers = user.folowers, let countRepos = user.public_repos {
            cell.countSubscribersLabel.text = "\(countFolowers) подписчиков"
            cell.countRepositoriesLabel.text = "\(countRepos) репозиториев"
        }
        if let imageData = user.imageData{
            cell.imageView.image = UIImage(data: imageData)
        }
        
    }
    
    func selectedCell(index: Int){
        print(users[index].login)
        selectedUser!(users[index].login)
    }
    
}
