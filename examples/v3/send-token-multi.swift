// SendTokenMulti - یک قالب، چند گیرنده، مقادیر متفاوت.
//
// پارامترها اینجا آرایه‌اند، نه p1 تا p10. درایه اول به {1} می‌نشیند، دومی به
// {2} و همین‌طور تا آخر: ترتیب از شماره جای‌گاه می‌آید، نه از جایی که در متن
// قالب دیده می‌شود.
//
// جز Foundation به چیزی وابسته نیست. کپی کنید و در پروژه خودتان اجرا کنید.
//
//   PAYAM_RESAN_API_KEY=... swift examples/v3/send-token-multi.swift

// docs:start
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let apiKey = ProcessInfo.processInfo.environment["PAYAM_RESAN_API_KEY"] ?? ""

do {
    // قالب نمونه: «مرسوله شما از {2} تحویل پست شد. بارکد مرسوله پستی: {1}»
    let payload: [String: Any] = [
        "ApiKey": apiKey,
        "TemplateKey": "postcode",
        "Recipients": [
            [
                "Destination": 9121112222,
                "UserTraceId": 1001,
                "Parameters": ["BARCODE-AAA", "شیراز"],
            ],
            [
                "Destination": 9121113333,
                "UserTraceId": 1002,
                "Parameters": ["BARCODE-BBB", "تبریز"],
            ],
        ],
    ]

    var request = URLRequest(
        url: URL(string: "https://api.sms-webservice.com/api/V3/SendTokenMulti")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONSerialization.data(withJSONObject: payload)
    request.timeoutInterval = 30

    let (data, _) = try await URLSession.shared.data(for: request)
    let response = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    guard let success = response?["Success"] as? Bool, success else {
        let code = response?["ErrorCode"] as? Int ?? 0
        let message = response?["Error"] as? String ?? ""
        FileHandle.standardError.write(Data("ناموفق. کد \(code): \(message)\n".utf8))
        exit(1)
    }

    for message in response?["Result"] as? [[String: Any]] ?? [] {
        print("\(message["UserTraceId"] ?? 0) => \(message["FinalText"] ?? "")")
    }
} catch {
    FileHandle.standardError.write(Data("درخواست ناتمام ماند: \(error)\n".utf8))
    exit(1)
}
// docs:end
