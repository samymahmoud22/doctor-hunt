///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'دكتور هانت';
	@override late final _Translations$onboarding$ar onboarding = _Translations$onboarding$ar._(_root);
	@override late final _Translations$role$ar role = _Translations$role$ar._(_root);
	@override late final _Translations$auth$ar auth = _Translations$auth$ar._(_root);
	@override late final _Translations$common$ar common = _Translations$common$ar._(_root);
	@override late final _Translations$home$ar home = _Translations$home$ar._(_root);
	@override late final _Translations$doctors$ar doctors = _Translations$doctors$ar._(_root);
	@override late final _Translations$admin$ar admin = _Translations$admin$ar._(_root);
	@override late final _Translations$appointments$ar appointments = _Translations$appointments$ar._(_root);
	@override late final _Translations$profile$ar profile = _Translations$profile$ar._(_root);
	@override late final _Translations$drawer$ar drawer = _Translations$drawer$ar._(_root);
}

// Path: onboarding
class _Translations$onboarding$ar extends Translations$onboarding$en {
	_Translations$onboarding$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title1 => 'ابحث عن أطباء موثوقين';
	@override String get desc1 => 'اعثر على أفضل الأطباء والمتخصصين واستشر أطباء معتمدين بسهولة وفي أي وقت.';
	@override String get title2 => 'اختر أفضل الأطباء';
	@override String get desc2 => 'تصفح التقييمات وخبرات الأطباء واختر الطبيب الأنسب لاحتياجاتك الصحية.';
	@override String get title3 => 'حجوزات سهلة وسريعة';
	@override String get desc3 => 'احجز مواعيدك الطبية بضغطة زر واحدة وتابع كشوفاتك بكل سهولة.';
	@override String get next => 'التالي';
	@override String get getStarted => 'ابدأ الآن';
	@override String get skip => 'تخطي';
}

// Path: role
class _Translations$role$ar extends Translations$role$en {
	_Translations$role$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'حدد نوع الحساب';
	@override String get subtitle => 'اختر كيف تريد استخدام تطبيق دكتور هانت';
	@override String get patient => 'مريض';
	@override String get patientDesc => 'البحث عن الأطباء وحجز المواعيد وإدارة الملف الطبي';
	@override String get admin => 'مسؤول / طبيب';
	@override String get adminDesc => 'إدارة مواعيد العيادة والجدول الزمني واستشارات المرضى';
	@override String get continueBtn => 'متابعة';
}

