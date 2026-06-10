# BMI Calculator

Ứng dụng Flutter tính chỉ số BMI — nhanh, đơn giản, lưu lịch sử trên thiết bị.

## Tính năng

- Tính BMI với hệ mét (kg/cm) hoặc hệ Anh (lbs/in)
- Kết quả theo tiêu chuẩn WHO với gợi ý sức khỏe
- Lưu lịch sử các lần tính
- Giao diện sáng/tối, English / Tiếng Việt
- Dữ liệu lưu trên thiết bị (SharedPreferences)

## Cấu trúc dự án

```
lib/
├── main.dart
├── core/           # constants, themes, services, utils
├── models/         # BmiEntry
├── providers/      # BmiProvider, ThemeProvider, LocaleProvider
├── screens/        # calculator, history, settings
└── widgets/        # UI components
```

## Chạy ứng dụng

```bash
flutter pub get
flutter run
```

## Build release

```bash
flutter build apk --release
flutter build appbundle --release   # Google Play
flutter build ipa --release         # App Store (macOS)
```

## App ID

- Android: `com.bmicalculator.bmicalculator`
- iOS: `com.bmicalculator.bmicalculator`

## Ghi chú

- Thêm icon tùy chỉnh trước khi đăng store (hiện dùng icon mặc định Flutter).
- File `android/key.properties` và keystore cần cấu hình riêng cho signing release.
