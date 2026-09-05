// SendBulk - یک متن به چند گیرنده، هر کدام با شناسه پی‌گیری خودتان.
//
// روش پیشنهادی برای ارسال عملیاتی. کلید در بدنه درخواست می‌رود نه در نشانی،
// و برای هر گیرنده UserTraceId می‌پذیرد تا گزارش تحویل را بدون نگه‌داشتن Id
// سامانه بگیرید.
//
// جز Foundation به چیزی وابسته نیست. کپی کنید و در پروژه خودتان اجرا کنید.
//
//   PAYAM_RESAN_API_KEY=... PAYAM_RESAN_SENDER=... swift examples/v3/send-bulk.swift

// docs:start
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let apiKey = ProcessInfo.processInfo.environment["PAYAM_RESAN_API_KEY"] ?? ""

// سرویس Sender را عدد می‌خواهد، نه رشته.
guard let sender = Int(ProcessInfo.processInfo.environment["PAYAM_RESAN_SENDER"] ?? "") else {
    FileHandle.standardError.write(Data("متغیر PAYAM_RESAN_SENDER باید یک عدد باشد\n".utf8))
    exit(1)
}

do {
    let payload: [String: Any] = [
        "ApiKey": apiKey,
        "Sender": sender,
        "Text": "سفارش شما ثبت شد.",
        "Recipients": [
            ["Destination": 9121112222, "UserTraceId": 1001],
            ["Destination": 9121113333, "UserTraceId": 1002],
        ],
    ]

    var request = URLRequest(
        url: URL(string: "https://api.sms-webservice.com/api/V3/SendBulk")!)
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
        print("\(message["UserTraceId"] ?? 0) => شناسه \(message["Id"] ?? 0)")
    }
} catch {
    FileHandle.standardError.write(Data("درخواست ناتمام ماند: \(error)\n".utf8))
    exit(1)
}
// docs:end
