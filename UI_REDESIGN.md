# UI/UX Redesign - IRNet v2.0

## 🎨 تغییرات اعمال شده

### ✨ طراحی جدید
پروژه IRNet با طراحی کاملاً جدید و مدرن بازسازی شده است که شامل موارد زیر می‌شود:

### 🌓 تم دارک و لایت
- **تم روشن (Purple Dream)**: پالت بنفش/صورتی با پس‌زمینه روشن
- **تم تاریک (Cyberpunk Nights)**: ترکیب بنفش فوشیا و سبز نئونی با پس‌زمینه سیاه/بنفش عمیق
- **تغییر آسان تم**: دکمه سوئیچ تم در AppBar
- **ذخیره‌سازی خودکار**: ترجیحات تم در SharedPreferences ذخیره می‌شود
- **افکت‌های نئونی**: سایه‌ها و border های درخشان در حالت dark mode
- **گرادیانت‌های چشم‌نواز**: Purple-to-Green در دارک، Purple-to-Pink در لایت

#### رنگ‌های اصلی (Cyberpunk Theme):
- **Primary Light**: `#D946EF` (Fuchsia - بنفش فوشیا)
- **Primary Dark**: `#F0ABFC` (Light Fuchsia)
- **Secondary Light**: `#8B5CF6` (Purple - بنفش)
- **Secondary Dark**: `#10B981` (Emerald - سبز زمردی)
- **Success**: `#10B981` (Emerald Green - نئون سبز)
- **Error**: `#FF0080` (Hot Pink - صورتی نئونی)
- **Warning**: `#FBBF24` (Amber)
- **Info**: `#3B82F6` (Blue)

#### رنگ‌های Accent:
- **Cyan**: `#06B6D4` (آبی فیروزه‌ای)
- **Pink**: `#EC4899` (صورتی)
- **Purple**: `#9333EA` (بنفش تیره)
- **Green**: `#10B981` (سبز نئون)

### 🎭 کامپوننت‌های جدید

#### 1. ModernCard
کارت‌های مدرن با سایه و انیمیشن:
```dart
ModernCard(
  child: YourWidget(),
  onTap: () {},
)
```

#### 2. GradientButton
دکمه‌های گرادیانت با افکت‌های بصری:
```dart
GradientButton(
  text: 'Click Me',
  icon: Icons.check,
  onPressed: () {},
  isLoading: false,
)
```

#### 3. StatusBadge
نشان‌های وضعیت زیبا:
```dart
StatusBadge(
  text: 'Connected',
  color: Colors.green,
  icon: Icons.check,
)
```

#### 4. InfoRow
نمایش اطلاعات با آیکون:
```dart
InfoRow(
  icon: Icons.speed,
  label: 'Speed',
  value: '100 Mbps',
  iconColor: Colors.blue,
)
```

#### 5. ShimmerLoading
افکت لودینگ شیمر:
```dart
ShimmerLoading(
  width: 200,
  height: 50,
)
```

#### 6. SectionHeader
عنوان بخش‌ها:
```dart
SectionHeader(
  title: 'Network Info',
  subtitle: 'Your connection details',
  icon: Icons.info,
)
```

### 📱 صفحات بازطراحی شده

#### 1. **Home Page** (`lib/home.dart`)
- صفحه اصلی با لی‌اوت ریسپانسیو
- سازگار با موبایل، تبلت و دسکتاپ
- Navigation Bar برای موبایل
- Hero Section برای دسکتاپ
- انیمیشن‌های نرم در تغییر صفحات

#### 2. **Connection View** (`lib/views/connection.dart`)
- کارت اطلاعات سرعت اینترنت
- نمایش Ping، Download و Upload
- دکمه تست با لودینگ انیمیشن
- رنگ‌بندی متمایز برای هر متریک

#### 3. **Leak Detection** (`lib/views/leak.dart`)
- لیست leak test‌ها با انیمیشن
- آیکون‌های وضعیت (Success/Error/Loading)
- ورودی URL با طراحی مدرن
- حالت خالی (Empty State) زیبا

