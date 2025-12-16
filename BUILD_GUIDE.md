# 🚀 راهنمای Build و اجرا

## دستورات اولیه

### نصب Dependencies
```bash
flutter pub get
```

### اجرای پروژه در حالت Debug

#### اندروید
```bash
flutter run -d android
```

#### ویندوز
```bash
flutter run -d windows
```

#### لینوکس
```bash
flutter run -d linux
```

#### macOS
```bash
flutter run -d macos
```

#### وب
```bash
flutter run -d chrome
```

### Build برای Production

#### اندروید APK
```bash
flutter build apk --release
```

#### اندروید App Bundle (برای Google Play)
```bash
flutter build appbundle --release
```

#### ویندوز
```bash
flutter build windows --release
```

#### لینوکس
```bash
./build_linux.sh
```

#### macOS
```bash
flutter build macos --release
```

#### وب
```bash
flutter build web --release
```

### Build ویندوز Installer (Inno Setup)
```bash
# ابتدا build ویندوز را انجام دهید
flutter build windows --release

# سپس از Inno Setup Compiler استفاده کنید
# فایل: inno/Inno installer script.iss
```

## چک کردن خطاها

### تحلیل کد
```bash
flutter analyze
```

### فرمت کردن کد
```bash
flutter format .
```

### تست‌ها
```bash
flutter test
```

## نکات مهم برای Build اندروید

### تنظیمات Signing (برای Release)
فایل `android/key.properties` را ایجاد کنید:
```properties
storePassword=your_password
keyPassword=your_password
keyAlias=your_key_alias
storeFile=path/to/keystore.jks
```

### Clean Build
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## مشکلات رایج و راه‌حل‌ها

### مشکل 1: Gradle Build Error
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### مشکل 2: Plugin Issues
```bash
flutter pub cache repair
flutter pub get
```

### مشکل 3: Version Conflicts
```bash
flutter doctor -v
# به‌روزرسانی Flutter
flutter upgrade
```

## دستورات مفید Development

### Hot Reload
در حالت debug: فشار دادن `r` در terminal

### Hot Restart
در حالت debug: فشار دادن `R` در terminal

### بررسی Performance
```bash
flutter run --profile
```

### نمایش Size Analysis
```bash
flutter build apk --analyze-size
flutter build appbundle --analyze-size
```

## بهینه‌سازی Build

### کاهش حجم APK
```bash
flutter build apk --release --split-per-abi
```
این دستور APK های جداگانه برای هر معماری ایجاد می‌کند:
- `app-armeabi-v7a-release.apk`
- `app-arm64-v8a-release.apk`
- `app-x86_64-release.apk`

### Obfuscation (مخفی‌سازی کد)
```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

## محیط‌های مختلف

### Development
```bash
flutter run --debug
```

### Profile (برای تست Performance)
```bash
flutter run --profile
```

### Release
```bash
flutter run --release
```

## CI/CD

### GitHub Actions نمونه
```yaml
name: Build
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
```

## نسخه‌گذاری

برای تغییر نسخه، فایل `pubspec.yaml` را ویرایش کنید:
```yaml
version: 1.5.0+12
#        ^^^^^  ^^
#        |      Build number
#        Version name
```

## لاگ‌گیری و Debug

### نمایش لاگ‌های اندروید
```bash
flutter logs
```
یا
```bash
adb logcat
```

### Debug با VS Code
1. فایل `.vscode/launch.json` را ایجاد کنید
2. F5 را بزنید برای شروع debug

### Sentry Integration
لاگ‌های خطا به صورت خودکار به Sentry ارسال می‌شوند (در حالت Release).

---

💡 **نکته**: همیشه قبل از Build نهایی، `flutter clean` را اجرا کنید تا از Clean Build اطمینان حاصل شود.