// Path: auth
class _Translations$auth$ar extends Translations$auth$en {
	_Translations$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get welcomeBack => 'مرحباً بك مجدداً';
	@override String get loginSubtitle => 'قم بتسجيل الدخول لمتابعة خدماتك الطبية';
	@override String get createAccount => 'إنشاء حساب جديد';
	@override String get registerSubtitle => 'انضم إلى دكتور هانت لحجز المواعيد وإدارة صحتك';
	@override String get forgotPassword => 'نسيت كلمة السر';
	@override String get forgotSubtitle => 'أدخل بريدك الإلكتروني لإرسال رابط إعادة الضبط';
	@override String get emailLabel => 'البريد الإلكتروني';
	@override String get emailHint => 'example@domain.com';
	@override String get passwordLabel => 'كلمة المرور';
	@override String get passwordHint => '••••••••';
	@override String get fullNameLabel => 'الاسم الكامل';
	@override String get fullNameHint => 'أحمد محمد';
	@override String get rememberMe => 'تذكرني';
	@override String get forgotPasswordLink => 'نسيت كلمة المرور؟';
	@override String get loginBtn => 'تسجيل الدخول';
	@override String get registerBtn => 'إنشاء حساب';
	@override String get resetBtn => 'إرسال رابط الضبط';
	@override String get socialSignIn => 'أو سجل الدخول عبر';
	@override String get google => 'جوجل';
	@override String get facebook => 'فيسبوك';
	@override String get noAccount => 'ليس لديك حساب؟';
	@override String get haveAccount => 'لديك حساب بالفعل؟';
	@override String get signUpLink => 'سجل الآن';
	@override String get signInLink => 'تسجيل الدخول';
	@override String get termsAgree => 'أوافق على شروط الخدمة وسياسة الخصوصية';
	@override String get joinUsTitle => 'انضم إلينا لبدء البحث';
	@override String get welcomeBackTitle => 'مرحباً بعودتك';
	@override String get authSubtitle => 'يمكنك البحث عن الأطباء وحجز المواعيد واستشارة أفضل المتخصصين';
	@override String get nameHint => 'الاسم';
	@override String get emailFieldHint => 'البريد الإلكتروني';
	@override String get passwordFieldHint => 'كلمة المرور';
	@override String get termsAgreeText => 'أوافق على شروط الخدمة وسياسة الخصوصية';
	@override String get signUpBtn => 'تسجيل حساب';
	@override String get haveAccountLogIn => 'لديك حساب بالفعل؟';
	@override String get logInLink => 'تسجيل الدخول';
	@override String get forgotPasswordSubtitleSheet => 'أدخل بريدك الإلكتروني لعملية التحقق. سنرسل رمزاً مكوناً من 6 أرقام إلى بريدك.';
	@override String get enter4DigitsCode => 'أدخل الرمز المكون من 6 أرقام';
	@override String get enter4DigitsSubtitle => 'أدخل الرمز المكون من 6 أرقام الذي استلمته على بريدك الإلكتروني.';
	@override String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';
	@override String get resetPasswordSubtitle => 'قم بتعيين كلمة المرور الجديدة لحسابك لتتمكن من تسجيل الدخول واستخدام كافة الميزات.';
	@override String get newPasswordHint => 'كلمة المرور الجديدة';
	@override String get reenterPasswordHint => 'إعادة إدخال كلمة المرور';
	@override String get updatePasswordBtn => 'تحديث كلمة المرور';
	@override String get continueBtn => 'متابعة';
	@override String get dontHaveAccount => 'ليس لديك حساب؟';
	@override String get joinUsLink => 'انضم إلينا';
}

// Path: common
class _Translations$common$ar extends Translations$common$en {
	_Translations$common$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get search => 'بحث...';
	@override String get seeAll => 'عرض الكل';
	@override String get bookNow => 'احجز الآن';
	@override String get bookAppointment => 'حجز موعد';
	@override String get cancel => 'إلغاء';
	@override String get done => 'تم';
	@override String get save => 'حفظ';
	@override String get edit => 'تعديل';
	@override String get delete => 'حذف';
	@override String get error => 'خطأ';
	@override String get success => 'نجاح';
	@override String get loading => 'جاري التحميل...';
	@override String get confirm => 'تأكيد';
	@override String get selectSlot => 'اختر موعداً';
	@override String get back => 'رجوع';
}

// Path: home
class _Translations$home$ar extends Translations$home$en {
	_Translations$home$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get greeting => 'مرحباً هاندويركر!';
	@override String get findDoctor => 'ابحث عن طبيبك';
	@override String get liveDoctors => 'أطباء متاحون الآن';
	@override String get popularDoctors => 'أطباء مشهورون';
	@override String get topRatedDoctors => 'الأطباء الأعلى تقييماً';
	@override String get featureDoctors => 'أطباء مميزون';
	@override String get dentist => 'طبيب أسنان';
	@override String get cardiology => 'أمراض القلب';
	@override String get eye => 'عيون';
	@override String get general => 'طب عام';
	@override String get appointments => 'مواعيدي';
	@override String get appointmentsDesc => 'ستظهر مواعيدك الطبية المحجوزة هنا.';
	@override String get allAppointments => 'جميع المواعيد';
	@override String get allAppointmentsDesc => 'إدارة ومراجعة مواعيد الأطباء في النظام.';
	@override String get profile => 'الملف الشخصي';
	@override String get switchRole => 'التبديل إلى';
	@override String get categories => 'الفئات';
}

