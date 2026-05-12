import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/view/privacy_&_terms_conditions/widgets/legal_document_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Update: October 15, 2025',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            const LegalDocumentSection(
              title: "1. Information We Collect",
              content:
                  "We collect information that you provide directly to us, including but not limited to your name, email address, phone number, and payment information. We may also collect data automatically, such as device details, IP address, browser type, and app usage behavior to improve our services and user experience.",
            ),

            const LegalDocumentSection(
              title: "2. How We Use Your Information",
              content:
                  "We use the information we collect to provide and improve our services, process your transactions, send updates and notifications, personalize user experience, and ensure security. Your information also helps us comply with applicable laws and prevent fraudulent activities.",
            ),

            const LegalDocumentSection(
              title: "3. Data Security",
              content:
                  "We use technical and organizational measures to safeguard your personal data against unauthorized access, alteration, disclosure, or destruction. These include encryption, secure servers, and limited data access. While we strive to protect your data, no online system is completely secure, so please protect your account credentials carefully.",
            ),

            const LegalDocumentSection(
              title: "4. Your Rights",
              content:
                  "You have the right to access, correct, or delete your personal information. You may also withdraw your consent, restrict processing, or request a copy of your data. If you believe your rights are violated, you may contact us or file a complaint with your local data protection authority.",
            ),
          ],
        ),
      ),
    );
  }
}
