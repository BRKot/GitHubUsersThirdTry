import Foundation


enum UserEndPoint{
    case users
    case user
    case subscribers
    case repositories
    
    var baseUrl: String{
        return "https://api.github.com/"
    }
    
    var endPoint: String{
        switch self{
        case .users:
            return "users"
        case .user:
            return ""
        case .subscribers:
            return ""
        case .repositories:
            return ""
        }
    }
    
}

class UserServiceImpl{
    
}