// Path: doctors
class _Translations$doctors$ar extends Translations$doctors$en {
	_Translations$doctors$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get findDoctors => 'البحث عن الأطباء';
	@override String get doctorDetails => 'تفاصيل الطبيب';
	@override String get selectTime => 'تحديد الموعد';
	@override String get popularDoctors => 'الأطباء المشهورون';
	@override String get topRatedDoctors => 'الأطباء الأعلى تقييماً';
	@override String get favouriteDoctors => 'الأطباء المفضلون';
	@override String get liveChat => 'محادثة مباشرة';
	@override String get experience => 'الخبرة';
	@override String get patients => 'المرضى';
	@override String get reviews => 'التقييمات';
	@override String get aboutDoctor => 'عن الطبيب';
	@override String get services => 'الخدمات';
	@override String get nextAvailable => 'الموعد القادم المتاح';
	@override String get bookingConfirmed => 'تم تأكيد الحجز!';
	@override String get bookingSuccess => 'تم حجز موعدك الطبي بنجاح.';
	@override String get slotsAvailable => 'مواعيد متاحة';
	@override String get noSlotsAvailable => 'لا توجد مواعيد متاحة';
	@override String get noDoctorsFound => 'لم يتم العثور على أطباء';
	@override String get noFavoritesSaved => 'لا يوجد أطباء مفضلون حتى الآن.';
	@override String get adjustSearchFilters => 'جرب تعديل البحث أو الفلاتر.';
	@override String get today => 'اليوم';
	@override String get tomorrow => 'غداً';
	@override String get afternoon => 'بعد الظهر';
	@override String get evening => 'المساء';
	@override String get typeMessage => 'اكتب رسالة...';
	@override String get send => 'إرسال';
	@override String get booked => 'محجوز';
}

// Path: admin
class _Translations$admin$ar extends Translations$admin$en {
	_Translations$admin$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get doctors => 'الأطباء';
	@override String get activeDoctors => 'الأطباء النشطون';
	@override String get totalDoctors => 'إجمالي الأطباء';
	@override String get searchDoctor => 'البحث عن طبيب...';
	@override String get addDoctor => 'إضافة طبيب';
	@override String get noDoctorsFound => 'لم يتم العثور على أطباء';
	@override String get noDoctorsDesc => 'لا يوجد حالياً أطباء مسجلون في التطبيق. أضف طبيبك الأول للبدء.';
	@override String get appointments => 'المواعيد';
	@override String get all => 'الكل';
	@override String get availability => 'المواعيد المتاحة';
	@override String get selectWorkingDays => 'اختر أيام العمل';
	@override String get workingHours => 'ساعات العمل';
	@override String get saveSchedule => 'حفظ الجدول';
	@override String get settings => 'الإعدادات';
	@override String get adminPortal => 'بوابة المسؤول';
}

// Path: appointments
class _Translations$appointments$ar extends Translations$appointments$en {
	_Translations$appointments$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get myAppointments => 'مواعيدي';
	@override String get upcoming => 'القادمة';
	@override String get completed => 'المكتملة';
	@override String get cancelled => 'الملغاة';
	@override String get cancelAppointment => 'إلغاء الموعد';
	@override String get cancelConfirm => 'هل أنت متأكد من إلغاء هذا الموعد؟';
	@override String get rateDoctor => 'تقييم الطبيب';
	@override String get appointmentDetails => 'تفاصيل الموعد';
	@override String get patientInfo => 'بيانات المريض';
	@override String get doctorInfo => 'بيانات الطبيب';
	@override String get dateAndTime => 'التاريخ والوقت';
	@override String get fee => 'رسوم الكشف';
	@override String get status => 'الحالة';
	@override String get location => 'عنوان العيادة';
	@override String get reschedule => 'إعادة جدولة';
	@override String get leaveReview => 'أضف تقييمك';
	@override String get submitReview => 'إرسال التقييم';
	@override String get commentOptional => 'تعليق (اختياري)';
	@override String get shareExperience => 'شاركنا تجربتك في الاستشارة...';
	@override String get noAppointments => 'لا توجد مواعيد';
	@override String get noAppointmentsDesc => 'ستظهر مواعيدك الطبية المحجوزة هنا.';
	@override String get cancelledBadge => 'ملغي';
	@override String get upcomingBadge => 'قادم';
	@override String get completedBadge => 'مكتمل';
}

