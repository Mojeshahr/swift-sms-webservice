import Foundation

struct StatusByUserTraceIdRequest: Codable {
    let ApiKey: String
    let UserTraceIds: [String]
}

func statusByUserTraceId(userTraceIds: [String], completion: @escaping (Result<String, Error>) -> Void) {
    let apiKey = "e883424d-d70f-4e58-8ee3-4e21ea390ff1"
    let urlString = "http://api.sms-webservice.com/api/V3/StatusByUserTraceId"
    
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0)))
        return
    }
    
    let requestBody = StatusByUserTraceIdRequest(ApiKey: apiKey, UserTraceIds: userTraceIds)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, _, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            completion(.success(responseString))
        } else {
            completion(.failure(NSError(domain: "Empty response", code: 0)))
        }
    }.resume()
}
