import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart'; // LanguageProvider

enum LegalType { privacyPolicy, termsConditions, aboutUs }

class LegalScreen extends StatelessWidget {
  final LegalType type;
  const LegalScreen({super.key, required this.type});

  String _getTitle(bool isHindi) {
    switch (type) {
      case LegalType.privacyPolicy:
        return isHindi ? 'गोपनीयता नीति' : 'Privacy Policy';
      case LegalType.termsConditions:
        return isHindi ? 'नियम और शर्तें' : 'Terms & Conditions';
      case LegalType.aboutUs:
        return isHindi ? 'हमारे बारे में' : 'About Us';
    }
  }

  String _getContent(bool isHindi) {
    switch (type) {
      case LegalType.privacyPolicy:
        return isHindi
            ? '''
गोपनीयता नीति

हम आपकी गोपनीयता का सम्मान करते हैं। यह ऐप केवल शैक्षिक उद्देश्यों के लिए है और मनोविज्ञान से संबंधित जानकारी प्रदान करता है।

हम कोई व्यक्तिगत डेटा एकत्र नहीं करते हैं। यदि आप लॉगिन करते हैं, तो हम केवल आपका ईमेल और पासवर्ड Firebase Authentication के माध्यम से सुरक्षित रूप से संग्रहीत करते हैं। हम आपकी जानकारी किसी तीसरे पक्ष को नहीं बेचते हैं।

इस ऐप की सामग्री केवल सूचनात्मक है और इसे पेशेवर मनोवैज्ञानिक सलाह के रूप में नहीं लिया जाना चाहिए।

यदि आपके कोई प्रश्न हैं, तो कृपया हमसे संपर्क करें।
'''
            : '''
Privacy Policy

We respect your privacy. This app is for educational purposes only and provides information related to psychology.

We do not collect any personal data. If you choose to log in, we only store your email and password securely via Firebase Authentication. We do not sell your information to any third party.

The content of this app is informational only and should not be taken as professional psychological advice.

If you have any questions, please contact us.
''';
      case LegalType.termsConditions:
        return isHindi
            ? '''
नियम और शर्तें

इस ऐप का उपयोग करके, आप इन शर्तों से सहमत होते हैं।

1. यह ऐप केवल शैक्षिक उद्देश्यों के लिए है।
2. सामग्री का दुरुपयोग न करें।
3. हम सामग्री की सटीकता की गारंटी नहीं देते हैं।
4. हम किसी भी नुकसान के लिए उत्तरदायी नहीं हैं।
5. हम बिना सूचना के इन शर्तों को बदल सकते हैं।

कृपया इस ऐप का जिम्मेदारी से उपयोग करें।
'''
            : '''
Terms & Conditions

By using this app, you agree to these terms.

1. This app is for educational purposes only.
2. Do not misuse the content.
3. We do not guarantee the accuracy of the content.
4. We are not liable for any damages.
5. We may change these terms without notice.

Please use this app responsibly.
''';
      case LegalType.aboutUs:
        return isHindi
            ? '''
हमारे बारे में

DarkSider एक शैक्षिक ऐप है जो डार्क साइकोलॉजी और मानव मनोविज्ञान के विभिन्न पहलुओं को सिखाने के लिए बनाया गया है। इसमें 90 से अधिक विषय, क्विज़, और टेक्स्ट-टू-स्पीच सुविधा शामिल है।

हमारा उद्देश्य लोगों को मनोविज्ञान की गहरी समझ प्रदान करना है ताकि वे खुद को और दूसरों को बेहतर समझ सकें।

धन्यवाद!
'''
            : '''
About Us

DarkSider is an educational app designed to teach various aspects of dark psychology and human psychology. It includes over 90 topics, quizzes, and text-to-speech features.

Our goal is to provide people with a deeper understanding of psychology so they can better understand themselves and others.

Thank you!
''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isHindi = langProvider.currentLanguage == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(isHindi)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          _getContent(isHindi),
          style: GoogleFonts.poppins(
            fontSize: 16,
            height: 1.6,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}