// StatusById - وضعیت پیامک با شناسه‌هایی که متد ارسال برگردانده است.
//
// دسته‌ای بپرسید، نه یکی‌یکی. فاصله استعلام‌ها را هم کمتر از چند دقیقه
// نگذارید، وگرنه به خطای ۲۰ می‌خورید.
//
// جز Foundation به چیزی وابسته نیست. کپی کنید و در پروژه خودتان اجرا کنید.
//
//   PAYAM_RESAN_API_KEY=... swift examples/v3/status-by-id.swift

// docs:start
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let apiKey = ProcessInfo.processInfo.environment["PAYAM_RESAN_API_KEY"] ?? ""

do {
    let payload: [String: Any] = [
        "ApiKey": apiKey,
        "Ids": [9903211, 9903212],
    ]

    var request = URLRequest(
        url: URL(string: "https://api.sms-webservice.com/api/V3/StatusById")!)
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

    // شرط را روی StatusCode بگذارید، نه روی متن Status. این پنج کد یعنی هنوز در
    // راه است و باید بعداً دوباره استعلام کنید، نه اینکه دوباره بفرستید.
    let pending: Set<Int> = [0, 1, 2, 3, 10]

    for message in response?["Result"] as? [[String: Any]] ?? [] {
        let code = message["StatusCode"] as? Int ?? -1
        let again = pending.contains(code) ? " (بعداً دوباره بپرسید)" : ""
        print("\(message["Id"] ?? 0): \(message["Status"] ?? "")\(again)")
    }
} catch {
    FileHandle.standardError.write(Data("درخواست ناتمام ماند: \(error)\n".utf8))
    exit(1)
}
// docs:end