// Path: profile
class _Translations$profile$ar extends Translations$profile$en {
	_Translations$profile$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'الإعدادات';
	@override String get accountSettings => 'إعدادات الحساب';
	@override String get personalInfo => 'المعلومات الشخصية';
	@override String get changePassword => 'تغيير كلمة المرور';
	@override String get enterNewPassword => 'أدخل كلمة المرور الجديدة';
	@override String get newPasswordMinChars => 'أدخل كلمة المرور الجديدة (6 أحرف على الأقل):';
	@override String get update => 'تحديث';
	@override String get logout => 'تسجيل الخروج';
	@override String get logoutConfirm => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';
	@override String get notifications => 'الإشعارات';
	@override String get language => 'اللغة';
	@override String get privacyPolicy => 'سياسة الخصوصية';
	@override String get termsOfService => 'شروط الخدمة';
	@override String get helpAndSupport => 'المساعدة والدعم';
	@override String get nameQuestion => 'ما هو اسمك؟';
	@override String get phoneQuestion => 'رقم الهاتف';
	@override String get fullNameHint => 'اسمك الكامل';
	@override String get phoneHint => '+20 100 000 0000';
	@override String get saveChanges => 'حفظ التغييرات';
	@override String get passwordChangedSuccess => 'تم تغيير كلمة المرور بنجاح';
	@override String get passwordMinLength => 'يجب ألا تقل كلمة المرور عن 6 أحرف';
	@override String get passwordUpdatedLocal => 'تم تحديث كلمة المرور في الجلسة الحالية';
	@override String get ok => 'حسناً';
}

