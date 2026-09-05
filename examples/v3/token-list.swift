// TokenList - قالب‌های حساب، با کلید و متن و وضعیت تأییدشان.
//
// برای پیدا کردن TemplateKey که متدهای ارسال قالب لازم دارند. این متد هم مثل
// AccountInfo از بررسی اعتبار معاف است.
//
// روی سرور آزمایشی پیاده نشده و ۴۰۴ می‌دهد؛ همین متد را از سرور عملیاتی صدا
// بزنید، چیزی نمی‌فرستد و اعتباری مصرف نمی‌کند.
//
// جز Foundation به چیزی وابسته نیست. کپی کنید و در پروژه خودتان اجرا کنید.
//
//   PAYAM_RESAN_API_KEY=... swift examples/v3/token-list.swift

// docs:start
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let apiKey = ProcessInfo.processInfo.environment["PAYAM_RESAN_API_KEY"] ?? ""

do {
    var request = URLRequest(
        url: URL(string: "https://api.sms-webservice.com/api/V3/TokenList")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONSerialization.data(withJSONObject: ["ApiKey": apiKey])
    request.timeoutInterval = 30

    let (data, _) = try await URLSession.shared.data(for: request)
    let response = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    guard let success = response?["Success"] as? Bool, success else {
        let code = response?["ErrorCode"] as? Int ?? 0
        let message = response?["Error"] as? String ?? ""
        FileHandle.standardError.write(Data("ناموفق. کد \(code): \(message)\n".utf8))
        exit(1)
    }

    for template in response?["Result"] as? [[String: Any]] ?? [] {
        let sendable = (template["Status"] as? Int) == 2 ? "قابل ارسال" : "قابل ارسال نیست"
        print("\(template["Key"] ?? "") (\(sendable)): \(template["TextTemplate"] ?? "")")
    }
} catch {
    FileHandle.standardError.write(Data("درخواست ناتمام ماند: \(error)\n".utf8))
    exit(1)
}
// docs:end
