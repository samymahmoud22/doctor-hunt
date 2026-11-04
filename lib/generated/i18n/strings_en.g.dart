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
	late final Translations$appointments$en appointments = Translations$appointments$en.internal(_root);
	late final Translations$profile$en profile = Translations$profile$en.internal(_root);
	late final Translations$drawer$en drawer = Translations$drawer$en.internal(_root);
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

	/// en: 'Booked'
	String get booked => 'Booked';
}

// Path: admin
class Translations$admin$en {
	Translations$admin$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctors'
	String get doctors => 'Doctors';

	/// en: 'Active Doctors'
	String get activeDoctors => 'Active Doctors';

	/// en: 'Total Doctors'
	String get totalDoctors => 'Total Doctors';

	/// en: 'Search doctors...'
	String get searchDoctor => 'Search doctors...';

	/// en: 'Add Doctor'
	String get addDoctor => 'Add Doctor';

	/// en: 'No Doctors Found'
	String get noDoctorsFound => 'No Doctors Found';

	/// en: 'There are currently no doctors registered on Doctor Hunt. Add your first doctor to get started.'
	String get noDoctorsDesc => 'There are currently no doctors registered on Doctor Hunt. Add your first doctor to get started.';

	/// en: 'Appointments'
	String get appointments => 'Appointments';

	/// en: 'All'
	String get all => 'All';

	/// en: 'Availability'
	String get availability => 'Availability';

	/// en: 'Select Working Days'
	String get selectWorkingDays => 'Select Working Days';

	/// en: 'Working Hours'
	String get workingHours => 'Working Hours';

	/// en: 'Save Schedule'
	String get saveSchedule => 'Save Schedule';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Admin Portal'
	String get adminPortal => 'Admin Portal';
}

// Path: appointments
class Translations$appointments$en {
	Translations$appointments$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Appointments'
	String get myAppointments => 'My Appointments';

	/// en: 'Upcoming'
	String get upcoming => 'Upcoming';

	/// en: 'Completed'
	String get completed => 'Completed';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: 'Cancel Appointment'
	String get cancelAppointment => 'Cancel Appointment';

	/// en: 'Are you sure you want to cancel this appointment?'
	String get cancelConfirm => 'Are you sure you want to cancel this appointment?';

	/// en: 'Rate Doctor'
	String get rateDoctor => 'Rate Doctor';

	/// en: 'Appointment Details'
	String get appointmentDetails => 'Appointment Details';

	/// en: 'Patient Information'
	String get patientInfo => 'Patient Information';

	/// en: 'Doctor Information'
	String get doctorInfo => 'Doctor Information';

	/// en: 'Date & Time'
	String get dateAndTime => 'Date & Time';

	/// en: 'Consultation Fee'
	String get fee => 'Consultation Fee';

	/// en: 'Status'
	String get status => 'Status';

	/// en: 'Clinic Location'
	String get location => 'Clinic Location';

	/// en: 'Reschedule'
	String get reschedule => 'Reschedule';

	/// en: 'Leave a Review'
	String get leaveReview => 'Leave a Review';

	/// en: 'Submit Review'
	String get submitReview => 'Submit Review';

	/// en: 'COMMENT (OPTIONAL)'
	String get commentOptional => 'COMMENT (OPTIONAL)';

	/// en: 'Share your consultation experience...'
	String get shareExperience => 'Share your consultation experience...';

	/// en: 'No appointments found'
	String get noAppointments => 'No appointments found';

	/// en: 'Your booked doctor appointments will appear here.'
	String get noAppointmentsDesc => 'Your booked doctor appointments will appear here.';

	/// en: 'Cancelled'
	String get cancelledBadge => 'Cancelled';

	/// en: 'Upcoming'
	String get upcomingBadge => 'Upcoming';

	/// en: 'Completed'
	String get completedBadge => 'Completed';
}

// Path: profile
class Translations$profile$en {
	Translations$profile$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Account settings'
	String get accountSettings => 'Account settings';

	/// en: 'Personal Information'
	String get personalInfo => 'Personal Information';

	/// en: 'Change Password'
	String get changePassword => 'Change Password';

	/// en: 'Enter new password'
	String get enterNewPassword => 'Enter new password';

	/// en: 'Enter your new password (minimum 6 characters):'
	String get newPasswordMinChars => 'Enter your new password (minimum 6 characters):';

	/// en: 'Update'
	String get update => 'Update';

	/// en: 'Log Out'
	String get logout => 'Log Out';

	/// en: 'Are you sure you want to logout?'
	String get logoutConfirm => 'Are you sure you want to logout?';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Privacy Policy'
	String get privacyPolicy => 'Privacy Policy';

	/// en: 'Terms of Service'
	String get termsOfService => 'Terms of Service';

	/// en: 'Help & Support'
	String get helpAndSupport => 'Help & Support';

	/// en: 'What is your name?'
	String get nameQuestion => 'What is your name?';

	/// en: 'Your Phone Number'
	String get phoneQuestion => 'Your Phone Number';

	/// en: 'Your Full Name'
	String get fullNameHint => 'Your Full Name';

	/// en: '+20 100 000 0000'
	String get phoneHint => '+20 100 000 0000';

	/// en: 'Save Changes'
	String get saveChanges => 'Save Changes';

	/// en: 'Password changed successfully'
	String get passwordChangedSuccess => 'Password changed successfully';

	/// en: 'Password must be at least 6 characters'
	String get passwordMinLength => 'Password must be at least 6 characters';

	/// en: 'Password updated in local session'
	String get passwordUpdatedLocal => 'Password updated in local session';

