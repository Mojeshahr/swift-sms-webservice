// Send - ساده‌ترین ارسال، یک متن به چند شماره با یک درخواست GET.
//
// برای آزمایش سریع خوب است. در محیط عملیاتی SendBulk را بردارید: کلید را از
// نشانی بیرون می‌برد و برای هر گیرنده شناسه پی‌گیری می‌پذیرد.
//
// جز Foundation به چیزی وابسته نیست. کپی کنید و در پروژه خودتان اجرا کنید.
//
//   PAYAM_RESAN_API_KEY=... PAYAM_RESAN_SENDER=... swift examples/v3/send.swift

// docs:start
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let apiKey = ProcessInfo.processInfo.environment["PAYAM_RESAN_API_KEY"] ?? ""
let sender = ProcessInfo.processInfo.environment["PAYAM_RESAN_SENDER"] ?? ""

do {
    // URLComponents خودش یک بار percent-encode می‌کند. اگر متن را پیش از این
    // هم encode کنید، پیامک با نویسه‌های %D8 به گوشی می‌رسد.
    var components = URLComponents(string: "https://api.sms-webservice.com/api/V3/Send")!
    components.queryItems = [
        URLQueryItem(name: "ApiKey", value: apiKey),
        URLQueryItem(name: "Sender", value: sender),
        URLQueryItem(name: "Text", value: "کد تأیید شما ۱۲۳۴۵۶ است"),
        URLQueryItem(name: "Recipients", value: "9121112222,9121113333"),
    ]

    let (data, _) = try await URLSession.shared.data(from: components.url!)
    let response = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    guard let success = response?["Success"] as? Bool, success else {
        let code = response?["ErrorCode"] as? Int ?? 0
        let message = response?["Error"] as? String ?? ""
        FileHandle.standardError.write(Data("ناموفق. کد \(code): \(message)\n".utf8))
        exit(1)
    }

    for message in response?["Result"] as? [[String: Any]] ?? [] {
        print("شناسه \(message["Id"] ?? 0)")
    }
} catch {
    FileHandle.standardError.write(Data("درخواست ناتمام ماند: \(error)\n".utf8))
    exit(1)
}
// docs:end
