import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/view/privacy_&_terms_conditions/widgets/legal_document_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
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
              'Last Updated: October 15, 2025',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),

            const LegalDocumentSection(
              title: "1. Acceptance of Terms",
              content:
                  "By accessing or using our application, you agree to comply with and be bound by these Terms and Conditions. If you do not agree, please do not use our services. We reserve the right to modify these terms at any time, and continued use of the app signifies your acceptance of those changes.",
            ),

            const LegalDocumentSection(
              title: "2. Use of Services",
              content:
                  "You agree to use the app only for lawful purposes and in accordance with these Terms. You must not misuse, modify, or interfere with the app’s functionality. Any unauthorized use or access may result in suspension or termination of your account.",
            ),

            const LegalDocumentSection(
              title: "3. User Accounts and Responsibilities",
              content:
                  "When creating an account, you must provide accurate, complete, and up-to-date information. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account. We are not liable for any loss resulting from unauthorized access to your account.",
            ),

            const LegalDocumentSection(
              title: "4. Intellectual Property",
              content:
                  "All content, logos, trademarks, and materials within the app are the property of the company or its licensors. You are not permitted to copy, reproduce, distribute, or create derivative works without prior written permission.",
            ),

            const LegalDocumentSection(
              title: "5. Payments and Subscriptions",
              content:
                  "If our services require payment, you agree to provide accurate billing information and authorize us to charge applicable fees. All payments are final and non-refundable unless otherwise stated by law or specific service policies.",
            ),

            const LegalDocumentSection(
              title: "6. Limitation of Liability",
              content:
                  "We strive to provide accurate and reliable services but cannot guarantee that the app will be error-free or uninterrupted. To the maximum extent permitted by law, we are not responsible for any damages, data loss, or inconvenience caused by your use or inability to use the app.",
            ),

            const LegalDocumentSection(
              title: "7. Termination",
              content:
                  "We may suspend or terminate your access to the app at any time if you violate these Terms, engage in fraudulent activity, or misuse our services. You may also choose to delete your account at any time through your account settings.",
            ),

            const LegalDocumentSection(
              title: "8. Governing Law",
              content:
                  "These Terms and Conditions are governed by and construed in accordance with the laws of Vietnam. Any disputes arising under or in connection with these Terms shall be resolved in the competent courts of Vietnam.",
            ),

            const LegalDocumentSection(
              title: "9. Contact Us",
              content:
                  "If you have questions, concerns, or requests regarding these Terms and Conditions, please contact us at: immangoc@gmail.com or call us at +84 0333 645 212.",
            ),
          ],
        ),
      ),
    );
  }
}