	/// en: 'Ok'
	String get ok => 'Ok';
}

// Path: drawer
class Translations$drawer$en {
	Translations$drawer$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'My Doctors'
	String get myDoctors => 'My Doctors';

	/// en: 'Medical Records'
	String get medicalRecords => 'Medical Records';

	/// en: 'Payment Methods'
	String get paymentMethods => 'Payment Methods';

	/// en: 'Favourites'
	String get favourites => 'Favourites';

	/// en: 'My Appointments'
	String get myAppointments => 'My Appointments';

	/// en: 'Payments'
	String get payments => 'Payments';

	/// en: 'Medicine Orders'
	String get medicineOrders => 'Medicine Orders';

	/// en: 'Help Center'
	String get helpCenter => 'Help Center';
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
			'home.topRatedDoctors' => 'Top Rated Doctors',
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
			'doctors.topRatedDoctors' => 'Top Rated Doctors',
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
			'doctors.noDoctorsFound' => 'No doctors found',
			'doctors.noFavoritesSaved' => 'No favorite doctors saved yet.',
			'doctors.adjustSearchFilters' => 'Try adjusting your search or specialty filters.',
			'doctors.today' => 'Today',
			'doctors.tomorrow' => 'Tomorrow',
			'doctors.afternoon' => 'Afternoon',
			'doctors.evening' => 'Evening',
			'doctors.typeMessage' => 'Type a message...',
			'doctors.send' => 'Send',
			'doctors.booked' => 'Booked',
			'admin.doctors' => 'Doctors',
			'admin.activeDoctors' => 'Active Doctors',
			'admin.totalDoctors' => 'Total Doctors',
			'admin.searchDoctor' => 'Search doctors...',
			'admin.addDoctor' => 'Add Doctor',
			'admin.noDoctorsFound' => 'No Doctors Found',
			'admin.noDoctorsDesc' => 'There are currently no doctors registered on Doctor Hunt. Add your first doctor to get started.',
			'admin.appointments' => 'Appointments',
			'admin.all' => 'All',
			'admin.availability' => 'Availability',
			'admin.selectWorkingDays' => 'Select Working Days',
			'admin.workingHours' => 'Working Hours',
			'admin.saveSchedule' => 'Save Schedule',
			'admin.settings' => 'Settings',
			'admin.adminPortal' => 'Admin Portal',
			'appointments.myAppointments' => 'My Appointments',
			'appointments.upcoming' => 'Upcoming',
			'appointments.completed' => 'Completed',
			'appointments.cancelled' => 'Cancelled',
			'appointments.cancelAppointment' => 'Cancel Appointment',
			'appointments.cancelConfirm' => 'Are you sure you want to cancel this appointment?',
			'appointments.rateDoctor' => 'Rate Doctor',
			'appointments.appointmentDetails' => 'Appointment Details',
			'appointments.patientInfo' => 'Patient Information',
			'appointments.doctorInfo' => 'Doctor Information',
			'appointments.dateAndTime' => 'Date & Time',
			'appointments.fee' => 'Consultation Fee',
			'appointments.status' => 'Status',
			'appointments.location' => 'Clinic Location',
			'appointments.reschedule' => 'Reschedule',
			'appointments.leaveReview' => 'Leave a Review',
			'appointments.submitReview' => 'Submit Review',
			'appointments.commentOptional' => 'COMMENT (OPTIONAL)',
			'appointments.shareExperience' => 'Share your consultation experience...',
			'appointments.noAppointments' => 'No appointments found',
			'appointments.noAppointmentsDesc' => 'Your booked doctor appointments will appear here.',
			'appointments.cancelledBadge' => 'Cancelled',
			'appointments.upcomingBadge' => 'Upcoming',
			'appointments.completedBadge' => 'Completed',
			'profile.settings' => 'Settings',
			'profile.accountSettings' => 'Account settings',
			'profile.personalInfo' => 'Personal Information',
			'profile.changePassword' => 'Change Password',
			'profile.enterNewPassword' => 'Enter new password',
			'profile.newPasswordMinChars' => 'Enter your new password (minimum 6 characters):',
			'profile.update' => 'Update',
			'profile.logout' => 'Log Out',
			'profile.logoutConfirm' => 'Are you sure you want to logout?',
			'profile.notifications' => 'Notifications',
			'profile.language' => 'Language',
			'profile.privacyPolicy' => 'Privacy Policy',
			'profile.termsOfService' => 'Terms of Service',
			'profile.helpAndSupport' => 'Help & Support',
			'profile.nameQuestion' => 'What is your name?',
			'profile.phoneQuestion' => 'Your Phone Number',
			'profile.fullNameHint' => 'Your Full Name',
			'profile.phoneHint' => '+20 100 000 0000',
			'profile.saveChanges' => 'Save Changes',
			'profile.passwordChangedSuccess' => 'Password changed successfully',
			'profile.passwordMinLength' => 'Password must be at least 6 characters',
			'profile.passwordUpdatedLocal' => 'Password updated in local session',
			'profile.ok' => 'Ok',
			'drawer.myDoctors' => 'My Doctors',
			'drawer.medicalRecords' => 'Medical Records',
			'drawer.paymentMethods' => 'Payment Methods',
			'drawer.favourites' => 'Favourites',
			'drawer.myAppointments' => 'My Appointments',
			'drawer.payments' => 'Payments',
			'drawer.medicineOrders' => 'Medicine Orders',
			'drawer.helpCenter' => 'Help Center',
			_ => null,
		};
	}
}
