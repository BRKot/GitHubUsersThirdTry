import Foundation

class APIClient<Response:Codable>{
    
    func createRequest(url: String, completion: @escaping(Response?, String?) -> Void){
        
        let tokenBase64 = "Z2l0aHViX3BhdF8xMUFQV0dNQ1EwNlo0NFRoelNKSDVmX2lKNzY5U3Q0RXNMMWpxaTR2Nk9TTG9Md05va09JZHQ0SVV6YU9mSkZqRkhWRVg0TE5YSEUzc0FTRjFI"
        
        guard let url = URL(string: url) else {
            print("Неверный URL")
            completion(nil, "Неверный URL")
            return
        }
        
        
        var request = URLRequest(url: url)
        
        if let token = tokenBase64.base64Decoded(){
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Создаем URL запрос
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверка на наличие ошибки
            if let error = error {
                completion(nil, String(describing: error))
                return
            }
            
            // Проверка на наличие данных
            guard let data = data else {
                completion(nil, "Данные не пришли")
                return
            }
            
            // Декодируем JSON в структуру [User]
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Response.self, from: data)
                completion(data, nil)
            } catch let jsonError {
                print(jsonError)
                completion(nil, String(describing: jsonError))
            }
        }
        
        
        // Запускаем задачу
        task.resume()
    }
    
    func loadImage(url: String, completion: @escaping(Data?, String?)-> Void){
        
        
        let token = "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"
        
        guard let url = URL(string: url) else {
            print("Неверный URL")
            completion(nil, "Неверный URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Создаем URL запрос
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверка на наличие ошибки
            if let error = error {
                completion(nil, String(describing: error))
                return
            }
            
            // Проверка на наличие данных
            guard let data = data else {
                completion(nil, "Данные не пришли")
                return
            }
            completion(data, nil)
        }
        
        
        // Запускаем задачу
        task.resume()
    }
    
}
