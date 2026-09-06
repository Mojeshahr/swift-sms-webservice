<div align="center">

<a href="https://payam-resan.com">
  <img src=".github/assets/logo.svg" width="64" height="64" alt="پیام رسان">
</a>

<h1>نمونه‌کدهای Swift وب‌سرویس پیام رسان</h1>

اتصال به وب‌سرویس <a href="https://payam-resan.com"><b>پنل پیامکی پیام رسان</b></a> با Swift<br>
یک فایل قابل اجرا به‌ازای هر متد سرویس، بدون هیچ وابستگی

[![API](https://img.shields.io/badge/API-V3-0a7cbd)](https://payam-resan.com)
[![Swift](https://img.shields.io/badge/Swift-6.1-f05138)](https://swift.org)
[![Dependencies](https://img.shields.io/badge/dependencies-none-2ea44f)](#شروع-سریع)
[![License](https://img.shields.io/badge/license-MIT-6e7781)](LICENSE)

<b>فارسی</b> · <a href="README.en.md">English</a>

</div>

<sub>دنبال زبان دیگری هستید؟ همین نمونه‌ها برای زبان‌های دیگر هم در
[github.com/Mojeshahr](https://github.com/Mojeshahr) هست.</sub>

---

## شروع سریع

```bash
git clone https://github.com/Mojeshahr/swift-sms-webservice.git
cd swift-sms-webservice

export PAYAM_RESAN_API_KEY='123456-XXXXXXXXXXXXXXX'
export PAYAM_RESAN_SENDER='30004040'

swift examples/v3/account-info.swift
```

هیچ بسته‌ای لازم نیست و فایل `Package.swift` هم اینجا نیست. هر نمونه فقط از
`URLSession` و `JSONSerialization` استفاده می‌کند که هر دو در Foundation
هستند، و مستقیم با خود `swift` اجرا می‌شود.

با `account-info.swift` شروع کنید: چیزی ارسال نمی‌کند، اعتباری مصرف نمی‌کند، و
اگر جواب داد یعنی کلید و اتصال هر دو سالم‌اند.

## پیش از ارسال واقعی

یک سرور آزمایشی هست که مثل سرور عملیاتی جواب می‌دهد ولی پیامکی نمی‌فرستد و
اعتباری مصرف نمی‌کند. کافی است `V3` در نشانی را با `V3SandBox` عوض کنید. تنها
استثنا `TokenList` است که روی آن سرور پیاده نشده.

## آی‌اواس و کلید حساب

کلید حساب را داخل اپ نگذارید. هر رشته‌ای که در بسته اپ برود قابل استخراج است،
و هر کسی که آن را دربیاورد با اعتبار شما پیامک می‌فرستد. نه در کد، نه در
`Info.plist`، نه در Keychain که خود اپ پرش کرده باشد.

جای درستش بک‌اند خودتان است. اپ به سرور شما می‌گوید «برای این کاربر کد
بفرست»، سرور شما تصمیم می‌گیرد و با کلید خودش این سرویس را صدا می‌زند.

نمونه‌های این مخزن کلید را از متغیر محیطی می‌خوانند، که روی macOS و لینوکس و
Vapor درست کار می‌کند. در اپ آی‌اواس متغیر محیطی وجود ندارد؛ آنجا شکل درخواست
همین است ولی صدازننده باید سرور شما باشد، نه اپ.

## متدها

<div dir="rtl">

| نمونه | متد | کار |
|---|---|---|
| [account-info.swift](examples/v3/account-info.swift) | `AccountInfo` | اعتبار و خطوط فعال |
| [send.swift](examples/v3/send.swift) | `Send` | ارسال ساده با `GET` |
| [send-bulk.swift](examples/v3/send-bulk.swift) | `SendBulk` | یک متن به چند گیرنده، با شناسه پی‌گیری |
| [send-multiple.swift](examples/v3/send-multiple.swift) | `SendMultiple` | متن جدا برای هر گیرنده |
| [token-list.swift](examples/v3/token-list.swift) | `TokenList` | فهرست قالب‌ها |
| [send-token-single.swift](examples/v3/send-token-single.swift) | `SendTokenSingle` | ارسال قالب به یک شماره |
| [send-token-single-get.swift](examples/v3/send-token-single-get.swift) | `SendTokenSingle` | همان، با `GET` |
| [send-token-multi.swift](examples/v3/send-token-multi.swift) | `SendTokenMulti` | یک قالب، چند گیرنده |
| [status-by-id.swift](examples/v3/status-by-id.swift) | `StatusById` | وضعیت با شناسه سامانه |
| [status-by-user-trace-id.swift](examples/v3/status-by-user-trace-id.swift) | `StatusByUserTraceId` | وضعیت با شناسه خودتان |
| [get-inbox.swift](examples/v3/get-inbox.swift) | `GetInbox` | پیامک‌های رسیده |

</div>

## روی لینوکس

نمونه‌ها روی لینوکس هم آزموده شده‌اند و همان‌جا یک تفاوت هست که هر فایل با آن
شروع می‌شود:

```swift
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
```

روی اپل، `URLSession` جزو Foundation است. روی لینوکس آن را به ماژول جدایی
منتقل کرده‌اند، پس بدون این سه خط کد آنجا کامپایل نمی‌شود. روی macOS و iOS
بی‌اثر است، پس همین یک فایل هر دو جا کار می‌کند. برندارید.

## استفاده در پروژه خودتان

نمونه‌ها عمداً به هیچ چیز این مخزن وابسته نیستند، پس کپی‌کردن بدنه فایل داخل
سرویس خودتان کافی است. اگر ترجیح می‌دهید به‌جای دیکشنری با نوع‌های واقعی کار
کنید، فقط بخش خواندن پاسخ را عوض کنید؛ شکل درخواست همان است:

```swift
struct SendResult: Decodable {
    let Id: Int
    let UserTraceId: Int?
}

struct SendResponse: Decodable {
    let Success: Bool
    let ErrorCode: Int?
    let Error: String?
    let Result: [SendResult]?
}

let response = try JSONDecoder().decode(SendResponse.self, from: data)
```

خود نمونه‌ها این کار را نمی‌کنند، چون بیست خط اعلان نوع پیش از چهار خطی می‌نشیند
که کار اصلی را نشان می‌دهد.

یک بسته نصب‌شدنی SwiftPM هم در برنامه هست و در مخزن جداگانه‌ای منتشر می‌شود.

## چند نکته که وقت‌تان را می‌خرد

**کد وضعیت HTTP اینجا چیزی ثابت نمی‌کند.** سرویس همیشه `200` برمی‌گرداند، حتی
وقتی کلید اشتباه است. تصمیم را از فیلد `Success` بگیرید.

**در همان `guard` اول وجود فیلد را بسنجید، نه فقط مقدارش.** نوشتن
`as? Bool` دقیقا برای همین است: نشانی‌ای که وجود نداشته باشد بدنه‌ای برمی‌گرداند
که فقط `Message` دارد، و بدون این تبدیل، کد به‌جای پیام خطا می‌ترکد.

**دو نوع خطا را با هم قاطی نکنید.** timeout و خطای DNS در `catch` می‌افتند، ولی
جواب‌دادن سرویس با `Success: false` چیز دیگری است. هر نمونه اینجا این دو را جدا
گزارش می‌کند.

**شماره گیرنده صفر ابتدایی ندارد.** یعنی `9121112222` یا با کد کشور
`989121112222`. شماره‌ای که با `9` یا `989` شروع نشود کد خطای `13` می‌گیرد.

**متن را دوباره encode نکنید.** کلاس `URLComponents` خودش یک بار این کار را
می‌کند. اگر پیش از آن هم encode کنید، پیامک با نویسه‌های `%D8` به گوشی می‌رسد.

**برای هر گیرنده یک `UserTraceId` یکتا بفرستید.** بعد از یک timeout، این تنها
راه فهمیدن این است که پیامک ثبت شده یا نه.

## امنیت کلید

کلید یک راز است. در مخزن کد، در جاوااسکریپت مرورگر و در بسته اپلیکیشن موبایل
نباید قرار بگیرد. جای آن متغیر محیطی است، همان‌طور که همه نمونه‌ها می‌خوانندش.

اگر کلیدی لو رفت، از پنل یکی تازه بسازید. کلید حذف‌شده برنمی‌گردد.

## ساختار

<div dir="rtl">

| مسیر | چه چیزی دارد |
|---|---|
| `examples/v3/` | یک نمونه مستقل به‌ازای هر عملیات سرویس |
| `.env.example` | نمونه متغیرهای محیطی |

</div>

عدد `v3` در مسیر عمدی است. نسخه تازه سرویس یعنی پوشه `examples/v<n>/` تازه، و
پوشه موجود دست‌نخورده می‌ماند.

## مستندات و پشتیبانی

راهنمای کامل وب‌سرویس در [docs.payam-resan.com](https://docs.payam-resan.com)
است. توصیف ماشین‌خوان OpenAPI هم در
[sms-webservice-spec](https://github.com/Mojeshahr/sms-webservice-spec).

## مجوز

منتشرشده با مجوز MIT. متن کامل در [`LICENSE`](LICENSE).
