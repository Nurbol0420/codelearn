import 'package:codelearn/bloc/font/font_bloc.dart';
import 'package:codelearn/bloc/font/font_event.dart';
import 'package:codelearn/bloc/language/language_bloc.dart';
import 'package:codelearn/bloc/language/language_event.dart';
import 'package:codelearn/bloc/language/language_state.dart';
import 'package:codelearn/core/theme/app_color.dart';
import 'package:codelearn/routes/app_routes.dart';
import 'package:codelearn/services/font_services.dart';
import 'package:codelearn/view/settings/widgets/setting_section.dart';
import 'package:codelearn/view/settings/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(l10n.settings, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === LANGUAGE SECTION ===
              BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, languageState) {
                  return SettingSection(
                    title: l10n.languageSettings,
                    children: [
                      SettingTile(
                        title: l10n.selectLanguage,
                        icon: Icons.language,
                        trailing: DropdownButton<String>(
                          value: languageState.locale.languageCode,
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(
                              value: 'en',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🇺🇸', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(l10n.english),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'kk',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🇰🇿', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(l10n.kazakh),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<LanguageBloc>()
                                  .add(ChangeLanguage(value));
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: l10n.appPreferences,
                children: [
                  SettingTile(
                    title: l10n.downloadWifiOnly,
                    icon: Icons.wifi_outlined,
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: l10n.content,
                children: [
                  SettingTile(
                    title: l10n.content,
                    icon: Icons.high_quality_outlined,
                    trailing: DropdownButton<String>(
                      onChanged: (value) {},
                      underline: const SizedBox(),
                      value: l10n.high,
                      items: [l10n.low, l10n.medium, l10n.high]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                    ),
                  ),
                  SettingTile(
                    title: l10n.autoPlayVideos,
                    icon: Icons.play_circle_outline,
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: l10n.privacy,
                children: [
                  SettingTile(
                    title: l10n.privacyPolicy,
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                  ),
                  SettingTile(
                    title: l10n.termsOfService,
                    icon: Icons.description_outlined,
                    onTap: () => Get.toNamed(AppRoutes.termsConditions),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: l10n.textSettings,
                children: [
                  SettingTile(
                    title: l10n.fontSize,
                    icon: Icons.format_size,
                    trailing: DropdownButton<String>(
                      value: FontService.currentFontScale == 0.8
                          ? l10n.small
                          : FontService.currentFontScale == 1.0
                          ? l10n.normal
                          : FontService.currentFontScale == 1.2
                          ? l10n.large
                          : l10n.extraLarge,
                      items: [l10n.small, l10n.normal, l10n.large, l10n.extraLarge]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          final scales = {
                            l10n.small: 0.8,
                            l10n.normal: 1.0,
                            l10n.large: 1.2,
                            l10n.extraLarge: 1.4,
                          };
                          context.read<FontBloc>().add(
                            UpdateFontScale(scales[value]!),
                          );
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                  SettingTile(
                    title: l10n.fontFamily,
                    icon: Icons.font_download,
                    trailing: DropdownButton<String>(
                      value: FontService.availableFonts.entries
                          .firstWhere(
                            (e) => e.value == FontService.currentFontFamily,
                          )
                          .key,
                      items: FontService.availableFonts.keys
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          context.read<FontBloc>().add(
                            UpdateFontFamily(
                              FontService.availableFonts[value]!,
                            ),
                          );
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: l10n.appInfo,
                children: [
                  SettingTile(
                    title: l10n.version,
                    icon: Icons.info_outline,
                    trailing: Text(
                      '1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
