import Foundation

struct Recipient: Codable {
    let Sender: Int64
    let Text: String
    let Destination: String
    let UserTraceId: String
}

struct SendMultipleRequest: Codable {
    let ApiKey: String
    let Recipients: [Recipient]
}

func sendMultiple(destination: String, userTraceId: String, text: String, completion: @escaping (Result<String, Error>) -> Void) {
    let apiKey = "e883424d-d70f-4e58-8ee3-4e21ea390ff1"
    let sender: Int64 = 30007546464646
    
    let recipient = Recipient(Sender: sender, Text: text, Destination: destination, UserTraceId: userTraceId)
    let requestBody = SendMultipleRequest(ApiKey: apiKey, Recipients: [recipient])
    
    guard let url = URL(string: "http://api.sms-webservice.com/api/V3/SendMultiple") else {
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
