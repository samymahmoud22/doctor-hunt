///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Doctor Hunt'
	String get appName => 'Doctor Hunt';

	late final Translations$onboarding$en onboarding = Translations$onboarding$en.internal(_root);
	late final Translations$role$en role = Translations$role$en.internal(_root);
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$home$en home = Translations$home$en.internal(_root);
	late final Translations$doctors$en doctors = Translations$doctors$en.internal(_root);
	late final Translations$admin$en admin = Translations$admin$en.internal(_root);
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find Trusted Doctors'
	String get title1 => 'Find Trusted Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get desc1 => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Choose Best Doctors'
	String get title2 => 'Choose Best Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get desc2 => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Easy Appointments'
	String get title3 => 'Easy Appointments';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get desc3 => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Get Started'
	String get getStarted => 'Get Started';

	/// en: 'Skip'
	String get skip => 'Skip';
}

// Path: role
class Translations$role$en {
	Translations$role$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose your role'
	String get title => 'Choose your role';

	/// en: 'The selected role determines the experience and available features.'
	String get subtitle => 'The selected role determines the experience and available features.';

	/// en: 'Patient'
	String get patient => 'Patient';

	/// en: 'Find doctors, book appointments, and manage your medical records.'
	String get patientDesc => 'Find doctors, book appointments, and manage your medical records.';

	/// en: 'Admin'
	String get admin => 'Admin';

	/// en: 'Manage doctors, appointments, users, and the platform.'
	String get adminDesc => 'Manage doctors, appointments, users, and the platform.';

	/// en: 'Continue'
	String get continueBtn => 'Continue';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome Back'
	String get welcomeBack => 'Welcome Back';

	/// en: 'Sign in to continue your healthcare journey'
	String get loginSubtitle => 'Sign in to continue your healthcare journey';

	/// en: 'Create Account'
	String get createAccount => 'Create Account';

	/// en: 'Join Doctor Hunt to book appointments & manage health'
	String get registerSubtitle => 'Join Doctor Hunt to book appointments & manage health';

	/// en: 'Forgot Password'
	String get forgotPassword => 'Forgot Password';

	/// en: 'Enter your email to receive password reset link'
	String get forgotSubtitle => 'Enter your email to receive password reset link';

	/// en: 'Email Address'
	String get emailLabel => 'Email Address';

	/// en: 'example@domain.com'
	String get emailHint => 'example@domain.com';

	/// en: 'Password'
	String get passwordLabel => 'Password';

	/// en: '••••••••'
	String get passwordHint => '••••••••';

	/// en: 'Full Name'
	String get fullNameLabel => 'Full Name';

	/// en: 'John Doe'
	String get fullNameHint => 'John Doe';

	/// en: 'Remember Me'
	String get rememberMe => 'Remember Me';

	/// en: 'Forgot Password?'
	String get forgotPasswordLink => 'Forgot Password?';

	/// en: 'Sign In'
	String get loginBtn => 'Sign In';

	/// en: 'Sign Up'
	String get registerBtn => 'Sign Up';

	/// en: 'Send Reset Link'
	String get resetBtn => 'Send Reset Link';

	/// en: 'Or sign in with'
	String get socialSignIn => 'Or sign in with';

	/// en: 'Google'
	String get google => 'Google';

	/// en: 'Facebook'
	String get facebook => 'Facebook';

	/// en: 'Don't have an account?'
	String get noAccount => 'Don\'t have an account?';

	/// en: 'Already have an account?'
	String get haveAccount => 'Already have an account?';

	/// en: 'Sign Up'
	String get signUpLink => 'Sign Up';

	/// en: 'Sign In'
	String get signInLink => 'Sign In';

	/// en: 'I agree to the Terms of Service & Privacy Policy'
	String get termsAgree => 'I agree to the Terms of Service & Privacy Policy';

	/// en: 'Join us to start searching'
	String get joinUsTitle => 'Join us to start searching';

	/// en: 'Welcome back'
	String get welcomeBackTitle => 'Welcome back';

	/// en: 'You can search course, apply course and find scholarship for abroad studies'
	String get authSubtitle => 'You can search course, apply course and find scholarship for abroad studies';

	/// en: 'Name'
	String get nameHint => 'Name';

	/// en: 'Email'
	String get emailFieldHint => 'Email';

	/// en: 'Password'
	String get passwordFieldHint => 'Password';

	/// en: 'I agree with the Terms of Service & Privacy Policy'
	String get termsAgreeText => 'I agree with the Terms of Service & Privacy Policy';