#### 4. **Network Info** (`lib/views/ip_stat.dart`)
- کارت‌های اطلاعاتی رنگی
- نمایش IP عمومی و خصوصی
- اطلاعات DNS
- پرچم کشور
- Shimmer loading برای داده‌های در حال بارگذاری

#### 5. **Settings** (`lib/views/options.dart`)
- تنظیمات با سوئیچ‌های مدرن
- آیکون‌های رنگی برای هر تنظیم
- توضیحات واضح

### 🎬 انیمیشن‌ها

1. **Fade Transitions**: برای تغییر صفحات
2. **Slide Animations**: برای ورود المان‌ها
3. **Shimmer Effects**: برای حالت لودینگ
4. **Staggered Animations**: برای لیست‌ها (هر آیتم با تاخیر ظاهر می‌شود)
5. **Smooth Transitions**: در تمام تعاملات UI

### 📦 پکیج‌های جدید اضافه شده

```yaml
dependencies:
  provider: ^6.1.2      # State Management برای Theme
  animations: ^2.0.11   # انیمیشن‌های پیشرفته
```

### 🏗️ ساختار فایل‌های جدید

```
lib/
├── theme/
│   ├── app_theme.dart        # تعریف تم‌های Dark و Light
│   └── theme_provider.dart   # مدیریت تغییر تم
├── widgets/
│   └── modern_widgets.dart   # کامپوننت‌های UI قابل استفاده مجدد
└── utils/
    └── ui_helpers.dart       # Helper functions و utilities
```

### 🎯 ویژگی‌های کلیدی

#### ✅ Responsive Design
- موبایل: لی‌اوت تک ستونه با Navigation Bar
- تبلت و دسکتاپ: لی‌اوت دو ستونه
- Breakpoints: 600px (mobile), 900px (tablet), 1200px (desktop)

#### ✅ Accessibility
- رنگ‌های با کنتراست مناسب
- سایزهای فونت قابل خواندن
- Touch targets استاندارد (minimum 48x48)

#### ✅ Performance
- استفاده از const constructors
- کش کردن تم در SharedPreferences
- Lazy loading برای انیمیشن‌ها

#### ✅ Material Design 3
- استفاده از useMaterial3: true
- کامپوننت‌های بروز
- Elevation و Shadow های استاندارد

### 🚀 نحوه استفاده

#### تغییر تم:
```dart
// در هر ویجت با دسترسی به context:
context.read<ThemeProvider>().toggleTheme();

// یا تنظیم مستقیم:
context.read<ThemeProvider>().setThemeMode(ThemeMode.dark);
```

#### استفاده از کامپوننت‌ها:
```dart
import 'package:ir_net/widgets/modern_widgets.dart';

// در build method:
ModernCard(
  padding: EdgeInsets.all(20),
  child: Column(
    children: [
      SectionHeader(title: 'My Section'),
      InfoRow(
        icon: Icons.info,
        label: 'Label',
        value: 'Value',
      ),
    ],
  ),
)
```

### 📝 نکات مهم

1. **سازگاری با نسخه قبل**: تمام قابلیت‌های قبلی حفظ شده‌اند
2. **بهینه‌سازی**: کد تمیز و قابل نگهداری
3. **مستندسازی**: کامنت‌های واضح در کد
4. **Type Safety**: استفاده کامل از Type Safety فلاتر

### 🔄 تغییرات آینده (پیشنهادی)

- [ ] افزودن Splash Screen
- [ ] اضافه کردن صفحه About
- [ ] تنظیمات پیشرفته تم (انتخاب رنگ دلخواه)
- [ ] Localization (چند زبانه)
- [ ] Dark mode scheduling (تغییر خودکار بر اساس ساعت)

### 📸 اسکرین‌شات‌ها
قبل از بیلد نهایی، اسکرین‌شات‌ها را در پوشه `screenshots/` قرار دهید.

---

**نسخه**: 2.0.0  
**تاریخ**: December 16, 2025  
**توسعه‌دهنده**: GitHub Copilot  

✨ **تجربه بصری کاملاً جدید با IRNet!** ✨
