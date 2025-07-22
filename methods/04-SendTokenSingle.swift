import Foundation

func sendTokenSingle(templateKey: String, destination: String, param1: String, param2: String, param3: String, completion: @escaping (Result<String, Error>) -> Void) {
    let apiKey = "e883424d-d70f-4e58-8ee3-4e21ea390ff1"
    
    var components = URLComponents(string: "http://api.sms-webservice.com/api/V3/SendTokenSingle")!
    components.queryItems = [
        URLQueryItem(name: "ApiKey", value: apiKey),
        URLQueryItem(name: "TemplateKey", value: templateKey),
        URLQueryItem(name: "Destination", value: destination),
        URLQueryItem(name: "p1", value: param1),
        URLQueryItem(name: "p2", value: param2),
        URLQueryItem(name: "p3", value: param3)
    ]
    
    guard let url = components.url else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0)))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            completion(.success(responseString))
        } else {
            completion(.failure(NSError(domain: "Empty response", code: 0)))
        }
    }
    task.resume()
}