	/// en: 'Sign up'
	String get signUpBtn => 'Sign up';

	/// en: 'Have an account?'
	String get haveAccountLogIn => 'Have an account?';

	/// en: 'Log in'
	String get logInLink => 'Log in';

	/// en: 'Enter your email for the verification process. We will send a 6-digit code to your email.'
	String get forgotPasswordSubtitleSheet => 'Enter your email for the verification process. We will send a 6-digit code to your email.';

	/// en: 'Enter 6 Digits Code'
	String get enter4DigitsCode => 'Enter 6 Digits Code';

	/// en: 'Enter the 6-digit code that you received on your email.'
	String get enter4DigitsSubtitle => 'Enter the 6-digit code that you received on your email.';

	/// en: 'Reset Password'
	String get resetPasswordTitle => 'Reset Password';

	/// en: 'Set the new password for your account so you can login and access all the features.'
	String get resetPasswordSubtitle => 'Set the new password for your account so you can login and access all the features.';

	/// en: 'New Password'
	String get newPasswordHint => 'New Password';

	/// en: 'Re-enter Password'
	String get reenterPasswordHint => 'Re-enter Password';

	/// en: 'Update Password'
	String get updatePasswordBtn => 'Update Password';

	/// en: 'Continue'
	String get continueBtn => 'Continue';

	/// en: 'Don't have an account?'
	String get dontHaveAccount => 'Don\'t have an account?';

	/// en: 'Join us'
	String get joinUsLink => 'Join us';
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search...'
	String get search => 'Search...';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'Book Now'
	String get bookNow => 'Book Now';

	/// en: 'Book Appointment'
	String get bookAppointment => 'Book Appointment';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Success'
	String get success => 'Success';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Select a slot'
	String get selectSlot => 'Select a slot';

	/// en: 'Back'
	String get back => 'Back';
}

// Path: home
class Translations$home$en {
	Translations$home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hi Handwerker!'
	String get greeting => 'Hi Handwerker!';

	/// en: 'Find Your Doctor'
	String get findDoctor => 'Find Your Doctor';

	/// en: 'Live Doctors'
	String get liveDoctors => 'Live Doctors';

	/// en: 'Popular Doctors'
	String get popularDoctors => 'Popular Doctors';

	/// en: 'Top Rated Doctors'
	String get topRatedDoctors => 'Top Rated Doctors';

	/// en: 'Feature Doctors'
	String get featureDoctors => 'Feature Doctors';

	/// en: 'Dentist'
	String get dentist => 'Dentist';

	/// en: 'Cardiology'
	String get cardiology => 'Cardiology';

	/// en: 'Eye Special'
	String get eye => 'Eye Special';

	/// en: 'General'
	String get general => 'General';

	/// en: 'My Appointments'
	String get appointments => 'My Appointments';

	/// en: 'Your booked doctor appointments will appear here.'
	String get appointmentsDesc => 'Your booked doctor appointments will appear here.';

	/// en: 'All Appointments'
	String get allAppointments => 'All Appointments';

	/// en: 'Manage and review system-wide doctor appointments.'
	String get allAppointmentsDesc => 'Manage and review system-wide doctor appointments.';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Switch to'
	String get switchRole => 'Switch to';

	/// en: 'Categories'
	String get categories => 'Categories';
}

// Path: doctors
class Translations$doctors$en {
	Translations$doctors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find Doctors'
	String get findDoctors => 'Find Doctors';

	/// en: 'Doctor Details'
	String get doctorDetails => 'Doctor Details';

	/// en: 'Select Time'
	String get selectTime => 'Select Time';

	/// en: 'Popular Doctors'
	String get popularDoctors => 'Popular Doctors';

	/// en: 'Top Rated Doctors'
	String get topRatedDoctors => 'Top Rated Doctors';

	/// en: 'Favourite Doctors'
	String get favouriteDoctors => 'Favourite Doctors';

	/// en: 'Live Chat'
	String get liveChat => 'Live Chat';

	/// en: 'Experience'
	String get experience => 'Experience';

	/// en: 'Patients'
	String get patients => 'Patients';

	/// en: 'Reviews'
	String get reviews => 'Reviews';

	/// en: 'About Doctor'
	String get aboutDoctor => 'About Doctor';

	/// en: 'Services'
	String get services => 'Services';

	/// en: 'Next Available'
	String get nextAvailable => 'Next Available';

