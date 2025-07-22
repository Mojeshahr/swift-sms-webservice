import Foundation

func send(recipients: String, text: String, completion: @escaping (String?, Error?) -> Void) {
    let apiKey = "e883424d-d70f-4e58-8ee3-4e21ea390ff1"
    let sender = "30007546464646"

    // ساخت پارامترها و urlencode کردن متن
    let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    var components = URLComponents(string: "http://api.sms-webservice.com/api/V3/Send")!
    components.queryItems = [
        URLQueryItem(name: "ApiKey", value: apiKey),
        URLQueryItem(name: "Text", value: encodedText),
        URLQueryItem(name: "Sender", value: sender),
        URLQueryItem(name: "Recipients", value: recipients)
    ]

    guard let url = components.url else {
        completion(nil, NSError(domain: "InvalidURL", code: 0))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            completion(responseString, nil)
        } else {
            completion(nil, NSError(domain: "NoData", code: 0))
        }
    }
    task.resume()
}
