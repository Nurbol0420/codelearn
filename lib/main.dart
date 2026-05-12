import 'package:codelearn/bloc/auth/auth_state.dart';
import 'package:codelearn/bloc/course/course_bloc.dart';
import 'package:codelearn/bloc/language/language_bloc.dart';
import 'package:codelearn/bloc/language/language_state.dart';
import 'package:codelearn/bloc/profile/profile_bloc.dart';
import 'package:codelearn/config/firebase_config.dart';
import 'package:codelearn/repositories/course_repository.dart';
import 'package:codelearn/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:codelearn/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:codelearn/bloc/font/font_bloc.dart';
import 'package:codelearn/bloc/font/font_state.dart';
import 'package:codelearn/bloc/auth/auth_bloc.dart';
import 'package:codelearn/core/theme/app_theme.dart';
import 'package:codelearn/routes/app_routes.dart';
import 'package:codelearn/routes/route_pages.dart';

import 'bloc/filtered_course/filtered_course_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  await GetStorage.init();

  await StorageService.init();
  await GetStorage().erase();

  Get.put<RouteObserver<PageRoute>>(RouteObserver<PageRoute>());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FontBloc>(create: (context) => FontBloc()),
        BlocProvider<LanguageBloc>(create: (context) => LanguageBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<CourseBloc>(
          create: (context) => CourseBloc(
            authBloc: context.read<AuthBloc>(),
            courseRepository: CourseRepository(),
          ),
        ),
        BlocProvider<FilteredCourseBloc>(
          create: (context) =>
              FilteredCourseBloc(courseRepository: CourseRepository()),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<FontBloc, FontState>(
          builder: (context, fontState) {
            return BlocBuilder<LanguageBloc, LanguageState>(
              builder: (context, languageState) {
                final routeObserver = Get.find<RouteObserver<PageRoute>>();
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'codelearn',
                  theme: AppTheme.getLightTheme(fontState),
                  themeMode: ThemeMode.light,
                  locale: languageState.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en'),
                    Locale('kk'),
                  ],
                  initialRoute: AppRoutes.splash,
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  getPages: AppPages.pages,
                  navigatorObservers: [routeObserver],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