	/// en: 'Booking Confirmed!'
	String get bookingConfirmed => 'Booking Confirmed!';

	/// en: 'Your appointment has been successfully booked.'
	String get bookingSuccess => 'Your appointment has been successfully booked.';

	/// en: 'slots available'
	String get slotsAvailable => 'slots available';

	/// en: 'No slots available'
	String get noSlotsAvailable => 'No slots available';

	/// en: 'No doctors found'
	String get noDoctorsFound => 'No doctors found';

	/// en: 'No favorite doctors saved yet.'
	String get noFavoritesSaved => 'No favorite doctors saved yet.';

	/// en: 'Try adjusting your search or specialty filters.'
	String get adjustSearchFilters => 'Try adjusting your search or specialty filters.';

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Tomorrow'
	String get tomorrow => 'Tomorrow';

	/// en: 'Afternoon'
	String get afternoon => 'Afternoon';

	/// en: 'Evening'
	String get evening => 'Evening';

	/// en: 'Type a message...'
	String get typeMessage => 'Type a message...';

	/// en: 'Send'
	String get send => 'Send';
}

// Path: admin
class Translations$admin$en {
	Translations$admin$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'ADMIN PORTAL'
	String get adminPortal => 'ADMIN PORTAL';

	/// en: 'System Overview'
	String get systemOverview => 'System Overview';

	/// en: 'Total Patients'
	String get totalPatients => 'Total Patients';

	/// en: 'Total Doctors'
	String get totalDoctors => 'Total Doctors';

	/// en: 'Today Appointments'
	String get todayAppointments => 'Today Appointments';

	/// en: 'Pending Requests'
	String get pendingRequests => 'Pending Requests';

	/// en: 'Recent Appointment Requests'
	String get recentAppointments => 'Recent Appointment Requests';

	/// en: 'Approve'
	String get approve => 'Approve';

	/// en: 'Reject'
	String get reject => 'Reject';

	/// en: 'Approved'
	String get approved => 'Approved';

