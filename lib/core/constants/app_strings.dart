import 'package:flutter/material.dart';

class AppStrings {
  static String t(BuildContext context, String key, {Map<String, String>? params}) {
    final locale = Localizations.localeOf(context).languageCode;
    var text = (_strings[locale] ?? _strings['en']!)[key] ?? key;
    params?.forEach((k, v) => text = text.replaceAll('{$k}', v));
    return text;
  }

  static const _strings = {
    'vi': {
      'appName': 'BMI Calculator',
      'appTagline': 'Tính chỉ số BMI nhanh & chính xác',
      'calculator': 'Tính BMI',
      'calculatorSubtitle': 'Nhập chiều cao và cân nặng để biết chỉ số cơ thể của bạn.',
      'history': 'Lịch sử',
      'historySubtitle': 'Các lần tính BMI trước đó',
      'settings': 'Cài đặt',
      'metric': 'Hệ mét',
      'imperial': 'Hệ Anh',
      'weight': 'Cân nặng',
      'height': 'Chiều cao',
      'weightHintMetric': 'Ví dụ: 65',
      'weightHintImperial': 'Ví dụ: 143',
      'heightHintMetric': 'Ví dụ: 170',
      'heightHintImperial': 'Ví dụ: 67',
      'calculate': 'Tính BMI',
      'yourBmi': 'Chỉ số BMI của bạn',
      'bmiScale': 'Thang đo BMI (WHO)',
      'categoryUnderweight': 'Thiếu cân',
      'categoryNormal': 'Bình thường',
      'categoryOverweight': 'Thừa cân',
      'categoryObese': 'Béo phì',
      'adviceUnderweight': 'BMI thấp hơn mức khuyến nghị. Hãy tham khảo ý kiến bác sĩ về chế độ dinh dưỡng phù hợp.',
      'adviceNormal': 'BMI của bạn nằm trong khoảng khỏe mạnh. Hãy duy trì lối sống cân bằng.',
      'adviceOverweight': 'BMI cao hơn mức khuyến nghị. Cân nhắc tăng vận động và điều chỉnh chế độ ăn.',
      'adviceObese': 'BMI ở mức cao. Nên tham khảo chuyên gia y tế để có kế hoạch sức khỏe phù hợp.',
      'invalidInput': 'Vui lòng nhập cân nặng và chiều cao hợp lệ.',
      'invalidHeight': 'Chiều cao không hợp lệ. Kiểm tra lại đơn vị đo.',
      'emptyHistory': 'Chưa có lịch sử',
      'emptyHistorySub': 'Tính BMI lần đầu để lưu kết quả tại đây.',
      'clearAll': 'Xóa hết',
      'clearHistory': 'Xóa lịch sử',
      'clearHistoryConfirm': 'Xóa toàn bộ lịch sử tính BMI?',
      'theme': 'Giao diện',
      'light': 'Sáng',
      'dark': 'Tối',
      'language': 'Ngôn ngữ',
      'vietnamese': 'Tiếng Việt',
      'english': 'English',
      'about': 'Giới thiệu',
      'aboutDesc': 'Ứng dụng tính chỉ số BMI đơn giản, nhanh chóng. Dữ liệu được lưu trên thiết bị của bạn.',
      'version': 'Phiên bản',
      'onboardingTitle': 'Chào mừng đến BMI Calculator',
      'onboardingSubtitle': 'Theo dõi chỉ số cơ thể, hiểu rõ tình trạng sức khỏe của bạn.',
      'onboardingFeature1': 'Tính BMI nhanh với hệ mét hoặc hệ Anh',
      'onboardingFeature2': 'Kết quả rõ ràng theo tiêu chuẩn WHO',
      'onboardingFeature3': 'Lưu lịch sử trên thiết bị, riêng tư',
      'start': 'Bắt đầu',
      'skip': 'Bỏ qua',
      'cancel': 'Hủy',
      'delete': 'Xóa',
      'copyright': '© 2026 BMI Calculator',
      'privacyPolicy': 'Chính sách riêng tư',
      'privacyPolicyTitle': 'Chính sách riêng tư',
      'privacyPolicyBody':
          'Cập nhật: 10/06/2026\n\n'
          'BMI Calculator chỉ lưu dữ liệu trên thiết bị của bạn.\n'
          'Chúng tôi thu thập:\n'
          '• Lịch sử tính BMI (cân nặng, chiều cao, kết quả, thời gian)\n'
          '• Cài đặt giao diện và ngôn ngữ\n\n'
          'Chúng tôi không thu thập, truyền hay bán dữ liệu cá nhân. '
          'Ứng dụng có thể tải font từ Google Fonts khi dùng lần đầu.\n\n'
          'Dữ liệu sẽ bị xóa khi bạn gỡ cài đặt hoặc xóa dữ liệu ứng dụng.',
    },
    'en': {
      'appName': 'BMI Calculator',
      'appTagline': 'Quick & accurate BMI tracking',
      'calculator': 'Calculator',
      'calculatorSubtitle': 'Enter your height and weight to check your body mass index.',
      'history': 'History',
      'historySubtitle': 'Your previous BMI calculations',
      'settings': 'Settings',
      'metric': 'Metric',
      'imperial': 'Imperial',
      'weight': 'Weight',
      'height': 'Height',
      'weightHintMetric': 'e.g. 65',
      'weightHintImperial': 'e.g. 143',
      'heightHintMetric': 'e.g. 170',
      'heightHintImperial': 'e.g. 67',
      'calculate': 'Calculate BMI',
      'yourBmi': 'Your BMI',
      'bmiScale': 'BMI Scale (WHO)',
      'categoryUnderweight': 'Underweight',
      'categoryNormal': 'Normal',
      'categoryOverweight': 'Overweight',
      'categoryObese': 'Obese',
      'adviceUnderweight': 'Your BMI is below the recommended range. Consider consulting a healthcare provider about nutrition.',
      'adviceNormal': 'Your BMI is in the healthy range. Keep up a balanced lifestyle.',
      'adviceOverweight': 'Your BMI is above the recommended range. Consider more activity and dietary adjustments.',
      'adviceObese': 'Your BMI is in a high range. Consult a healthcare professional for a personalized plan.',
      'invalidInput': 'Please enter valid weight and height values.',
      'invalidHeight': 'Invalid height. Please check your unit.',
      'emptyHistory': 'No history yet',
      'emptyHistorySub': 'Calculate your BMI to save results here.',
      'clearAll': 'Clear all',
      'clearHistory': 'Clear history',
      'clearHistoryConfirm': 'Delete all BMI history?',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'language': 'Language',
      'vietnamese': 'Tiếng Việt',
      'english': 'English',
      'about': 'About',
      'aboutDesc': 'A simple, fast BMI calculator. All data stays on your device.',
      'version': 'Version',
      'onboardingTitle': 'Welcome to BMI Calculator',
      'onboardingSubtitle': 'Track your body index and understand your health status.',
      'onboardingFeature1': 'Quick BMI with metric or imperial units',
      'onboardingFeature2': 'Clear results based on WHO standards',
      'onboardingFeature3': 'History saved locally, private',
      'start': 'Get started',
      'skip': 'Skip',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'copyright': '© 2026 BMI Calculator',
      'privacyPolicy': 'Privacy Policy',
      'privacyPolicyTitle': 'Privacy Policy',
      'privacyPolicyBody':
          'Last updated: June 10, 2026\n\n'
          'BMI Calculator stores data locally on your device only.\n'
          'We collect:\n'
          '• BMI calculation history (weight, height, result, timestamp)\n'
          '• Theme and language preferences\n\n'
          'We do not collect, transmit, or sell your personal data. '
          'The app may download fonts from Google Fonts on first use.\n\n'
          'All data is removed when you uninstall the app or clear its storage.',
    },
  };
}
