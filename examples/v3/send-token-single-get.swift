// SendTokenSingle با GET - همان ارسال قالب، با ورودی در نشانی.
//
// برای آزمایش دستی مناسب است، برای محیط عملیاتی نه: در GET هم کلید حساب و هم
// مقدار رمز یک‌بارمصرف داخل نشانی می‌نشینند و در لاگ وب‌سرور و هدر Referer
// ثبت می‌شوند. واریانت POST را بردارید.
//
// جز Foundation به چیزی وابسته نیست. کپی کنید و در پروژه خودتان اجرا کنید.
//
//   PAYAM_RESAN_API_KEY=... swift examples/v3/send-token-single-get.swift

// docs:start
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let apiKey = ProcessInfo.processInfo.environment["PAYAM_RESAN_API_KEY"] ?? ""

do {
    var components = URLComponents(
        string: "https://api.sms-webservice.com/api/V3/SendTokenSingle")!
    components.queryItems = [
        URLQueryItem(name: "ApiKey", value: apiKey),
        URLQueryItem(name: "TemplateKey", value: "verifycode"),
        URLQueryItem(name: "Destination", value: "9121112222"),
        URLQueryItem(name: "p1", value: "123456"),
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
        print("شناسه \(message["Id"] ?? 0)، متن نهایی: \(message["FinalText"] ?? "")")
    }
} catch {
    FileHandle.standardError.write(Data("درخواست ناتمام ماند: \(error)\n".utf8))
    exit(1)
}
// docs:end