	/// en: 'Rejected'
	String get rejected => 'Rejected';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Doctor Hunt',
			'onboarding.title1' => 'Find Trusted Doctors',
			'onboarding.desc1' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'onboarding.title2' => 'Choose Best Doctors',
			'onboarding.desc2' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'onboarding.title3' => 'Easy Appointments',
			'onboarding.desc3' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'onboarding.next' => 'Next',
			'onboarding.getStarted' => 'Get Started',
			'onboarding.skip' => 'Skip',
			'role.title' => 'Choose your role',
			'role.subtitle' => 'The selected role determines the experience and available features.',
			'role.patient' => 'Patient',
			'role.patientDesc' => 'Find doctors, book appointments, and manage your medical records.',
			'role.admin' => 'Admin',
			'role.adminDesc' => 'Manage doctors, appointments, users, and the platform.',
			'role.continueBtn' => 'Continue',
			'auth.welcomeBack' => 'Welcome Back',
			'auth.loginSubtitle' => 'Sign in to continue your healthcare journey',
			'auth.createAccount' => 'Create Account',
			'auth.registerSubtitle' => 'Join Doctor Hunt to book appointments & manage health',
			'auth.forgotPassword' => 'Forgot Password',
			'auth.forgotSubtitle' => 'Enter your email to receive password reset link',
			'auth.emailLabel' => 'Email Address',
			'auth.emailHint' => 'example@domain.com',
			'auth.passwordLabel' => 'Password',
			'auth.passwordHint' => '••••••••',
			'auth.fullNameLabel' => 'Full Name',
			'auth.fullNameHint' => 'John Doe',
			'auth.rememberMe' => 'Remember Me',
			'auth.forgotPasswordLink' => 'Forgot Password?',
			'auth.loginBtn' => 'Sign In',
			'auth.registerBtn' => 'Sign Up',
			'auth.resetBtn' => 'Send Reset Link',
			'auth.socialSignIn' => 'Or sign in with',
			'auth.google' => 'Google',
			'auth.facebook' => 'Facebook',
			'auth.noAccount' => 'Don\'t have an account?',
			'auth.haveAccount' => 'Already have an account?',
			'auth.signUpLink' => 'Sign Up',
			'auth.signInLink' => 'Sign In',
			'auth.termsAgree' => 'I agree to the Terms of Service & Privacy Policy',
			'auth.joinUsTitle' => 'Join us to start searching',
			'auth.welcomeBackTitle' => 'Welcome back',
			'auth.authSubtitle' => 'You can search course, apply course and find scholarship for abroad studies',
			'auth.nameHint' => 'Name',
			'auth.emailFieldHint' => 'Email',
			'auth.passwordFieldHint' => 'Password',
			'auth.termsAgreeText' => 'I agree with the Terms of Service & Privacy Policy',
			'auth.signUpBtn' => 'Sign up',
			'auth.haveAccountLogIn' => 'Have an account?',
			'auth.logInLink' => 'Log in',
			'auth.forgotPasswordSubtitleSheet' => 'Enter your email for the verification process. We will send a 6-digit code to your email.',
			'auth.enter4DigitsCode' => 'Enter 6 Digits Code',
			'auth.enter4DigitsSubtitle' => 'Enter the 6-digit code that you received on your email.',
			'auth.resetPasswordTitle' => 'Reset Password',
			'auth.resetPasswordSubtitle' => 'Set the new password for your account so you can login and access all the features.',
			'auth.newPasswordHint' => 'New Password',
			'auth.reenterPasswordHint' => 'Re-enter Password',
			'auth.updatePasswordBtn' => 'Update Password',
			'auth.continueBtn' => 'Continue',
			'auth.dontHaveAccount' => 'Don\'t have an account?',
			'auth.joinUsLink' => 'Join us',
			'common.search' => 'Search...',
			'common.seeAll' => 'See all',
			'common.bookNow' => 'Book Now',
			'common.bookAppointment' => 'Book Appointment',
			'common.cancel' => 'Cancel',
			'common.done' => 'Done',
			'common.save' => 'Save',
			'common.edit' => 'Edit',
			'common.delete' => 'Delete',
			'common.error' => 'Error',
			'common.success' => 'Success',
			'common.loading' => 'Loading...',
			'common.confirm' => 'Confirm',
			'common.selectSlot' => 'Select a slot',
			'common.back' => 'Back',
			'home.greeting' => 'Hi Handwerker!',
			'home.findDoctor' => 'Find Your Doctor',
			'home.liveDoctors' => 'Live Doctors',
			'home.popularDoctors' => 'Popular Doctors',
			'home.featureDoctors' => 'Feature Doctors',
			'home.dentist' => 'Dentist',
			'home.cardiology' => 'Cardiology',
			'home.eye' => 'Eye Special',
			'home.general' => 'General',
			'home.appointments' => 'My Appointments',
			'home.appointmentsDesc' => 'Your booked doctor appointments will appear here.',
			'home.allAppointments' => 'All Appointments',
			'home.allAppointmentsDesc' => 'Manage and review system-wide doctor appointments.',
			'home.profile' => 'Profile',
			'home.switchRole' => 'Switch to',
			'home.categories' => 'Categories',
			'doctors.findDoctors' => 'Find Doctors',
			'doctors.doctorDetails' => 'Doctor Details',
			'doctors.selectTime' => 'Select Time',
			'doctors.popularDoctors' => 'Popular Doctors',
			'doctors.favouriteDoctors' => 'Favourite Doctors',
			'doctors.liveChat' => 'Live Chat',
			'doctors.experience' => 'Experience',
			'doctors.patients' => 'Patients',
			'doctors.reviews' => 'Reviews',
			'doctors.aboutDoctor' => 'About Doctor',
			'doctors.services' => 'Services',
			'doctors.nextAvailable' => 'Next Available',
			'doctors.bookingConfirmed' => 'Booking Confirmed!',
			'doctors.bookingSuccess' => 'Your appointment has been successfully booked.',
			'doctors.slotsAvailable' => 'slots available',
			'doctors.noSlotsAvailable' => 'No slots available',
			'doctors.today' => 'Today',
			'doctors.tomorrow' => 'Tomorrow',
			'doctors.afternoon' => 'Afternoon',
			'doctors.evening' => 'Evening',
			'doctors.typeMessage' => 'Type a message...',
			'doctors.send' => 'Send',
			'admin.adminPortal' => 'ADMIN PORTAL',
			'admin.systemOverview' => 'System Overview',
			'admin.totalPatients' => 'Total Patients',
			'admin.totalDoctors' => 'Total Doctors',
			'admin.todayAppointments' => 'Today Appointments',
			'admin.pendingRequests' => 'Pending Requests',
			'admin.recentAppointments' => 'Recent Appointment Requests',
			'admin.approve' => 'Approve',
			'admin.reject' => 'Reject',
			'admin.approved' => 'Approved',
			'admin.rejected' => 'Rejected',
			_ => null,
		};
	}
}
