import Foundation

struct Recipient: Codable {
    let Destination: String
    let UserTraceId: String
}

struct SendBulkRequest: Codable {
    let ApiKey: String
    let Text: String
    let Sender: Int64
    let Recipients: [Recipient]
}

func sendBulk(destination: String, userTraceId: String, text: String, completion: @escaping (Result<String, Error>) -> Void) {
    let apiKey = "e883424d-d70f-4e58-8ee3-4e21ea390ff1"
    let sender: Int64 = 30007546464646
    
    let recipient = Recipient(Destination: destination, UserTraceId: userTraceId)
    let requestBody = SendBulkRequest(ApiKey: apiKey, Text: text, Sender: sender, Recipients: [recipient])
    
    guard let url = URL(string: "http://api.sms-webservice.com/api/V3/SendBulk") else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0)))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }
    
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
