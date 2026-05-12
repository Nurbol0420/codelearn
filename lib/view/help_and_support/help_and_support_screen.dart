import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/view/help_and_support/widgets/contact_tile.dart';
import 'package:codelearn/view/help_and_support/widgets/faq_tile.dart';
import 'package:codelearn/view/help_and_support/widgets/help_search_bar.dart';
import 'package:codelearn/view/help_and_support/widgets/help_section.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(l10n.helpAndSupport, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HelpSearchBar(),
              const SizedBox(height: 24),
              HelpSection(
                title: l10n.frequentlyAskedQuestions,
                children: [
                  FaqTile(question: l10n.resetPasswordFaq, answer: l10n.resetPasswordAnswer),
                  FaqTile(question: l10n.changeEmailFaq, answer: l10n.changeEmailAnswer),
                  FaqTile(question: l10n.updateAppFaq, answer: l10n.updateAppAnswer),
                  FaqTile(question: l10n.verificationEmailFaq, answer: l10n.verificationEmailAnswer),
                  FaqTile(question: l10n.cancelSubscriptionFaq, answer: l10n.cancelSubscriptionAnswer),
                  FaqTile(question: l10n.refundsFaq, answer: l10n.refundsAnswer),
                  FaqTile(question: l10n.offlineModeFaq, answer: l10n.offlineModeAnswer),
                  FaqTile(question: l10n.deleteAccountFaq, answer: l10n.deleteAccountAnswer),
                  FaqTile(question: l10n.exportDataFaq, answer: l10n.exportDataAnswer),
                  FaqTile(question: l10n.paymentFailedFaq, answer: l10n.paymentFailedAnswer),
                  FaqTile(question: l10n.reportBugFaq, answer: l10n.reportBugAnswer),
                  FaqTile(question: l10n.supportedDevicesFaq, answer: l10n.supportedDevicesAnswer),
                ],
              ),
              const SizedBox(height: 24),
              HelpSection(
                title: l10n.contactUs,
                children: [
                  ContactTile(title: l10n.emailSupport, subtitle: l10n.emailSupportDesc, icon: Icons.email_outlined, onTap: () {}),
                  ContactTile(title: l10n.liveChat, subtitle: l10n.liveChatDesc, icon: Icons.chat_outlined, onTap: () {}),
                  ContactTile(title: l10n.callUs, subtitle: l10n.callUsDesc, icon: Icons.phone_outlined, onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