// Path: drawer
class _Translations$drawer$ar extends Translations$drawer$en {
	_Translations$drawer$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get myDoctors => 'أطبائي';
	@override String get medicalRecords => 'السجلات الطبية';
	@override String get paymentMethods => 'طرق الدفع';
	@override String get favourites => 'المفضلة';
	@override String get myAppointments => 'مواعيدي';
	@override String get payments => 'المدفوعات';
	@override String get medicineOrders => 'طلبات الأدوية';
	@override String get helpCenter => 'مركز المساعدة';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'دكتور هانت',
			'onboarding.title1' => 'ابحث عن أطباء موثوقين',
			'onboarding.desc1' => 'اعثر على أفضل الأطباء والمتخصصين واستشر أطباء معتمدين بسهولة وفي أي وقت.',
			'onboarding.title2' => 'اختر أفضل الأطباء',
			'onboarding.desc2' => 'تصفح التقييمات وخبرات الأطباء واختر الطبيب الأنسب لاحتياجاتك الصحية.',
			'onboarding.title3' => 'حجوزات سهلة وسريعة',
			'onboarding.desc3' => 'احجز مواعيدك الطبية بضغطة زر واحدة وتابع كشوفاتك بكل سهولة.',
			'onboarding.next' => 'التالي',
			'onboarding.getStarted' => 'ابدأ الآن',
			'onboarding.skip' => 'تخطي',
			'role.title' => 'حدد نوع الحساب',
			'role.subtitle' => 'اختر كيف تريد استخدام تطبيق دكتور هانت',
			'role.patient' => 'مريض',
			'role.patientDesc' => 'البحث عن الأطباء وحجز المواعيد وإدارة الملف الطبي',
			'role.admin' => 'مسؤول / طبيب',
			'role.adminDesc' => 'إدارة مواعيد العيادة والجدول الزمني واستشارات المرضى',
			'role.continueBtn' => 'متابعة',
			'auth.welcomeBack' => 'مرحباً بك مجدداً',
			'auth.loginSubtitle' => 'قم بتسجيل الدخول لمتابعة خدماتك الطبية',
			'auth.createAccount' => 'إنشاء حساب جديد',
			'auth.registerSubtitle' => 'انضم إلى دكتور هانت لحجز المواعيد وإدارة صحتك',
			'auth.forgotPassword' => 'نسيت كلمة السر',
			'auth.forgotSubtitle' => 'أدخل بريدك الإلكتروني لإرسال رابط إعادة الضبط',
			'auth.emailLabel' => 'البريد الإلكتروني',
			'auth.emailHint' => 'example@domain.com',
			'auth.passwordLabel' => 'كلمة المرور',
			'auth.passwordHint' => '••••••••',
			'auth.fullNameLabel' => 'الاسم الكامل',
			'auth.fullNameHint' => 'أحمد محمد',
			'auth.rememberMe' => 'تذكرني',
			'auth.forgotPasswordLink' => 'نسيت كلمة المرور؟',
			'auth.loginBtn' => 'تسجيل الدخول',
			'auth.registerBtn' => 'إنشاء حساب',
			'auth.resetBtn' => 'إرسال رابط الضبط',
			'auth.socialSignIn' => 'أو سجل الدخول عبر',
			'auth.google' => 'جوجل',
			'auth.facebook' => 'فيسبوك',
			'auth.noAccount' => 'ليس لديك حساب؟',
			'auth.haveAccount' => 'لديك حساب بالفعل؟',
			'auth.signUpLink' => 'سجل الآن',
			'auth.signInLink' => 'تسجيل الدخول',
			'auth.termsAgree' => 'أوافق على شروط الخدمة وسياسة الخصوصية',
			'auth.joinUsTitle' => 'انضم إلينا لبدء البحث',
			'auth.welcomeBackTitle' => 'مرحباً بعودتك',
			'auth.authSubtitle' => 'يمكنك البحث عن الأطباء وحجز المواعيد واستشارة أفضل المتخصصين',
			'auth.nameHint' => 'الاسم',
			'auth.emailFieldHint' => 'البريد الإلكتروني',
			'auth.passwordFieldHint' => 'كلمة المرور',
			'auth.termsAgreeText' => 'أوافق على شروط الخدمة وسياسة الخصوصية',
			'auth.signUpBtn' => 'تسجيل حساب',
			'auth.haveAccountLogIn' => 'لديك حساب بالفعل؟',
			'auth.logInLink' => 'تسجيل الدخول',
			'auth.forgotPasswordSubtitleSheet' => 'أدخل بريدك الإلكتروني لعملية التحقق. سنرسل رمزاً مكوناً من 6 أرقام إلى بريدك.',
			'auth.enter4DigitsCode' => 'أدخل الرمز المكون من 6 أرقام',
			'auth.enter4DigitsSubtitle' => 'أدخل الرمز المكون من 6 أرقام الذي استلمته على بريدك الإلكتروني.',
			'auth.resetPasswordTitle' => 'إعادة تعيين كلمة المرور',
			'auth.resetPasswordSubtitle' => 'قم بتعيين كلمة المرور الجديدة لحسابك لتتمكن من تسجيل الدخول واستخدام كافة الميزات.',
			'auth.newPasswordHint' => 'كلمة المرور الجديدة',
			'auth.reenterPasswordHint' => 'إعادة إدخال كلمة المرور',
			'auth.updatePasswordBtn' => 'تحديث كلمة المرور',
			'auth.continueBtn' => 'متابعة',
			'auth.dontHaveAccount' => 'ليس لديك حساب؟',
			'auth.joinUsLink' => 'انضم إلينا',
			'common.search' => 'بحث...',
			'common.seeAll' => 'عرض الكل',
			'common.bookNow' => 'احجز الآن',
			'common.bookAppointment' => 'حجز موعد',
			'common.cancel' => 'إلغاء',
			'common.done' => 'تم',
			'common.save' => 'حفظ',
			'common.edit' => 'تعديل',
			'common.delete' => 'حذف',
			'common.error' => 'خطأ',
			'common.success' => 'نجاح',
			'common.loading' => 'جاري التحميل...',
			'common.confirm' => 'تأكيد',
			'common.selectSlot' => 'اختر موعداً',
			'common.back' => 'رجوع',
			'home.greeting' => 'مرحباً هاندويركر!',
			'home.findDoctor' => 'ابحث عن طبيبك',
			'home.liveDoctors' => 'أطباء متاحون الآن',
			'home.popularDoctors' => 'أطباء مشهورون',
			'home.topRatedDoctors' => 'الأطباء الأعلى تقييماً',
			'home.featureDoctors' => 'أطباء مميزون',
			'home.dentist' => 'طبيب أسنان',
			'home.cardiology' => 'أمراض القلب',
			'home.eye' => 'عيون',
			'home.general' => 'طب عام',
			'home.appointments' => 'مواعيدي',
			'home.appointmentsDesc' => 'ستظهر مواعيدك الطبية المحجوزة هنا.',
			'home.allAppointments' => 'جميع المواعيد',
			'home.allAppointmentsDesc' => 'إدارة ومراجعة مواعيد الأطباء في النظام.',
			'home.profile' => 'الملف الشخصي',
			'home.switchRole' => 'التبديل إلى',
			'home.categories' => 'الفئات',
			'doctors.findDoctors' => 'البحث عن الأطباء',
			'doctors.doctorDetails' => 'تفاصيل الطبيب',
			'doctors.selectTime' => 'تحديد الموعد',
			'doctors.popularDoctors' => 'الأطباء المشهورون',
			'doctors.topRatedDoctors' => 'الأطباء الأعلى تقييماً',
			'doctors.favouriteDoctors' => 'الأطباء المفضلون',
			'doctors.liveChat' => 'محادثة مباشرة',
			'doctors.experience' => 'الخبرة',
			'doctors.patients' => 'المرضى',
			'doctors.reviews' => 'التقييمات',
			'doctors.aboutDoctor' => 'عن الطبيب',
			'doctors.services' => 'الخدمات',
			'doctors.nextAvailable' => 'الموعد القادم المتاح',
			'doctors.bookingConfirmed' => 'تم تأكيد الحجز!',
			'doctors.bookingSuccess' => 'تم حجز موعدك الطبي بنجاح.',
			'doctors.slotsAvailable' => 'مواعيد متاحة',
			'doctors.noSlotsAvailable' => 'لا توجد مواعيد متاحة',
			'doctors.noDoctorsFound' => 'لم يتم العثور على أطباء',
			'doctors.noFavoritesSaved' => 'لا يوجد أطباء مفضلون حتى الآن.',
			'doctors.adjustSearchFilters' => 'جرب تعديل البحث أو الفلاتر.',
			'doctors.today' => 'اليوم',
			'doctors.tomorrow' => 'غداً',
			'doctors.afternoon' => 'بعد الظهر',
			'doctors.evening' => 'المساء',
			'doctors.typeMessage' => 'اكتب رسالة...',
			'doctors.send' => 'إرسال',
			'doctors.booked' => 'محجوز',
			'admin.doctors' => 'الأطباء',
			'admin.activeDoctors' => 'الأطباء النشطون',
			'admin.totalDoctors' => 'إجمالي الأطباء',
			'admin.searchDoctor' => 'البحث عن طبيب...',
			'admin.addDoctor' => 'إضافة طبيب',
			'admin.noDoctorsFound' => 'لم يتم العثور على أطباء',
			'admin.noDoctorsDesc' => 'لا يوجد حالياً أطباء مسجلون في التطبيق. أضف طبيبك الأول للبدء.',
			'admin.appointments' => 'المواعيد',
			'admin.all' => 'الكل',
			'admin.availability' => 'المواعيد المتاحة',
			'admin.selectWorkingDays' => 'اختر أيام العمل',
			'admin.workingHours' => 'ساعات العمل',
			'admin.saveSchedule' => 'حفظ الجدول',
			'admin.settings' => 'الإعدادات',
			'admin.adminPortal' => 'بوابة المسؤول',
			'appointments.myAppointments' => 'مواعيدي',
			'appointments.upcoming' => 'القادمة',
			'appointments.completed' => 'المكتملة',
			'appointments.cancelled' => 'الملغاة',
			'appointments.cancelAppointment' => 'إلغاء الموعد',
			'appointments.cancelConfirm' => 'هل أنت متأكد من إلغاء هذا الموعد؟',
			'appointments.rateDoctor' => 'تقييم الطبيب',
			'appointments.appointmentDetails' => 'تفاصيل الموعد',
			'appointments.patientInfo' => 'بيانات المريض',
			'appointments.doctorInfo' => 'بيانات الطبيب',
			'appointments.dateAndTime' => 'التاريخ والوقت',
			'appointments.fee' => 'رسوم الكشف',
			'appointments.status' => 'الحالة',
			'appointments.location' => 'عنوان العيادة',
			'appointments.reschedule' => 'إعادة جدولة',
			'appointments.leaveReview' => 'أضف تقييمك',
			'appointments.submitReview' => 'إرسال التقييم',
			'appointments.commentOptional' => 'تعليق (اختياري)',
			'appointments.shareExperience' => 'شاركنا تجربتك في الاستشارة...',
			'appointments.noAppointments' => 'لا توجد مواعيد',
			'appointments.noAppointmentsDesc' => 'ستظهر مواعيدك الطبية المحجوزة هنا.',
			'appointments.cancelledBadge' => 'ملغي',
			'appointments.upcomingBadge' => 'قادم',
			'appointments.completedBadge' => 'مكتمل',
			'profile.settings' => 'الإعدادات',
			'profile.accountSettings' => 'إعدادات الحساب',
			'profile.personalInfo' => 'المعلومات الشخصية',
			'profile.changePassword' => 'تغيير كلمة المرور',
			'profile.enterNewPassword' => 'أدخل كلمة المرور الجديدة',
			'profile.newPasswordMinChars' => 'أدخل كلمة المرور الجديدة (6 أحرف على الأقل):',
			'profile.update' => 'تحديث',
			'profile.logout' => 'تسجيل الخروج',
			'profile.logoutConfirm' => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
			'profile.notifications' => 'الإشعارات',
			'profile.language' => 'اللغة',
			'profile.privacyPolicy' => 'سياسة الخصوصية',
			'profile.termsOfService' => 'شروط الخدمة',
			'profile.helpAndSupport' => 'المساعدة والدعم',
			'profile.nameQuestion' => 'ما هو اسمك؟',
			'profile.phoneQuestion' => 'رقم الهاتف',
			'profile.fullNameHint' => 'اسمك الكامل',
			'profile.phoneHint' => '+20 100 000 0000',
			'profile.saveChanges' => 'حفظ التغييرات',
			'profile.passwordChangedSuccess' => 'تم تغيير كلمة المرور بنجاح',
			'profile.passwordMinLength' => 'يجب ألا تقل كلمة المرور عن 6 أحرف',
			'profile.passwordUpdatedLocal' => 'تم تحديث كلمة المرور في الجلسة الحالية',
			'profile.ok' => 'حسناً',
			'drawer.myDoctors' => 'أطبائي',
			'drawer.medicalRecords' => 'السجلات الطبية',
			'drawer.paymentMethods' => 'طرق الدفع',
			'drawer.favourites' => 'المفضلة',
			'drawer.myAppointments' => 'مواعيدي',
			'drawer.payments' => 'المدفوعات',
			'drawer.medicineOrders' => 'طلبات الأدوية',
			'drawer.helpCenter' => 'مركز المساعدة',
			_ => null,
		};
	}
}
