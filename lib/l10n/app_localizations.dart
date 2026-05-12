import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'codelearn'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @downloadWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Download over Wi-Fi only'**
  String get downloadWifiOnly;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @autoPlayVideos.
  ///
  /// In en, this message translates to:
  /// **'Auto-plays Videos'**
  String get autoPlayVideos;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @textSettings.
  ///
  /// In en, this message translates to:
  /// **'Text Settings'**
  String get textSettings;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @fontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamily;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @kazakh.
  ///
  /// In en, this message translates to:
  /// **'Қазақша'**
  String get kazakh;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetSent;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start your learning journey'**
  String get startJourney;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @selectRoleHint.
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectRoleHint;

  /// No description provided for @pleaseSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get pleaseSelectRole;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPassword;

  /// No description provided for @enterEmailToResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Email ToReset Password'**
  String get enterEmailToResetPassword;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @recentNotifications.
  ///
  /// In en, this message translates to:
  /// **'Recent Notifications'**
  String get recentNotifications;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchCourses.
  ///
  /// In en, this message translates to:
  /// **'Search courses...'**
  String get searchCourses;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @myCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourses;

  /// No description provided for @allCourses.
  ///
  /// In en, this message translates to:
  /// **'All Courses'**
  String get allCourses;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @coursesCount.
  ///
  /// In en, this message translates to:
  /// **'courses'**
  String get coursesCount;

  /// No description provided for @noCoursesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get noCoursesAvailable;

  /// No description provided for @unknownInstructor.
  ///
  /// In en, this message translates to:
  /// **'Unknown Instructor'**
  String get unknownInstructor;

  /// No description provided for @enrollNow.
  ///
  /// In en, this message translates to:
  /// **'Enroll Now'**
  String get enrollNow;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @quizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzes;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @instructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @aboutCourse.
  ///
  /// In en, this message translates to:
  /// **'About this course'**
  String get aboutCourse;

  /// No description provided for @courseContent.
  ///
  /// In en, this message translates to:
  /// **'Course Content'**
  String get courseContent;

  /// No description provided for @requirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// No description provided for @whatYouLearn.
  ///
  /// In en, this message translates to:
  /// **'What you\'ll learn'**
  String get whatYouLearn;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @loadingCourse.
  ///
  /// In en, this message translates to:
  /// **'Loading course details...'**
  String get loadingCourse;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now for'**
  String get buyNow;

  /// No description provided for @premiumCourse.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM COURSE'**
  String get premiumCourse;

  /// No description provided for @noLessonsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No lessons available'**
  String get noLessonsAvailable;

  /// No description provided for @viewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get viewCertificate;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get oops;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get somethingWentWrong;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get tryAgainLater;

  /// No description provided for @reviews2.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews2;

  /// No description provided for @learnAnywhere.
  ///
  /// In en, this message translates to:
  /// **'Learn Anywhere'**
  String get learnAnywhere;

  /// No description provided for @learnAnywhereDesc.
  ///
  /// In en, this message translates to:
  /// **'Access your courses on any device. Learn at your own pace with our flexible learning platform.'**
  String get learnAnywhereDesc;

  /// No description provided for @interactiveLearning.
  ///
  /// In en, this message translates to:
  /// **'Interactive Learning'**
  String get interactiveLearning;

  /// No description provided for @interactiveLearningDesc.
  ///
  /// In en, this message translates to:
  /// **'Engage with interactive quizzes, live sessions, and hands-on projects to enhance your learning experience.'**
  String get interactiveLearningDesc;

  /// No description provided for @trackProgress.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get trackProgress;

  /// No description provided for @trackProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor your progress, earn certificates, and achieve your learning goals with our comprehensive tracking system.'**
  String get trackProgressDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @completedCourses.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedCourses;

  /// No description provided for @inProgressCourses.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgressCourses;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @editYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Profile'**
  String get editYourProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @aboutYou.
  ///
  /// In en, this message translates to:
  /// **'About You'**
  String get aboutYou;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @courses2.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses2;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @success2.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success2;

  /// No description provided for @editProfileOption.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileOption;

  /// No description provided for @editProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get editProfileSub;

  /// No description provided for @notificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Manage your notifications'**
  String get notificationsSub;

  /// No description provided for @settingsSub.
  ///
  /// In en, this message translates to:
  /// **'App preferences and more'**
  String get settingsSub;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @helpSupportSub.
  ///
  /// In en, this message translates to:
  /// **'Get help or contact support'**
  String get helpSupportSub;

  /// No description provided for @logoutSub.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get logoutSub;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @downloadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Download Certificate'**
  String get downloadCertificate;

  /// No description provided for @shareCertificate.
  ///
  /// In en, this message translates to:
  /// **'Share Certificate'**
  String get shareCertificate;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @courseCompleted.
  ///
  /// In en, this message translates to:
  /// **'You have completed all lessons'**
  String get courseCompleted;

  /// No description provided for @downloadCertDesc.
  ///
  /// In en, this message translates to:
  /// **'You can now download your certificate of completion'**
  String get downloadCertDesc;

  /// No description provided for @quizResult.
  ///
  /// In en, this message translates to:
  /// **'Quiz Result'**
  String get quizResult;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct Answers'**
  String get correctAnswers;

  /// No description provided for @wrongAnswers.
  ///
  /// In en, this message translates to:
  /// **'Wrong Answers'**
  String get wrongAnswers;

  /// No description provided for @totalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get totalQuestions;

  /// No description provided for @retakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get retakeQuiz;

  /// No description provided for @submitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get submitQuiz;

  /// No description provided for @submitQuizConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to submit your answers?'**
  String get submitQuizConfirm;

  /// No description provided for @keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep Practicing'**
  String get keepPracticing;

  /// No description provided for @findNextCourse.
  ///
  /// In en, this message translates to:
  /// **'Find Your Next Course'**
  String get findNextCourse;

  /// No description provided for @startTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing to see the magic happen!'**
  String get startTyping;

  /// No description provided for @searchForCourses.
  ///
  /// In en, this message translates to:
  /// **'Search for courses...'**
  String get searchForCourses;

  /// No description provided for @noCoursesFound.
  ///
  /// In en, this message translates to:
  /// **'No courses found'**
  String get noCoursesFound;

  /// No description provided for @noCoursesCategory.
  ///
  /// In en, this message translates to:
  /// **'There are no Courses available in this category yet'**
  String get noCoursesCategory;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @filterCourses.
  ///
  /// In en, this message translates to:
  /// **'Filter Courses'**
  String get filterCourses;

  /// No description provided for @allLevels.
  ///
  /// In en, this message translates to:
  /// **'All Levels'**
  String get allLevels;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// No description provided for @paymentSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'You now have full access to the course. Start learning now!'**
  String get paymentSuccessDesc;

  /// No description provided for @teacherDashboard.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get teacherDashboard;

  /// No description provided for @createCourse.
  ///
  /// In en, this message translates to:
  /// **'Create Course'**
  String get createCourse;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @studentProgress.
  ///
  /// In en, this message translates to:
  /// **'Student Progress'**
  String get studentProgress;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @myCourse.
  ///
  /// In en, this message translates to:
  /// **'My Course'**
  String get myCourse;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedIn;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @extraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extraLarge;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get tabCourses;

  /// No description provided for @tabQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get tabQuizzes;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @errorLoadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Error loading video'**
  String get errorLoadingVideo;

  /// No description provided for @frequentlyAskedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// No description provided for @resetPasswordFaq.
  ///
  /// In en, this message translates to:
  /// **'How do I reset my password?'**
  String get resetPasswordFaq;

  /// No description provided for @resetPasswordAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to the login screen and tap \"Forgot Password\". Follow the instructions sent to your email.'**
  String get resetPasswordAnswer;

  /// No description provided for @changeEmailFaq.
  ///
  /// In en, this message translates to:
  /// **'How can I change my email or phone number?'**
  String get changeEmailFaq;

  /// No description provided for @changeEmailAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open Settings > Account > Personal Info and update your email or phone number. We may ask you to verify the change.'**
  String get changeEmailAnswer;

  /// No description provided for @updateAppFaq.
  ///
  /// In en, this message translates to:
  /// **'How do I update the app to the latest version?'**
  String get updateAppFaq;

  /// No description provided for @updateAppAnswer.
  ///
  /// In en, this message translates to:
  /// **'Visit the App Store/Google Play, search for our app, and tap \"Update\". Keeping the app up to date ensures the best experience.'**
  String get updateAppAnswer;

  /// No description provided for @verificationEmailFaq.
  ///
  /// In en, this message translates to:
  /// **'Why didn\'t I receive the verification email?'**
  String get verificationEmailFaq;

  /// No description provided for @verificationEmailAnswer.
  ///
  /// In en, this message translates to:
  /// **'Please check your Spam/Junk folder and ensure you entered the correct email. If needed, tap \"Resend\" on the verification screen.'**
  String get verificationEmailAnswer;

  /// No description provided for @cancelSubscriptionFaq.
  ///
  /// In en, this message translates to:
  /// **'How do I cancel my subscription?'**
  String get cancelSubscriptionFaq;

  /// No description provided for @cancelSubscriptionAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Subscription and follow the cancellation steps. If you subscribed via App Store/Google Play, manage it in your store settings.'**
  String get cancelSubscriptionAnswer;

  /// No description provided for @refundsFaq.
  ///
  /// In en, this message translates to:
  /// **'Do you offer refunds?'**
  String get refundsFaq;

  /// No description provided for @refundsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Refunds follow our policy and the rules of the payment platform used. Please contact support with your order ID for assistance.'**
  String get refundsAnswer;

  /// No description provided for @offlineModeFaq.
  ///
  /// In en, this message translates to:
  /// **'Can I use the app offline?'**
  String get offlineModeFaq;

  /// No description provided for @offlineModeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Some features may work offline, but certain content and sync actions require an internet connection.'**
  String get offlineModeAnswer;

  /// No description provided for @deleteAccountFaq.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account and data?'**
  String get deleteAccountFaq;

  /// No description provided for @deleteAccountAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Privacy > Delete Account. This action is permanent and will remove your personal data where legally allowed.'**
  String get deleteAccountAnswer;

  /// No description provided for @exportDataFaq.
  ///
  /// In en, this message translates to:
  /// **'How can I export my data?'**
  String get exportDataFaq;

  /// No description provided for @exportDataAnswer.
  ///
  /// In en, this message translates to:
  /// **'Request a data export via Settings > Privacy > Data Export. We will prepare a machine-readable file and notify you by email.'**
  String get exportDataAnswer;

  /// No description provided for @paymentFailedFaq.
  ///
  /// In en, this message translates to:
  /// **'My payment failed—what should I do?'**
  String get paymentFailedFaq;

  /// No description provided for @paymentFailedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check that your card has sufficient funds, is enabled for online purchases, and matches your billing info. Try again or use another method.'**
  String get paymentFailedAnswer;

  /// No description provided for @reportBugFaq.
  ///
  /// In en, this message translates to:
  /// **'How do I report a bug or suggest a feature?'**
  String get reportBugFaq;

  /// No description provided for @reportBugAnswer.
  ///
  /// In en, this message translates to:
  /// **'Use Settings > Help & Support > Send Feedback, or email support@yourapp.com with screenshots and a short description.'**
  String get reportBugAnswer;

  /// No description provided for @supportedDevicesFaq.
  ///
  /// In en, this message translates to:
  /// **'What devices and OS versions are supported?'**
  String get supportedDevicesFaq;

  /// No description provided for @supportedDevicesAnswer.
  ///
  /// In en, this message translates to:
  /// **'We support recent iOS and Android versions. For the best performance, keep your OS and the app updated to the latest stable release.'**
  String get supportedDevicesAnswer;

  /// No description provided for @emailSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Get help via email'**
  String get emailSupportDesc;

  /// No description provided for @emailSupportSub.
  ///
  /// In en, this message translates to:
  /// **'Get help via email'**
  String get emailSupportSub;

  /// No description provided for @liveChatSub.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team'**
  String get liveChatSub;

  /// No description provided for @callUsSub.
  ///
  /// In en, this message translates to:
  /// **'Speak with a representative'**
  String get callUsSub;

  /// No description provided for @liveChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support team'**
  String get liveChatDesc;

  /// No description provided for @callUsDesc.
  ///
  /// In en, this message translates to:
  /// **'Speak with a representative'**
  String get callUsDesc;

  /// No description provided for @flutterBootcamp.
  ///
  /// In en, this message translates to:
  /// **'Flutter Development Bootcamp'**
  String get flutterBootcamp;

  /// No description provided for @flutterBootcampDesc.
  ///
  /// In en, this message translates to:
  /// **'Master Flutter and Dart from scratch. Build real-world cross-platform apps.'**
  String get flutterBootcampDesc;

  /// No description provided for @uiuxMasterclass.
  ///
  /// In en, this message translates to:
  /// **'UI/UX Design Masterclass'**
  String get uiuxMasterclass;

  /// No description provided for @uiuxMasterclassDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn professional UI/UX design from scratch using Figma and Adobe XD'**
  String get uiuxMasterclassDesc;

  /// No description provided for @digitalMarketingEssentials.
  ///
  /// In en, this message translates to:
  /// **'Digital Marketing Essentials'**
  String get digitalMarketingEssentials;

  /// No description provided for @digitalMarketingDesc.
  ///
  /// In en, this message translates to:
  /// **'Master digital marketing strategies for business growth.'**
  String get digitalMarketingDesc;

  /// No description provided for @advancedMobileArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Advanced Mobile App Architecture'**
  String get advancedMobileArchitecture;

  /// No description provided for @advancedMobileArchitectureDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn advanced architectural patterns and best practices for mobile app development.'**
  String get advancedMobileArchitectureDesc;

  /// No description provided for @motionDesignAE.
  ///
  /// In en, this message translates to:
  /// **'Motion Design with After Effects'**
  String get motionDesignAE;

  /// No description provided for @motionDesignAEDesc.
  ///
  /// In en, this message translates to:
  /// **'Create stunning motion graphics and visual effects using Adobe After Effects.'**
  String get motionDesignAEDesc;

  /// No description provided for @financialManagement.
  ///
  /// In en, this message translates to:
  /// **'Financial Management Fundamentals'**
  String get financialManagement;

  /// No description provided for @financialManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Master the basics of financial management and business economics.'**
  String get financialManagementDesc;

  /// No description provided for @professionalPhotography.
  ///
  /// In en, this message translates to:
  /// **'Professional Photography Masterclass'**
  String get professionalPhotography;

  /// No description provided for @professionalPhotographyDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn professional photography techniques from composition to post-processing.'**
  String get professionalPhotographyDesc;

  /// No description provided for @englishBusinessComm.
  ///
  /// In en, this message translates to:
  /// **'English Business Communication'**
  String get englishBusinessComm;

  /// No description provided for @englishBusinessCommDesc.
  ///
  /// In en, this message translates to:
  /// **'Master business English for professional success.'**
  String get englishBusinessCommDesc;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I reset my password?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'Go to the login screen and tap \"Forgot Password\". Follow the instructions sent to your email.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'How can I change my email or phone number?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'Open Settings > Account > Personal Info and update your email or phone number. We may ask you to verify the change.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I update the app to the latest version?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'Visit the App Store/Google Play, search for our app, and tap \"Update\". Keeping the app up to date ensures the best experience.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'Why didn\'t I receive the verification email?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'Please check your Spam/Junk folder and ensure you entered the correct email. If needed, tap \"Resend\" on the verification screen.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'How do I cancel my subscription?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Subscription and follow the cancellation steps. If you subscribed via App Store/Google Play, manage it in your store settings.'**
  String get faqA5;

  /// No description provided for @faqQ6.
  ///
  /// In en, this message translates to:
  /// **'Do you offer refunds?'**
  String get faqQ6;

  /// No description provided for @faqA6.
  ///
  /// In en, this message translates to:
  /// **'Refunds follow our policy and the rules of the payment platform used. Please contact support with your order ID for assistance.'**
  String get faqA6;

  /// No description provided for @faqQ7.
  ///
  /// In en, this message translates to:
  /// **'Can I use the app offline?'**
  String get faqQ7;

  /// No description provided for @faqA7.
  ///
  /// In en, this message translates to:
  /// **'Some features may work offline, but certain content and sync actions require an internet connection.'**
  String get faqA7;

  /// No description provided for @faqQ8.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account and data?'**
  String get faqQ8;

  /// No description provided for @faqA8.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Privacy > Delete Account. This action is permanent and will remove your personal data where legally allowed.'**
  String get faqA8;

  /// No description provided for @faqQ9.
  ///
  /// In en, this message translates to:
  /// **'How can I export my data?'**
  String get faqQ9;

  /// No description provided for @faqA9.
  ///
  /// In en, this message translates to:
  /// **'Request a data export via Settings > Privacy > Data Export. We will prepare a machine-readable file and notify you by email.'**
  String get faqA9;

  /// No description provided for @faqQ10.
  ///
  /// In en, this message translates to:
  /// **'My payment failed — what should I do?'**
  String get faqQ10;

  /// No description provided for @faqA10.
  ///
  /// In en, this message translates to:
  /// **'Check that your card has sufficient funds, is enabled for online purchases, and matches your billing info. Try again or use another method.'**
  String get faqA10;

  /// No description provided for @faqQ11.
  ///
  /// In en, this message translates to:
  /// **'How do I report a bug or suggest a feature?'**
  String get faqQ11;

  /// No description provided for @faqA11.
  ///
  /// In en, this message translates to:
  /// **'Use Settings > Help & Support > Send Feedback, or email support@yourapp.com with screenshots and a short description.'**
  String get faqA11;

  /// No description provided for @faqQ12.
  ///
  /// In en, this message translates to:
  /// **'What devices and OS versions are supported?'**
  String get faqQ12;

  /// No description provided for @faqA12.
  ///
  /// In en, this message translates to:
  /// **'We support recent iOS and Android versions. For the best performance, keep your OS and the app updated to the latest stable release.'**
  String get faqA12;

  /// No description provided for @createCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Course'**
  String get createCourseTitle;

  /// No description provided for @editCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Course'**
  String get editCourseTitle;

  /// No description provided for @courseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Title'**
  String get courseTitle;

  /// No description provided for @courseTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter course title'**
  String get courseTitleHint;

  /// No description provided for @courseTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get courseTitleRequired;

  /// No description provided for @courseDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get courseDescription;

  /// No description provided for @courseDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter course description'**
  String get courseDescriptionHint;

  /// No description provided for @courseDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get courseDescriptionRequired;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get priceHint;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get priceRequired;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @premiumCourseLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium Course'**
  String get premiumCourseLabel;

  /// No description provided for @prerequisitesLabel.
  ///
  /// In en, this message translates to:
  /// **'Prerequisites'**
  String get prerequisitesLabel;

  /// No description provided for @selectPrerequisites.
  ///
  /// In en, this message translates to:
  /// **'Select Prerequisites'**
  String get selectPrerequisites;

  /// No description provided for @courseRequirementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Course Requirements'**
  String get courseRequirementsLabel;

  /// No description provided for @whatYouWillLearnLabel.
  ///
  /// In en, this message translates to:
  /// **'What You Will Learn'**
  String get whatYouWillLearnLabel;

  /// No description provided for @courseLessons.
  ///
  /// In en, this message translates to:
  /// **'Course Lessons'**
  String get courseLessons;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addLesson.
  ///
  /// In en, this message translates to:
  /// **'Add Lesson'**
  String get addLesson;

  /// No description provided for @lessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson Title'**
  String get lessonTitle;

  /// No description provided for @lessonTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter lesson title'**
  String get lessonTitleHint;

  /// No description provided for @lessonDescription.
  ///
  /// In en, this message translates to:
  /// **'Lesson Description'**
  String get lessonDescription;

  /// No description provided for @lessonDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter lesson description'**
  String get lessonDescriptionHint;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// No description provided for @durationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter duration'**
  String get durationHint;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @addVideo.
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get addVideo;

  /// No description provided for @changeVideo.
  ///
  /// In en, this message translates to:
  /// **'Change Video'**
  String get changeVideo;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @resourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get resourceLabel;

  /// No description provided for @addResource.
  ///
  /// In en, this message translates to:
  /// **'Add Resource'**
  String get addResource;

  /// No description provided for @addCourseThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Add Course Thumbnail'**
  String get addCourseThumbnail;

  /// No description provided for @changeThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Change Thumbnail'**
  String get changeThumbnail;

  /// No description provided for @selectThumbnailError.
  ///
  /// In en, this message translates to:
  /// **'Please select a course thumbnail'**
  String get selectThumbnailError;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryError;

  /// No description provided for @addLessonError.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one lesson'**
  String get addLessonError;

  /// No description provided for @lessonTitleError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title for Lesson'**
  String get lessonTitleError;

  /// No description provided for @lessonDescriptionError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description for Lesson'**
  String get lessonDescriptionError;

  /// No description provided for @lessonVideoError.
  ///
  /// In en, this message translates to:
  /// **'Please upload a video for Lesson'**
  String get lessonVideoError;

  /// No description provided for @lessonDurationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid duration for lesson'**
  String get lessonDurationError;

  /// No description provided for @courseCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Course created successfully'**
  String get courseCreatedSuccess;

  /// No description provided for @courseUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Course updated successfully'**
  String get courseUpdatedSuccess;

  /// No description provided for @failedToCreateCourse.
  ///
  /// In en, this message translates to:
  /// **'Failed to create course'**
  String get failedToCreateCourse;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get failedToLoadCategories;

  /// No description provided for @failedToLoadCourses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load courses'**
  String get failedToLoadCourses;

  /// No description provided for @failedToAddResource.
  ///
  /// In en, this message translates to:
  /// **'Failed to add resource'**
  String get failedToAddResource;

  /// No description provided for @failedToPickVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick video'**
  String get failedToPickVideo;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @failedToInitPlayer.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize player'**
  String get failedToInitPlayer;

  /// No description provided for @unknownCourse.
  ///
  /// In en, this message translates to:
  /// **'Unknown Course'**
  String get unknownCourse;

  /// No description provided for @createQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Quiz'**
  String get createQuizTitle;

  /// No description provided for @editQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Quiz'**
  String get editQuizTitle;

  /// No description provided for @quizTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Quiz Title'**
  String get quizTitleLabel;

  /// No description provided for @quizTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter quiz title'**
  String get quizTitleHint;

  /// No description provided for @quizTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get quizTitleRequired;

  /// No description provided for @quizDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get quizDescriptionLabel;

  /// No description provided for @quizDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter quiz description'**
  String get quizDescriptionHint;

  /// No description provided for @quizDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get quizDescriptionRequired;

  /// No description provided for @timeLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Time Limit (minutes)'**
  String get timeLimitLabel;

  /// No description provided for @timeLimitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 30'**
  String get timeLimitHint;

  /// No description provided for @timeLimitRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter time limit'**
  String get timeLimitRequired;

  /// No description provided for @uploadDocxTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Questions from Word File'**
  String get uploadDocxTitle;

  /// No description provided for @uploadDocxButton.
  ///
  /// In en, this message translates to:
  /// **'Upload .docx file'**
  String get uploadDocxButton;

  /// No description provided for @uploadDocxSub.
  ///
  /// In en, this message translates to:
  /// **'Only .docx format is supported'**
  String get uploadDocxSub;

  /// No description provided for @formatHintTitle.
  ///
  /// In en, this message translates to:
  /// **'File Format'**
  String get formatHintTitle;

  /// No description provided for @formatHintBody.
  ///
  /// In en, this message translates to:
  /// **'1. Question text?\nA) variant a\nB) variant B\nV) variant B\nG) variant d\n\n denote the correct answer in format A.'**
  String get formatHintBody;

  /// No description provided for @parsingFile.
  ///
  /// In en, this message translates to:
  /// **'Parsing file...'**
  String get parsingFile;

  /// No description provided for @parsedQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parsed Questions'**
  String get parsedQuestionsTitle;

  /// No description provided for @questionsCount.
  ///
  /// In en, this message translates to:
  /// **'questions'**
  String get questionsCount;

  /// No description provided for @questionsAdded.
  ///
  /// In en, this message translates to:
  /// **'questions added'**
  String get questionsAdded;

  /// No description provided for @addToQuiz.
  ///
  /// In en, this message translates to:
  /// **'Add to Quiz'**
  String get addToQuiz;

  /// No description provided for @questionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questionsLabel;

  /// No description provided for @noQuestionsYet.
  ///
  /// In en, this message translates to:
  /// **'No questions yet. Upload a Word file.'**
  String get noQuestionsYet;

  /// No description provided for @noQuestionsFound.
  ///
  /// In en, this message translates to:
  /// **'No questions found in the file. Check the format.'**
  String get noQuestionsFound;

  /// No description provided for @addAtLeastOneQuestion.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one question'**
  String get addAtLeastOneQuestion;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correctAnswer;

  /// No description provided for @quizCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Quiz created successfully'**
  String get quizCreatedSuccess;

  /// No description provided for @quizUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Quiz updated successfully'**
  String get quizUpdatedSuccess;

  /// No description provided for @failedToSaveQuiz.
  ///
  /// In en, this message translates to:
  /// **'Failed to save quiz'**
  String get failedToSaveQuiz;

  /// No description provided for @failedToParseFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse file'**
  String get failedToParseFile;

  /// No description provided for @createQuiz.
  ///
  /// In en, this message translates to:
  /// **'Create Quiz'**
  String get createQuiz;

  /// No description provided for @myQuizzes.
  ///
  /// In en, this message translates to:
  /// **'My Quizzes'**
  String get myQuizzes;

  /// No description provided for @myQuizHistory.
  ///
  /// In en, this message translates to:
  /// **'My Quiz History'**
  String get myQuizHistory;

  /// No description provided for @noAttemptsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t taken any quizzes yet'**
  String get noAttemptsYet;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get points;

  /// No description provided for @totalStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get totalStudents;

  /// No description provided for @avgScore.
  ///
  /// In en, this message translates to:
  /// **'Avg Score'**
  String get avgScore;

  /// No description provided for @noStudentsYet.
  ///
  /// In en, this message translates to:
  /// **'No students have taken this quiz yet'**
  String get noStudentsYet;

  /// No description provided for @studentResults.
  ///
  /// In en, this message translates to:
  /// **'Student Results'**
  String get studentResults;

  /// No description provided for @noQuizzesYet.
  ///
  /// In en, this message translates to:
  /// **'No quizzes yet'**
  String get noQuizzesYet;

  /// No description provided for @quizResults.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResults;

  /// No description provided for @groupChat.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get groupChat;

  /// No description provided for @groupChatSub.
  ///
  /// In en, this message translates to:
  /// **'Everyone can chat here'**
  String get groupChatSub;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @beFirstToMessage.
  ///
  /// In en, this message translates to:
  /// **'Be the first to say something!'**
  String get beFirstToMessage;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @areyousure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areyousure;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
