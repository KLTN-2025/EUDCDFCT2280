import 'package:flutter_localization/flutter_localization.dart';

// ignore: constant_identifier_names
const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("de", LocaleData.DE),
  MapLocale("fr", LocaleData.FR),
  MapLocale("es", LocaleData.ES),
  MapLocale("it", LocaleData.IT),
  MapLocale("pt", LocaleData.PT),
  MapLocale("zh", LocaleData.CN),
  MapLocale("ko", LocaleData.KR),
  MapLocale("ja", LocaleData.JP),
  MapLocale("ru", LocaleData.RU),
  MapLocale("vi", LocaleData.VN),
];

mixin LocaleData {
  static const String title = 'title';
  static const String title2 = 'title2';
  static const String title3 = 'title3';
  static const String title4 = 'title4';
  static const String body = 'body';
  static const String body2 = 'body2';
  static const String body3 = 'body3';
  static const String body4 = 'body4';
  static const String skip = 'skip';
  static const String next = 'next';
  static const String finish = 'finish';
  static const String settings = 'Settings';
  // ignore: constant_identifier_names
  static const String light_darkmode = 'light/dark mode';
  static const String language = 'language';
  // ignore: constant_identifier_names
  static const String app_name = 'app_name';
  // ignore: constant_identifier_names
  static const String enter_text = 'enter_text';
  // ignore: constant_identifier_names
  static const String converted_text = 'converted_text';
  // ignore: constant_identifier_names
  static const String converted_text_description = 'converted_text_description';
  static const String copy = 'copy';
  static const String reset = 'reset';
  static const String savePDF = 'savePDF';
  static const String saveWord = 'saveWord';
  static const String profile = 'profile';
  static const String feeds = 'feeds';
  static const String blog = 'blog';
  static const String achievements = 'achievements';
  static const String feedDS = 'feedDS';
  static const String blogDS = 'blogDS';
  static const String achievementsDS = 'achievementsDS';
  static const String aboutapp = 'aboutapp';
  static const String developerinfo = 'developerinfo';
  static const String appdescription = 'appdescription';
  static const String ecosiasr = 'ecosiasr';
  static const String ecosiaDS = 'ecosiaDS';
  static const String aiselection = 'aiselection';
  static const String aiinstruction = 'aiinstruction';
  static const String aibtt1 = 'aibtt1';
  static const String aibtt2 = 'aibtt2';
  static const String aibtt3 = 'aibtt3';
  static const String aiinfo = 'aiinfo';
  static const String historyname = 'historyname';
  static const String historystatus = 'historystatus';
  static const String loadHistory = 'loadHistory';
  static const String clearHistory = 'clearHistory';
  static const String confirmlogout = 'confirmlogout';
  static const String logoutDS = 'logoutDS';
  static const String cancel = 'cancel';
  static const String exit = 'exit';
  static const String seeyou = 'seeyou';
  static const String logoutbtt = 'logoutbtt';
  static const String emailtxt = 'emailtxt';
  static const String passwordtxt = 'passwordtxt';
  static const String loginbtt = 'loginbtt';
  static const String forgotpassword = 'forgotpassword';
  static const String forgotpasswordWord = 'forgotpasswordWord';
  static const String forgotpasswordHint = 'forgotpasswordHint';
  static const String forgotpasswordbtt = 'forgotpasswordbtt';
  static const String forgotpasswordEx = 'forgotpasswordEx';
  static const String forgotpasswordnotify = 'forgotpasswordnotify';
  static const String forgotpasswordEmail = 'forgotpasswordEmail';
  static const String or = 'or';
  static const String googletxt = 'googletxt';
  static const String signuptxt = 'signuptxt';
  static const String signupbtt = 'signupbtt';
  // ignore: constant_identifier_names
  static const String signup_name = 'signup_name';
  // ignore: constant_identifier_names
  static const String signup_email = 'signup_email';
  // ignore: constant_identifier_names
  static const String signup_password = 'signup_password';
  // ignore: constant_identifier_names
  static const String signup_confirmpassword = 'signup_confirmpassword';
  // ignore: constant_identifier_names
  static const String signup_btt = 'signup_btt';
  // ignore: constant_identifier_names
  static const String signup_passwordNoti = 'signup_passwordNoti';
  // ignore: constant_identifier_names
  static const String signup_Noti = 'signup_Noti';
  // ignore: constant_identifier_names
  static const String signup_Noti_invalid = 'signup_Noti_invalid';
  // ignore: constant_identifier_names
  static const String signup_Noti_8ch = 'signup_Noti_8ch';
  // ignore: constant_identifier_names
  static const String signup_field = 'signup_field';
  static const String resendEmail = 'resendEmail';
  static const String resendWait = 'resendWait';
  // ignore: constant_identifier_names
  static const String signup_alreadyDS = 'signup_alreadyDS';
  // ignore: constant_identifier_names
  static const String login_signup_btt = 'loginsignupbtt';
  // ignore: constant_identifier_names
  static const String login_email_hint = 'loginemailhint';
  // ignore: constant_identifier_names
  static const String login_password_hint = 'loginpasswordhint';
  static const String forgotpptxt = 'forgotpptxt';
  static const String forgotpphint = 'forgotpphint';
  static const String forgotppsendbtt = 'forgotppsendbtt';
  static const String forgotppPlenter = 'forgotppPlenter';
  static const String forgotppCheckmail = 'forgotppCheckmail';
  static const String ggcheckfail = 'ggcheckfail';
  static const String signupdonmatch = 'signupdonmatch';
  // ignore: constant_identifier_names
  static const String login_email_auth = 'login_email_auth';
  // ignore: constant_identifier_names
  static const String login_email_verify = 'login_email_verify';
  // ignore: constant_identifier_names
  static const String resPP_notify = 'resPP_notify';
  // ignore: constant_identifier_names
  static const String resPP_email_auth = 'resPP_email_auth';
  // ignore: constant_identifier_names
  static const String resPP_email_send = 'resPP_email_send';
  static const String resendEmailVerify = 'resendEmailVerify';
  static const String resendUserno = 'resendUserno';
  static const String resendEmailalready = 'resendEmailalready';
  // ignore: constant_identifier_names
  static const String signup_email_format = 'signup_email_format';
  // ignore: constant_identifier_names
  static const String signup_password_format = 'signup_password_format';
  // ignore: constant_identifier_names
  static const String signup_email_inbox = 'signup_email_inbox';
  static const String toolsselection = 'toolsselection';
  static const tool1 = 'tool1';
  static const enginedescription = 'enginedescription';
  static const aboutai = 'aboutai';
  static const previewscreen = 'previewscreen';
  static const pickatextcolor = 'pickatextcolor';
  static const previewstatus = 'previewstatus';
  // ignore: constant_identifier_names
  static const font_converter_title = 'font_converter_title';
  // ignore: constant_identifier_names
  static const new_font = 'new_font';
  // ignore: constant_identifier_names
  static const preview_title = 'preview_title';
  // ignore: constant_identifier_names
  static const result_converted = 'result_converted';
  static const uploadfile = 'uploadfile';
  static const fileconverted = 'fileconverted';
  static const selectedfromstorage = 'selectedfromstorage';
  static const selectedfromgoogledrive = 'selectedfromgoogledrive';
  static const downloadbtt = 'downloadbtt';
  static const nofiledownload = 'nofiledownload';
  static const filetoimage = 'filetoimage';
  static const sortofimage = 'sortofimage';
  static const noresult = 'nolresult';
  static const downloadall = 'downloadall';
  static const convertlanguage = 'convertlanguage';
  static const newlanguage = 'newlanguage';
  static const contentfileconverted = 'contentfileconverted';
  static const historyconvertedfiletoimage = 'historyconvertedfiletoimage';
  static const historyconvertedfilelanguage = 'historyconvertedfilelanguage';
  static const historyconvertedfiletolanguagetranslated =
      'historyconvertedfilelanguagetranslated';
  static const downloading = 'downloading';
  static const downloadcompleted = 'downloadcompleted';
  static const convertedfiletoimage = 'convertedfiletoimage';
  static const imagefrom = 'imagefrom';
  static const downloadthisimage = 'downloadthisimage';
  static const downloadthisallimage = 'downloadthisallimage';
  static const close = 'close';
  static const nohistory = 'nohistory';
  static const deleteconfirm = 'deleteconfirm';
  static const deleteconfirm2 = 'deleteconfirm2';
  static const deletebtt = 'deletebtt';
  static const deletewholehistory = 'deletewholehistory';
  static const deletewholehistory2 = 'deletewholehistory2';
  static const hasbeendeleted = 'hasbeendeleted';
  static const hasbeendeleted1file = 'hasbeendeleted1file';
  static const hasbeendeleted1image = 'hasbeendeleted1image';
  // ignore: constant_identifier_names
  static const language_appear = 'language_appear';
  // ignore: constant_identifier_names
  static const language_translated_success = 'language_translated_success';
  // ignore: constant_identifier_names
  static const language_detect_error = 'language_detect_error';
  // ignore: constant_identifier_names
  static const language_received = 'language_received';
  // ignore: constant_identifier_names
  static const language_error = 'language_error';
  // ignore: constant_identifier_names
  static const language_choose_method = 'language_choose_method';
  // ignore: constant_identifier_names
  static const language_ask = 'language_ask';
  // ignore: constant_identifier_names
  static const language_trans_all = 'language_trans_all';
  // ignore: constant_identifier_names
  static const language_trans_chunk = 'language_trans_chunk';
  // ignore: constant_identifier_names
  static const language_seperate = 'language_seperate';
  // ignore: constant_identifier_names
  static const language_trans_already = 'language_trans_already';
  // ignore: constant_identifier_names
  static const language_error_seperate = 'language_error_seperate';
  // ignore: constant_identifier_names
  static const language_convert = 'language_convert';
  // ignore: constant_identifier_names
  static const language_down_file = 'language_down_file';
  // ignore: constant_identifier_names
  static const all_convert_no = 'all_convert_no';
  // ignore: constant_identifier_names
  static const all_convert_no2 = 'all_convert_no2';
  static const ok = 'ok';
  // ignore: constant_identifier_names
  static const language_history = 'language_history';
  // ignore: constant_identifier_names
  static const language_file_chose = 'language_file_chose';
  // ignore: constant_identifier_names
  static const language_processing = 'language_processing';
  // ignore: constant_identifier_names
  static const download_file_trans = 'download_file_trans';
  // ignore: constant_identifier_names
  static const download_already = 'download_already';
  // ignore: constant_identifier_names
  static const download_this_file = 'download_this_file';
  // ignore: constant_identifier_names
  static const file_all = 'file_all';
  // ignore: constant_identifier_names
  static const file_ask = 'file_ask';
  // ignore: constant_identifier_names
  static const file_seperate = 'file_seperate';
  // ignore: constant_identifier_names
  static const file_choose_method = 'file_choose_method';
  // ignore: constant_identifier_names
  static const file_processing = 'file_processing';
  // ignore: constant_identifier_names
  static const file_process_temp = 'file_process_temp';
  // ignore: constant_identifier_names
  static const file_converted_success = 'file_converted_success';
  // ignore: constant_identifier_names
  static const file_converted_error = 'file_converted_error';
  // ignore: constant_identifier_names
  static const file_cannot_out = 'file_cannot_out';
  // ignore: constant_identifier_names
  static const file_cannot_out2 = 'file_cannot_out2';
  // ignore: constant_identifier_names
  static const file_history_title = 'file_history_title';
  // ignore: constant_identifier_names
  static const file_hasbeensaved = 'file_hasbeensaved';
  // ignore: constant_identifier_names
  static const file_open = 'file_open';
  // ignore: constant_identifier_names
  static const file_download = 'file_download';
  // ignore: constant_identifier_names
  static const file_downloading = 'file_downloading';
  // ignore: constant_identifier_names
  static const file_image = 'file_image';
  // ignore: constant_identifier_names
  static const file_image_hasbeenchose = 'file_image_hasbeenchose';
  // ignore: constant_identifier_names
  static const file_image_see = 'file_image_see';
  // ignore: constant_identifier_names
  static const downloading_image = 'downloading_image';
  // ignore: constant_identifier_names
  static const cannot_open_file = 'cannot_open_file';
  // ignore: constant_identifier_names
  static const no_image_to_download = 'no_image_to_download';
  // ignore: constant_identifier_names
  static const download_all_image = 'download_all_image';
  // ignore: constant_identifier_names
  static const file_saved = 'file_saved';
  // ignore: constant_identifier_names
  static const image_to_gallery = 'image_to_gallery';
  // ignore: constant_identifier_names
  static const open_gallery = 'open_gallery';
  // ignore: constant_identifier_names
  static const cannot_loading = 'cannot_loading';
  // ignore: constant_identifier_names
  static const no_image_saved = 'no_ image_saved';
  // ignore: constant_identifier_names
  static const download_already_all_image = 'download_already_all_image';
  // ignore: constant_identifier_names
  static const font_bold_word = 'font_bold_word';
  // ignore: constant_identifier_names
  static const font_received_server = 'font_received_server';
  // ignore: constant_identifier_names
  static const font_cannot_open = 'font_cannot_open';
  // ignore: constant_identifier_names
  static const font_download_error = 'font_download_error';
  // ignore: constant_identifier_names
  static const font_error_export = 'font_error_export';
  // ignore: constant_identifier_names
  static const font_edit = 'font_edit';
  // ignore: constant_identifier_names
  static const font_tip = 'font_tip';
  // ignore: constant_identifier_names
  static const font_content = 'font_content';
  // ignore: constant_identifier_names
  static const font_export_DOCX = 'font_export_DOCX';
  // ignore: constant_identifier_names
  static const font_export_PDF = 'font_export_PDF';
  // ignore: constant_identifier_names
  static const font_error_file = 'font_error_file';
  // ignore: constant_identifier_names
  static const font_converted = 'font_converted';
  // ignore: constant_identifier_names
  static const font_link_below = 'font_link_below';
  // ignore: constant_identifier_names
  static const font_no_text = 'font_no_text';
  // ignore: constant_identifier_names
  static const font_install = 'font_install';
  // ignore: constant_identifier_names
  static const font_instruction = 'font_instruction';
  // ignore: constant_identifier_names
  static const font_history = 'font_history';
  // ignore: constant_identifier_names
  static const font_done = 'font_done';
  // ignore: constant_identifier_names
  static const font_download_again = 'font_download_again';
  // ignore: constant_identifier_names
  static const font_history_screen = 'font_history_screen';
  // ignore: constant_identifier_names
  static const font_delete = 'font_delete';
  // ignore: constant_identifier_names
  static const font_delete_sure = 'font_delete_sure';
  static const image = 'image';
  // ignore: constant_identifier_names
  static const image_downloaded = 'image_downloaded';
  // ignore: constant_identifier_names
  static const image_open_library = 'image_open_library';
  // ignore: constant_identifier_names
  static const image_please_choose = 'image_please_choose';
  // ignore: constant_identifier_names
  static const image_exported_success = 'image_exported_success';
  // ignore: constant_identifier_names
  static const image_adjust_sepe = 'image_adjust_sepe';
  // ignore: constant_identifier_names
  static const image_all = 'image_all';
  // ignore: constant_identifier_names
  static const image_cancel = 'image_cancel';
  // ignore: constant_identifier_names
  static const image_page = 'image_page';
  // ignore: constant_identifier_names
  static const image_type = 'image_type';
  // ignore: constant_identifier_names
  static const image_tap_to_choose = 'image_tap_to_choose';
  // ignore: constant_identifier_names
  static const image_exported = 'image_exported';
  // ignore: constant_identifier_names
  static const image_to_history = 'image_to_history';
  // ignore: constant_identifier_names
  static const language_detected = 'language_detected';
  // ignore: constant_identifier_names
  static const language_translating = 'language_translating';
  // ignore: constant_identifier_names
  static const language_hasbeen_detected = 'language_hasbeen_detected';
  // ignore: constant_identifier_names
  static const language_error_file = 'language_error_file';
  // ignore: constant_identifier_names
  static const language_hasbeen_exported = 'language_hasbeen_exported';
  // ignore: constant_identifier_names
  static const language_being_exportPDF = 'language_being_exportPDF';
  // ignore: constant_identifier_names
  static const language_PDF = 'language_PDF';
  // ignore: constant_identifier_names
  static const language_doc = 'language_doc';
  // ignore: constant_identifier_names
  static const language_typing = 'language_typing';
  // ignore: constant_identifier_names
  static const language_translate_again = 'language_translate_again';
  // ignore: constant_identifier_names
  static const language_done = 'language_done';
  // ignore: constant_identifier_names
  static const language_tutorial_detail = 'language_tutorial_detail';
  // ignore: constant_identifier_names
  static const language_tutorial_choose = 'language_tutorial_choose';
  // ignore: constant_identifier_names
  static const language_understand = 'language_understand';
  // ignore: constant_identifier_names
  static const language_step = 'language_step';
  // ignore: constant_identifier_names
  static const language_step2 = 'language_step2';
  // ignore: constant_identifier_names
  static const language_step3 = 'language_step3';
  // ignore: constant_identifier_names
  static const language_step4 = 'language_step4';
  // ignore: constant_identifier_names
  static const language_step5 = 'language_step5';
  // ignore: constant_identifier_names
  static const language_step6 = 'language_step6';
  // ignore: constant_identifier_names
  static const font_step = 'font_step';
  // ignore: constant_identifier_names
  static const font_step2 = 'font_step2';
  // ignore: constant_identifier_names
  static const font_step3 = 'font_step3';
  // ignore: constant_identifier_names
  static const font_step4 = 'font_step4';
  // ignore: constant_identifier_names
  static const font_step5 = 'font_step5';
  // ignore: constant_identifier_names
  static const font_step6 = 'font_step6';
  // ignore: constant_identifier_names
  static const image_step = 'image_step';
  // ignore: constant_identifier_names
  static const image_step2 = 'image_step2';
  // ignore: constant_identifier_names
  static const image_step3 = 'image_step3';
  // ignore: constant_identifier_names
  static const image_step4 = 'image_step4';
  // ignore: constant_identifier_names
  static const image_step5 = 'image_step5';
  // ignore: constant_identifier_names
  static const image_step6 = 'image_step6';
  static const understand = 'understand';
  // ignore: constant_identifier_names
  static const language_swip = 'language_swip';
  // ignore: constant_identifier_names
  static const image_select = 'image_select';
  // ignore: constant_identifier_names
  static const image_seperate = 'image_seperate';
  // ignore: constant_identifier_names
  static const font_select = 'font_select';
  static const seperate = 'seperate';
  // ignore: constant_identifier_names
  static const home_tutorial1 = 'home_tutorial1';
  // ignore: constant_identifier_names
  static const home_tutorial2 = 'home_tutorial2';
  // ignore: constant_identifier_names
  static const home_tutorial3 = 'home_tutorial3';
  // ignore: constant_identifier_names
  static const home_tutorial4 = 'home_tutorial4';
  // ignore: constant_identifier_names
  static const home_tutorial5 = 'home_tutorial5';
  // ignore: constant_identifier_names
  static const home_tutorial6 = 'home_tutorial6';
  // ignore: constant_identifier_names
  static const home_tutorial7 = 'home_tutorial7';
  // ignore: constant_identifier_names
  static const home_tutorial8 = 'home_tutorial8';
  // ignore: constant_identifier_names
  static const home_tutorial9 = 'home_tutorial9';
  // ignore: constant_identifier_names
  static const home_tutorial10 = 'home_tutorial10';
  // ignore: constant_identifier_names
  static const home_tutorial11 = 'home_tutorial11';
  // ignore: constant_identifier_names
  static const home_quote1 = 'home_quote1';
  // ignore: constant_identifier_names
  static const home_quote2 = 'home_quote2';
  // ignore: constant_identifier_names
  static const home_quote3 = 'home_quote3';
  // ignore: constant_identifier_names
  static const home_quote4 = 'home_quote4';
  // ignore: constant_identifier_names
  static const home_quote5 = 'home_quote5';
  // ignore: constant_identifier_names
  static const home_quote6 = 'home_quote6';
  // ignore: constant_identifier_names
  static const home_quote7 = 'home_quote7';
  // ignore: constant_identifier_names
  static const home_quote8 = 'home_quote8';
  // ignore: constant_identifier_names
  static const home_quote9 = 'home_quote9';
  // ignore: constant_identifier_names
  static const home_quote10 = 'home_quote10';
  // ignore: constant_identifier_names
  static const home_quote11 = 'home_quote11';
  // ignore: constant_identifier_names
  static const privacy_term = 'privacy_term';
  static const notify = 'notify';
  // ignore: constant_identifier_names
  static const update_pdf = 'update_pdf';
  static const vietnamese = 'vietnamese';
  static const english = 'english';
  static const german = 'german';
  static const french = 'french';
  static const italian = 'italian';
  static const spanish = 'spanish';
  static const portuguese = 'portuguese';
  static const chinese = 'chinese';
  static const korean = 'korean';
  static const japanese = 'japanese';
  static const russian = 'russian';
  // ignore: constant_identifier_names
  static const language_download_successed = 'language_download_successed';

  // ignore: constant_identifier_names
  static const Map<String, dynamic> EN = {
    title: 'Welcome to Écolive',
    title2: 'Professional Font Converter',
    title3: 'Document Translation',
    title4: 'Convert File to Image',
    body:
        'Your professional tool for Font Conversion, Document Translation, and File to Image processing.',
    body2:
        'Instantly change fonts in your Word and PDF documents. Customize document styles with ease.',
    body3:
        'Translate entire files or specific segments into multiple languages while preserving the original formatting.',
    body4:
        'Turn your documents into high-quality images (PNG/JPG). Ready to start managing your files?',
    skip: 'Skip',
    next: 'Next',
    finish: 'Finish',
    settings: 'Settings',
    light_darkmode: 'Light / Dark Mode',
    language: 'Language',
    app_name: 'Écolive',
    enter_text: 'Enter text',
    converted_text: 'Converted Text',
    converted_text_description: 'Your converted text will appear here...',
    copy: 'Copy',
    reset: 'Reset',
    savePDF: 'Save as PDF',
    saveWord: 'Save as Word',
    profile: 'Profile',
    feeds: 'Feeds',
    blog: 'Blog',
    achievements: 'Achievements',
    feedDS: 'Feeds will be displayed here',
    blogDS: 'Blog posts will be displayed here',
    achievementsDS: 'Achievements will be displayed here',
    aboutapp: 'About The App',
    appdescription: """
Écolive helps you convert text formats and languages easily and effectively.

• Font Conversion: Supports converting between available system fonts, helping you change text display styles quickly.\n
• Format Conversion: Turn Word/PDF documents into high-quality image files.\n
• Automatic Translation: Automatically translate text from one language to another, supporting your work and studies.
""",
    ecosiasr: 'Search the web to plant trees...',
    ecosiaDS: 'Trees planted by Ecosia users',
    aiselection: 'TOOLS SELECTION',
    aiinstruction: 'Choosing any kind of tools you wanna use',
    aibtt1: 'A.I CHATBOT',
    aibtt2: 'CONVERT FILE TO IMAGE',
    aibtt3: 'CONVERT LANGUAGE OF THE FILE',
    aiinfo: 'INFORMATION',
    historyname: 'Conversion History',
    historystatus: 'No history yet.',
    loadHistory: 'Loaded History:',
    clearHistory: 'History cleared!',
    confirmlogout: 'Confirm Logout',
    logoutDS: 'Do you want to leave?',
    cancel: 'Cancel',
    exit: 'Exit',
    seeyou: 'See you soon',
    logoutbtt: 'Log Out',
    emailtxt: 'Enter your email',
    passwordtxt: 'Enter your password',
    loginbtt: 'Log In',
    forgotpassword: 'Forgot Password?',
    or: 'or',
    googletxt: 'Continue with Google',
    signuptxt: "Don't have an account?",
    signupbtt: 'Sign Up',
    signup_name: 'Enter your name',
    signup_email: 'Enter your email',
    signup_password: 'Enter your password',
    signup_confirmpassword: 'Confirm your password',
    signup_btt: 'Sign Up',
    signup_passwordNoti: 'Please enter all fields.',
    signup_Noti: 'Please enter a valid email address',
    signup_Noti_invalid: 'Please enter a valid email address',
    signup_Noti_8ch: 'Password must be at least 8 characters long',
    resendEmail: 'Resend Verification Email',
    resendWait: 'Wait',
    signup_alreadyDS: 'Already have an account?',
    login_signup_btt: 'Login',
    login_email_hint: 'Enter your email',
    forgotpptxt: 'Forgot Your Password',
    forgotpphint: 'Enter your email',
    forgotppsendbtt: 'Send',
    forgotppPlenter: 'Please enter your email',
    forgotppCheckmail: 'Check your email for a password reset link',
    ggcheckfail: 'Google Sign-In failed. Please try again.',
    signupdonmatch: 'Passwords do not match',
    signup_field: 'Please enter all fields.',
    login_email_auth: 'Invalid email format!',
    login_email_verify: 'Please verify your email before logging in.',
    resPP_notify: 'Please fulfill your information',
    resPP_email_auth: 'Invalid email format!',
    resPP_email_send: 'Password reset email sent successfully',
    resendEmailVerify: 'Verification email sent!',
    resendUserno: 'No user found. Please sign in first.',
    resendEmailalready: 'Your email is already verified.',
    signup_email_format: 'Invalid email format!',
    signup_password_format:
        'Password must be at least 8 characters long, contain letters and numbers.',
    signup_email_inbox:
        'A verification email has been sent. Please check your inbox.',
    forgotpasswordWord: 'Forgot Your Password',
    forgotpasswordHint: 'Enter your email',
    forgotpasswordbtt: 'Send',
    forgotpasswordEx: 'eg abc@gmail.com',
    forgotpasswordnotify: 'Reset link sent! Please check your email.',
    forgotpasswordEmail: 'Please enter your email.',
    toolsselection: 'TOOLS SELECTION',
    tool1: 'CONVERT FONT AUTOMATICALLY',
    enginedescription: """
Écolive Converter is an application that supports:

Automatically converting fonts in Word/PDF documents.
Exporting documents to image formats (PNG, JPG, ...).
Translating text from one language to another.

⚡ Powered by
• Flutter → for building cross-platform applications (mobile, desktop, web).
• Python (FastAPI) → backend for document processing (fonts, PDF → image, language translation).
• Google Cloud Firestore → for storing conversion history.
• Google Cloud Storage / Firebase Storage → for storing input and output documents.
• Google Translate API → for automatic translation of multiple languages.
• Uvicorn → for running the Python backend server.
""",
    previewscreen: 'Preview Screen',
    pickatextcolor: 'Pick a Text Color',
    previewstatus: 'There is no content',
    font_converter_title: 'Font Converter',
    new_font: 'New Font',
    preview_title: 'Preview',
    result_converted: 'Converted Result',
    uploadfile: 'UPLOAD FILE',
    fileconverted: 'File has been converted will be shown here',
    selectedfromstorage: 'Select from Device Storage',
    selectedfromgoogledrive: 'Select from Google Drive',
    downloadbtt: 'Download',
    nofiledownload: 'No file to download.',
    filetoimage: 'File to Image',
    sortofimage: 'Sort of Image',
    noresult: 'No Result',
    downloadall: 'Download All',
    convertlanguage: 'CONVERT LANGUAGE OF FILE',
    newlanguage: 'New Language',
    contentfileconverted: 'The converted file content will be shown here',
    historyconvertedfilelanguage: 'History Converted File',
    historyconvertedfiletoimage: 'History Converted',
    historyconvertedfiletolanguagetranslated: 'Translated: ',
    downloading: '⏳ Downloading...',
    downloadcompleted: '✅Download completed!',
    convertedfiletoimage: 'File → Image',
    imagefrom: 'Image from file',
    downloadthisimage: 'Download this image',
    downloadthisallimage: 'Download all images',
    close: 'Close',
    nohistory: 'No history available.',
    deleteconfirm: 'Are you sure?',
    deleteconfirm2: 'Are you sure to delete this History?',
    deletebtt: 'Delete',
    deletewholehistory: 'Delete whole History',
    deletewholehistory2: 'This action cannot be undo',
    hasbeendeleted: '🧹 History has been deleted',
    hasbeendeleted1file: '🧹 1 file history has been deleted',
    hasbeendeleted1image: '🧹 1 image has been deleted',
    language_appear: '🔍 Detecting language...',
    language_translated_success: '✅ Translated successfully!',
    language_detect_error: '❌ Error when translating',
    language_received: '✅ Download URL received:',
    language_error: '⚠️ Error:',
    language_choose_method: 'Choose translation method',
    language_ask: 'Do you want to translate the entire file or chunks?',
    language_trans_all: 'Translate all',
    language_trans_chunk: 'Translate chunks',
    language_seperate: '⏳ Splitting chunks...',
    language_trans_already: '✅ Chunks processed!\nPlease preview the content.',
    language_error_seperate: '❌ Error processing chunks',
    language_convert: 'Conversion status',
    language_down_file: '✅ File downloaded:',
    all_convert_no: 'Cannot exit',
    all_convert_no2:
        'Conversion in progress. Please wait for completion before returning.',
    ok: 'OK',
    language_history: 'View conversion history',
    language_file_chose: '📄 Selected file:',
    language_processing: 'Processing... Please wait',
    download_file_trans: 'Download translation file',
    download_already: '✅ Download complete',
    download_this_file: 'Download this file',
    file_choose_method: 'Choose conversion method',
    file_ask:
        'Do you want to convert the entire file or select parts of the result?',
    file_all: 'All',
    file_seperate: 'Parts',
    file_processing: '⏳ Processing...',
    file_process_temp: '✅ Temp data fetched. Switch screen...',
    file_converted_success: '✅ Conversion successful',
    file_converted_error: '❌ Error while converting',
    file_cannot_out: 'Cannot exit',
    file_cannot_out2:
        'Converting in progress. Please wait for completion before returning.',
    file_history_title: 'View conversion history',
    file_hasbeensaved: '✅ Image saved to gallery!',
    file_open: 'Open',
    file_download: 'Downloading image',
    file_downloading: 'Downloading',
    file_image: 'image...',
    file_image_hasbeenchose: 'Selected:',
    file_image_see: 'View image',
    downloading_image: '⏳ Downloading image...',
    cannot_open_file: '❌ Unable to download image',
    no_image_to_download: 'No images to download',
    download_all_image: '⏳ Downloading all images...',
    file_saved: '✅ Saved',
    image_to_gallery: 'image to gallery!',
    open_gallery: '📸 Open gallery',
    cannot_loading: 'Unable to load history.',
    no_image_saved: 'No images saved.',
    download_already_all_image: '✅ All images loaded!',
    font_bold_word: 'Please highlight (select) text to change Font!',
    font_cannot_open: '⚠️ Cannot open file:',
    font_download_error: '⚠️ File download error:',
    font_error_export: '⚠️ Export error:',
    font_edit: 'Edit Font',
    font_tip: '💡 Tip: Highlight text then select Font above to change.',
    font_content: 'Text content...',
    font_export_DOCX: 'Export DOCX',
    font_export_PDF: 'Export PDF',
    font_error_file: '❌ Error: Cannot get file path',
    font_converted: '✅ Converted all to',
    font_link_below: 'Download link below.',
    font_no_text: 'File has no text content!',
    font_install: 'Please install Word/Office on Google Store.',
    font_instruction: 'Instruction',
    font_history: 'History',
    font_done: 'Completed!',
    font_download_again: 'Re-downloading...',
    font_history_screen: 'Font Conversion History',
    font_delete: 'Delete this item?',
    font_delete_sure: 'Are you sure you want to delete this item?',
    image_downloaded: '✅ Downloaded',
    image: 'image',
    image_open_library: 'and opened gallery successfully',
    image_please_choose: '⚠️ Please select at least 1 image!',
    image_exported_success: '✅ Export successful! Opening history...',
    image_adjust_sepe: 'Adjust each image',
    image_all: 'All',
    image_cancel: 'Deselect',
    image_page: 'Page',
    image_type: 'Ext',
    image_tap_to_choose: 'Tap to select',
    image_exported: 'EXPORT',
    image_to_history: 'IMAGE TO HISTORY',
    language_detected: '🌐 Detected:',
    language_translating: '⏳ Translating...',
    language_hasbeen_detected: '✅ Language detected:',
    language_error_file: '❌ Error loading file:',
    language_hasbeen_exported: '✅ File exported:',
    language_being_exportPDF: '⏳ Creating PDF, please wait...',
    language_PDF: '✅ PDF exported:',
    language_doc: 'Document Editor',
    language_typing: 'Enter translation...',
    language_translate_again: 'Retranslate',
    language_done: 'Done',
    language_tutorial_detail: 'Detailed Tutorial',
    language_tutorial_choose: 'There are 2 types: Translate All and Chunks',
    language_understand: 'Got it, Start now!',
    language_step:
        'Step 1: Tap the new Language Dropdown to select the language you want to translate to.',
    language_step2:
        'Step 2: Click Upload File (Storage/Drive), select file. When Dialog appears, select "Translate All" and wait for the system to return the file.',
    language_step3:
        'Step 1: Click Upload File and the Storage + Google Drive screen will appear.',
    language_step4:
        'Step 2: Find and select file. At the Dialog, click "Translate Chunks" immediately. The detail screen will appear.',
    language_step5:
        'Step 3: Find the segments you want to change, click on that word/segment to change the language or edit as desired.',
    language_step6:
        'Step 4: After editing, click on the top right corner to Export DOCX or PDF.',
    font_step:
        'Step 1: Tap the new Font Dropdown to select the new Font style you want to convert.',
    font_step2:
        'Step 2: Click Upload File, select file from Storage or Drive. When Dialog appears, click "All" immediately and wait for the system to return the file.',
    font_step3:
        'Step 1: Click Upload File and the Storage + Google Drive screen will appear.',
    font_step4:
        'Step 2: Find and select file. At the Dialog, click "Parts" immediately. The partial conversion screen will appear.',
    font_step5:
        'Step 3: Select the segments you want to change Font by clicking on that segment. For individual words, tap to retype or delete.',
    font_step6:
        'Step 4: After editing, click the top right button to export the File as DOCX or PDF.',
    image_step:
        'Step 1: Tap the new Image Type Dropdown to select the image file you want to convert (PNG, JPG...).',
    image_step2:
        'Step 2: Click Upload File, select file. When Dialog appears, click "All" immediately and wait for the system to return the file.',
    image_step3:
        'Step 1: Click Upload File and the Storage + Google Drive screen will appear.',
    image_step4:
        'Step 2: Find and select file. At the Dialog, click "Parts" immediately. The partial conversion screen will appear.',
    image_step5:
        'Step 3: At this screen, you select the images you want to change by clicking on each image as desired.',
    image_step6:
        'Step 4: After editing, click the green button at the bottom to export the file.',
    understand: 'Got it, Start now!',
    language_swip: 'Swipe left or tap here to see more',
    image_select: 'There are 2 conversion types: "All" and "Parts"',
    image_seperate: 'Convert parts',
    font_select: 'There are 2 conversion types: "All" and "Parts"',
    seperate: 'Parts',
    home_tutorial1: '1. Select Font',
    home_quote1: 'Tap here to choose the Font type you want to try.',
    home_tutorial2: '2. Enter Text',
    home_quote2: 'Type the content you want to try in this box.',
    home_tutorial3: '3. Format Text',
    home_quote3: 'Customize Bold, Italic, Underline or Change text color here.',
    home_tutorial4: '4. Result',
    home_quote4:
        'The text after being entered and customized will appear here.',
    home_tutorial5: '5. Quick Actions',
    home_quote5: 'Copy the result or clear to start over.',
    home_tutorial6: '6. Navigation Bar',
    home_quote6:
        'Switch between screens: Profile, About, Tools, Settings and Logout.',
    home_tutorial7: '7. Personal Info',
    home_quote7: 'View your information.',
    home_tutorial8: '8. About App',
    home_quote8: 'Learn more about app information and functions.',
    home_tutorial9: '9. Select Tools',
    home_quote9: 'Where to choose tools to convert text as desired.',
    home_tutorial10: '10. Settings',
    home_quote10:
        'Customize interface, app language \n and Privacy Policies & Terms and Conditions.',
    home_tutorial11: '11. Logout',
    home_quote11: 'Logout from current account.',
    privacy_term: 'Privacy Policy & Terms',
    notify: 'Notification',
    update_pdf:
        'The PDF Export feature is under development.\nPlease come back later!',
    vietnamese: 'Vietnamese',
    english: 'English',
    german: 'German',
    french: 'French',
    italian: 'Italian',
    spanish: 'Spanish',
    portuguese: 'Portuguese',
    chinese: 'Chinese (Simplified)',
    korean: 'Korean',
    japanese: 'Japanese',
    russian: 'Russian',
    language_download_successed:
        '✅ Download successful! Do you want to open the file?',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> DE = {
    title: 'Willkommen bei Écolive',
    body:
        'Ihr professionelles Tool für Schriftartkonvertierung, Dokumentübersetzung und Datei-zu-Bild-Verarbeitung.',
    title2: 'Professioneller Schriftart-Konverter',
    body2:
        'Ändern Sie sofort Schriftarten in Ihren Word- und PDF-Dokumenten. Passen Sie Dokumentstile einfach an.',
    title3: 'Dokumentübersetzung',
    body3:
        'Übersetzen Sie ganze Dateien oder bestimmte Segmente in mehrere Sprachen unter Beibehaltung der Formatierung.',
    title4: 'Datei in Bild konvertieren',
    body4:
        'Verwandeln Sie Ihre Dokumente in hochwertige Bilder (PNG/JPG). Bereit zum Starten?',
    skip: 'Überspringen',
    next: 'Nächster',
    finish: 'Fertig',
    settings: 'Einstellungen',
    light_darkmode: 'Hell / Dunkel Modus',
    language: 'Sprache',
    app_name: 'Écolive',
    enter_text: 'Text eingeben',
    converted_text: 'Konvertierter Text',
    converted_text_description: 'Ihr konvertierter Text wird hier angezeigt...',
    copy: 'Kopieren',
    reset: 'Zurücksetzen',
    savePDF: 'Als PDF speichern',
    saveWord: 'Als Word speichern',
    profile: 'Profil',
    feeds: 'Feeds',
    blog: 'Blog',
    achievements: 'Errungenschaften',
    feedDS: 'Feeds werden hier angezeigt',
    blogDS: 'Blogbeiträge werden hier angezeigt',
    achievementsDS: 'Errungenschaften werden hier angezeigt',
    aboutapp: 'Über die App',
    appdescription: """
Écolive hilft Ihnen, Textformate und Sprachen einfach und effektiv zu konvertieren.

• Schriftartkonvertierung: Unterstützt die Konvertierung zwischen verfügbaren Systemschriftarten, um den Textstil schnell zu ändern.\n
• Formatkonvertierung: Verwandeln Sie Word/PDF-Dokumente in hochwertige Bilddateien.\n
• Automatische Übersetzung: Übersetzen Sie Text automatisch von einer Sprache in eine andere, um Ihre Arbeit und Ihr Studium zu unterstützen.
""",
    ecosiasr: 'Durchsuchen Sie das Web, um Bäume zu pflanzen...',
    ecosiaDS: 'Von Ecosia-Nutzern gepflanzte Bäume',
    aiselection: 'Werkzeugauswahl',
    aiinstruction:
        'wählen sie jede art von werkzeugen, die sie verwenden möchten',
    aibtt1: 'KI-CHATBOT',
    aibtt2: 'DATEI IN BILD UMWANDELN',
    aibtt3: 'DATEI-SPRACHE ÄNDERN',
    aiinfo: 'INFORMATION',
    historyname: 'Konvertierungshistorie',
    historystatus: 'Noch keine Historie.',
    confirmlogout: 'Abmeldung bestätigen',
    logoutDS: 'Möchten Sie gehen?',
    cancel: 'Abbrechen',
    exit: 'Ausfahrt',
    seeyou: 'Bis bald',
    logoutbtt: 'Abmelden',
    emailtxt: 'Geben Sie Ihre E-Mail ein',
    passwordtxt: 'Geben Sie Ihr Passwort ein',
    loginbtt: 'Einloggen',
    forgotpassword: 'Passwort vergessen?',
    or: 'oder',
    googletxt: 'Mit Google fortfahren',
    signuptxt: 'Haben Sie kein Konto?',
    signupbtt: 'Registrieren',
    signup_name: 'Geben Sie Ihren Namen ein',
    signup_email: 'Geben Sie Ihre E-Mail ein',
    signup_password: 'Geben Sie Ihr Passwort ein',
    signup_confirmpassword: 'Bestätigen Sie Ihr Passwort',
    signup_btt: 'Registrieren',
    signup_passwordNoti: 'Bitte alle Felder ausfüllen.',
    signup_Noti: 'Bitte geben Sie eine gültige E-Mail-Adresse ein',
    signup_Noti_invalid: 'Bitte geben Sie eine gültige E-Mail-Adresse ein',
    signup_Noti_8ch: 'Das Passwort muss mindestens 8 Zeichen lang sein',
    resendEmail: 'Bestätigungs-E-Mail erneut senden',
    resendWait: 'Warten',
    signup_alreadyDS: 'Haben Sie bereits ein Konto?',
    login_signup_btt: 'Einloggen',
    login_email_hint: 'Geben Sie Ihre E-Mail ein',
    forgotpptxt: 'Passwort vergessen',
    forgotpphint: 'Geben Sie Ihre E-Mail ein',
    forgotppsendbtt: 'Senden',
    forgotppPlenter: 'Bitte geben Sie Ihre E-Mail ein',
    forgotppCheckmail:
        'Überprüfen Sie Ihre E-Mail auf einen Link zum Zurücksetzen des Passworts',
    ggcheckfail:
        'Google-Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.',
    signupdonmatch: 'Passwörter stimmen nicht überein',
    signup_field: 'Bitte alle Felder ausfüllen.',
    login_email_auth: 'Ungültiges E-Mail-Format!',
    login_email_verify:
        'Bitte überprüfen Sie Ihre E-Mail, bevor Sie sich anmelden.',
    resPP_notify: 'Bitte erfüllen Sie Ihre Informationen',
    resPP_email_auth: 'Ungültiges E-Mail-Format!',
    resPP_email_send: 'Passwort-Zurücksetzungs-E-Mail erfolgreich gesendet',
    resendEmailVerify: 'Bestätigungs-E-Mail gesendet!',
    resendUserno: 'Kein Benutzer gefunden. Bitte melden Sie sich zuerst an.',
    resendEmailalready: 'Ihre E-Mail ist bereits verifiziert.',
    signup_email_format: 'Ungültiges E-Mail-Format!',
    signup_password_format:
        'Das Passwort muss mindestens 8 Zeichen lang sein, Buchstaben und Zahlen enthalten.',
    signup_email_inbox:
        'Eine Bestätigungs-E-Mail wurde gesendet. Bitte überprüfen Sie Ihr Postfach.',
    forgotpasswordWord: 'Passwort vergessen',
    forgotpasswordHint: 'Geben Sie Ihre E-Mail ein',
    forgotpasswordbtt: 'Senden',
    forgotpasswordEx: 'z.B.abc@gmail.com',
    forgotpasswordnotify:
        'Zurücksetzen-Link gesendet! Bitte überprüfen Sie Ihre E-Mail.',
    forgotpasswordEmail: 'Bitte geben Sie Ihre E-Mail ein.',
    toolsselection: 'WERKZEUGAUSWAHL',
    tool1: 'AUTOMATISCHE SCHRIFTARTKONVERTIERUNG',
    enginedescription: """
Écolive Converter ist eine Anwendung, die Folgendes unterstützt:

Automatisches Konvertieren von Schriftarten in Word/PDF-Dokumenten.
Exportieren von Dokumenten in Bildformate (PNG, JPG, ...).
Übersetzen von Text von einer Sprache in eine andere.

⚡ Angetrieben durch
• Flutter → zum Erstellen plattformübergreifender Anwendungen (mobile, Desktop, Web).
• Python (FastAPI) → Backend zur Dokumentenverarbeitung (Schriftarten, PDF → Bild, Sprachübersetzung).
• Google Cloud Firestore → zum Speichern des Konvertierungsverlaufs.
• Google Cloud Storage / Firebase Storage → zum Speichern von Eingabe- und Ausgabedokumenten.
• Google Translate API → für die automatische Übersetzung mehrerer Sprachen.
• Uvicorn → zum Betreiben des Python-Backend-Servers.
""",
    previewscreen: 'Vorschau Bildschirm',
    pickatextcolor: 'Wählen Sie eine Textfarbe',
    previewstatus: 'Es gibt keinen Inhalt',
    font_converter_title: 'Schriftart Konverter',
    new_font: 'Neue Schriftart',
    preview_title: 'Vorschau',
    result_converted: 'Konvertiertes Ergebnis',
    uploadfile: 'DATEI HOCHLADEN',
    fileconverted: 'Die konvertierte Datei wird hier angezeigt',
    selectedfromstorage: 'Aus Gerätespeicher auswählen',
    selectedfromgoogledrive: 'Aus Google Drive auswählen',
    downloadbtt: 'Herunterladen',
    nofiledownload: 'Keine Datei zum Herunterladen.',
    filetoimage: 'Datei zu Bild',
    sortofimage: 'Art des Bildes',
    noresult: 'Kein Ergebnis',
    downloadall: 'Alle herunterladen',
    convertlanguage: 'SPRACHE DER DATEI KONVERTIEREN',
    newlanguage: 'Neue Sprache',
    contentfileconverted:
        'Der Inhalt der konvertierten Datei wird hier angezeigt',
    historyconvertedfilelanguage: 'Verlauf konvertierte Datei',
    historyconvertedfiletoimage: 'Verlauf konvertiert',
    historyconvertedfiletolanguagetranslated: 'Übersetzt: ',
    downloading: '⏳Wird heruntergeladen...',
    downloadcompleted: '✅Download abgeschlossen!',
    convertedfiletoimage: 'Datei → Bild',
    imagefrom: 'Bild aus Datei',
    downloadthisimage: 'Dieses Bild herunterladen',
    downloadthisallimage: 'Alle Bilder herunterladen',
    close: 'Schließen',
    nohistory: 'Keine Historie verfügbar.',
    deleteconfirm: 'Sind Sie sicher?',
    deleteconfirm2: 'Sind Sie sicher, dass Sie diesen Verlauf löschen möchten?',
    deletebtt: 'Löschen',
    deletewholehistory: 'Gesamten Verlauf löschen',
    deletewholehistory2: 'Diese Aktion kann nicht rückgängig gemacht werden',
    hasbeendeleted: '🧹 Verlauf wurde gelöscht',
    hasbeendeleted1file: '🧹 1 Dateiver',
    hasbeendeleted1image: '🧹 1 Bildverlauf wurde gelöscht',
    language_appear: '🔍 Sprache wird erkannt...',
    language_translated_success: '✅ Erfolgreich übersetzt!',
    language_detect_error: '❌ Fehler beim Übersetzen',
    language_received: '✅ Download-URL erhalten:',
    language_error: '⚠️ Fehler:',
    language_choose_method: 'Wählen Sie die Übersetzungsmethode',
    language_ask:
        'Möchten Sie die gesamte Datei oder einzelne Abschnitte übersetzen?',
    language_trans_all: 'Alles übersetzen',
    language_trans_chunk: 'Abschnitte übersetzen',
    language_seperate: '⏳ Abschnitte werden getrennt...',
    language_trans_already:
        '✅ Abschnitte verarbeitet!\nBitte Inhalt vorschauen.',
    language_error_seperate: '❌ Fehler bei der Abschnittsverarbeitung',
    language_convert: 'Konvertierungsstatus',
    language_down_file: '✅ Datei heruntergeladen:',
    all_convert_no: 'Beenden nicht möglich',
    all_convert_no2: 'Konvertierung läuft. Bitte warten Sie den Abschluss ab.',
    ok: 'OK',
    language_history: 'Konvertierungsverlauf anzeigen',
    language_file_chose: '📄 Ausgewählte Datei:',
    language_processing: 'Verarbeitung... Bitte warten',
    download_file_trans: 'Übersetzungsdatei herunterladen',
    download_already: '✅ Download abgeschlossen',
    download_this_file: 'Diese Datei herunterladen',
    file_choose_method: 'Konvertierungsmethode wählen',
    file_ask:
        'Möchten Sie die gesamte Datei konvertieren oder Teile auswählen?',
    file_all: 'Alles',
    file_seperate: 'Teile',
    file_processing: '⏳ Verarbeitung...',
    file_process_temp: '✅ Temp-Daten abgerufen. Bildschirm wechseln...',
    file_converted_success: '✅ Konvertierung erfolgreich',
    file_converted_error: '❌ Fehler bei der Konvertierung',
    file_cannot_out: 'Beenden nicht möglich',
    file_cannot_out2: 'Konvertierung läuft. Bitte warten Sie den Abschluss ab.',
    file_history_title: 'Konvertierungsverlauf anzeigen',
    file_hasbeensaved: '✅ Bild in Galerie gespeichert!',
    file_open: 'Öffnen',
    file_download: 'Bild wird heruntergeladen',
    file_downloading: 'Wird heruntergeladen',
    file_image: 'Bild...',
    file_image_hasbeenchose: 'Ausgewählt:',
    file_image_see: 'Bild ansehen',
    downloading_image: '⏳ Bild wird heruntergeladen...',
    cannot_open_file: '❌ Bild kann nicht heruntergeladen werden',
    no_image_to_download: 'Keine Bilder zum Herunterladen',
    download_all_image: '⏳ Alle Bilder werden heruntergeladen...',
    file_saved: '✅ Gespeichert',
    image_to_gallery: 'Bild in Galerie!',
    open_gallery: '📸 Galerie öffnen',
    cannot_loading: 'Verlauf kann nicht geladen werden.',
    no_image_saved: 'Keine Bilder gespeichert.',
    download_already_all_image: '✅ Alle Bilder geladen!',
    font_bold_word:
        'Bitte markieren Sie den Text, um die Schriftart zu ändern!',
    font_cannot_open: '⚠️ Datei kann nicht geöffnet werden:',
    font_download_error: '⚠️ Fehler beim Herunterladen:',
    font_error_export: '⚠️ Exportfehler:',
    font_edit: 'Schriftart bearbeiten',
    font_tip: '💡 Tipp: Text markieren und oben Schriftart wählen.',
    font_content: 'Textinhalt...',
    font_export_DOCX: 'DOCX exportieren',
    font_export_PDF: 'PDF exportieren',
    font_error_file: '❌ Fehler: Dateipfad nicht gefunden',
    font_converted: '✅ Alles konvertiert zu',
    font_link_below: 'Download-Link unten.',
    font_no_text: 'Datei hat keinen Textinhalt!',
    font_install: 'Bitte installieren Sie Word/Office aus dem Google Store.',
    font_instruction: 'Anleitung',
    font_history: 'Verlauf',
    font_done: 'Erledigt!',
    font_download_again: 'Erneutes Herunterladen...',
    font_history_screen: 'Schriftkonvertierungsverlauf',
    font_delete: 'Diesen Eintrag löschen?',
    font_delete_sure: 'Möchten Sie diesen Eintrag wirklich löschen?',
    image_downloaded: '✅ Heruntergeladen',
    image: 'Bild',
    image_open_library: 'und Galerie erfolgreich geöffnet',
    image_please_choose: '⚠️ Bitte wählen Sie mindestens 1 Bild!',
    image_exported_success: '✅ Export erfolgreich! Öffne Verlauf...',
    image_adjust_sepe: 'Jedes Bild anpassen',
    image_all: 'Alle',
    image_cancel: 'Abwählen',
    image_page: 'Seite',
    image_type: 'Typ',
    image_tap_to_choose: 'Zum Auswählen tippen',
    image_exported: 'EXPORT',
    image_to_history: 'BILD IN VERLAUF',
    language_detected: '🌐 Erkannt:',
    language_translating: '⏳ Übersetzen...',
    language_hasbeen_detected: '✅ Sprache erkannt:',
    language_error_file: '❌ Fehler beim Laden der Datei:',
    language_hasbeen_exported: '✅ Datei exportiert:',
    language_being_exportPDF: '⏳ PDF wird erstellt, bitte warten...',
    language_PDF: '✅ PDF exportiert:',
    language_doc: 'Dokumenteneditor',
    language_typing: 'Übersetzung eingeben...',
    language_translate_again: 'Neu übersetzen',
    language_done: 'Fertig',
    language_tutorial_detail: 'Detaillierte Anleitung',
    language_tutorial_choose:
        'Es gibt 2 Übersetzungsarten: Alle und Abschnitte',
    language_understand: 'Verstanden, jetzt starten!',
    language_step:
        'Schritt 1: Tippen Sie auf das Dropdown-Menü für die neue Sprache, um die Zielsprache auszuwählen.',
    language_step2:
        'Schritt 2: Klicken Sie auf Datei hochladen (Speicher/Drive), wählen Sie die Datei aus. Wenn der Dialog erscheint, wählen Sie "Alles übersetzen" und warten Sie auf die Rückgabe der Datei.',
    language_step3:
        'Schritt 1: Klicken Sie auf Datei hochladen und der Bildschirm Speicher + Google Drive erscheint.',
    language_step4:
        'Schritt 2: Datei suchen und auswählen. Klicken Sie im Dialog sofort auf "Abschnitte übersetzen". Der Detailbildschirm erscheint.',
    language_step5:
        'Schritt 3: Suchen Sie die Abschnitte, die Sie ändern möchten, klicken Sie auf das Wort/den Abschnitt, um die Sprache zu ändern oder nach Wunsch zu bearbeiten.',
    language_step6:
        'Schritt 4: Nach der Bearbeitung klicken Sie oben rechts auf DOCX oder PDF exportieren.',
    font_step:
        'Schritt 1: Tippen Sie auf das Dropdown-Menü für die neue Schriftart, um den neuen Schriftstil auszuwählen.',
    font_step2:
        'Schritt 2: Klicken Sie auf Datei hochladen, wählen Sie die Datei aus Speicher oder Drive. Wenn der Dialog erscheint, klicken Sie sofort auf "Alles" und warten Sie.',
    font_step3:
        'Schritt 1: Klicken Sie auf Datei hochladen und der Bildschirm Speicher + Google Drive erscheint.',
    font_step4:
        'Schritt 2: Datei suchen und auswählen. Klicken Sie im Dialog sofort auf "Teile". Der Bildschirm für die Teilkonvertierung erscheint.',
    font_step5:
        'Schritt 3: Wählen Sie die Abschnitte aus, deren Schriftart Sie ändern möchten, indem Sie auf den Abschnitt klicken. Bei einzelnen Wörtern tippen Sie darauf, um sie neu zu tippen oder zu löschen.',
    font_step6:
        'Schritt 4: Nach der Bearbeitung klicken Sie auf die Schaltfläche oben rechts, um die Datei als DOCX oder PDF zu exportieren.',
    image_step:
        'Schritt 1: Tippen Sie auf das Dropdown-Menü für den Bildtyp, um die Bilddatei auszuwählen, die Sie konvertieren möchten (PNG, JPG...).',
    image_step2:
        'Schritt 2: Klicken Sie auf Datei hochladen, wählen Sie die Datei. Wenn der Dialog erscheint, klicken Sie sofort auf "Alles" und warten Sie.',
    image_step3:
        'Schritt 1: Klicken Sie auf Datei hochladen und der Bildschirm Speicher + Google Drive erscheint.',
    image_step4:
        'Schritt 2: Datei suchen und auswählen. Klicken Sie im Dialog sofort auf "Teile". Der Bildschirm für die Teilkonvertierung erscheint.',
    image_step5:
        'Schritt 3: Auf diesem Bildschirm wählen Sie die Bilder aus, die Sie ändern möchten, indem Sie auf das jeweilige Bild klicken.',
    image_step6:
        'Schritt 4: Nach der Bearbeitung klicken Sie auf die grüne Schaltfläche unten, um die Datei zu exportieren.',
    understand: 'Verstanden, jetzt starten!',
    language_swip: 'Nach links wischen oder hier tippen, um mehr zu sehen',
    image_select: 'Es gibt 2 Konvertierungsarten: "Alles" und "Teile"',
    image_seperate: 'Teile konvertieren',
    font_select: 'Es gibt 2 Konvertierungsarten: "Alles" und "Teile"',
    seperate: 'Teile',
    home_tutorial1: '1. Schriftart wählen',
    home_quote1: 'Tippen Sie hier, um den Schriftarttyp auszuwählen.',
    home_tutorial2: '2. Text eingeben',
    home_quote2:
        'Geben Sie den Inhalt, den Sie testen möchten, in dieses Feld ein.',
    home_tutorial3: '3. Text formatieren',
    home_quote3: 'Fett, Kursiv, Unterstrichen oder Textfarbe hier anpassen.',
    home_tutorial4: '4. Ergebnis',
    home_quote4: 'Der Text erscheint hier nach Eingabe und Anpassung.',
    home_tutorial5: '5. Schnellaktionen',
    home_quote5: 'Ergebnis kopieren oder löschen, um neu zu beginnen.',
    home_tutorial6: '6. Navigationsleiste',
    home_quote6:
        'Zwischen Bildschirmen wechseln: Profil, Info, Werkzeuge, Einstellungen und Abmelden.',
    home_tutorial7: '7. Persönliche Info',
    home_quote7: 'Ihre Informationen anzeigen.',
    home_tutorial8: '8. Über die App',
    home_quote8: 'Erfahren Sie mehr über App-Informationen und Funktionen.',
    home_tutorial9: '9. Werkzeuge wählen',
    home_quote9:
        'Wo Sie Werkzeuge auswählen, um Text nach Wunsch zu konvertieren.',
    home_tutorial10: '10. Einstellungen',
    home_quote10:
        'Benutzeroberfläche, App-Sprache \n und Datenschutzrichtlinien & Geschäftsbedingungen anpassen.',
    home_tutorial11: '11. Abmelden',
    home_quote11: 'Vom aktuellen Konto abmelden.',
    privacy_term: 'Datenschutz & Bedingungen',
    notify: 'Hinweis',
    update_pdf:
        'Die PDF-Exportfunktion befindet sich in der Entwicklung.\nBitte versuchen Sie es später erneut!',
    vietnamese: 'Vietnamesisch',
    english: 'Englisch',
    german: 'Deutsch',
    french: 'Französisch',
    italian: 'Italienisch',
    spanish: 'Spanisch',
    portuguese: 'Portugiesisch',
    chinese: 'Chinesisch (Vereinfacht)',
    korean: 'Koreanisch',
    japanese: 'Japanisch',
    russian: 'Russisch',
    language_download_successed:
        '✅ Download erfolgreich! Möchten Sie die Datei öffnen?',
  };

  // ignore: constant_identifier_names
  // ignore: constant_identifier_names
  // ignore: constant_identifier_names
  // ignore: constant_identifier_names
  static const Map<String, dynamic> FR = {
    title: 'Bienvenue sur Écolive',
    body:
        'Votre outil professionnel pour la conversion de polices, la traduction de documents et la conversion de fichiers en images.',
    title2: 'Convertisseur de polices professionnel',
    body2:
        'Changez instantanément les polices dans vos documents Word et PDF. Personnalisez facilement les styles.',
    title3: 'Traduction de documents',
    body3:
        'Traduisez des fichiers entiers ou des segments spécifiques dans plusieurs langues tout en conservant le formatage.',
    title4: 'Convertir un fichier en image',
    body4:
        'Transformez vos documents en images de haute qualité (PNG/JPG). Prêt à commencer ?',
    skip: 'Passer',
    next: 'Suivant',
    finish: 'Terminer',
    settings: 'Paramètres',
    light_darkmode: 'Mode clair / sombre',
    language: 'Langue',
    app_name: 'Écolive',
    enter_text: 'Entrer le texte',
    converted_text: 'Texte converti',
    converted_text_description: 'Votre texte converti apparaîtra ici...',
    copy: 'Copier',
    reset: 'Réinitialiser',
    savePDF: 'Enregistrer en tant que PDF',
    saveWord: 'Enregistrer en tant que Word',
    profile: 'Profil',
    feeds: 'Flux',
    blog: 'Blog',
    achievements: 'Réalisations',
    feedDS: 'Les flux seront affichés ici',
    blogDS: 'Les articles de blog seront affichés ici',
    achievementsDS: 'Les réalisations seront affichées ici',
    aboutapp: 'À propos de l\'application',
    appdescription: """
Écolive vous aide à convertir les formats de texte et les langues facilement et efficacement.

• Conversion de police : Prend en charge la conversion entre les polices système disponibles, vous aidant à changer rapidement le style d'affichage du texte.\n
• Conversion de format : Transformez des documents Word/PDF en fichiers image de haute qualité.\n
• Traduction automatique : Traduisez automatiquement du texte d'une langue à une autre, pour vous aider dans votre travail et vos études.
""",
    ecosiasr: 'Recherchez sur le web pour planter des arbres...',
    ecosiaDS: 'Arbres plantés par les utilisateurs d\'Ecosia',
    aiselection: 'SÉLECTION D' "OUTILS",
    aiinstruction:
        'choisissez n' "importe quel type d'outils que vous voulez utiliser'",
    aibtt1: 'CHATBOT',
    aibtt2: 'CONVERTIR UN FICHIER EN IMAGE',
    aibtt3: 'CONVERTIR LA LANGUE D"UN FICHIER"',
    aiinfo: 'INFORMATION',
    historyname: 'Historique de conversion',
    historystatus: 'Pas encore d\'historique.',
    confirmlogout: 'Confirmer la déconnexion',
    logoutDS: 'Voulez-vous partir ?',
    cancel: 'Annuler',
    exit: 'Sortie',
    seeyou: 'À bientôt',
    logoutbtt: 'Se déconnecter',
    emailtxt: 'Entrez votre e-mail',
    passwordtxt: 'Entrez votre mot de passe',
    loginbtt: 'Se connecter',
    forgotpassword: 'Mot de passe oublié ?',
    or: 'ou',
    googletxt: 'Continuer avec Google',
    signuptxt: 'Vous n\'avez pas de compte ?',
    signupbtt: 'S\'inscrire',
    signup_name: 'Entrez votre nom',
    signup_email: 'Entrez votre e-mail',
    signup_password: 'Entrez votre mot de passe',
    signup_confirmpassword: 'Confirmez votre mot de passe',
    signup_btt: 'S\'inscrire',
    signup_passwordNoti: 'Veuillez remplir tous les champs.',
    signup_Noti: 'Veuillez entrer une adresse e-mail valide',
    signup_Noti_invalid: 'Veuillez entrer une adresse e-mail valide',
    signup_Noti_8ch: 'Le mot de passe doit comporter au moins 8 caractères',
    resendEmail: 'Renvoyer l\'e-mail de vérification',
    resendWait: 'Attendre',
    signup_alreadyDS: 'Vous avez déjà un compte ?',
    login_signup_btt: 'Connexion',
    login_email_hint: 'Entrez votre e-mail',
    forgotpptxt: 'Mot de passe oublié',
    forgotpphint: 'Entrez votre e-mail',
    forgotppsendbtt: 'Envoyer',
    forgotppPlenter: 'Veuillez entrer votre e-mail',
    forgotppCheckmail:
        'Vérifiez votre e-mail pour un lien de réinitialisation du mot de passe',
    ggcheckfail: 'Échec de la connexion Google. Veuillez réessayer.',
    signupdonmatch: 'Les mots de passe ne correspondent pas',
    signup_field: 'Veuillez remplir tous les champs.',
    login_email_auth: 'Format d\'email invalide !',
    login_email_verify:
        'Veuillez vérifier votre e-mail avant de vous connecter.',
    resPP_notify: 'Veuillez remplir vos informations',
    resPP_email_auth: 'Format d\'email invalide !',
    resPP_email_send:
        'E-mail de réinitialisation de mot de passe envoyé avec succès',
    resendEmailVerify: 'E-mail de vérification envoyé !',
    resendUserno: 'Aucun utilisateur trouvé. Veuillez d\'abord vous connecter.',
    resendEmailalready: 'Votre e-mail est déjà vérifié.',
    signup_email_format: 'Format d\'email invalide !',
    signup_password_format:
        'Le mot de passe doit comporter au moins 8 caractères, contenir des lettres et des chiffres.',
    signup_email_inbox:
        'Un e-mail de vérification a été envoyé. Veuillez vérifier votre boîte de réception.',
    forgotpasswordWord: 'Mot de passe oublié',
    forgotpasswordHint: 'Entrez votre e-mail',
    forgotpasswordbtt: 'Envoyer',
    forgotpasswordEx: 'ex.abc@gmail.com',
    forgotpasswordnotify:
        'Lien de réinitialisation envoyé ! Veuillez vérifier votre e-mail.',
    toolsselection: 'SÉLECTION DES OUTILS',
    tool1: 'CONVERSION AUTOMATIQUE DE POLICE',
    enginedescription: """
Écolive Converter est une application qui permet de :

Convertir automatiquement les polices de caractères dans les documents Word/PDF.
Exporter les documents vers des formats d'image (PNG, JPG, ...).
Traduire le texte d'une langue à une autre.

⚡ Propulsé par
• Flutter → pour créer des applications multiplateformes (mobile, bureau, web).
• Python (FastAPI) → backend pour le traitement des documents (polices, PDF → image, traduction linguistique).
• Google Cloud Firestore → pour stocker l'historique des conversions.
• Google Cloud Storage / Firebase Storage → pour stocker les documents d'entrée et de sortie.
• Google Translate API → pour la traduction automatique de plusieurs langues.
• Uvicorn → pour faire fonctionner le serveur backend Python.
""",
    previewscreen: 'Écran de prévisualisation',
    pickatextcolor: 'Choisissez une couleur de texte',
    previewstatus: 'Il n\'y a pas de contenu',
    font_converter_title: 'Convertisseur de polices',
    new_font: 'Nouvelle police',
    preview_title: 'Aperçu',
    result_converted: 'Résultat converti',
    uploadfile: 'TÉLÉCHARGER LE FICHIER',
    fileconverted: 'Le fichier converti sera affiché ici',
    selectedfromstorage: 'Sélectionner depuis le stockage de l\'appareil',
    selectedfromgoogledrive: 'Sélectionner depuis Google Drive',
    downloadbtt: 'Télécharger',
    nofiledownload: 'Aucun fichier à télécharger.',
    filetoimage: 'Fichier en image',
    sortofimage: 'Type d\'image',
    noresult: 'Aucun résultat',
    downloadall: 'Tout télécharger',
    convertlanguage: 'CONVERTIR LA LANGUE DU FICHIER',
    newlanguage: 'Nouvelle langue',
    contentfileconverted: 'Le contenu du fichier converti sera affiché ici',
    historyconvertedfilelanguage: 'Historique du fichier converti',
    historyconvertedfiletoimage: 'Historique converti',
    historyconvertedfiletolanguagetranslated: 'Traduit : ',
    downloading: '⏳ Téléchargement...',
    downloadcompleted: '✅Téléchargement terminé !',
    convertedfiletoimage: 'Fichier → Image',
    imagefrom: 'Image à partir du fichier',
    downloadthisimage: 'Télécharger cette image',
    downloadthisallimage: 'Télécharger toutes les images',
    close: 'Fermer',
    nohistory: 'Aucun historique disponible.',
    deleteconfirm: 'Êtes-vous sûr ?',
    deleteconfirm2: 'Êtes-vous sûr de vouloir supprimer cet historique ?',
    deletebtt: 'Supprimer',
    deletewholehistory: 'Supprimer tout l\'historique',
    deletewholehistory2: 'Cette action ne peut pas être annulée',
    hasbeendeleted: '🧹 L\'historique a été supprimé',
    hasbeendeleted1file: '🧹 L\'historique de 1 fichier a été supprimé',
    hasbeendeleted1image: '🧹 L\'historique de 1 image a été supprimé',
    language_appear: '🔍 Détection de la langue...',
    language_translated_success: '✅ Traduit avec succès !',
    language_detect_error: '❌ Erreur lors de la traduction',
    language_received: '✅ URL de téléchargement reçue :',
    language_error: '⚠️ Erreur :',
    language_choose_method: 'Choisissez la méthode de traduction',
    language_ask: 'Voulez-vous traduire tout le fichier ou par segments ?',
    language_trans_all: 'Tout traduire',
    language_trans_chunk: 'Traduire par segments',
    language_seperate: '⏳ Séparation des segments...',
    language_trans_already:
        '✅ Segments traités !\nVeuillez prévisualiser le contenu.',
    language_error_seperate: '❌ Erreur de traitement des segments',
    language_convert: 'État de la conversion',
    language_down_file: '✅ Fichier téléchargé :',
    all_convert_no: 'Impossible de quitter',
    all_convert_no2: 'Conversion en cours. Veuillez attendre la fin.',
    ok: 'OK',
    language_history: 'Voir l\'historique de conversion',
    language_file_chose: '📄 Fichier sélectionné :',
    language_processing: 'Traitement... Veuillez patienter',
    download_file_trans: 'Télécharger le fichier traduit',
    download_already: '✅ Téléchargement terminé',
    download_this_file: 'Télécharger ce fichier',
    file_choose_method: 'Choisir la méthode de conversion',
    file_ask:
        'Voulez-vous convertir tout le fichier ou sélectionner des parties ?',
    file_all: 'Tout',
    file_seperate: 'Parties',
    file_processing: '⏳ Traitement...',
    file_process_temp: '✅ Données temp récupérées. Changement d\'écran...',
    file_converted_success: '✅ Conversion réussie',
    file_converted_error: '❌ Erreur lors de la conversion',
    file_cannot_out: 'Impossible de quitter',
    file_cannot_out2: 'Conversion en cours. Veuillez attendre la fin.',
    file_history_title: 'Voir l\'historique de conversion',
    file_hasbeensaved: '✅ Image enregistrée dans la galerie !',
    file_open: 'Ouvrir',
    file_download: 'Téléchargement de l\'image',
    file_downloading: 'Téléchargement',
    file_image: 'image...',
    file_image_hasbeenchose: 'Sélectionné :',
    file_image_see: 'Voir l\'image',
    downloading_image: '⏳ Téléchargement de l\'image...',
    cannot_open_file: '❌ Impossible de télécharger l\'image',
    no_image_to_download: 'Aucune image à télécharger',
    download_all_image: '⏳ Téléchargement de toutes les images...',
    file_saved: '✅ Enregistré',
    image_to_gallery: 'image dans la galerie !',
    open_gallery: '📸 Ouvrir la galerie',
    cannot_loading: 'Impossible de charger l\'historique.',
    no_image_saved: 'Aucune image enregistrée.',
    download_already_all_image: '✅ Toutes les images chargées !',
    font_bold_word: 'Veuillez sélectionner le texte pour changer la police !',
    font_cannot_open: '⚠️ Impossible d\'ouvrir le fichier :',
    font_download_error: '⚠️ Erreur de téléchargement :',
    font_error_export: '⚠️ Erreur d\'exportation :',
    font_edit: 'Modifier la police',
    font_tip: '💡 Astuce : Sélectionnez le texte puis choisissez la police.',
    font_content: 'Contenu du texte...',
    font_export_DOCX: 'Exporter DOCX',
    font_export_PDF: 'Exporter PDF',
    font_error_file: '❌ Erreur : Impossible d\'obtenir le chemin',
    font_converted: '✅ Tout converti en',
    font_link_below: 'Lien de téléchargement ci-dessous.',
    font_no_text: 'Le fichier ne contient pas de texte !',
    font_install: 'Veuillez installer Word/Office depuis le Google Store.',
    font_instruction: 'Instruction',
    font_history: 'Historique',
    font_done: 'Terminé !',
    font_download_again: 'Re-téléchargement...',
    font_history_screen: 'Historique des polices',
    font_delete: 'Supprimer cet élément ?',
    font_delete_sure: 'Voulez-vous vraiment supprimer cet élément ?',
    image_downloaded: '✅ Téléchargé',
    image: 'image',
    image_open_library: 'et galerie ouverte avec succès',
    image_please_choose: '⚠️ Veuillez sélectionner au moins 1 image !',
    image_exported_success: '✅ Export réussi ! Ouverture de l\'historique...',
    image_adjust_sepe: 'Ajuster chaque image',
    image_all: 'Tout',
    image_cancel: 'Désélectionner',
    image_page: 'Page',
    image_type: 'Ext',
    image_tap_to_choose: 'Appuyez pour choisir',
    image_exported: 'EXPORTER',
    image_to_history: 'IMAGE VERS HISTOIRE',
    language_detected: '🌐 Détecté :',
    language_translating: '⏳ Traduction...',
    language_hasbeen_detected: '✅ Langue détectée :',
    language_error_file: '❌ Erreur de chargement :',
    language_hasbeen_exported: '✅ Fichier exporté :',
    language_being_exportPDF: '⏳ Création du PDF, veuillez patienter...',
    language_PDF: '✅ PDF exporté :',
    language_doc: 'Éditeur de documents',
    language_typing: 'Entrez la traduction...',
    language_translate_again: 'Retraduire',
    language_done: 'Fini',
    language_tutorial_detail: 'Tutoriel détaillé',
    language_tutorial_choose:
        'Il y a 2 types de traduction : Tout et Par segments',
    language_understand: 'Compris, Commencer !',
    language_step:
        'Étape 1 : Appuyez sur le menu déroulant de langue pour choisir la langue cible.',
    language_step2:
        'Étape 2 : Cliquez sur Télécharger le fichier (Stockage/Drive), sélectionnez le fichier. Lorsque la boîte de dialogue apparaît, choisissez "Tout traduire" et attendez le retour du système.',
    language_step3:
        'Étape 1 : Cliquez sur Télécharger le fichier et l\'écran Stockage + Google Drive apparaîtra.',
    language_step4:
        'Étape 2 : Trouvez et sélectionnez le fichier. Dans la boîte de dialogue, cliquez immédiatement sur "Traduire par segments". L\'écran détaillé apparaîtra.',
    language_step5:
        'Étape 3 : Trouvez les segments à modifier, cliquez sur le mot/segment pour changer la langue ou modifier selon vos souhaits.',
    language_step6:
        'Étape 4 : Après modification, cliquez en haut à droite pour Exporter en DOCX ou PDF.',
    font_step:
        'Étape 1 : Appuyez sur le menu déroulant de police pour choisir le nouveau style de police.',
    font_step2:
        'Étape 2 : Cliquez sur Télécharger le fichier, sélectionnez le fichier. Lorsque la boîte de dialogue apparaît, cliquez immédiatement sur "Tout" et attendez.',
    font_step3:
        'Étape 1 : Cliquez sur Télécharger le fichier et l\'écran Stockage + Google Drive apparaîtra.',
    font_step4:
        'Étape 2 : Trouvez et sélectionnez le fichier. Dans la boîte de dialogue, cliquez immédiatement sur "Parties". L\'écran de conversion partielle apparaîtra.',
    font_step5:
        'Étape 3 : Sélectionnez les segments dont vous voulez changer la police en cliquant dessus. Pour des mots individuels, appuyez pour retaper ou supprimer.',
    font_step6:
        'Étape 4 : Après modification, cliquez sur le bouton en haut à droite pour exporter le fichier en DOCX ou PDF.',
    image_step:
        'Étape 1 : Appuyez sur le menu déroulant de type d\'image pour choisir le fichier image à convertir (PNG, JPG...).',
    image_step2:
        'Étape 2 : Cliquez sur Télécharger le fichier, sélectionnez le fichier. Lorsque la boîte de dialogue apparaît, cliquez immédiatement sur "Tout" et attendez.',
    image_step3:
        'Étape 1 : Cliquez sur Télécharger le fichier et l\'écran Stockage + Google Drive apparaîtra.',
    image_step4:
        'Étape 2 : Trouvez et sélectionnez le fichier. Dans la boîte de dialogue, cliquez immédiatement sur "Parties". L\'écran de conversion partielle apparaîtra.',
    image_step5:
        'Étape 3 : Sur cet écran, sélectionnez les images à modifier en cliquant sur chaque image selon vos souhaits.',
    image_step6:
        'Étape 4 : Après modification, cliquez sur le bouton vert en bas pour exporter le fichier.',
    understand: 'Compris, Commencer !',
    language_swip: 'Balayez vers la gauche ou appuyez ici pour voir plus',
    image_select: 'Il y a 2 types de conversion : "Tout" et "Parties"',
    image_seperate: 'Convertir des parties',
    font_select: 'Il y a 2 types de conversion : "Tout" et "Parties"',
    seperate: 'Parties',
    home_tutorial1: '1. Choisir la police',
    home_quote1: 'Appuyez ici pour choisir le type de police à essayer.',
    home_tutorial2: '2. Entrer le texte',
    home_quote2: 'Tapez le contenu que vous souhaitez essayer dans cette case.',
    home_tutorial3: '3. Formater le texte',
    home_quote3:
        'Personnalisez Gras, Italique, Souligné ou Changez la couleur du texte ici.',
    home_tutorial4: '4. Résultat',
    home_quote4: 'Le texte après saisie et personnalisation apparaîtra ici.',
    home_tutorial5: '5. Actions rapides',
    home_quote5: 'Copier le résultat ou effacer pour recommencer.',
    home_tutorial6: '6. Barre de navigation',
    home_quote6:
        'Basculer entre les écrans : Profil, À propos, Outils, Paramètres et Déconnexion.',
    home_tutorial7: '7. Infos personnelles',
    home_quote7: 'Voir vos informations.',
    home_tutorial8: '8. À propos de l\'app',
    home_quote8:
        'En savoir plus sur les informations et fonctions de l\'application.',
    home_tutorial9: '9. Sélectionner outils',
    home_quote9:
        'Où choisir les outils pour convertir le texte selon vos souhaits.',
    home_tutorial10: '10. Paramètres',
    home_quote10:
        'Personnaliser l\'interface, la langue \n et Politiques de confidentialité & Conditions générales.',
    home_tutorial11: '11. Déconnexion',
    home_quote11: 'Se déconnecter du compte actuel.',
    privacy_term: 'Confidentialité et Conditions',
    notify: 'Notification',
    update_pdf:
        'La fonction d\'exportation PDF est en cours de développement.\nVeuillez revenir plus tard !',
    vietnamese: 'Vietnamien',
    english: 'Anglais',
    german: 'Allemand',
    french: 'Français',
    italian: 'Italien',
    spanish: 'Espagnol',
    portuguese: 'Portugais',
    chinese: 'Chinois (Simplifié)',
    korean: 'Coréen',
    japanese: 'Japonais',
    russian: 'Russe',
    language_download_successed:
        '✅ Téléchargement réussi ! Voulez-vous ouvrir le fichier ?',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> ES = {
    title: 'Bienvenido a Écolive',
    body:
        'Tu herramienta profesional para conversión de fuentes, traducción de documentos y procesamiento de archivo a imagen.',
    title2: 'Convertidor de fuentes profesional',
    body2:
        'Cambia instantáneamente las fuentes en tus documentos de Word y PDF. Personaliza estilos con facilidad.',
    title3: 'Traducción de documentos',
    body3:
        'Traduce archivos completos o segmentos específicos a varios idiomas conservando el formato original.',
    title4: 'Convertir archivo a imagen',
    body4:
        'Convierte tus documentos en imágenes de alta calidad (PNG/JPG). ¿Listo para empezar?',
    skip: 'Saltar',
    next: 'Siguiente',
    finish: 'Terminar',
    settings: 'Configuraciones',
    light_darkmode: 'Modo claro / oscuro',
    language: 'Idioma',
    app_name: 'Écolive',
    enter_text: 'Ingresar texto',
    converted_text: 'Texto convertido',
    converted_text_description: 'Tu texto convertido aparecerá aquí...',
    copy: 'Copiar',
    reset: 'Restablecer',
    savePDF: 'Guardar como PDF',
    saveWord: 'Guardar como Word',
    profile: 'Perfil',
    feeds: 'Fuentes',
    blog: 'Blog',
    achievements: 'Logros',
    feedDS: 'Las fuentes se mostrarán aquí',
    blogDS: 'Las publicaciones del blog se mostrarán aquí',
    achievementsDS: 'Los logros se mostrarán aquí',
    aboutapp: 'Acerca de la aplicación',
    appdescription: """
Écolive te ayuda a convertir formatos de texto e idiomas de manera fácil y efectiva.

• Conversión de Fuentes: Admite la conversión entre fuentes del sistema disponibles, ayudándote a cambiar el estilo del texto rápidamente.\n
• Conversión de Formato: Convierte documentos Word/PDF en archivos de imagen de alta calidad.\n
• Traducción Automática: Traduce texto automáticamente de un idioma a otro, apoyando tu trabajo y estudios.
""",
    ecosiasr: 'Busca en la web para plantar árboles...',
    ecosiaDS: 'Árboles plantados por usuarios de Ecosia',
    aiselection: 'SELECCIÓN A.I',
    aiinstruction: 'elija cualquier tipo de herramienta que quiera utilizar',
    aibtt1: 'CHATBOT',
    aibtt2: 'CONVERTIR ARCHIVO A IMAGEN',
    aibtt3: 'CONVERTIR IDIOMA DE ARCHIVO',
    aiinfo: 'INFORMACIÓN',
    historyname: 'Historial de conversiones',
    historystatus: 'Aún no hay historial.',
    confirmlogout: 'Confirmar cierre de sesión',
    logoutDS: '¿Quieres salir?',
    cancel: 'Cancelar',
    exit: 'Salir',
    seeyou: 'Hasta pronto',
    logoutbtt: 'Cerrar sesión',
    emailtxt: 'Ingresa tu correo electrónico',
    passwordtxt: 'Ingresa tu contraseña',
    loginbtt: 'Iniciar sesión',
    forgotpassword: '¿Olvidaste tu contraseña?',
    or: 'o',
    googletxt: 'Continuar con Google',
    signuptxt: '¿No tienes una cuenta?',
    signupbtt: 'Regístrate',
    signup_name: 'Ingresa tu nombre',
    signup_email: 'Ingresa tu correo electrónico',
    signup_password: 'Ingresa tu contraseña',
    signup_confirmpassword: 'Confirma tu contraseña',
    signup_btt: 'Regístrate',
    signup_passwordNoti: 'Por favor completa todos los campos.',
    signup_Noti: 'Por favor ingresa una dirección de correo electrónico válida',
    signup_Noti_invalid:
        'Por favor ingresa una dirección de correo electrónico válida',
    signup_Noti_8ch: 'La contraseña debe tener al menos 8 caracteres',
    resendEmail: 'Reenviar correo electrónico de verificación',
    resendWait: 'Esperar',
    signup_alreadyDS: '¿Ya tienes una cuenta?',
    login_signup_btt: 'Iniciar sesión',
    login_email_hint: 'Ingresa tu correo electrónico',
    forgotpptxt: 'Olvidaste tu contraseña',
    forgotpphint: 'Ingresa tu correo electrónico',
    forgotppsendbtt: 'Enviar',
    forgotppPlenter: 'Por favor ingresa tu correo electrónico',
    forgotppCheckmail:
        'Revisa tu correo electrónico para un enlace de restablecimiento de contraseña',
    ggcheckfail:
        'Error de inicio de sesión de Google. Por favor intenta de nuevo.',
    signupdonmatch: 'Las contraseñas no coinciden',
    signup_field: 'Por favor completa todos los campos.',
    login_email_auth: '¡Formato de correo electrónico no válido!',
    login_email_verify:
        'Por favor verifica tu correo electrónico antes de iniciar sesión.',
    resPP_notify: 'Por favor completa tu información',
    resPP_email_auth: '¡Formato de correo electrónico no válido!',
    resPP_email_send:
        'Correo electrónico de restablecimiento de contraseña enviado con éxito',
    resendEmailVerify: '¡Correo electrónico de verificación enviado!',
    resendUserno:
        'No se encontró ningún usuario. Por favor inicia sesión primero.',
    resendEmailalready: 'Tu correo electrónico ya está verificado.',
    signup_email_format: '¡Formato de correo electrónico no válido!',
    signup_password_format:
        'La contraseña debe tener al menos 8 caracteres, contener letras y números.',
    signup_email_inbox:
        'Se ha enviado un correo electrónico de verificación. Por favor revisa tu bandeja de entrada.',
    forgotpasswordWord: 'Olvidaste tu contraseña',
    forgotpasswordHint: 'Ingresa tu correo electrónico',
    forgotpasswordbtt: 'Enviar',
    forgotpasswordEx: 'abc@gmai.com',
    forgotpasswordnotify:
        '¡Enlace de restablecimiento enviado! Por favor revisa tu correo electrónico.',
    toolsselection: 'SELECCIÓN DE HERRAMIENTAS',
    tool1: 'CONVERSIÓN AUTOMÁTICA DE FUENTE',
    enginedescription: """
Écolive Converter es una aplicación que ayuda a:

Convertir automáticamente las fuentes en documentos de Word/PDF.
Exportar documentos a formatos de imagen (PNG, JPG, ...).
Traducir texto de un idioma a otro.

⚡ Desarrollado por
• Flutter → para construir aplicaciones multiplataforma (móvil, escritorio, web).
• Python (FastAPI) → backend para el procesamiento de documentos (fuentes, PDF → imagen, traducción de idiomas).
• Google Cloud Firestore → para almacenar el historial de conversiones.
• Google Cloud Storage / Firebase Storage → para almacenar documentos de entrada y salida.
• Google Translate API → para la traducción automática de varios idiomas.
• Uvicorn → para ejecutar el servidor backend de Python.
""",
    previewscreen: 'Pantalla de vista previa',
    pickatextcolor: 'Elige un color de texto',
    previewstatus: 'No hay contenido',
    font_converter_title: 'Convertidor de fuentes',
    new_font: 'Nueva fuente',
    preview_title: 'Vista previa',
    result_converted: 'Resultado convertido',
    uploadfile: 'SUBIR ARCHIVO',
    fileconverted: 'El archivo convertido se mostrará aquí',
    selectedfromstorage: 'Seleccionar desde el almacenamiento del dispositivo',
    selectedfromgoogledrive: 'Seleccionar desde Google Drive',
    downloadbtt: 'Descargar',
    nofiledownload: 'No hay archivo para descargar.',
    filetoimage: 'Archivo a imagen',
    sortofimage: 'Tipo de imagen',
    noresult: 'No hay resultado',
    downloadall: 'Descargar todo',
    convertlanguage: 'CONVERTIR IDIOMA DEL ARCHIVO',
    newlanguage: 'Nuevo idioma',
    contentfileconverted:
        'El contenido del archivo convertido se mostrará aquí',
    historyconvertedfilelanguage: 'Historial de archivos convertidos',
    historyconvertedfiletoimage: 'Historial convertido',
    historyconvertedfiletolanguagetranslated: 'Traducido: ',
    downloading: '⏳ Descargando...',
    downloadcompleted: '✅¡Descarga completada!',
    convertedfiletoimage: 'Archivo → Imagen',
    imagefrom: 'Imagen desde archivo',
    downloadthisimage: 'Descargar esta imagen',
    downloadthisallimage: 'Descargar todas las imágenes',
    close: 'Cerrar',
    nohistory: 'No hay historial disponible.',
    deleteconfirm: '¿Estás seguro?',
    deleteconfirm2: '¿Estás seguro de eliminar este historial?',
    deletebtt: 'Eliminar',
    deletewholehistory: 'Eliminar todo el historial',
    deletewholehistory2: 'Esta acción no se puede deshacer',
    hasbeendeleted: '🧹 El historial ha sido eliminado',
    hasbeendeleted1file: '🧹 1 historial de archivo ha sido eliminado',
    hasbeendeleted1image: '🧹 1 historial de imagen ha sido eliminado',
    language_appear: '🔍 Detectando idioma...',
    language_translated_success: '✅¡Traducido con éxito!',
    language_detect_error: '❌ Error al traducir',
    language_received: '✅ URL de descarga recibida:',
    language_error: '⚠️ Error:',
    language_choose_method: 'Elige el método de traducción',
    language_ask: '¿Quieres traducir todo el archivo o por fragmentos?',
    language_trans_all: 'Traducir todo',
    language_trans_chunk: 'Traducir fragmentos',
    language_seperate: '⏳ Dividiendo fragmentos...',
    language_trans_already:
        '✅ ¡Fragmentos procesados!\nPor favor, previsualiza el contenido.',
    language_error_seperate: '❌ Error al procesar fragmentos',
    language_convert: 'Estado de conversión',
    language_down_file: '✅ Archivo descargado:',
    all_convert_no: 'No se puede salir',
    all_convert_no2: 'Conversión en progreso. Por favor espera a que termine.',
    ok: 'OK',
    language_history: 'Ver historial de conversión',
    language_file_chose: '📄 Archivo seleccionado:',
    language_processing: 'Procesando... Por favor espera',
    download_file_trans: 'Descargar archivo traducido',
    download_already: '✅ Descarga completada',
    download_this_file: 'Descargar este archivo',
    file_choose_method: 'Elegir método de conversión',
    file_ask: '¿Quieres convertir todo el archivo o seleccionar partes?',
    file_all: 'Todo',
    file_seperate: 'Partes',
    file_processing: '⏳ Procesando...',
    file_process_temp: '✅ Datos temporales obtenidos. Cambiando pantalla...',
    file_converted_success: '✅ Conversión exitosa',
    file_converted_error: '❌ Error al convertir',
    file_cannot_out: 'No se puede salir',
    file_cannot_out2: 'Conversión en progreso. Por favor espera a que termine.',
    file_history_title: 'Ver historial de conversión',
    file_hasbeensaved: '✅ ¡Imagen guardada en la galería!',
    file_open: 'Abrir',
    file_download: 'Descargando imagen',
    file_downloading: 'Descargando',
    file_image: 'imagen...',
    file_image_hasbeenchose: 'Seleccionado:',
    file_image_see: 'Ver imagen',
    downloading_image: '⏳ Descargando imagen...',
    cannot_open_file: '❌ No se puede descargar la imagen',
    no_image_to_download: 'No hay imágenes para descargar',
    download_all_image: '⏳ Descargando todas las imágenes...',
    file_saved: '✅ Guardado',
    image_to_gallery: 'imagen en galería!',
    open_gallery: '📸 Abrir galería',
    cannot_loading: 'No se puede cargar el historial.',
    no_image_saved: 'No hay imágenes guardadas.',
    download_already_all_image: '✅ ¡Todas las imágenes cargadas!',
    font_bold_word: '¡Resalta (selecciona) el texto para cambiar la fuente!',
    font_cannot_open: '⚠️ No se puede abrir el archivo:',
    font_download_error: '⚠️ Error de descarga:',
    font_error_export: '⚠️ Error de exportación:',
    font_edit: 'Editar fuente',
    font_tip: '💡 Consejo: Resalta el texto y selecciona la fuente arriba.',
    font_content: 'Contenido del texto...',
    font_export_DOCX: 'Exportar DOCX',
    font_export_PDF: 'Exportar PDF',
    font_error_file: '❌ Error: No se pudo obtener la ruta del archivo',
    font_converted: '✅ Convertido todo a',
    font_link_below: 'Enlace de descarga abajo.',
    font_no_text: '¡El archivo no tiene texto!',
    font_install: 'Por favor instala Word/Office desde Google Store.',
    font_instruction: 'Instrucción',
    font_history: 'Historial',
    font_done: '¡Hecho!',
    font_download_again: 'Volviendo a descargar...',
    font_history_screen: 'Historial de conversión de fuentes',
    font_delete: '¿Eliminar este elemento?',
    font_delete_sure: '¿Estás seguro de eliminar este elemento?',
    image_downloaded: '✅ Descargado',
    image: 'imagen',
    image_open_library: 'y galería abierta con éxito',
    image_please_choose: '⚠️ ¡Selecciona al menos 1 imagen!',
    image_exported_success: '✅ ¡Exportación exitosa! Abriendo historial...',
    image_adjust_sepe: 'Ajustar cada imagen',
    image_all: 'Todo',
    image_cancel: 'Deseleccionar',
    image_page: 'Pág',
    image_type: 'Ext',
    image_tap_to_choose: 'Toca para seleccionar',
    image_exported: 'EXPORTAR',
    image_to_history: 'IMAGEN AL HISTORIAL',
    language_detected: '🌐 Detectado:',
    language_translating: '⏳ Traduciendo...',
    language_hasbeen_detected: '✅ Idioma detectado:',
    language_error_file: '❌ Error al cargar archivo:',
    language_hasbeen_exported: '✅ Archivo exportado:',
    language_being_exportPDF: '⏳ Creando PDF, espera...',
    language_PDF: '✅ PDF exportado:',
    language_doc: 'Editor de documentos',
    language_typing: 'Ingresa la traducción...',
    language_translate_again: 'Volver a traducir',
    language_done: 'Listo',
    language_tutorial_detail: 'Tutorial detallado',
    language_tutorial_choose: 'Hay 2 tipos de traducción: Todo y Fragmentos',
    language_understand: '¡Entendido, Empezar!',
    language_step:
        'Paso 1: Toca el menú desplegable de idioma para seleccionar el idioma al que deseas traducir.',
    language_step2:
        'Paso 2: Haz clic en Subir archivo (Almacenamiento/Drive), selecciona el archivo. Cuando aparezca el diálogo, selecciona "Traducir todo" y espera.',
    language_step3:
        'Paso 1: Haz clic en Subir archivo y aparecerá la pantalla de Almacenamiento + Google Drive.',
    language_step4:
        'Paso 2: Busca y selecciona el archivo. En el diálogo, haz clic en "Traducir fragmentos" inmediatamente. Aparecerá la pantalla de detalles.',
    language_step5:
        'Paso 3: Busca los segmentos que deseas cambiar, haz clic en esa palabra/segmento para cambiar el idioma o editar según desees.',
    language_step6:
        'Paso 4: Después de editar, haz clic en la esquina superior derecha para Exportar DOCX o PDF.',
    font_step:
        'Paso 1: Toca el menú desplegable de fuente para seleccionar el nuevo estilo de fuente.',
    font_step2:
        'Paso 2: Haz clic en Subir archivo, selecciona el archivo. Cuando aparezca el diálogo, haz clic en "Todo" inmediatamente y espera.',
    font_step3:
        'Paso 1: Haz clic en Subir archivo y aparecerá la pantalla de Almacenamiento + Google Drive.',
    font_step4:
        'Paso 2: Busca y selecciona el archivo. En el diálogo, haz clic en "Partes" inmediatamente. Aparecerá la pantalla de conversión parcial.',
    font_step5:
        'Paso 3: Selecciona los segmentos donde deseas cambiar la fuente haciendo clic en ellos. Para palabras individuales, toca para reescribir o eliminar.',
    font_step6:
        'Paso 4: Después de editar, haz clic en el botón superior derecho para exportar el archivo como DOCX o PDF.',
    image_step:
        'Paso 1: Toca el menú desplegable de tipo de imagen para seleccionar el archivo de imagen a convertir (PNG, JPG...).',
    image_step2:
        'Paso 2: Haz clic en Subir archivo, selecciona el archivo. Cuando aparezca el diálogo, haz clic en "Todo" inmediatamente y espera.',
    image_step3:
        'Paso 1: Haz clic en Subir archivo y aparecerá la pantalla de Almacenamiento + Google Drive.',
    image_step4:
        'Paso 2: Busca y selecciona el archivo. En el diálogo, haz clic en "Partes" inmediatamente. Aparecerá la pantalla de conversión parcial.',
    image_step5:
        'Paso 3: En esta pantalla, selecciona las imágenes que deseas cambiar haciendo clic en cada imagen según desees.',
    image_step6:
        'Paso 4: Después de editar, haz clic en el botón verde en la parte inferior para exportar el archivo.',
    understand: '¡Entendido, Empezar!',
    language_swip: 'Desliza a la izquierda o toca aquí para ver más',
    image_select: 'Hay 2 tipos de conversión: "Todo" y "Partes"',
    image_seperate: 'Convertir partes',
    font_select: 'Hay 2 tipos de conversión: "Todo" y "Partes"',
    seperate: 'Partes',
    home_tutorial1: '1. Seleccionar Fuente',
    home_quote1: 'Toca aquí para elegir el tipo de fuente que deseas probar.',
    home_tutorial2: '2. Ingresar Texto',
    home_quote2: 'Escribe el contenido que deseas probar en este cuadro.',
    home_tutorial3: '3. Formato de Texto',
    home_quote3:
        'Personaliza Negrita, Cursiva, Subrayado o Cambia el color del texto aquí.',
    home_tutorial4: '4. Resultado',
    home_quote4:
        'El texto después de ser ingresado y personalizado aparecerá aquí.',
    home_tutorial5: '5. Acciones rápidas',
    home_quote5: 'Copiar el resultado o borrar para empezar de nuevo.',
    home_tutorial6: '6. Barra de navegación',
    home_quote6:
        'Cambiar entre pantallas: Perfil, Acerca de, Herramientas, Configuración y Cerrar sesión.',
    home_tutorial7: '7. Info Personal',
    home_quote7: 'Ver tu información.',
    home_tutorial8: '8. Acerca de la App',
    home_quote8:
        'Aprende más sobre la información y funciones de la aplicación.',
    home_tutorial9: '9. Seleccionar Herramientas',
    home_quote9: 'Donde elegir herramientas para convertir texto según desees.',
    home_tutorial10: '10. Configuración',
    home_quote10:
        'Personalizar interfaz, idioma de la app \n y Políticas de Privacidad y Términos y Condiciones.',
    home_tutorial11: '11. Cerrar sesión',
    home_quote11: 'Cerrar sesión de la cuenta actual.',
    privacy_term: 'Privacidad y Términos',
    notify: 'Aviso',
    update_pdf:
        'La función de exportación a PDF está en desarrollo.\n¡Por favor, vuelve más tarde!',
    vietnamese: 'Vietnamita',
    english: 'Inglés',
    german: 'Alemán',
    french: 'Francés',
    italian: 'Italiano',
    spanish: 'Español',
    portuguese: 'Portugués',
    chinese: 'Chino (Simplificado)',
    korean: 'Coreano',
    japanese: 'Japonés',
    russian: 'Ruso',
    language_download_successed:
        '✅ ¡Descarga completada! ¿Quieres abrir el archivo?',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> IT = {
    title: 'Benvenuto in Écolive',
    body:
        'Il tuo strumento professionale per la conversione di font, traduzione di documenti e conversione da file a immagine.',
    title2: 'Convertitore di font professionale',
    body2:
        'Cambia istantaneamente i font nei tuoi documenti Word e PDF. Personalizza gli stili con facilità.',
    title3: 'Traduzione di documenti',
    body3:
        'Traduci interi file o segmenti specifici in più lingue mantenendo la formattazione originale.',
    title4: 'Converti file in immagine',
    body4:
        'Trasforma i tuoi documenti in immagini di alta qualità (PNG/JPG). Pronto per iniziare?',
    skip: 'Salta',
    next: 'Prossimo',
    finish: 'Fine',
    settings: 'Impostazioni',
    light_darkmode: 'Modalità chiara / scura',
    language: 'Lingua',
    app_name: 'Écolive',
    enter_text: 'Inserisci testo',
    converted_text: 'Testo convertito',
    converted_text_description: 'Il tuo testo convertito apparirà qui...',
    copy: 'Copia',
    reset: 'Ripristina',
    savePDF: 'Salva come PDF',
    saveWord: 'Salva come Word',
    profile: 'Profilo',
    feeds: 'Feed',
    blog: 'Blog',
    achievements: 'Risultati',
    feedDS: 'I feed verranno visualizzati qui',
    blogDS: 'I post del blog verranno visualizzati qui',
    achievementsDS: 'I risultati verranno visualizzati qui',
    aboutapp: 'Informazioni sull\'app',
    appdescription: """
Écolive ti aiuta a convertire formati di testo e lingue in modo semplice ed efficace.

• Conversione Font: Supporta la conversione tra i font di sistema disponibili, aiutandoti a cambiare rapidamente lo stile del testo.\n
• Conversione Formato: Trasforma documenti Word/PDF in file immagine di alta qualità.\n
• Traduzione Automatica: Traduci automaticamente il testo da una lingua all'altra, supportando il tuo lavoro e studio.
""",
    ecosiasr: 'Cerca sul web per piantare alberi...',
    ecosiaDS: 'Alberi piantati dagli utenti di Ecosia',
    aiselection: 'SELEZIONE A.I',
    aiinstruction: 'Scegli il tipo di strumenti che vuoi usare',
    aibtt1: 'CHATBOT',
    aibtt2: 'CONVERTI FILE IN IMMAGINE',
    aibtt3: 'CONVERTI LINGUA DEL FILE',
    aiinfo: 'INFORMAZIONI',
    historyname: 'Cronologia conversioni',
    historystatus: 'Nessuna cronologia ancora.',
    confirmlogout: 'Conferma disconnessione',
    logoutDS: 'Vuoi uscire?',
    cancel: 'Annulla',
    exit: 'Uscita',
    seeyou: 'A presto',
    logoutbtt: 'Disconnettersi',
    emailtxt: 'Inserisci la tua email',
    passwordtxt: 'Inserisci la tua password',
    loginbtt: 'Accedi',
    forgotpassword: 'Password dimenticata?',
    or: 'o',
    googletxt: 'Continua con Google',
    signuptxt: 'Non hai un account?',
    signupbtt: 'Registrati',
    signup_name: 'Inserisci il tuo nome',
    signup_email: 'Inserisci la tua email',
    signup_password: 'Inserisci la tua password',
    signup_confirmpassword: 'Conferma la tua password',
    signup_btt: 'Registrati',
    signup_passwordNoti: 'Si prega di compilare tutti i campi.',
    signup_Noti: 'Si prega di inserire un indirizzo email valido',
    signup_Noti_invalid: 'Si prega di inserire un indirizzo email valido',
    signup_Noti_8ch: 'La password deve contenere almeno 8 caratteri',
    resendEmail: 'Reinvia email di verifica',
    resendWait: 'Aspetta',
    signup_alreadyDS: 'Hai già un account?',
    login_signup_btt: 'Accedi',
    login_email_hint: 'Inserisci la tua email',
    forgotpptxt: 'Password dimenticata',
    forgotpphint: 'Inserisci la tua email',
    forgotppsendbtt: 'Invia',
    forgotppPlenter: 'Si prega di inserire la propria email',
    forgotppCheckmail:
        'Controlla la tua email per un link per reimpostare la password',
    ggcheckfail: 'Accesso Google non riuscito. Si prega di riprovare.',
    signupdonmatch: 'Le password non corrispondono',
    signup_field: 'Si prega di compilare tutti i campi.',
    login_email_auth: 'Formato email non valido!',
    login_email_verify:
        'Si prega di verificare la propria email prima di accedere.',
    resPP_notify: 'Si prega di completare le proprie informazioni',
    resPP_email_auth: 'Formato email non valido!',
    resPP_email_send: 'Email di reimpostazione password inviata con successo',
    resendEmailVerify: 'Email di verifica inviata!',
    resendUserno: 'Nessun utente trovato. Si prega di accedere prima.',
    resendEmailalready: 'La tua email è già verificata.',
    signup_email_format: 'Formato email non valido!',
    signup_password_format:
        'La password deve contenere almeno 8 caratteri, lettere e numeri.',
    signup_email_inbox:
        'È stata inviata un\'email di verifica. Si prega di controllare la propria casella di posta.',
    forgotpasswordWord: 'Password dimenticata',
    forgotpasswordHint: 'Inserisci la tua email',
    forgotpasswordbtt: 'Invia',
    forgotpasswordEx: 'abc@gmail.com',
    forgotpasswordnotify:
        'Link di reimpostazione inviato! Si prega di controllare la propria email.',
    toolsselection: 'SELEZIONE STRUMENTI',
    tool1: 'CONVERSIONE AUTOMATICA DEI CARATTERI',
    enginedescription: """
Écolive Converter è un'applicazione che supporta:

La conversione automatica dei caratteri nei documenti Word/PDF.
L'esportazione di documenti in formati immagine (PNG, JPG, ...).
La traduzione di testi da una lingua all'altra.

⚡ Alimentato da
• Flutter → per la creazione di applicazioni multipiattaforma (mobile, desktop, web).
• Python (FastAPI) → backend per l'elaborazione di documenti (caratteri, PDF → immagine, traduzione linguistica).
• Google Cloud Firestore → per l'archiviazione della cronologia delle conversioni.
• Google Cloud Storage / Firebase Storage → per l'archiviazione dei documenti di input e output.
• Google Translate API → per la traduzione automatica di più lingue.
• Uvicorn → per l'esecuzione del server backend Python.
""",
    previewscreen: 'Schermata di anteprima',
    pickatextcolor: 'Scegli un colore del testo',
    previewstatus: 'Non ci sono contenuti',
    font_converter_title: 'Convertitore di caratteri',
    new_font: 'Nuovo carattere',
    preview_title: 'Anteprima',
    result_converted: 'Risultato convertito',
    uploadfile: 'CARICA FILE',
    fileconverted: 'Il file convertito verrà mostrato qui',
    selectedfromstorage: 'Seleziona dalla memoria del dispositivo',
    selectedfromgoogledrive: 'Seleziona da Google Drive',
    downloadbtt: 'Scarica',
    nofiledownload: 'Nessun file da scaricare.',
    filetoimage: 'File in immagine',
    sortofimage: 'Tipo di immagine',
    noresult: 'Nessun risultato',
    downloadall: 'Scarica tutto',
    convertlanguage: 'CONVERTI LINGUA DEL FILE',
    newlanguage: 'Nuova lingua',
    contentfileconverted: 'Il contenuto del file convertito verrà mostrato qui',
    historyconvertedfilelanguage: 'Cronologia file convertiti',
    historyconvertedfiletoimage: 'Cronologia convertita',
    historyconvertedfiletolanguagetranslated: 'Tradotto: ',
    downloading: '⏳Download in corso...',
    downloadcompleted: '✅Download completato!',
    convertedfiletoimage: 'File → Immagine',
    imagefrom: 'Immagine da file',
    downloadthisimage: 'Scarica questa immagine',
    downloadthisallimage: 'Scarica tutte le immagini',
    close: 'Chiudi',
    nohistory: 'Nessuna cronologia disponibile.',
    deleteconfirm: 'Sei sicuro?',
    deleteconfirm2: 'Sei sicuro di voler eliminare questa cronologia?',
    deletebtt: 'Elimina',
    deletewholehistory: 'Elimina tutta la cronologia',
    deletewholehistory2: 'Questa azione non può essere annullata',
    hasbeendeleted: '🧹 La cronologia è stata eliminata',
    hasbeendeleted1file: '🧹 1 cronologia file è stata eliminata',
    hasbeendeleted1image: '🧹 1 cronologia immagine è stata eliminata',
    language_appear: '🔍 Rilevamento lingua in corso...',
    language_translated_success: '✅ Tradotto con successo!',
    language_detect_error: '❌ Errore durante la traduzione',
    language_received: '✅ URL di download ricevuta:',
    language_error: '⚠️ Errore:',
    language_choose_method: 'Scegli il metodo di traduzione',
    language_ask: 'Vuoi tradurre l\'intero file o per segmenti?',
    language_trans_all: 'Traduci tutto',
    language_trans_chunk: 'Traduci segmenti',
    language_seperate: '⏳ Divisione segmenti...',
    language_trans_already:
        '✅ Segmenti elaborati!\nVisualizza l\'anteprima del contenuto.',
    language_error_seperate: '❌ Errore elaborazione segmenti',
    language_convert: 'Stato conversione',
    language_down_file: '✅ File scaricato:',
    all_convert_no: 'Impossibile uscire',
    all_convert_no2: 'Conversione in corso. Attendi il completamento.',
    ok: 'OK',
    language_history: 'Vedi cronologia conversioni',
    language_file_chose: '📄 File selezionato:',
    language_processing: 'Elaborazione... Attendere prego',
    download_file_trans: 'Scarica file tradotto',
    download_already: '✅ Download completato',
    download_this_file: 'Scarica questo file',
    file_choose_method: 'Scegli metodo di conversione',
    file_ask: 'Vuoi convertire l\'intero file o selezionare parti?',
    file_all: 'Tutto',
    file_seperate: 'Parti',
    file_processing: '⏳ Elaborazione...',
    file_process_temp: '✅ Dati temp recuperati. Cambio schermata...',
    file_converted_success: '✅ Conversione riuscita',
    file_converted_error: '❌ Errore durante la conversione',
    file_cannot_out: 'Impossibile uscire',
    file_cannot_out2: 'Conversione in corso. Attendi il completamento.',
    file_history_title: 'Vedi cronologia conversioni',
    file_hasbeensaved: '✅ Immagine salvata nella galleria!',
    file_open: 'Apri',
    file_download: 'Scaricamento immagine',
    file_downloading: 'Scaricamento',
    file_image: 'immagine...',
    file_image_hasbeenchose: 'Selezionato:',
    file_image_see: 'Vedi immagine',
    downloading_image: '⏳ Scaricamento immagine...',
    cannot_open_file: '❌ Impossibile scaricare immagine',
    no_image_to_download: 'Nessuna immagine da scaricare',
    download_all_image: '⏳ Scaricamento di tutte le immagini...',
    file_saved: '✅ Salvato',
    image_to_gallery: 'immagine in galleria!',
    open_gallery: '📸 Apri galleria',
    cannot_loading: 'Impossibile caricare la cronologia.',
    no_image_saved: 'Nessuna immagine salvata.',
    download_already_all_image: '✅ Tutte le immagini caricate!',
    font_bold_word: 'Evidenzia (seleziona) il testo per cambiare Font!',
    font_cannot_open: '⚠️ Impossibile aprire il file:',
    font_download_error: '⚠️ Errore di download:',
    font_error_export: '⚠️ Errore di esportazione:',
    font_edit: 'Modifica Font',
    font_tip: '💡 Suggerimento: Evidenzia il testo e seleziona il Font sopra.',
    font_content: 'Contenuto del testo...',
    font_export_DOCX: 'Esporta DOCX',
    font_export_PDF: 'Esporta PDF',
    font_error_file: '❌ Errore: Impossibile ottenere il percorso del file',
    font_converted: '✅ Convertito tutto in',
    font_link_below: 'Link di download qui sotto.',
    font_no_text: 'Il file non ha contenuto di testo!',
    font_install: 'Si prega di installare Word/Office su Google Store.',
    font_instruction: 'Istruzioni',
    font_history: 'Cronologia',
    font_done: 'Completato!',
    font_download_again: 'Scaricamento di nuovo...',
    font_history_screen: 'Cronologia conversione Font',
    font_delete: 'Eliminare questo elemento?',
    font_delete_sure: 'Sei sicuro di voler eliminare questo elemento?',
    image_downloaded: '✅ Scaricato',
    image: 'immagine',
    image_open_library: 'e galleria aperta con successo',
    image_please_choose: '⚠️ Seleziona almeno 1 immagine!',
    image_exported_success: '✅ Esportazione riuscita! Apertura cronologia...',
    image_adjust_sepe: 'Regola ogni immagine',
    image_all: 'Tutto',
    image_cancel: 'Deseleziona',
    image_page: 'Pagina',
    image_type: 'Est',
    image_tap_to_choose: 'Tocca per selezionare',
    image_exported: 'ESPORTA',
    image_to_history: 'IMMAGINE IN CRONOLOGIA',
    language_detected: '🌐 Rilevato:',
    language_translating: '⏳ Traduzione...',
    language_hasbeen_detected: '✅ Lingua rilevata:',
    language_error_file: '❌ Errore caricamento file:',
    language_hasbeen_exported: '✅ File esportato:',
    language_being_exportPDF: '⏳ Creazione PDF, attendere...',
    language_PDF: '✅ PDF esportato:',
    language_doc: 'Editor di documenti',
    language_typing: 'Inserisci traduzione...',
    language_translate_again: 'Ritraduci',
    language_done: 'Fatto',
    language_tutorial_detail: 'Tutorial dettagliato',
    language_tutorial_choose:
        'Ci sono 2 tipi di traduzione: Tutto e Per segmenti',
    language_understand: 'Capito, Inizia!',
    language_step:
        'Passo 1: Tocca il menu a discesa della lingua per selezionare la lingua in cui desideri tradurre.',
    language_step2:
        'Passo 2: Clicca Carica File (Memoria/Drive), seleziona il file. Quando appare la finestra di dialogo, seleziona "Traduci Tutto" e attendi.',
    language_step3:
        'Passo 1: Clicca Carica File e apparirà la schermata Memoria + Google Drive.',
    language_step4:
        'Passo 2: Trova e seleziona il file. Nella finestra di dialogo, clicca subito su "Traduci Segmenti". Apparirà la schermata dettagliata.',
    language_step5:
        'Passo 3: Trova i segmenti che vuoi cambiare, clicca su quella parola/segmento per cambiare la lingua o modificare come desideri.',
    language_step6:
        'Passo 4: Dopo la modifica, clicca nell\'angolo in alto a destra per Esportare in DOCX o PDF.',
    font_step:
        'Passo 1: Tocca il menu a discesa del font per selezionare il nuovo stile di carattere.',
    font_step2:
        'Passo 2: Clicca Carica File, seleziona il file. Quando appare la finestra di dialogo, clicca subito su "Tutto" e attendi.',
    font_step3:
        'Passo 1: Clicca Carica File e apparirà la schermata Memoria + Google Drive.',
    font_step4:
        'Passo 2: Trova e seleziona il file. Nella finestra di dialogo, clicca subito su "Parti". Apparirà la schermata di conversione parziale.',
    font_step5:
        'Passo 3: Seleziona i segmenti in cui vuoi cambiare Font cliccandoci sopra. Per singole parole, tocca per ridigitare o eliminare.',
    font_step6:
        'Passo 4: Dopo la modifica, clicca sul pulsante in alto a destra per esportare il file come DOCX o PDF.',
    image_step:
        'Passo 1: Tocca il menu a discesa del tipo di immagine per selezionare il file immagine da convertire (PNG, JPG...).',
    image_step2:
        'Passo 2: Clicca Carica File, seleziona il file. Quando appare la finestra di dialogo, clicca subito su "Tutto" e attendi.',
    image_step3:
        'Passo 1: Clicca Carica File e apparirà la schermata Memoria + Google Drive.',
    image_step4:
        'Passo 2: Trova e seleziona il file. Nella finestra di dialogo, clicca subito su "Parti". Apparirà la schermata di conversione parziale.',
    image_step5:
        'Passo 3: In questa schermata, seleziona le immagini che vuoi cambiare cliccando su ogni immagine come desideri.',
    image_step6:
        'Passo 4: Dopo la modifica, clicca sul pulsante verde in basso per esportare il file.',
    understand: 'Capito, Inizia!',
    language_swip: 'Scorri a sinistra o tocca qui per vedere altro',
    image_select: 'Ci sono 2 tipi di conversione: "Tutto" e "Parti"',
    image_seperate: 'Converti parti',
    font_select: 'Ci sono 2 tipi di conversione: "Tutto" e "Parti"',
    seperate: 'Parti',
    home_tutorial1: '1. Seleziona Font',
    home_quote1: 'Tocca qui per scegliere il tipo di Font che vuoi provare.',
    home_tutorial2: '2. Inserisci Testo',
    home_quote2: 'Digita il contenuto che vuoi provare in questa casella.',
    home_tutorial3: '3. Formatta Testo',
    home_quote3:
        'Personalizza Grassetto, Corsivo, Sottolineato o Cambia colore testo qui.',
    home_tutorial4: '4. Risultato',
    home_quote4:
        'Il testo dopo essere stato inserito e personalizzato apparirà qui.',
    home_tutorial5: '5. Azioni Rapide',
    home_quote5: 'Copia il risultato o cancella per ricominciare.',
    home_tutorial6: '6. Barra di Navigazione',
    home_quote6:
        'Passa tra le schermate: Profilo, Info, Strumenti, Impostazioni e Logout.',
    home_tutorial7: '7. Info Personali',
    home_quote7: 'Visualizza le tue informazioni.',
    home_tutorial8: '8. Info App',
    home_quote8:
        'Scopri di più sulle informazioni e funzioni dell\'applicazione.',
    home_tutorial9: '9. Seleziona Strumenti',
    home_quote9:
        'Dove scegliere gli strumenti per convertire il testo come desiderato.',
    home_tutorial10: '10. Impostazioni',
    home_quote10:
        'Personalizza interfaccia, lingua app \n e Privacy Policy & Termini e Condizioni.',
    home_tutorial11: '11. Logout',
    home_quote11: 'Disconnettiti dall\'account corrente.',
    privacy_term: 'Privacy e Termini',
    notify: 'Avviso',
    update_pdf:
        'La funzione di esportazione PDF è in fase di sviluppo.\nSi prega di riprovare più tardi!',
    vietnamese: 'Vietnamita',
    english: 'Inglese',
    german: 'Tedesco',
    french: 'Francese',
    italian: 'Italiano',
    spanish: 'Spagnolo',
    portuguese: 'Portoghese',
    chinese: 'Cinese (Semplificato)',
    korean: 'Coreano',
    japanese: 'Giapponese',
    russian: 'Russo',
    language_download_successed: '✅ Download completato! Vuoi aprire il file?',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> PT = {
    title: 'Bem-vindo ao Écolive',
    body:
        'Sua ferramenta profissional para conversão de fontes, tradução de documentos e conversão de arquivo para imagem.',
    title2: 'Conversor de fontes profissional',
    body2:
        'Altere instantaneamente as fontes em seus documentos Word e PDF. Personalize estilos com facilidade.',
    title3: 'Tradução de documentos',
    body3:
        'Traduza arquivos inteiros ou segmentos específicos para vários idiomas, mantendo a formatação original.',
    title4: 'Converter arquivo para imagem',
    body4:
        'Transforme seus documentos em imagens de alta qualidade (PNG/JPG). Pronto para começar?',
    skip: 'Pular',
    next: 'Próximo',
    finish: 'Concluir',
    settings: 'Configurações',
    light_darkmode: 'Modo claro / escuro',
    language: 'Idioma',
    app_name: 'Écolive',
    enter_text: 'Digite o texto',
    converted_text: 'Texto convertido',
    converted_text_description: 'Seu texto convertido aparecerá aqui...',
    copy: 'Copiar',
    reset: 'Redefinir',
    savePDF: 'Salvar como PDF',
    saveWord: 'Salvar como Word',
    profile: 'Perfil',
    feeds: 'Feeds',
    blog: 'Blog',
    achievements: 'Conquistas',
    feedDS: 'Os feeds serão exibidos aqui',
    blogDS: 'As postagens do blog serão exibidas aqui',
    achievementsDS: 'As conquistas serão exibidas aqui',
    aboutapp: 'Sobre o aplicativo',
    appdescription: """
Écolive ajuda você a converter formatos de texto e idiomas de forma fácil e eficaz.

• Conversão de Fonte: Suporta a conversão entre fontes do sistema disponíveis, ajudando a alterar o estilo do texto rapidamente.\n
• Conversão de Formato: Transforme documentos Word/PDF em arquivos de imagem de alta qualidade.\n
• Tradução Automática: Traduza texto automaticamente de um idioma para outro, apoiando seu trabalho e estudos.
""",
    ecosiasr: 'Pesquise na web para plantar árvores...',
    ecosiaDS: 'Árvores plantadas por usuários do Ecosia',
    aiselection: 'SELEÇÃO A.I',
    aiinstruction: 'Escolha qualquer tipo de ferramentas que você queira usar',
    aibtt1: 'CHATBOT',
    aibtt2: 'CONVERTER ARQUIVO PARA IMAGEM',
    aibtt3: 'CONVERTER IDIOMA DE ARQUIVO',
    aiinfo: 'INFORMAÇÃO',
    historyname: 'Histórico de conversão',
    historystatus: 'Nenhum histórico ainda.',
    confirmlogout: 'Confirmar logout',
    logoutDS: 'Você quer sair?',
    cancel: 'Cancelar',
    exit: 'Sair',
    seeyou: 'Até logo',
    logoutbtt: 'Sair',
    emailtxt: 'Digite seu e-mail',
    passwordtxt: 'Digite sua senha',
    loginbtt: 'Entrar',
    forgotpassword: 'Esqueceu a senha?',
    or: 'ou',
    googletxt: 'Continuar com o Google',
    signuptxt: 'Não tem uma conta?',
    signupbtt: 'Registrar',
    signup_name: 'Digite seu nome',
    signup_email: 'Digite seu e-mail',
    signup_password: 'Digite sua senha',
    signup_confirmpassword: 'Confirme sua senha',
    signup_btt: 'Registrar',
    signup_passwordNoti: 'Por favor, preencha todos os campos.',
    signup_Noti: 'Por favor, insira um endereço de e-mail válido',
    signup_Noti_invalid: 'Por favor, insira um endereço de e-mail válido',
    signup_Noti_8ch: 'A senha deve ter pelo menos 8 caracteres',
    resendEmail: 'Reenviar e-mail de verificação',
    resendWait: 'Aguarde',
    signup_alreadyDS: 'Já tem uma conta?',
    login_signup_btt: 'Entrar',
    login_email_hint: 'Digite seu e-mail',
    forgotpptxt: 'Esqueceu sua senha',
    forgotpphint: 'Digite seu e-mail',
    forgotppsendbtt: 'Enviar',
    forgotppPlenter: 'Por favor, insira seu e-mail',
    forgotppCheckmail:
        'Verifique seu e-mail para um link de redefinição de senha',
    ggcheckfail: 'Falha ao fazer login no Google. Por favor, tente novamente.',
    signupdonmatch: 'As senhas não correspondem',
    signup_field: 'Por favor, preencha todos os campos.',
    login_email_auth: 'Formato de e-mail inválido!',
    login_email_verify: 'Verifique seu e-mail antes de fazer login.',
    resPP_notify: 'Por favor, preencha suas informações',
    resPP_email_auth: 'Formato de e-mail inválido!',
    resPP_email_send:
        'E-mail de redefinição de palavra-passe enviado com sucesso',
    resendEmailVerify: 'E-mail de verificação enviado!',
    resendUserno: 'Nenhum usuário encontrado. Faça login primeiro.',
    resendEmailalready: 'Seu e-mail já está verificado.',
    signup_email_format: 'Formato de e-mail inválido!',
    signup_password_format:
        'A senha deve ter pelo menos 8 caracteres, conter letras e números.',
    signup_email_inbox:
        'Um e-mail de verificação foi enviado. Verifique sua caixa de entrada.',
    forgotpasswordWord: 'Esqueceu sua senha',
    forgotpasswordHint: 'Digite seu e-mail',
    forgotpasswordbtt: 'Enviar',
    forgotpasswordEx: 'abc@gmail.com',
    forgotpasswordnotify: 'Link de redefinição enviado! Verifique seu e-mail.',
    toolsselection: 'SELEÇÃO DE FERRAMENTAS',
    tool1: 'CONVERSÃO AUTOMÁTICA DE FONTE',
    enginedescription: """
Écolive Converter é um aplicativo que oferece suporte a:

Conversão automática de fontes em documentos Word/PDF.
Exportação de documentos para formatos de imagem (PNG, JPG, ...).
Tradução de texto de um idioma para outro.

⚡ Desenvolvido por
• Flutter → para criar aplicativos multiplataforma (mobile, desktop, web).
• Python (FastAPI) → backend para processamento de documentos (fontes, PDF → imagem, tradução de idioma).
• Google Cloud Firestore → para armazenar o histórico de conversão.
• Google Cloud Storage / Firebase Storage → para armazenar documentos de entrada e saída.
• Google Translate API → para tradução automática de vários idiomas.
• Uvicorn → para executar o servidor backend Python.
""",
    previewscreen: 'Tela de visualização',
    pickatextcolor: 'Escolha uma cor de texto',
    previewstatus: 'Não há conteúdo',
    font_converter_title: 'Conversor de fonte',
    new_font: 'Nova fonte',
    preview_title: 'Visualização',
    result_converted: 'Resultado convertido',
    uploadfile: 'CARREGAR ARQUIVO',
    fileconverted: 'O arquivo convertido será exibido aqui',
    selectedfromstorage: 'Selecionar do armazenamento do dispositivo',
    selectedfromgoogledrive: 'Selecionar do Google Drive',
    downloadbtt: 'Baixar',
    nofiledownload: 'Nenhum arquivo para baixar.',
    filetoimage: 'Arquivo para imagem',
    sortofimage: 'Tipo de imagem',
    noresult: 'Nenhum resultado',
    downloadall: 'Baixar tudo',
    convertlanguage: 'CONVERTER IDIOMA DO ARQUIVO',
    newlanguage: 'Novo idioma',
    contentfileconverted: 'O conteúdo do arquivo convertido será exibido aqui',
    historyconvertedfilelanguage: 'Histórico de arquivos convertidos',
    historyconvertedfiletoimage: 'Histórico convertido',
    historyconvertedfiletolanguagetranslated: 'Traduzido: ',
    downloading: '⏳ Baixando...',
    downloadcompleted: '✅Download concluído!',
    convertedfiletoimage: 'Arquivo → Imagem',
    imagefrom: 'Imagem do arquivo',
    downloadthisimage: 'Baixar esta imagem',
    downloadthisallimage: 'Baixar todas as imagens',
    close: 'Fechar',
    nohistory: 'Nenhum histórico disponível.',
    deleteconfirm: 'Você tem certeza?',
    deleteconfirm2: 'Você tem certeza de que deseja excluir este histórico?',
    deletebtt: 'Excluir',
    deletewholehistory: 'Excluir todo o histórico',
    deletewholehistory2: 'Esta ação não pode ser desfeita',
    hasbeendeleted: '🧹 O histórico foi excluído',
    hasbeendeleted1file: '🧹 1 histórico de arquivo foi excluído',
    hasbeendeleted1image: '🧹 1 histórico de imagem foi excluído',
    language_appear: '🔍 Detectando idioma...',
    language_translated_success: '✅ Traduzido com sucesso!',
    language_detect_error: '❌ Erro ao traduzir',
    language_received: '✅ URL de download recebida:',
    language_error: '⚠️ Erro:',
    language_choose_method: 'Escolha o método de tradução',
    language_ask: 'Deseja traduzir o arquivo inteiro ou por trechos?',
    language_trans_all: 'Traduzir tudo',
    language_trans_chunk: 'Traduzir trechos',
    language_seperate: '⏳ Separando trechos...',
    language_trans_already:
        '✅ Trechos processados!\nPor favor, visualize o conteúdo.',
    language_error_seperate: '❌ Erro ao processar trechos',
    language_convert: 'Status da conversão',
    language_down_file: '✅ Arquivo baixado:',
    all_convert_no: 'Não é possível sair',
    all_convert_no2: 'Conversão em andamento. Aguarde a conclusão.',
    ok: 'OK',
    language_history: 'Ver histórico de conversão',
    language_file_chose: '📄 Arquivo selecionado:',
    language_processing: 'Processando... Por favor, aguarde',
    download_file_trans: 'Baixar arquivo traduzido',
    download_already: '✅ Download concluído',
    download_this_file: 'Baixar este arquivo',
    file_choose_method: 'Escolher método de conversão',
    file_ask: 'Deseja converter o arquivo inteiro ou selecionar partes?',
    file_all: 'Tudo',
    file_seperate: 'Partes',
    file_processing: '⏳ Processando...',
    file_process_temp: '✅ Dados temporários obtidos. Trocando tela...',
    file_converted_success: '✅ Conversão bem-sucedida',
    file_converted_error: '❌ Erro durante a conversão',
    file_cannot_out: 'Não é possível sair',
    file_cannot_out2: 'Conversão em andamento. Aguarde a conclusão.',
    file_history_title: 'Ver histórico de conversão',
    file_hasbeensaved: '✅ Imagem salva na galeria!',
    file_open: 'Abrir',
    file_download: 'Baixando imagem',
    file_downloading: 'Baixando',
    file_image: 'imagem...',
    file_image_hasbeenchose: 'Selecionado:',
    file_image_see: 'Ver imagem',
    downloading_image: '⏳ Baixando imagem...',
    cannot_open_file: '❌ Não foi possível baixar a imagem',
    no_image_to_download: 'Nenhuma imagem para baixar',
    download_all_image: '⏳ Baixando todas as imagens...',
    file_saved: '✅ Salvo',
    image_to_gallery: 'imagem na galeria!',
    open_gallery: '📸 Abrir galeria',
    cannot_loading: 'Não foi possível carregar o histórico.',
    no_image_saved: 'Nenhuma imagem salva.',
    download_already_all_image: '✅ Todas as imagens carregadas!',
    font_bold_word: 'Realce (selecione) o texto para alterar a fonte!',
    font_cannot_open: '⚠️ Não é possível abrir o arquivo:',
    font_download_error: '⚠️ Erro no download:',
    font_error_export: '⚠️ Erro na exportação:',
    font_edit: 'Editar Fonte',
    font_tip: '💡 Dica: Realce o texto e selecione a fonte acima.',
    font_content: 'Conteúdo do texto...',
    font_export_DOCX: 'Exportar DOCX',
    font_export_PDF: 'Exportar PDF',
    font_error_file: '❌ Erro: Caminho do arquivo não encontrado',
    font_converted: '✅ Convertido tudo para',
    font_link_below: 'Link de download abaixo.',
    font_no_text: 'O arquivo não tem texto!',
    font_install: 'Instale o Word/Office na Google Store.',
    font_instruction: 'Instrução',
    font_history: 'Histórico',
    font_done: 'Concluído!',
    font_download_again: 'Baixando novamente...',
    font_history_screen: 'Histórico de fontes',
    font_delete: 'Excluir este item?',
    font_delete_sure: 'Tem certeza que deseja excluir este item?',
    image_downloaded: '✅ Baixado',
    image: 'imagem',
    image_open_library: 'e galeria aberta com sucesso',
    image_please_choose: '⚠️ Selecione pelo menos 1 imagem!',
    image_exported_success: '✅ Exportação bem-sucedida! Abrindo histórico...',
    image_adjust_sepe: 'Ajustar cada imagem',
    image_all: 'Tudo',
    image_cancel: 'Desmarcar',
    image_page: 'Pág',
    image_type: 'Ext',
    image_tap_to_choose: 'Toque para selecionar',
    image_exported: 'EXPORTAR',
    image_to_history: 'IMAGEM PARA HISTÓRICO',
    language_detected: '🌐 Detectado:',
    language_translating: '⏳ Traduzindo...',
    language_hasbeen_detected: '✅ Idioma detectado:',
    language_error_file: '❌ Erro ao carregar arquivo:',
    language_hasbeen_exported: '✅ Arquivo exportado:',
    language_being_exportPDF: '⏳ Criando PDF, aguarde...',
    language_PDF: '✅ PDF exportado:',
    language_doc: 'Editor de documentos',
    language_typing: 'Digite a tradução...',
    language_translate_again: 'Retraduzir',
    language_done: 'Pronto',
    language_tutorial_detail: 'Tutorial detalhado',
    language_tutorial_choose: 'Existem 2 tipos de tradução: Tudo e Trechos',
    language_understand: 'Entendi, Começar!',
    language_step:
        'Passo 1: Toque no menu suspenso de idioma para selecionar o idioma para o qual deseja traduzir.',
    language_step2:
        'Passo 2: Clique em Carregar Arquivo (Armazenamento/Drive), selecione o arquivo. Quando a caixa de diálogo aparecer, selecione "Traduzir Tudo" e aguarde.',
    language_step3:
        'Passo 1: Clique em Carregar Arquivo e a tela Armazenamento + Google Drive aparecerá.',
    language_step4:
        'Passo 2: Encontre e selecione o arquivo. Na caixa de diálogo, clique em "Traduzir Trechos" imediatamente. A tela de detalhes aparecerá.',
    language_step5:
        'Passo 3: Encontre os segmentos que deseja alterar, clique nessa palavra/segmento para mudar o idioma ou editar conforme desejado.',
    language_step6:
        'Passo 4: Após editar, clique no canto superior direito para Exportar DOCX ou PDF.',
    font_step:
        'Passo 1: Toque no menu suspenso de fonte para selecionar o novo estilo de fonte.',
    font_step2:
        'Passo 2: Clique em Carregar Arquivo, selecione o arquivo. Quando a caixa de diálogo aparecer, clique em "Tudo" imediatamente e aguarde.',
    font_step3:
        'Passo 1: Clique em Carregar Arquivo e a tela Armazenamento + Google Drive aparecerá.',
    font_step4:
        'Passo 2: Encontre e selecione o arquivo. Na caixa de diálogo, clique em "Partes" imediatamente. A tela de conversão parcial aparecerá.',
    font_step5:
        'Passo 3: Selecione os segmentos onde deseja alterar a fonte clicando neles. Para palavras individuais, toque para redigitar ou excluir.',
    font_step6:
        'Passo 4: Após editar, clique no botão superior direito para exportar o arquivo como DOCX ou PDF.',
    image_step:
        'Passo 1: Toque no menu suspenso de tipo de imagem para selecionar o arquivo de imagem a converter (PNG, JPG...).',
    image_step2:
        'Passo 2: Clique em Carregar Arquivo, selecione o arquivo. Quando a caixa de diálogo aparecer, clique em "Tudo" imediatamente e aguarde.',
    image_step3:
        'Passo 1: Clique em Carregar Arquivo e a tela Armazenamento + Google Drive aparecerá.',
    image_step4:
        'Passo 2: Encontre e selecione o arquivo. Na caixa de diálogo, clique em "Partes" imediatamente. A tela de conversão parcial aparecerá.',
    image_step5:
        'Passo 3: Nesta tela, selecione as imagens que deseja alterar clicando em cada imagem conforme desejado.',
    image_step6:
        'Passo 4: Após editar, clique no botão verde na parte inferior para exportar o arquivo.',
    understand: 'Entendi, Começar!',
    language_swip: 'Deslize para a esquerda ou toque aqui para ver mais',
    image_select: 'Existem 2 tipos de conversão: "Tudo" e "Partes"',
    image_seperate: 'Converter partes',
    font_select: 'Existem 2 tipos de conversão: "Tudo" e "Partes"',
    seperate: 'Partes',
    home_tutorial1: '1. Selecionar Fonte',
    home_quote1: 'Toque aqui para escolher o tipo de fonte que deseja testar.',
    home_tutorial2: '2. Inserir Texto',
    home_quote2: 'Digite o conteúdo que deseja testar nesta caixa.',
    home_tutorial3: '3. Formatar Texto',
    home_quote3:
        'Personalize Negrito, Itálico, Sublinhado ou Mude a cor do texto aqui.',
    home_tutorial4: '4. Resultado',
    home_quote4: 'O texto após ser inserido e personalizado aparecerá aqui.',
    home_tutorial5: '5. Ações Rápidas',
    home_quote5: 'Copiar o resultado ou limpar para começar de novo.',
    home_tutorial6: '6. Barra de Navegação',
    home_quote6:
        'Alternar entre telas: Perfil, Sobre, Ferramentas, Configurações e Sair.',
    home_tutorial7: '7. Info Pessoal',
    home_quote7: 'Ver suas informações.',
    home_tutorial8: '8. Sobre o App',
    home_quote8: 'Saiba mais sobre as informações e funções do aplicativo.',
    home_tutorial9: '9. Selecionar Ferramentas',
    home_quote9:
        'Onde escolher ferramentas para converter texto conforme desejado.',
    home_tutorial10: '10. Configurações',
    home_quote10:
        'Personalizar interface, idioma do app \n e Políticas de Privacidade e Termos e Condições.',
    home_tutorial11: '11. Sair',
    home_quote11: 'Sair da conta atual.',
    privacy_term: 'Privacidade e Termos',
    notify: 'Aviso',
    update_pdf:
        'A função de exportação de PDF está em desenvolvimento.\nPor favor, volte mais tarde!',
    vietnamese: 'Vietnamita',
    english: 'Inglês',
    german: 'Alemão',
    french: 'Francês',
    italian: 'Italiano',
    spanish: 'Espanhol',
    portuguese: 'Português',
    chinese: 'Chinês (Simplificado)',
    korean: 'Coreano',
    japanese: 'Japonês',
    russian: 'Russo',
    language_download_successed:
        '✅ Download concluído! Deseja abrir o arquivo?',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> CN = {
    title: '欢迎来到 Écolive',
    body: '您的专业工具，用于字体转换、文档翻译和文件转图像处理。',
    title2: '专业字体转换器',
    body2: '即时更改 Word 和 PDF 文档中的字体。轻松自定义文档样式。',
    title3: '文档翻译',
    body3: '将整个文件或特定段落翻译成多种语言，同时保留原始格式。',
    title4: '将文件转换为图像',
    body4: '将您的文档转换为高质量图像（PNG/JPG）。准备好开始了吗？',
    skip: '跳过',
    next: '下一个',
    finish: '完成',
    settings: '设置',
    light_darkmode: '明亮/黑暗模式',
    language: '语言',
    app_name: 'Écolive',
    enter_text: '输入文本',
    converted_text: '转换的文本',
    converted_text_description: '您的转换文本将在这里显示...',
    copy: '复制',
    reset: '重置',
    savePDF: '保存为PDF',
    saveWord: '保存为Word',
    profile: '个人资料',
    feeds: '动态',
    blog: '博客',
    achievements: '成就',
    feedDS: '动态将在这里显示',
    blogDS: '博客文章将在这里显示',
    achievementsDS: '成就将在这里显示',
    aboutapp: '关于应用程序',
    appdescription: """
Écolive 帮助您轻松高效地转换文本格式和语言。

• 字体转换：支持在可用系统字体之间转换，帮助您快速更改文本显示风格。\n
• 格式转换：将 Word/PDF 文档转换为高质量图像文件。\n
• 自动翻译：自动将文本从一种语言翻译成另一种语言，支持您的工作和学习。
""",
    ecosiasr: '搜索网络以种植树木...',
    ecosiaDS: 'Ecosia用户种植的树木',
    aiselection: '人工智能选择',
    aiinstruction: '选择你想使用的任何一种工具',
    aibtt1: '人工智能聊天机器人',
    aibtt2: '将文件转换为图像',
    aibtt3: '转换文件语言',
    aiinfo: '信息',
    historyname: '转换历史',
    historystatus: '尚无历史记录。',
    confirmlogout: '确认注销',
    logoutDS: '你想离开吗？',
    cancel: '取消',
    exit: '退出',
    seeyou: '再见',
    logoutbtt: '登出',
    emailtxt: '输入您的电子邮件',
    passwordtxt: '输入您的密码',
    loginbtt: '登录',
    forgotpassword: '忘记密码？',
    or: '或者',
    googletxt: '继续使用谷歌',
    signuptxt: '还没有帐户？',
    signupbtt: '注册',
    signup_name: '输入您的姓名',
    signup_email: '输入您的电子邮件',
    signup_password: '输入您的密码',
    signup_confirmpassword: '确认您的密码',
    signup_btt: '注册',
    signup_passwordNoti: '请填写所有字段。',
    signup_Noti: '请输入有效的电子邮件地址',
    signup_Noti_invalid: '请输入有效的电子邮件地址',
    signup_Noti_8ch: '密码必须至少包含8个字符',
    resendEmail: '重新发送验证电子邮件',
    resendWait: '等待',
    signup_alreadyDS: '已经有一个帐户？',
    login_signup_btt: '登录',
    login_email_hint: '输入您的电子邮件',
    forgotpptxt: '忘记密码',
    forgotpphint: '输入您的电子邮件',
    forgotppsendbtt: '发送',
    forgotppPlenter: '请输入您的电子邮件',
    forgotppCheckmail: '检查您的电子邮件以获取重置密码的链接',
    ggcheckfail: 'Google登录失败。请再试一次。',
    signupdonmatch: '密码不匹配',
    signup_field: '请填写所有字段。',
    login_email_auth: '无效的电子邮件格式！',
    login_email_verify: '请在登录之前验证您的电子邮件。',
    resPP_notify: '请填写您的信息',
    resPP_email_auth: '电子邮件格式无效',
    resPP_email_send: '密码重置电子邮件已成功发送',
    resendEmailVerify: '验证电子邮件已发送！',
    resendUserno: '未找到用户。请先登录。',
    resendEmailalready: '您的电子邮件已被验证。',
    signup_email_format: '无效的电子邮件格式！',
    signup_password_format: '密码必须至少包含8个字符，包含字母和数字。',
    signup_email_inbox: '已发送验证电子邮件。请检查您的收件箱。',
    forgotpasswordWord: '忘记密码',
    forgotpasswordHint: '输入您的电子邮件',
    forgotpasswordbtt: '发送',
    forgotpasswordEx: '例如abc@gmail.com',
    forgotpasswordnotify: '重置链接已发送！请检查您的电子邮件。',
    toolsselection: '工具选择',
    tool1: '自动字体转换',
    enginedescription: """
Écolive Converter 是一款支持以下功能的应用程序：

自动转换 Word/PDF 文档中的字体。
将文档导出为图像格式（PNG、JPG 等）。
将文本从一种语言翻译成另一种语言。

⚡ 技术支持
• Flutter → 用于构建跨平台应用程序（移动、桌面、网络）。
• Python (FastAPI) → 用于处理文档的后端（字体、PDF → 图像、语言翻译）。
• Google Cloud Firestore → 用于存储转换历史记录。
• Google Cloud Storage / Firebase Storage → 用于存储输入和输出文档。
• Google Translate API → 用于多种语言的自动翻译。
• Uvicorn → 用于运行 Python 后端服务器。
""",
    previewscreen: '预览屏幕',
    pickatextcolor: '选择文本颜色',
    previewstatus: '没有内容',
    font_converter_title: '字体转换器',
    new_font: '新字体',
    preview_title: '预览',
    result_converted: '转换结果',
    uploadfile: '上传文件',
    fileconverted: '转换后的文件将显示在此处',
    selectedfromstorage: '从设备存储中选择',
    selectedfromgoogledrive: '从Google云端硬盘中选择',
    downloadbtt: '下载',
    nofiledownload: '没有可下载的文件。',
    filetoimage: '文件转图像',
    sortofimage: '图像类型',
    noresult: '没有结果',
    downloadall: '全部下载',
    convertlanguage: '转换文件语言',
    newlanguage: '新语言',
    contentfileconverted: '转换后的文件内容将显示在此处',
    historyconvertedfilelanguage: '转换文件历史记录',
    historyconvertedfiletoimage: '转换历史记录',
    historyconvertedfiletolanguagetranslated: '已翻译：',
    downloading: '⏳ 正在下载...',
    downloadcompleted: '✅下载完成！',
    convertedfiletoimage: '文件 → 图像',
    imagefrom: '来自文件的图像',
    downloadthisimage: '下载此图像',
    downloadthisallimage: '下载所有图像',
    close: '关闭',
    nohistory: '没有可用的历史记录。',
    deleteconfirm: '你确定吗？',
    deleteconfirm2: '你确定要删除此历史记录吗？',
    deletebtt: '删除',
    deletewholehistory: '删除所有历史记录',
    deletewholehistory2: '此操作无法撤消',
    hasbeendeleted: '🧹 历史记录已被删除',
    hasbeendeleted1file: '🧹 1 个文件历史记录已被删除',
    hasbeendeleted1image: '🧹 1 个图像历史记录已被删除',
    language_appear: '🔍 正在检测语言...',
    language_translated_success: '✅ 翻译成功！',
    language_detect_error: '❌ 翻译时出错',
    language_received: '✅ 下载URL已收到：',
    language_error: '⚠️ 错误：',
    language_choose_method: '选择翻译方法',
    language_ask: '您想翻译整个文件还是分段翻译？',
    language_trans_all: '全部翻译',
    language_trans_chunk: '分段翻译',
    language_seperate: '⏳ 正在分段...',
    language_trans_already: '✅ 分段处理完毕！\n请预览内容。',
    language_error_seperate: '❌ 分段处理出错',
    language_convert: '转换状态',
    language_down_file: '✅ 文件已下载：',
    all_convert_no: '无法退出',
    all_convert_no2: '转换正在进行中。请等待完成后再返回。',
    ok: '确定',
    language_history: '查看转换历史',
    language_file_chose: '📄 已选文件：',
    language_processing: '处理中... 请稍候',
    download_file_trans: '下载翻译文件',
    download_already: '✅ 下载完成',
    download_this_file: '下载此文件',
    file_choose_method: '选择转换方式',
    file_ask: '您想转换整个文件还是选择部分结果？',
    file_all: '全部',
    file_seperate: '部分',
    file_processing: '⏳ 处理中...',
    file_process_temp: '✅ 临时数据已获取。切换屏幕...',
    file_converted_success: '✅ 转换成功',
    file_converted_error: '❌ 转换时出错',
    file_cannot_out: '无法退出',
    file_cannot_out2: '转换正在进行中。请等待完成后再返回。',
    file_history_title: '查看转换历史',
    file_hasbeensaved: '✅ 图片已保存至相册！',
    file_open: '打开',
    file_download: '正在下载图片',
    file_downloading: '下载中',
    file_image: '图片...',
    file_image_hasbeenchose: '已选：',
    file_image_see: '查看图片',
    downloading_image: '⏳ 正在下载图片...',
    cannot_open_file: '❌ 无法下载图片',
    no_image_to_download: '没有图片可下载',
    download_all_image: '⏳ 正在下载所有图片...',
    file_saved: '✅ 已保存',
    image_to_gallery: '图片至相册！',
    open_gallery: '📸 打开相册',
    cannot_loading: '无法加载历史记录。',
    no_image_saved: '没有保存的图片。',
    download_already_all_image: '✅ 所有图片已加载！',
    font_bold_word: '请选中（高亮）文本以更改字体！',
    font_cannot_open: '⚠️ 无法打开文件：',
    font_download_error: '⚠️ 文件下载错误：',
    font_error_export: '⚠️ 导出错误：',
    font_edit: '编辑字体',
    font_tip: '💡 提示：选中文本，然后在上方选择字体。',
    font_content: '文本内容...',
    font_export_DOCX: '导出 DOCX',
    font_export_PDF: '导出 PDF',
    font_error_file: '❌ 错误：无法获取文件路径',
    font_converted: '✅ 已全部转换为',
    font_link_below: '下载链接在下方。',
    font_no_text: '文件没有文本内容！',
    font_install: '请在 Google Store 安装 Word/Office。',
    font_instruction: '说明',
    font_history: '历史记录',
    font_done: '完成！',
    font_download_again: '正在重新下载...',
    font_history_screen: '字体转换历史',
    font_delete: '删除此项目？',
    font_delete_sure: '您确定要删除此项目吗？',
    image_downloaded: '✅ 已下载',
    image: '图片',
    image_open_library: '并成功打开相册',
    image_please_choose: '⚠️ 请至少选择 1 张图片！',
    image_exported_success: '✅ 导出成功！正在打开历史记录...',
    image_adjust_sepe: '调整每张图片',
    image_all: '全部',
    image_cancel: '取消选择',
    image_page: '页',
    image_type: '格式',
    image_tap_to_choose: '点击选择',
    image_exported: '导出',
    image_to_history: '图片存入历史',
    language_detected: '🌐 检测到：',
    language_translating: '⏳ 正在翻译...',
    language_hasbeen_detected: '✅ 检测到的语言：',
    language_error_file: '❌ 加载文件错误：',
    language_hasbeen_exported: '✅ 文件已导出：',
    language_being_exportPDF: '⏳ 正在创建 PDF，请稍候...',
    language_PDF: '✅ PDF 已导出：',
    language_doc: '文档编辑器',
    language_typing: '输入翻译...',
    language_translate_again: '重新翻译',
    language_done: '完成',
    language_tutorial_detail: '详细教程',
    language_tutorial_choose: '有两种翻译类型：全部和分段',
    language_understand: '明白了，开始！',
    language_step: '步骤 1：点击新的语言下拉菜单以选择您想要翻译的目标语言。',
    language_step2: '步骤 2：点击上传文件（存储/Drive），选择文件。当对话框出现时，选择“全部翻译”并等待系统返回文件。',
    language_step3: '步骤 1：点击上传文件，将出现存储 + Google Drive 屏幕。',
    language_step4: '步骤 2：查找并选择文件。在对话框中，立即点击“分段翻译”。详细屏幕将出现。',
    language_step5: '步骤 3：找到要更改的段落，点击该单词/段落以更改语言或按需编辑。',
    language_step6: '步骤 4：编辑完成后，点击右上角导出 DOCX 或 PDF。',
    font_step: '步骤 1：点击新的字体下拉菜单以选择您想要转换的新字体样式。',
    font_step2: '步骤 2：点击上传文件，从存储或 Drive 中选择文件。当对话框出现时，立即点击“全部”并等待系统返回文件。',
    font_step3: '步骤 1：点击上传文件，将出现存储 + Google Drive 屏幕。',
    font_step4: '步骤 2：查找并选择文件。在对话框中，立即点击“部分”。部分转换屏幕将出现。',
    font_step5: '步骤 3：通过点击段落选择要更改字体的段落。对于单个单词，点击以重新输入或删除。',
    font_step6: '步骤 4：编辑完成后，点击右上角的按钮将文件导出为 DOCX 或 PDF。',
    image_step: '步骤 1：点击新的图像类型下拉菜单以选择您想要转换的图像文件（PNG，JPG...）。',
    image_step2: '步骤 2：点击上传文件，选择文件。当对话框出现时，立即点击“全部”并等待系统返回文件。',
    image_step3: '步骤 1：点击上传文件，将出现存储 + Google Drive 屏幕。',
    image_step4: '步骤 2：查找并选择文件。在对话框中，立即点击“部分”。部分转换屏幕将出现。',
    image_step5: '步骤 3：在此屏幕上，按需点击每个图像以选择要更改的图像。',
    image_step6: '步骤 4：编辑完成后，点击底部的绿色按钮导出文件。',
    understand: '明白了，开始！',
    language_swip: '向左滑动或点击此处查看更多',
    image_select: '有两种转换类型：“全部”和“部分”',
    image_seperate: '转换部分',
    font_select: '有两种转换类型：“全部”和“部分”',
    seperate: '部分',
    home_tutorial1: '1. 选择字体',
    home_quote1: '点击此处选择您想尝试的字体类型。',
    home_tutorial2: '2. 输入文本',
    home_quote2: '在此框中输入您想尝试的内容。',
    home_tutorial3: '3. 格式化文本',
    home_quote3: '在此处自定义粗体、斜体、下划线或更改文本颜色。',
    home_tutorial4: '4. 结果',
    home_quote4: '输入并自定义后的文本将显示在此处。',
    home_tutorial5: '5. 快速操作',
    home_quote5: '复制结果或清除以重新开始。',
    home_tutorial6: '6. 导航栏',
    home_quote6: '在屏幕之间切换：个人资料、关于、工具、设置和注销。',
    home_tutorial7: '7. 个人信息',
    home_quote7: '查看您的信息。',
    home_tutorial8: '8. 关于应用',
    home_quote8: '了解更多关于应用程序信息和功能的内容。',
    home_tutorial9: '9. 选择工具',
    home_quote9: '选择按需转换文本的工具的地方。',
    home_tutorial10: '10. 设置',
    home_quote10: '自定义界面、应用语言 \n 以及隐私政策和条款条件。',
    home_tutorial11: '11. 注销',
    home_quote11: '从当前帐户注销。',
    privacy_term: '隐私与条款',
    notify: '通知',
    update_pdf: 'PDF 导出功能正在开发中。\n请稍后再试！',
    vietnamese: '越南语',
    english: '英语',
    german: '德语',
    french: '法语',
    italian: '意大利语',
    spanish: '西班牙语',
    portuguese: '葡萄牙语',
    chinese: '中文 (简体)',
    korean: '韩语',
    japanese: '日语',
    russian: '俄语',
    language_download_successed: '✅ 下载成功！您想打开文件吗？',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> KR = {
    title: 'Écolive에 오신 것을 환영합니다',
    body: '글꼴 변환, 문서 번역 및 파일 이미지 변환을 위한 전문 도구입니다.',
    title2: '전문 글꼴 변환기',
    body2: 'Word 및 PDF 문서의 글꼴을 즉시 변경하세요. 문서 스타일을 쉽게 사용자 정의하십시오.',
    title3: '문서 번역',
    body3: '원래 서식을 유지하면서 전체 파일 또는 특정 세그먼트를 여러 언어로 번역합니다.',
    title4: '파일을 이미지로 변환',
    body4: '문서를 고품질 이미지(PNG/JPG)로 변환하세요. 시작할 준비가 되셨나요?',
    skip: '건너뛰기',
    next: '다음',
    finish: '완료',
    settings: '설정',
    light_darkmode: '라이트 / 다크 모드',
    language: '언어',
    app_name: 'Écolive',
    enter_text: '텍스트 입력',
    converted_text: '변환된 텍스트',
    converted_text_description: '변환된 텍스트가 여기에 표시됩니다...',
    copy: '복사',
    reset: '재설정',
    savePDF: 'PDF로 저장',
    saveWord: 'Word로 저장',
    profile: '프로필',
    feeds: '피드',
    blog: '블로그',
    achievements: '업적',
    feedDS: '피드가 여기에 표시됩니다',
    blogDS: '블로그 게시물이 여기에 표시됩니다',
    achievementsDS: '업적이 여기에 표시됩니다',
    aboutapp: '앱 정보',
    appdescription: """
Écolive는 텍스트 형식과 언어를 쉽고 효과적으로 변환하도록 도와줍니다.

• 글꼴 변환: 사용 가능한 시스템 글꼴 간의 변환을 지원하여 텍스트 스타일을 빠르게 변경할 수 있습니다.\n
• 형식 변환: Word/PDF 문서를 고품질 이미지 파일로 변환합니다.\n
• 자동 번역: 텍스트를 한 언어에서 다른 언어로 자동 번역하여 업무와 학습을 지원합니다.
""",
    ecosiasr: '나무를 심기 위해 웹 검색...',
    ecosiaDS: 'Ecosia 사용자가 심은 나무',
    aiselection: '인공지능 선택',
    aiinstruction: ' 사용하고 싶은 도구를 선택하세요',
    aibtt1: '인공지능 챗봇',
    aibtt2: '파일에서 이미지로 변환',
    aibtt3: '파일 언어 변환',
    aiinfo: '정보',
    historyname: '변환 기록',
    historystatus: '아직 기록이 없습니다.',
    confirmlogout: '로그아웃 확인',
    logoutDS: '떠나고 싶습니까?',
    cancel: '취소',
    exit: '출구',
    seeyou: '곧 뵙겠습니다',
    logoutbtt: '로그아웃',
    emailtxt: '이메일 입력',
    passwordtxt: '비밀번호 입력',
    loginbtt: '로그인',
    forgotpassword: '비밀번호를 잊으셨나요?',
    or: '또는',
    googletxt: 'Google로 계속하기',
    signuptxt: '계정이 없습니까?',
    signupbtt: '가입하기',
    signup_name: '이름 입력',
    signup_email: '이메일 입력',
    signup_password: '비밀번호 입력',
    signup_confirmpassword: '비밀번호 확인',
    signup_btt: '가입하기',
    signup_passwordNoti: '모든 필드를 작성하십시오.',
    signup_Noti: '유효한 이메일 주소를 입력하십시오',
    signup_Noti_invalid: '유효한 이메일 주소를 입력하십시오',
    signup_Noti_8ch: '비밀번호는 8자 이상이어야 합니다',
    resendEmail: '확인 이메일 재전송',
    resendWait: '기다리다',
    signup_alreadyDS: '계정이 이미 있습니까?',
    login_signup_btt: '로그인',
    login_email_hint: '이메일 입력',
    forgotpptxt: '비밀번호를 잊으셨나요',
    forgotpphint: '이메일 입력',
    forgotppsendbtt: '보내기',
    forgotppPlenter: '이메일을 입력하세요',
    forgotppCheckmail: '비밀번호 재설정 링크가 포함된 이메일을 확인하세요',
    ggcheckfail: 'Google 로그인 실패. 다시 시도하십시오.',
    signupdonmatch: '비밀번호가 일치하지 않습니다',
    signup_field: '모든 필드를 작성하십시오.',
    login_email_auth: '잘못된 이메일 형식입니다!',
    login_email_verify: '로그인하기 전에 이메일을 확인하세요.',
    resPP_notify: '정보를 입력하세요',
    resPP_email_auth: '이메일 형식이 잘못되었습니다!',
    resPP_email_send: '비밀번호 재설정 이메일이 성공적으로 전송되었습니다',
    resendEmailVerify: '확인 이메일이 전송되었습니다!',
    resendUserno: '사용자를 찾을 수 없습니다. 먼저 로그인하세요.',
    resendEmailalready: '귀하의 이메일은 이미 확인되었습니다.',
    signup_email_format: '잘못된 이메일 형식입니다!',
    signup_password_format: '비밀번호는 8자 이상이어야 하며 문자와 숫자를 포함해야 합니다.',
    signup_email_inbox: '확인 이메일이 전송되었습니다. 받은 편지함을 확인하세요.',
    forgotpasswordWord: '비밀번호를 잊으셨나요',
    forgotpasswordHint: '이메일 입력',
    forgotpasswordbtt: '보내기',
    forgotpasswordEx: 'abc@gmail.com',
    forgotpasswordnotify: '재설정 링크가 전송되었습니다! 이메일을 확인하세요.',
    toolsselection: '도구 선택',
    tool1: '자동 글꼴 변환',
    enginedescription: """
에코라이브 컨버터는 다음을 지원하는 애플리케이션입니다:

Word/PDF 문서의 글꼴 자동 변환.
문서를 이미지 형식(PNG, JPG 등)으로 내보내기.
텍스트를 한 언어에서 다른 언어로 번역.

⚡ 구동 기술
• Flutter → 크로스 플랫폼 애플리케이션(모바일, 데스크톱, 웹) 구축.
• Python (FastAPI) → 문서 처리 백엔드(글꼴, PDF → 이미지, 언어 번역).
• Google Cloud Firestore → 변환 기록 저장.
• Google Cloud Storage / Firebase Storage → 입력 및 출력 문서 저장.
• Google Translate API → 다양한 언어 자동 번역.
• Uvicorn → 파이썬 백엔드 서버 실행.
""",
    previewscreen: '미리보기 화면',
    pickatextcolor: '텍스트 색상 선택',
    previewstatus: '콘텐츠가 없습니다',
    font_converter_title: '글꼴 변환기',
    new_font: '새 글꼴',
    preview_title: '미리보기',
    result_converted: '변환된 결과',
    uploadfile: '파일 업로드',
    fileconverted: '변환된 파일이 여기에 표시됩니다',
    selectedfromstorage: '장치 저장소에서 선택',
    selectedfromgoogledrive: 'Google 드라이브에서 선택',
    downloadbtt: '다운로드',
    nofiledownload: '다운로드할 파일이 없습니다.',
    filetoimage: '파일을 이미지로',
    sortofimage: '이미지 유형',
    noresult: '결과 없음',
    downloadall: '모두 다운로드',
    convertlanguage: '파일 언어 변환',
    newlanguage: '새 언어',
    contentfileconverted: '변환된 파일 내용이 여기에 표시됩니다',
    historyconvertedfilelanguage: '변환된 파일 기록',
    historyconvertedfiletoimage: '변환된 기록',
    historyconvertedfiletolanguagetranslated: '번역됨: ',
    downloading: '⏳ 다운로드 중...',
    downloadcompleted: '✅다운로드 완료!',
    convertedfiletoimage: '파일 → 이미지',
    imagefrom: '파일에서 이미지',
    downloadthisimage: '이 이미지 다운로드',
    downloadthisallimage: '모든 이미지 다운로드',
    close: '닫기',
    nohistory: '사용 가능한 기록이 없습니다.',
    deleteconfirm: '확실합니까?',
    deleteconfirm2: '이 기록을 삭제하시겠습니까?',
    deletebtt: '삭제',
    deletewholehistory: '전체 기록 삭제',
    deletewholehistory2: '이 작업은 취소할 수 없습니다',
    hasbeendeleted: '🧹 기록이 삭제되었습니다',
    hasbeendeleted1file: '🧹 1개의 파일 기록이 삭제되었습니다',
    hasbeendeleted1image: '🧹 1개의 이미지 기록이 삭제되었습니다',
    language_appear: '🔍 언어 감지 중...',
    language_translated_success: '✅ 성공적으로 번역되었습니다!',
    language_detect_error: '❌ 번역 중 오류 발생',
    language_received: '✅ 다운로드 URL 수신:',
    language_error: '⚠️ 오류:',
    language_choose_method: '번역 방법 선택',
    language_ask: '전체 파일을 번역하시겠습니까, 아니면 부분적으로 하시겠습니까?',
    language_trans_all: '전체 번역',
    language_trans_chunk: '부분 번역',
    language_seperate: '⏳ 부분 분할 중...',
    language_trans_already: '✅ 부분 처리 완료!\n내용을 미리 확인하세요.',
    language_error_seperate: '❌ 부분 처리 오류',
    language_convert: '변환 상태',
    language_down_file: '✅ 파일 다운로드됨:',
    all_convert_no: '종료 불가',
    all_convert_no2: '변환 중입니다. 완료될 때까지 기다려 주세요.',
    ok: '확인',
    language_history: '변환 기록 보기',
    language_file_chose: '📄 선택된 파일:',
    language_processing: '처리 중... 잠시만 기다려주세요',
    download_file_trans: '번역 파일 다운로드',
    download_already: '✅ 다운로드 완료',
    download_this_file: '이 파일 다운로드',
    file_choose_method: '변환 방법 선택',
    file_ask: '전체 파일을 변환하시겠습니까, 아니면 결과의 일부를 선택하시겠습니까?',
    file_all: '전체',
    file_seperate: '일부',
    file_processing: '⏳ 처리 중...',
    file_process_temp: '✅ 임시 데이터 가져옴. 화면 전환...',
    file_converted_success: '✅ 변환 성공',
    file_converted_error: '❌ 변환 중 오류 발생',
    file_cannot_out: '종료 불가',
    file_cannot_out2: '변환 중입니다. 완료될 때까지 기다려 주세요.',
    file_history_title: '변환 기록 보기',
    file_hasbeensaved: '✅ 갤러리에 이미지 저장됨!',
    file_open: '열기',
    file_download: '이미지 다운로드 중',
    file_downloading: '다운로드 중',
    file_image: '이미지...',
    file_image_hasbeenchose: '선택됨:',
    file_image_see: '이미지 보기',
    downloading_image: '⏳ 이미지 다운로드 중...',
    cannot_open_file: '❌ 이미지를 다운로드할 수 없습니다',
    no_image_to_download: '다운로드할 이미지가 없습니다',
    download_all_image: '⏳ 모든 이미지 다운로드 중...',
    file_saved: '✅ 저장됨',
    image_to_gallery: '이미지를 갤러리로!',
    open_gallery: '📸 갤러리 열기',
    cannot_loading: '기록을 불러올 수 없습니다.',
    no_image_saved: '저장된 이미지가 없습니다.',
    download_already_all_image: '✅ 모든 이미지가 로드되었습니다!',
    font_bold_word: '글꼴을 변경하려면 텍스트를 선택(강조)하세요!',
    font_cannot_open: '⚠️ 파일을 열 수 없습니다:',
    font_download_error: '⚠️ 파일 다운로드 오류:',
    font_error_export: '⚠️ 내보내기 오류:',
    font_edit: '글꼴 편집',
    font_tip: '💡 팁: 텍스트를 선택한 후 위에서 글꼴을 변경하세요.',
    font_content: '텍스트 내용...',
    font_export_DOCX: 'DOCX 내보내기',
    font_export_PDF: 'PDF 내보내기',
    font_error_file: '❌ 오류: 파일 경로를 가져올 수 없습니다',
    font_converted: '✅ 모두 다음으로 변환됨:',
    font_link_below: '아래 다운로드 링크.',
    font_no_text: '파일에 텍스트 내용이 없습니다!',
    font_install: 'Google Store에서 Word/Office를 설치하세요.',
    font_instruction: '지침',
    font_history: '기록',
    font_done: '완료!',
    font_download_again: '다시 다운로드 중...',
    font_history_screen: '글꼴 변환 기록',
    font_delete: '이 항목을 삭제하시겠습니까?',
    font_delete_sure: '정말 이 항목을 삭제하시겠습니까?',
    image_downloaded: '✅ 다운로드됨',
    image: '이미지',
    image_open_library: '및 갤러리 열기 성공',
    image_please_choose: '⚠️ 이미지를 최소 1개 선택하세요!',
    image_exported_success: '✅ 내보내기 성공! 기록을 여는 중...',
    image_adjust_sepe: '각 이미지 조정',
    image_all: '전체',
    image_cancel: '선택 해제',
    image_page: '페이지',
    image_type: '확장자',
    image_tap_to_choose: '탭하여 선택',
    image_exported: '내보내기',
    image_to_history: '이미지 기록 저장',
    language_detected: '🌐 감지됨:',
    language_translating: '⏳ 번역 중...',
    language_hasbeen_detected: '✅ 감지된 언어:',
    language_error_file: '❌ 파일 로드 오류:',
    language_hasbeen_exported: '✅ 파일 내보내기 완료:',
    language_being_exportPDF: '⏳ PDF 생성 중, 잠시만 기다려주세요...',
    language_PDF: '✅ PDF 내보내기 완료:',
    language_doc: '문서 편집기',
    language_typing: '번역 입력...',
    language_translate_again: '다시 번역',
    language_done: '완료',
    language_tutorial_detail: '상세 튜토리얼',
    language_tutorial_choose: '2가지 번역 유형이 있습니다: 전체 및 부분',
    language_understand: '알겠습니다, 시작!',
    language_step: '1단계: 새 언어 드롭다운을 눌러 번역하려는 언어를 선택하세요.',
    language_step2:
        '2단계: 파일 업로드(저장소/드라이브)를 클릭하고 파일을 선택하세요. 대화 상자가 나타나면 "전체 번역"을 선택하고 시스템이 파일을 반환할 때까지 기다리세요.',
    language_step3: '1단계: 파일 업로드를 클릭하면 저장소 + Google 드라이브 화면이 나타납니다.',
    language_step4:
        '2단계: 파일을 찾아 선택하세요. 대화 상자에서 즉시 "부분 번역"을 클릭하세요. 상세 화면이 나타납니다.',
    language_step5:
        '3단계: 변경하려는 세그먼트를 찾아 해당 단어/세그먼트를 클릭하여 언어를 변경하거나 원하는 대로 편집하세요.',
    language_step6: '4단계: 편집 후 오른쪽 상단을 클릭하여 DOCX 또는 PDF로 내보내세요.',
    font_step: '1단계: 새 글꼴 드롭다운을 눌러 변환하려는 새 글꼴 스타일을 선택하세요.',
    font_step2:
        '2단계: 파일 업로드를 클릭하고 저장소 또는 드라이브에서 파일을 선택하세요. 대화 상자가 나타나면 즉시 "전체"를 클릭하고 기다리세요.',
    font_step3: '1단계: 파일 업로드를 클릭하면 저장소 + Google 드라이브 화면이 나타납니다.',
    font_step4: '2단계: 파일을 찾아 선택하세요. 대화 상자에서 즉시 "부분"을 클릭하세요. 부분 변환 화면이 나타납니다.',
    font_step5:
        '3단계: 해당 세그먼트를 클릭하여 글꼴을 변경하려는 세그먼트를 선택하세요. 개별 단어의 경우 탭하여 다시 입력하거나 삭제하세요.',
    font_step6: '4단계: 편집 후 오른쪽 상단 버튼을 클릭하여 파일을 DOCX 또는 PDF로 내보내세요.',
    image_step: '1단계: 새 이미지 유형 드롭다운을 눌러 변환하려는 이미지 파일(PNG, JPG...)을 선택하세요.',
    image_step2:
        '2단계: 파일 업로드를 클릭하고 파일을 선택하세요. 대화 상자가 나타나면 즉시 "전체"를 클릭하고 기다리세요.',
    image_step3: '1단계: 파일 업로드를 클릭하면 저장소 + Google 드라이브 화면이 나타납니다.',
    image_step4: '2단계: 파일을 찾아 선택하세요. 대화 상자에서 즉시 "부분"을 클릭하세요. 부분 변환 화면이 나타납니다.',
    image_step5: '3단계: 이 화면에서 원하는 대로 각 이미지를 클릭하여 변경하려는 이미지를 선택하세요.',
    image_step6: '4단계: 편집 후 하단의 녹색 버튼을 클릭하여 파일을 내보내세요.',
    understand: '알겠습니다, 시작!',
    language_swip: '왼쪽으로 스와이프하거나 여기를 탭하여 더 보기',
    image_select: '2가지 변환 유형이 있습니다: "전체" 및 "부분"',
    image_seperate: '부분 변환',
    font_select: '2가지 변환 유형이 있습니다: "전체" 및 "부분"',
    seperate: '부분',
    home_tutorial1: '1. 글꼴 선택',
    home_quote1: '여기를 탭하여 시도하려는 글꼴 유형을 선택하세요.',
    home_tutorial2: '2. 텍스트 입력',
    home_quote2: '이 상자에 시도하려는 내용을 입력하세요.',
    home_tutorial3: '3. 텍스트 서식',
    home_quote3: '여기에서 굵게, 기울임꼴, 밑줄을 사용자 지정하거나 텍스트 색상을 변경하세요.',
    home_tutorial4: '4. 결과',
    home_quote4: '입력 및 사용자 지정 후의 텍스트가 여기에 나타납니다.',
    home_tutorial5: '5. 빠른 작업',
    home_quote5: '결과를 복사하거나 지우고 다시 시작하세요.',
    home_tutorial6: '6. 내비게이션 바',
    home_quote6: '화면 간 전환: 프로필, 정보, 도구, 설정 및 로그아웃.',
    home_tutorial7: '7. 개인 정보',
    home_quote7: '정보 보기.',
    home_tutorial8: '8. 앱 정보',
    home_quote8: '앱 정보 및 기능에 대해 자세히 알아보세요.',
    home_tutorial9: '9. 도구 선택',
    home_quote9: '원하는 대로 텍스트를 변환할 도구를 선택하는 곳입니다.',
    home_tutorial10: '10. 설정',
    home_quote10: '인터페이스, 앱 언어 \n 및 개인 정보 보호 정책 & 이용 약관을 사용자 지정하세요.',
    home_tutorial11: '11. 로그아웃',
    home_quote11: '현재 계정에서 로그아웃합니다.',
    privacy_term: '개인정보 및 약관',
    notify: '알림',
    update_pdf: 'PDF 내보내기 기능은 현재 개발 중입니다.\n나중에 다시 확인해 주세요!',
    vietnamese: '베트남어',
    english: '영어',
    german: '독일어',
    french: '프랑스어',
    italian: '이탈리아어',
    spanish: '스페인어',
    portuguese: '포르투갈어',
    chinese: '중국어 (간체)',
    korean: '한국어',
    japanese: '일본어',
    russian: '러시아어',
    language_download_successed: '✅ 다운로드 성공! 파일을 여시겠습니까?',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> JP = {
    title: 'Écoliveへようこそ',
    body: 'フォント変換、ドキュメント翻訳、ファイルから画像への変換のためのプロフェッショナルツール。',
    title2: 'プロフェッショナルなフォント変換',
    body2: 'WordおよびPDFドキュメントのフォントを即座に変更します。ドキュメントスタイルを簡単にカスタマイズ。',
    title3: 'ドキュメント翻訳',
    body3: '元のフォーマットを維持しながら、ファイル全体または特定のセグメントを多言語に翻訳します。',
    title4: 'ファイルを画像に変換',
    body4: 'ドキュメントを高品質の画像（PNG/JPG）に変換します。始める準備はできましたか？',
    skip: 'スキップ',
    next: '次へ',
    finish: '終了',
    settings: '設定',
    light_darkmode: 'ライト / ダークモード',
    language: '言語',
    app_name: 'Écolive',
    enter_text: 'テキストを入力',
    converted_text: '変換されたテキスト',
    converted_text_description: '変換されたテキストがここに表示されます...',
    copy: 'コピー',
    reset: 'リセット',
    savePDF: 'PDFとして保存',
    saveWord: 'Wordとして保存',
    profile: 'プロフィール',
    feeds: 'フィード',
    blog: 'ブログ',
    achievements: '成果',
    feedDS: 'フィードがここに表示されます',
    blogDS: 'ブログ投稿がここに表示されます',
    achievementsDS: '成果がここに表示されます',
    aboutapp: 'アプリについて',
    appdescription: """
Écoliveは、テキスト形式と言語を簡単かつ効果的に変換するのに役立ちます。

• フォント変換：利用可能なシステムフォント間の変換をサポートし、テキストの表示スタイルを素早く変更できます。\n
• 形式変換：Word/PDFドキュメントを高品質の画像ファイルに変換します。\n
• 自動翻訳：ある言語から別の言語へテキストを自動的に翻訳し、仕事や学習をサポートします。
""",
    ecosiasr: '木を植えるためにウェブ検索...',
    ecosiaDS: 'Ecosiaユーザーによって植えられた木',
    aiselection: 'AI選択',
    aiinstruction: '使用したいツールをどれでも選んでください ',
    aibtt1: 'チャットボット',
    aibtt2: 'ファイルを画像に変換',
    aibtt3: 'ファイルの言語を変換',
    aiinfo: '情報',
    historyname: '変換履歴',
    historystatus: 'まだ履歴はありません。',
    confirmlogout: 'ログアウトを確認',
    logoutDS: '出発しますか？',
    cancel: 'キャンセル',
    exit: '出口',
    seeyou: 'またね',
    logoutbtt: 'ログアウト',
    emailtxt: 'メールアドレスを入力',
    passwordtxt: 'パスワードを入力',
    loginbtt: 'ログイン',
    forgotpassword: 'パスワードをお忘れですか？',
    or: 'または',
    googletxt: 'Googleで続行',
    signuptxt: 'アカウントをお持ちでないですか？',
    signupbtt: 'サインアップ',
    signup_name: '名前を入力',
    signup_email: 'メールアドレスを入力',
    signup_password: 'パスワードを入力',
    signup_confirmpassword: 'パスワードを確認',
    signup_btt: 'サインアップ',
    signup_passwordNoti: 'すべてのフィールドに入力してください。',
    signup_Noti: '有効なメールアドレスを入力してください',
    signup_Noti_invalid: '有効なメールアドレスを入力してください',
    signup_Noti_8ch: 'パスワードは8文字以上である必要があります',
    resendEmail: '確認メールを再送信',
    resendWait: 'お待ちください',
    signup_alreadyDS: 'すでにアカウントをお持ちですか？',
    login_signup_btt: 'ログイン',
    login_email_hint: 'メールアドレスを入力',
    forgotpptxt: 'パスワードをお忘れですか',
    forgotpphint: 'メールアドレスを入力',
    forgotppsendbtt: '送信',
    forgotppPlenter: 'メールアドレスを入力してください',
    forgotppCheckmail: 'パスワードリセットリンクのメールを確認してください',
    ggcheckfail: 'Googleログインに失敗しました。もう一度お試しください。',
    signupdonmatch: 'パスワードが一致しません',
    signup_field: 'すべてのフィールドに入力してください。',
    login_email_auth: '無効なメール形式！',
    login_email_verify: 'ログインする前にメールを確認してください。',
    resPP_notify: '情報を入力してください',
    resPP_email_auth: 'メールの形式が無効です！',
    resPP_email_send: 'パスワードリセットメールが送信されました',
    resendEmailVerify: '確認メールが送信されました！',
    resendUserno: 'ユーザーが見つかりません。最初にログインしてください。',
    resendEmailalready: 'あなたのメールはすでに確認されています。',
    signup_email_format: '無効なメール形式！',
    signup_password_format: 'パスワードは8文字以上で、文字と数字を含める必要があります。',
    signup_email_inbox: '確認メールが送信されました。受信トレイを確認してください。',
    forgotpasswordWord: 'パスワードをお忘れですか',
    forgotpasswordHint: 'メールアドレスを入力',
    forgotpasswordbtt: '送信',
    forgotpasswordEx: 'abc@gmail.com',
    forgotpasswordnotify: 'リセットリンクが送信されました！メールを確認してください。',
    toolsselection: 'ツール選択',
    tool1: '自動フォント変換',
    enginedescription: """
Écolive Converterは、以下をサポートするアプリケーションです。

Word/PDFドキュメントのフォントを自動で変換します。
ドキュメントを画像形式（PNG、JPGなど）にエクスポートします。
テキストをある言語から別の言語へ翻訳します。

⚡ Powered by (技術提供)
• Flutter → クロスプラットフォームアプリケーション（モバイル、デスクトップ、ウェブ）の構築。
• Python (FastAPI) → ドキュメント処理（フォント、PDF → 画像、言語翻訳）のバックエンド。
• Google Cloud Firestore → 変換履歴の保存。
• Google Cloud Storage / Firebase Storage → 入力および出力ドキュメントの保存。
• Google Translate API → 多言語の自動翻訳。
• Uvicorn → Pythonバックエンドサーバーの実行。
""",
    previewscreen: 'プレビュー画面',
    pickatextcolor: 'テキストの色を選択',
    previewstatus: 'コンテンツがありません',
    font_converter_title: 'フォントコンバーター',
    new_font: '新しいフォント',
    preview_title: 'プレビュー',
    result_converted: '変換結果',
    uploadfile: 'ファイルをアップロード',
    fileconverted: '変換されたファイルがここに表示されます',
    selectedfromstorage: 'デバイスのストレージから選択',
    selectedfromgoogledrive: 'Googleドライブから選択',
    downloadbtt: 'ダウンロード',
    nofiledownload: 'ダウンロードするファイルがありません。',
    filetoimage: 'ファイルを画像に変換',
    sortofimage: '画像の種類',
    noresult: '結果がありません',
    downloadall: 'すべてダウンロード',
    convertlanguage: 'ファイルの言語を変換',
    newlanguage: '新しい言語',
    contentfileconverted: '変換されたファイルの内容がここに表示されます',
    historyconvertedfilelanguage: '変換されたファイルの履歴',
    historyconvertedfiletoimage: '変換履歴',
    historyconvertedfiletolanguagetranslated: '翻訳済み：',
    downloading: '⏳ ダウンロード中...',
    downloadcompleted: '✅ダウンロード完了！',
    convertedfiletoimage: 'ファイル → 画像',
    imagefrom: 'ファイルからの画像',
    downloadthisimage: 'この画像をダウンロード',
    downloadthisallimage: 'すべての画像をダウンロード',
    close: '閉じる',
    nohistory: '利用可能な履歴がありません。',
    deleteconfirm: 'よろしいですか？',
    deleteconfirm2: 'この履歴を削除してもよろしいですか？',
    deletebtt: '削除',
    deletewholehistory: 'すべての履歴を削除',
    deletewholehistory2: 'この操作は元に戻せません',
    hasbeendeleted: '🧹 履歴が削除されました',
    hasbeendeleted1file: '🧹 1つのファイル履歴が削除されました',
    hasbeendeleted1image: '🧹 1つの画像履歴が削除されました',
    language_appear: '🔍 言語を検出しています...',
    language_translated_success: '✅ 翻訳に成功しました！',
    language_detect_error: '❌ 翻訳中にエラーが発生しました',
    language_received: '✅ ダウンロードURLを受信しました：',
    language_error: '⚠️ エラー：',
    language_choose_method: '翻訳方法を選択',
    language_ask: 'ファイル全体を翻訳しますか、それとも部分ごとに翻訳しますか？',
    language_trans_all: 'すべて翻訳',
    language_trans_chunk: '部分翻訳',
    language_seperate: '⏳ 部分分割中...',
    language_trans_already: '✅ 処理完了！\n内容をプレビューしてください。',
    language_error_seperate: '❌ 部分処理エラー',
    language_convert: '変換ステータス',
    language_down_file: '✅ ファイルをダウンロードしました:',
    all_convert_no: '終了できません',
    all_convert_no2: '変換中です。完了するまでお待ちください。',
    ok: 'OK',
    language_history: '変換履歴を表示',
    language_file_chose: '📄 選択されたファイル:',
    language_processing: '処理中... お待ちください',
    download_file_trans: '翻訳ファイルをダウンロード',
    download_already: '✅ ダウンロード完了',
    download_this_file: 'このファイルをダウンロード',
    file_choose_method: '変換方法を選択',
    file_ask: 'ファイル全体を変換しますか、それとも結果の一部を選択しますか？',
    file_all: 'すべて',
    file_seperate: '一部',
    file_processing: '⏳ 処理中...',
    file_process_temp: '✅ 一時データを取得しました。画面を切り替えます...',
    file_converted_success: '✅ 変換成功',
    file_converted_error: '❌ 変換中にエラーが発生しました',
    file_cannot_out: '終了できません',
    file_cannot_out2: '変換中です。完了するまでお待ちください。',
    file_history_title: '変換履歴を表示',
    file_hasbeensaved: '✅ 画像をギャラリーに保存しました！',
    file_open: '開く',
    file_download: '画像をダウンロード中',
    file_downloading: 'ダウンロード中',
    file_image: '画像...',
    file_image_hasbeenchose: '選択済み:',
    file_image_see: '画像を表示',
    downloading_image: '⏳ 画像をダウンロード中...',
    cannot_open_file: '❌ 画像をダウンロードできません',
    no_image_to_download: 'ダウンロードする画像がありません',
    download_all_image: '⏳ すべての画像をダウンロード中...',
    file_saved: '✅ 保存しました',
    image_to_gallery: '画像をギャラリーへ！',
    open_gallery: '📸 ギャラリーを開く',
    cannot_loading: '履歴を読み込めません。',
    no_image_saved: '保存された画像はありません。',
    download_already_all_image: '✅ すべての画像を読み込みました！',
    font_bold_word: 'フォントを変更するにはテキストを選択（ハイライト）してください！',
    font_cannot_open: '⚠️ ファイルを開けません：',
    font_download_error: '⚠️ ダウンロードエラー：',
    font_error_export: '⚠️ エクスポートエラー：',
    font_edit: 'フォント編集',
    font_tip: '💡 ヒント：テキストを選択して上のフォントを選んでください。',
    font_content: 'テキスト内容...',
    font_export_DOCX: 'DOCXをエクスポート',
    font_export_PDF: 'PDFをエクスポート',
    font_error_file: '❌ エラー：ファイルパスを取得できません',
    font_converted: '✅ すべて変換しました：',
    font_link_below: 'ダウンロードリンクは以下です。',
    font_no_text: 'ファイルにテキストがありません！',
    font_install: 'Google StoreでWord/Officeをインストールしてください。',
    font_instruction: '説明',
    font_history: '履歴',
    font_done: '完了！',
    font_download_again: '再ダウンロード中...',
    font_history_screen: 'フォント変換履歴',
    font_delete: 'この項目を削除しますか？',
    font_delete_sure: '本当に削除してもよろしいですか？',
    image_downloaded: '✅ ダウンロード済み',
    image: '画像',
    image_open_library: 'およびギャラリーを開きました',
    image_please_choose: '⚠️ 画像を少なくとも1つ選択してください！',
    image_exported_success: '✅ エクスポート成功！履歴を開いています...',
    image_adjust_sepe: '各画像を調整',
    image_all: 'すべて',
    image_cancel: '選択解除',
    image_page: 'ページ',
    image_type: '拡張子',
    image_tap_to_choose: 'タップして選択',
    image_exported: 'エクスポート',
    image_to_history: '履歴に画像を保存',
    language_detected: '🌐 検出：',
    language_translating: '⏳ 翻訳中...',
    language_hasbeen_detected: '✅ 検出された言語：',
    language_error_file: '❌ ファイル読み込みエラー：',
    language_hasbeen_exported: '✅ ファイルをエクスポートしました：',
    language_being_exportPDF: '⏳ PDFを作成中、お待ちください...',
    language_PDF: '✅ PDFをエクスポートしました：',
    language_doc: 'ドキュメントエディタ',
    language_typing: '翻訳を入力...',
    language_translate_again: '再翻訳',
    language_done: '完了',
    language_tutorial_detail: '詳細チュートリアル',
    language_tutorial_choose: '翻訳には2つのタイプがあります：すべてと部分',
    language_understand: 'わかった、開始！',
    language_step: 'ステップ1：新しい言語のドロップダウンをタップして、翻訳したい言語を選択します。',
    language_step2:
        'ステップ2：ファイルアップロード（ストレージ/ドライブ）をクリックし、ファイルを選択します。ダイアログが表示されたら、「すべて翻訳」を選択し、システムがファイルを返すのを待ちます。',
    language_step3: 'ステップ1：ファイルアップロードをクリックすると、ストレージ + Googleドライブ画面が表示されます。',
    language_step4:
        'ステップ2：ファイルを検索して選択します。ダイアログで、すぐに「部分翻訳」をクリックします。詳細画面が表示されます。',
    language_step5:
        'ステップ3：変更したいセグメントを見つけ、その単語/セグメントをクリックして言語を変更したり、必要に応じて編集したりします。',
    language_step6: 'ステップ4：編集後、右上の隅をクリックしてDOCXまたはPDFをエクスポートします。',
    font_step: 'ステップ1：新しいフォントのドロップダウンをタップして、変換したい新しいフォントスタイルを選択します。',
    font_step2:
        'ステップ2：ファイルアップロードをクリックし、ストレージまたはドライブからファイルを選択します。ダイアログが表示されたら、すぐに「すべて」をクリックして待ちます。',
    font_step3: 'ステップ1：ファイルアップロードをクリックすると、ストレージ + Googleドライブ画面が表示されます。',
    font_step4: 'ステップ2：ファイルを検索して選択します。ダイアログで、すぐに「部分」をクリックします。部分変換画面が表示されます。',
    font_step5:
        'ステップ3：そのセグメントをクリックして、フォントを変更したいセグメントを選択します。個々の単語については、タップして再入力または削除します。',
    font_step6: 'ステップ4：編集後、右上のボタンをクリックしてファイルをDOCXまたはPDFとしてエクスポートします。',
    image_step: 'ステップ1：新しい画像タイプのドロップダウンをタップして、変換したい画像ファイル（PNG、JPG...）を選択します。',
    image_step2:
        'ステップ2：ファイルアップロードをクリックし、ファイルを選択します。ダイアログが表示されたら、すぐに「すべて」をクリックして待ちます。',
    image_step3: 'ステップ1：ファイルアップロードをクリックすると、ストレージ + Googleドライブ画面が表示されます。',
    image_step4: 'ステップ2：ファイルを検索して選択します。ダイアログで、すぐに「部分」をクリックします。部分変換画面が表示されます。',
    image_step5: 'ステップ3：この画面で、希望に応じて各画像をクリックして変更したい画像を選択します。',
    image_step6: 'ステップ4：編集後、下部の緑色のボタンをクリックしてファイルをエクスポートします。',
    understand: 'わかった、開始！',
    language_swip: '左にスワイプするか、ここをタップして詳細を表示',
    image_select: '2つの変換タイプがあります：「すべて」と「部分」',
    image_seperate: '部分を変換',
    font_select: '2つの変換タイプがあります：「すべて」と「部分」',
    seperate: '部分',
    home_tutorial1: '1. フォント選択',
    home_quote1: 'ここをタップして、試したいフォントタイプを選択します。',
    home_tutorial2: '2. テキスト入力',
    home_quote2: '試したい内容をこのボックスに入力します。',
    home_tutorial3: '3. テキスト書式設定',
    home_quote3: 'ここで太字、斜体、下線、またはテキストの色をカスタマイズします。',
    home_tutorial4: '4. 結果',
    home_quote4: '入力およびカスタマイズ後のテキストがここに表示されます。',
    home_tutorial5: '5. クイックアクション',
    home_quote5: '結果をコピーするか、クリアしてやり直します。',
    home_tutorial6: '6. ナビゲーションバー',
    home_quote6: '画面を切り替えます：プロフィール、情報、ツール、設定、ログアウト。',
    home_tutorial7: '7. 個人情報',
    home_quote7: 'あなたの情報を表示します。',
    home_tutorial8: '8. アプリについて',
    home_quote8: 'アプリの情報と機能について詳しく学びます。',
    home_tutorial9: '9. ツール選択',
    home_quote9: '希望通りにテキストを変換するツールを選択する場所。',
    home_tutorial10: '10. 設定',
    home_quote10: 'インターフェース、アプリの言語 \n およびプライバシーポリシーと利用規約をカスタマイズします。',
    home_tutorial11: '11. ログアウト',
    home_quote11: '現在のアカウントからログアウトします。',
    privacy_term: 'プライバシーと規約',
    notify: 'お知らせ',
    update_pdf: 'PDFエクスポート機能は現在開発中です。\n後ほどもう一度お試しください！',
    vietnamese: 'ベトナム語',
    english: '英語',
    german: 'ドイツ語',
    french: 'フランス語',
    italian: 'イタリア語',
    spanish: 'スペイン語',
    portuguese: 'ポルトガル語',
    chinese: '中国語 (簡体字)',
    korean: '韓国語',
    japanese: '日本語',
    russian: 'ロシア語',
    language_download_successed: '✅ ダウンロード完了！ファイルを開きますか？',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> RU = {
    title: 'Добро пожаловать в Écolive',
    body:
        'Ваш профессиональный инструмент для конвертации шрифтов, перевода документов и преобразования файлов в изображения.',
    title2: 'Профессиональный конвертер шрифтов',
    body2:
        'Мгновенно изменяйте шрифты в документах Word и PDF. Легко настраивайте стили документов.',
    title3: 'Перевод документов',
    body3:
        'Переводите целые файлы или отдельные сегменты на несколько языков, сохраняя исходное форматирование.',
    title4: 'Конвертировать файл в изображение',
    body4:
        'Превратите ваши документы в высококачественные изображения (PNG/JPG). Готовы начать?',
    skip: 'Пропустить',
    next: 'Далее',
    finish: 'Завершить',
    settings: 'Настройки',
    light_darkmode: 'Светлый / Темный режим',
    language: 'Язык',
    app_name: 'Écolive',
    enter_text: 'Введите текст',
    converted_text: 'Преобразованный текст',
    converted_text_description: 'Ваш преобразованный текст появится здесь...',
    copy: 'Копировать',
    reset: 'Сбросить',
    savePDF: 'Сохранить как PDF',
    saveWord: 'Сохранить как Word',
    profile: 'Профиль',
    feeds: 'Ленты',
    blog: 'Блог',
    achievements: 'Достижения',
    feedDS: 'Ленты будут отображаться здесь',
    blogDS: 'Записи блога будут отображаться здесь',
    achievementsDS: 'Достижения будут отображаться здесь',
    aboutapp: 'О приложении',
    appdescription:
        'Конвертер Écolive помогает вам преобразовать текст в экологически чистый шрифт, уменьшая использование чернил и минимизируя углеродный след.',
    ecosiasr: 'Ищите в Интернете, чтобы сажать деревья...',
    ecosiaDS: 'Деревья, посаженные пользователями Ecosia',
    aiselection: 'ВЫБОР ИИ',
    aiinstruction: 'выберите любой инструмент, который вы хотите использовать',
    aibtt1: 'ЧАТ-БОТ ИИ',
    aibtt2: 'КОНВЕРТИРОВАТЬ ФАЙЛ В ИЗОБРАЖЕНИЕ',
    aibtt3: 'ИЗМЕНИТЬ ЯЗЫК ФАЙЛА',
    aiinfo: 'ИНФОРМАЦИЯ',
    historyname: 'История преобразования',
    historystatus: 'Истории пока нет.',
    confirmlogout: 'Подтвердить выход',
    logoutDS: 'Вы хотите выйти?',
    cancel: 'Отмена',
    exit: 'Выход',
    seeyou: 'До скорой встречи',
    logoutbtt: 'Выйти',
    emailtxt: 'Введите свой адрес электронной почты',
    passwordtxt: 'Введите свой пароль',
    loginbtt: 'Войти',
    forgotpassword: 'Забыли пароль?',
    or: 'или',
    googletxt: 'Продолжить с Google',
    signuptxt: 'У вас нет учетной записи?',
    signupbtt: 'Зарегистрироваться',
    signup_name: 'Введите свое имя',
    signup_email: 'Введите свой адрес электронной почты',
    signup_password: 'Введите свой пароль',
    signup_confirmpassword: 'Подтвердите свой пароль',
    signup_btt: 'Зарегистрироваться',
    signup_passwordNoti: 'Пожалуйста, заполните все поля.',
    signup_Noti: 'Пожалуйста, введите действительный адрес электронной почты',
    signup_Noti_invalid:
        'Пожалуйста, введите действительный адрес электронной почты',
    signup_Noti_8ch: 'Пароль должен содержать не менее 8 символов',
    resendEmail: 'Повторно отправить электронное письмо для подтверждения',
    resendWait: 'Подождите',
    signup_alreadyDS: 'Уже есть учетная запись?',
    login_signup_btt: 'Войти',
    login_email_hint: 'Введите свой адрес электронной почты',
    forgotpptxt: 'Забыли пароль',
    forgotpphint: 'Введите свой адрес электронной почты',
    forgotppsendbtt: 'Отправить',
    forgotppPlenter: 'Пожалуйста, введите свой адрес электронной почты',
    forgotppCheckmail:
        'Проверьте свою электронную почту на наличие ссылки для сброса пароля',
    ggcheckfail: 'Ошибка входа в Google. Пожалуйста, попробуйте еще раз.',
    signupdonmatch: 'Пароли не совпадают',
    signup_field: 'Пожалуйста, заполните все поля.',
    login_email_auth: 'Недопустимый формат электронной почты!',
    login_email_verify:
        'Пожалуйста, проверьте свою электронную почту перед входом в систему.',
    resPP_notify: 'Пожалуйста, заполните свои данные',
    resPP_email_auth: 'Неверный формат электронной почты!',
    resPP_email_send: 'Письмо для сброса пароля успешно отправлено',
    resendEmailVerify: 'Письмо для подтверждения отправлено!',
    resendUserno:
        'Пользователь не найден. Пожалуйста, войдите в систему сначала.',
    resendEmailalready: 'Ваш адрес электронной почты уже подтвержден.',
    signup_email_format: 'Недопустимый формат электронной почты!',
    signup_password_format:
        'Пароль должен содержать не менее 8 символов, содержать буквы и цифры.',
    signup_email_inbox:
        'Письмо для подтверждения отправлено. Проверьте свой почтовый ящик.',
    forgotpasswordWord: 'Забыли пароль',
    forgotpasswordHint: 'Введите свой адрес электронной почты',
    forgotpasswordbtt: 'Отправить',
    forgotpasswordEx: 'например,abc@gmail.com',
    forgotpasswordnotify:
        'Ссылка для сброса пароля отправлена! Проверьте свою электронную почту.',
    toolsselection: 'ВЫБОР ИНСТРУМЕНТА',
    tool1: 'АВТОМАТИЧЕСКОЕ ПРЕОБРАЗОВАНИЕ ШРИФТОВ',
    enginedescription: """
Écolive Converter — это приложение, которое поддерживает:

Автоматическое преобразование шрифтов в документах Word/PDF.
Экспорт документов в форматы изображений (PNG, JPG и др.).
Перевод текста с одного языка на другой.

⚡ Работает на
• Flutter → для создания кроссплатформенных приложений (мобильных, настольных, веб).
• Python (FastAPI) → бэкенд для обработки документов (шрифты, PDF → изображение, перевод языков).
• Google Cloud Firestore → для хранения истории преобразований.
• Google Cloud Storage / Firebase Storage → для хранения входных и выходных документов.
• Google Translate API → для автоматического перевода на несколько языков.
• Uvicorn → для запуска бэкенд-сервера Python.
""",
    previewscreen: 'Экран предварительного просмотра',
    pickatextcolor: 'Выберите цвет текста',
    previewstatus: 'Нет содержимого',
    font_converter_title: 'Конвертер шрифтов',
    new_font: 'Новый шрифт',
    preview_title: 'Предварительный просмотр',
    result_converted: 'Преобразованный результат',
    uploadfile: 'ЗАГРУЗИТЬ ФАЙЛ',
    fileconverted: 'Преобразованный файл будет отображаться здесь',
    selectedfromstorage: 'Выбрать из хранилища устройства',
    selectedfromgoogledrive: 'Выбрать из Google Диска',
    downloadbtt: 'Скачать',
    nofiledownload: 'Нет файлов для загрузки.',
    filetoimage: 'Файл в изображение',
    sortofimage: 'Тип изображения',
    noresult: 'Нет результатов',
    downloadall: 'Скачать все',
    convertlanguage: 'Преобразовать язык файла',
    newlanguage: 'Новый язык',
    contentfileconverted:
        'Содержимое преобразованного файла будет отображаться здесь',
    historyconvertedfilelanguage: 'История преобразованных файлов',
    historyconvertedfiletoimage: 'История преобразований',
    historyconvertedfiletolanguagetranslated: 'Переведено:',
    downloading: '⏳ Загрузка...',
    downloadcompleted: '✅Загрузка завершена!',
    convertedfiletoimage: 'Файл → Изображение',
    imagefrom: 'Изображение из файла',
    downloadthisimage: 'Скачать это изображение',
    downloadthisallimage: 'Скачать все изображения',
    close: 'Закрыть',
    nohistory: 'Нет доступной истории.',
    deleteconfirm: 'Вы уверены?',
    deleteconfirm2: 'Вы уверены, что хотите удалить эту историю?',
    deletebtt: 'Удалить',
    deletewholehistory: 'Удалить всю историю',
    deletewholehistory2: 'Это действие нельзя отменить',
    hasbeendeleted: '🧹 История была удалена',
    hasbeendeleted1file: '🧹 История 1 файла была удалена',
    hasbeendeleted1image: '🧹 История 1 изображения была удалена',
    language_appear: '🔍 Обнаружение языка...',
    language_translated_success: '✅ Успешно переведено!',
    language_detect_error: '❌ Ошибка при переводе',
    language_received: '✅ Получен URL для загрузки:',
    language_error: '⚠️ Ошибка:',
    language_choose_method: 'Выберите метод перевода',
    language_ask: 'Вы хотите перевести весь файл или по частям?',
    language_trans_all: 'Перевести все',
    language_trans_chunk: 'Перевести по частям',
    language_seperate: '⏳ Разделение на части...',
    language_trans_already:
        '✅ Части обработаны!\nПожалуйста, просмотрите содержимое.',
    language_error_seperate: '❌ Ошибка обработки частей',
    language_convert: 'Статус преобразования',
    language_down_file: '✅ Файл загружен:',
    all_convert_no: 'Невозможно выйти',
    all_convert_no2: 'Идет преобразование. Пожалуйста, дождитесь завершения.',
    ok: 'ОК',
    language_history: 'Просмотреть историю преобразований',
    language_file_chose: '📄 Выбранный файл:',
    language_processing: 'Обработка... Пожалуйста, подождите',
    download_file_trans: 'Скачать файл перевода',
    download_already: '✅ Загрузка завершена',
    download_this_file: 'Скачать этот файл',
    file_choose_method: 'Выберите метод преобразования',
    file_ask: 'Вы хотите преобразовать весь файл или выбрать части результата?',
    file_all: 'Все',
    file_seperate: 'Части',
    file_processing: '⏳ Обработка...',
    file_process_temp: '✅ Временные данные получены. Переключение экрана...',
    file_converted_success: '✅ Преобразование успешно',
    file_converted_error: '❌ Ошибка при преобразовании',
    file_cannot_out: 'Невозможно выйти',
    file_cannot_out2: 'Идет преобразование. Пожалуйста, дождитесь завершения.',
    file_history_title: 'Просмотреть историю преобразований',
    file_hasbeensaved: '✅ Изображение сохранено в галерею!',
    file_open: 'Открыть',
    file_download: 'Загрузка изображения',
    file_downloading: 'Загрузка',
    file_image: 'изображения...',
    file_image_hasbeenchose: 'Выбрано:',
    file_image_see: 'Просмотреть изображение',
    downloading_image: '⏳ Загрузка изображения...',
    cannot_open_file: '❌ Невозможно загрузить изображение',
    no_image_to_download: 'Нет изображений для загрузки',
    download_all_image: '⏳ Загрузка всех изображений...',
    file_saved: '✅ Сохранено',
    image_to_gallery: 'изображение в галерею!',
    open_gallery: '📸 Открыть галерею',
    cannot_loading: 'Невозможно загрузить историю.',
    no_image_saved: 'Нет сохраненных изображений.',
    download_already_all_image: '✅ Все изображения загружены!',
    font_bold_word: 'Выделите текст, чтобы изменить шрифт!',
    font_cannot_open: '⚠️ Невозможно открыть файл:',
    font_download_error: '⚠️ Ошибка загрузки:',
    font_error_export: '⚠️ Ошибка экспорта:',
    font_edit: 'Редактировать шрифт',
    font_tip: '💡 Совет: Выделите текст и выберите шрифт выше.',
    font_content: 'Содержимое текста...',
    font_export_DOCX: 'Экспорт DOCX',
    font_export_PDF: 'Экспорт PDF',
    font_error_file: '❌ Ошибка: Не удалось получить путь к файлу',
    font_converted: '✅ Все преобразовано в',
    font_link_below: 'Ссылка для скачивания ниже.',
    font_no_text: 'В файле нет текста!',
    font_install: 'Пожалуйста, установите Word/Office из Google Store.',
    font_instruction: 'Инструкция',
    font_history: 'История',
    font_done: 'Готово!',
    font_download_again: 'Повторная загрузка...',
    font_history_screen: 'История шрифтов',
    font_delete: 'Удалить этот элемент?',
    font_delete_sure: 'Вы уверены, что хотите удалить этот элемент?',
    image_downloaded: '✅ Загружено',
    image: 'изображение',
    image_open_library: 'и галерея успешно открыта',
    image_please_choose: '⚠️ Выберите хотя бы 1 изображение!',
    image_exported_success: '✅ Экспорт успешен! Открытие истории...',
    image_adjust_sepe: 'Настроить каждое',
    image_all: 'Все',
    image_cancel: 'Отменить',
    image_page: 'Стр.',
    image_type: 'Тип',
    image_tap_to_choose: 'Нажмите для выбора',
    image_exported: 'ЭКСПОРТ',
    image_to_history: 'ИЗОБРАЖЕНИЕ В ИСТОРИЮ',
    language_detected: '🌐 Обнаружено:',
    language_translating: '⏳ Перевод...',
    language_hasbeen_detected: '✅ Язык обнаружен:',
    language_error_file: '❌ Ошибка загрузки файла:',
    language_hasbeen_exported: '✅ Файл экспортирован:',
    language_being_exportPDF: '⏳ Создание PDF, подождите...',
    language_PDF: '✅ PDF экспортирован:',
    language_doc: 'Редактор документов',
    language_typing: 'Введите перевод...',
    language_translate_again: 'Перевести снова',
    language_done: 'Готово',
    language_tutorial_detail: 'Подробная инструкция',
    language_tutorial_choose: 'Есть 2 типа перевода: Все и По частям',
    language_understand: 'Понятно, начать!',
    language_step:
        'Шаг 1: Нажмите на выпадающий список языков, чтобы выбрать язык перевода.',
    language_step2:
        'Шаг 2: Нажмите Загрузить файл (Память/Диск), выберите файл. Когда появится диалог, выберите "Перевести все" и ждите.',
    language_step3:
        'Шаг 1: Нажмите Загрузить файл, появится экран Память + Google Диск.',
    language_step4:
        'Шаг 2: Найдите и выберите файл. В диалоге сразу нажмите "Перевести по частям". Появится подробный экран.',
    language_step5:
        'Шаг 3: Найдите сегменты для изменения, нажмите на слово/сегмент, чтобы изменить язык или отредактировать.',
    language_step6:
        'Шаг 4: После редактирования нажмите в правом верхнем углу Экспорт DOCX или PDF.',
    font_step:
        'Шаг 1: Нажмите на выпадающий список шрифтов, чтобы выбрать новый стиль шрифта.',
    font_step2:
        'Шаг 2: Нажмите Загрузить файл, выберите файл. Когда появится диалог, сразу нажмите "Все" и ждите.',
    font_step3:
        'Шаг 1: Нажмите Загрузить файл, появится экран Память + Google Диск.',
    font_step4:
        'Шаг 2: Найдите и выберите файл. В диалоге сразу нажмите "Части". Появится экран частичного преобразования.',
    font_step5:
        'Шаг 3: Выберите сегменты, где нужно изменить шрифт, нажав на них. Для отдельных слов нажмите, чтобы перепечатать или удалить.',
    font_step6:
        'Шаг 4: После редактирования нажмите кнопку в правом верхнем углу для экспорта файла в DOCX или PDF.',
    image_step:
        'Шаг 1: Нажмите на выпадающий список типа изображения, чтобы выбрать файл изображения для преобразования (PNG, JPG...).',
    image_step2:
        'Шаг 2: Нажмите Загрузить файл, выберите файл. Когда появится диалог, сразу нажмите "Все" и ждите.',
    image_step3:
        'Шаг 1: Нажмите Загрузить файл, появится экран Память + Google Диск.',
    image_step4:
        'Шаг 2: Найдите и выберите файл. В диалоге сразу нажмите "Части". Появится экран частичного преобразования.',
    image_step5:
        'Шаг 3: На этом экране выберите изображения для изменения, нажимая на каждое по желанию.',
    image_step6:
        'Шаг 4: После редактирования нажмите зеленую кнопку внизу для экспорта файла.',
    understand: 'Понятно, начать!',
    language_swip: 'Смахните влево или нажмите здесь, чтобы увидеть больше',
    image_select: 'Есть 2 типа преобразования: "Все" и "Части"',
    image_seperate: 'Преобразовать части',
    font_select: 'Есть 2 типа преобразования: "Все" и "Части"',
    seperate: 'Части',
    home_tutorial1: '1. Выбрать шрифт',
    home_quote1: 'Нажмите здесь, чтобы выбрать тип шрифта.',
    home_tutorial2: '2. Ввести текст',
    home_quote2: 'Введите содержимое, которое хотите попробовать, в это поле.',
    home_tutorial3: '3. Формат текста',
    home_quote3:
        'Настройте Жирный, Курсив, Подчеркнутый или измените цвет текста здесь.',
    home_tutorial4: '4. Результат',
    home_quote4: 'Текст после ввода и настройки появится здесь.',
    home_tutorial5: '5. Быстрые действия',
    home_quote5: 'Копировать результат или очистить, чтобы начать заново.',
    home_tutorial6: '6. Панель навигации',
    home_quote6:
        'Переключение между экранами: Профиль, О нас, Инструменты, Настройки и Выход.',
    home_tutorial7: '7. Личная инфо',
    home_quote7: 'Просмотр вашей информации.',
    home_tutorial8: '8. О приложении',
    home_quote8: 'Узнайте больше о информации и функциях приложения.',
    home_tutorial9: '9. Выбор инструментов',
    home_quote9:
        'Где выбрать инструменты для преобразования текста по желанию.',
    home_tutorial10: '10. Настройки',
    home_quote10:
        'Настроить интерфейс, язык приложения \n и Политики конфиденциальности и Условия использования.',
    home_tutorial11: '11. Выйти',
    home_quote11: 'Выйти из текущей учетной записи.',
    privacy_term: 'Конфиденциальность и Условия',
    notify: 'Уведомление',
    update_pdf:
        'Функция экспорта в PDF находится в разработке.\nПожалуйста, попробуйте позже!',
    vietnamese: 'Вьетнамский',
    english: 'Английский',
    german: 'Немецкий',
    french: 'Французский',
    italian: 'Итальянский',
    spanish: 'Испанский',
    portuguese: 'Португальский',
    chinese: 'Китайский (Упрощенный)',
    korean: 'Корейский',
    japanese: 'Японский',
    russian: 'Русский',
    language_download_successed: '✅ Загрузка завершена! Хотите открыть файл?',
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> VN = {
    title: 'Chào mừng đến với Écolive',
    body:
        'Công cụ chuyên nghiệp giúp Chuyển đổi Font, Dịch thuật tài liệu và Xử lý tệp tin sang ảnh.',
    title2: 'Chuyển đổi Font chuyên nghiệp',
    body2:
        'Thay đổi phông chữ trong tài liệu Word và PDF ngay lập tức. Tùy chỉnh phong cách văn bản dễ dàng.',
    title3: 'Dịch thuật tài liệu',
    body3:
        'Dịch toàn bộ tệp hoặc từng đoạn sang nhiều ngôn ngữ khác nhau mà vẫn giữ nguyên định dạng gốc.',
    title4: 'Chuyển đổi File sang Ảnh',
    body4:
        'Biến tài liệu của bạn thành hình ảnh chất lượng cao (PNG/JPG). Bạn đã sẵn sàng bắt đầu chưa?',
    skip: 'Bỏ qua',
    next: 'Tiếp theo',
    finish: 'Kết thúc',
    settings: 'Cài đặt',
    light_darkmode: 'Chế độ sáng / tối',
    language: 'Ngôn ngữ',
    app_name: 'Écolive',
    enter_text: 'Nhập văn bản',
    converted_text: 'Văn bản đã chuyển đổi',
    converted_text_description:
        'Văn bản đã chuyển đổi của bạn sẽ xuất hiện ở đây...',
    copy: 'Sao chép',
    reset: 'Đặt lại',
    savePDF: 'Lưu dưới dạng PDF',
    saveWord: 'Lưu dưới dạng Word',
    profile: 'Hồ sơ',
    feeds: 'Thông tin cá nhân',
    blog: 'Blog',
    achievements: 'Thành tựu',
    feedDS: 'Các nguồn cấp dữ liệu sẽ được hiển thị ở đây',
    blogDS: 'Các bài đăng trên blog sẽ được hiển thị ở đây',
    achievementsDS: 'Các thành tựu sẽ được hiển thị ở đây',
    aboutapp: 'Giới thiệu về ứng dụng',
    appdescription: """
  Écolive giúp bạn chuyển đổi định dạng và ngôn ngữ của văn bản một cách dễ dàng và hiệu quả.

  • Chuyển đổi font chữ: Hỗ trợ chuyển đổi giữa các font chữ có sẵn trên hệ thống, giúp bạn thay đổi phong cách hiển thị văn bản nhanh chóng.\n
  • Chuyển đổi định dạng: Biến các tài liệu Word/PDF thành tệp ảnh chất lượng cao.\n
  • Dịch thuật tự động: Dịch văn bản từ ngôn ngữ này sang ngôn ngữ khác một cách tự động, hỗ trợ bạn trong công việc và học tập.
  """,
    ecosiasr: 'Tìm kiếm trên web để trồng cây...',
    ecosiaDS: 'Cây được trồng bởi người dùng Ecosia',
    aiselection: 'LỰA CHỌN A.I',
    aiinstruction: 'Chọn bất kỳ loại công cụ nào bạn muốn sử dụng',
    aibtt1: 'CHATBOT',
    aibtt2: 'CHUYỂN ĐỔI FILE SANG IMAGE',
    aibtt3: 'CHUYỂN ĐỔI NGÔN NGỮ CỦA FILE',
    aiinfo: 'THÔNG TIN',
    historyname: 'Lịch sử chuyển đổi',
    historystatus: 'Chưa có lịch sử nào.',
    confirmlogout: 'Xác nhận đăng xuất',
    logoutDS: 'Bạn có muốn thoát không?',
    cancel: 'Hủy',
    exit: 'Thoát',
    seeyou: 'Hẹn gặp lại',
    logoutbtt: 'Đăng xuất',
    emailtxt: 'Nhập email của bạn',
    passwordtxt: 'Nhập mật khẩu của bạn',
    loginbtt: 'Đăng nhập',
    forgotpassword: 'Quên mật khẩu?',
    or: 'hoặc',
    googletxt: 'Tiếp tục với Google',
    signuptxt: 'Bạn chưa có tài khoản?',
    signupbtt: 'Đăng ký',
    signup_name: 'Nhập tên của bạn',
    signup_email: 'Nhập email của bạn',
    signup_password: 'Nhập mật khẩu của bạn',
    signup_confirmpassword: 'Xác nhận mật khẩu của bạn',
    signup_btt: 'Đăng ký',
    signup_passwordNoti: 'Vui lòng điền vào tất cả các trường.',
    signup_Noti: 'Vui lòng nhập địa chỉ email hợp lệ',
    signup_Noti_invalid: 'Vui lòng nhập địa chỉ email hợp lệ',
    signup_Noti_8ch: 'Mật khẩu phải có ít nhất 8 ký tự',
    resendEmail: 'Gửi lại email xác minh',
    resendWait: 'Đợi',
    signup_alreadyDS: 'Bạn đã có tài khoản?',
    login_signup_btt: 'Đăng nhập',
    login_email_hint: 'Nhập email của bạn',
    forgotpptxt: 'Quên mật khẩu',
    forgotpphint: 'Nhập email của bạn',
    forgotppsendbtt: 'Gửi',
    forgotppPlenter: 'Vui lòng nhập email của bạn',
    forgotppCheckmail:
        'Kiểm tra email của bạn để biết liên kết đặt lại mật khẩu',
    ggcheckfail: 'Đăng nhập Google không thành công. Vui lòng thử lại.',
    signupdonmatch: 'Mật khẩu không khớp',
    signup_field: 'Vui lòng điền vào tất cả các trường.',
    login_email_auth: 'Định dạng email không hợp lệ!',
    login_email_verify: 'Vui lòng xác minh email của bạn trước khi đăng nhập.',
    resPP_notify: 'Vui lòng điền thông tin của bạn',
    resPP_email_auth: 'Định dạng email không hợp lệ!',
    resPP_email_send: 'Email đặt lại mật khẩu đã được gửi thành công',
    resendEmailVerify: 'Email xác minh đã được gửi!',
    resendUserno: 'Không tìm thấy người dùng. Vui lòng đăng nhập trước.',
    resendEmailalready: 'Email của bạn đã được xác minh.',
    signup_email_format: 'Định dạng email không hợp lệ!',
    signup_password_format:
        'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái và số.',
    signup_email_inbox:
        'Email xác minh đã được gửi. Vui lòng kiểm tra hộp thư đến của bạn.',
    forgotpasswordWord: 'Quên mật khẩu',
    forgotpasswordHint: 'Nhập email của bạn',
    forgotpasswordbtt: 'Gửi',
    forgotpasswordEx: 'ví dụ:abc@gmail.com',
    forgotpasswordnotify:
        'Liên kết đặt lại đã được gửi! Vui lòng kiểm tra email của bạn.',
    toolsselection: 'LỰA CHỌN CÔNG CỤ',
    tool1: 'CHUYỂN ĐỔI FONT TỰ ĐỘNG',
    enginedescription: """
Écolive Converter là ứng dụng hỗ trợ:

Tự động chuyển đổi font chữ trong tài liệu Word/PDF.
Xuất tài liệu thành định dạng hình ảnh (PNG, JPG, …).
Dịch văn bản từ ngôn ngữ này sang ngôn ngữ khác.

⚡ Powered by
• Flutter → xây dựng ứng dụng đa nền tảng (mobile, desktop, web).
• Python (FastAPI) → backend xử lý tài liệu (font, PDF → image, dịch ngôn ngữ).
• Google Cloud Firestore → lưu trữ lịch sử chuyển đổi.
• Google Cloud Storage / Firebase Storage → lưu trữ tài liệu đầu vào và kết quả.
• Google Translate API → dịch tự động nhiều ngôn ngữ.
• Uvicorn → chạy server backend Python.
""",
    previewscreen: 'Màn hình xem trước',
    pickatextcolor: 'Chọn màu văn bản',
    previewstatus: 'Không có nội dung',
    font_converter_title: 'Trình chuyển đổi phông chữ',
    new_font: 'Phông chữ mới',
    preview_title: 'Xem trước',
    result_converted: 'Kết quả đã chuyển đổi',
    uploadfile: 'TẢI TỆP LÊN',
    fileconverted: 'Tệp đã chuyển đổi sẽ hiển thị ở đây',
    selectedfromstorage: 'Chọn từ bộ nhớ thiết bị',
    selectedfromgoogledrive: 'Chọn từ Google Drive',
    downloadbtt: 'Tải xuống',
    nofiledownload: 'Không có tệp nào để tải xuống.',
    filetoimage: 'Tệp sang hình ảnh',
    sortofimage: 'Loại hình ảnh',
    noresult: 'Không có kết quả',
    downloadall: 'Tải tất cả',
    convertlanguage: 'Chuyển đổi ngôn ngữ tệp',
    newlanguage: 'Ngôn ngữ mới',
    contentfileconverted: 'Nội dung tệp đã chuyển đổi sẽ hiển thị ở đây',
    historyconvertedfilelanguage: 'Lịch sử tệp đã chuyển đổi',
    historyconvertedfiletoimage: 'Lịch sử chuyển đổi',
    historyconvertedfiletolanguagetranslated: 'Đã dịch: ',
    downloading: '⏳ Đang tải xuống...',
    downloadcompleted: '✅Đã tải xong',
    convertedfiletoimage: 'Tệp → Hình ảnh',
    imagefrom: 'Ảnh từ file',
    downloadthisimage: 'Tải ảnh này',
    downloadthisallimage: 'Tải tất cả ảnh',
    close: 'Đóng',
    nohistory: 'Không có lịch sử khả dụng.',
    deleteconfirm: 'Bạn có chắc không?',
    deleteconfirm2: 'Bạn có chắc chắn muốn xóa lịch sử này không?',
    deletebtt: 'Xóa',
    deletewholehistory: 'Xóa toàn bộ lịch sử?',
    deletewholehistory2: 'Hành động này không thể hoàn tác',
    hasbeendeleted: '🧹 Lịch sử đã bị xóa',
    hasbeendeleted1file: '🧹 Lịch sử 1 tệp đã bị xóa',
    hasbeendeleted1image: '🧹 Lịch sử 1 hình ảnh đã bị xóa',
    language_appear: '🔍 Đang phát hiện ngôn ngữ...',
    language_translated_success: '✅ Dịch thành công!',
    language_detect_error: '❌ Lỗi khi dịch',
    language_received: '✅ Đã nhận URL tải về:',
    language_error: '⚠️ Lỗi:',
    language_choose_method: 'Chọn phương thức dịch',
    language_ask: 'Bạn muốn dịch toàn bộ file hay dịch từng đoạn?',
    language_trans_all: 'Dịch tất cả',
    language_trans_chunk: 'Dịch từng đoạn',
    language_seperate: '⏳ Đang tách đoạn...',
    language_trans_already: '✅ Đã xử lý từng đoạn!\nHãy xem trước nội dung.',
    language_error_seperate: '❌ Lỗi khi xử lý từng đoạn',
    language_convert: 'Trạng thái chuyển đổi',
    language_down_file: '✅ File đã tải về:',
    all_convert_no: 'Không thể thoát',
    all_convert_no2:
        'Đang trong quá trình chuyển đổi. Vui lòng chờ hoàn tất trước khi quay lại.',
    ok: 'OK',
    language_history: 'Xem lịch sử chuyển đổi',
    language_file_chose: '📄 File đã chọn:',
    language_processing: 'Đang xử lý... Vui lòng chờ',
    download_file_trans: 'Tải file dịch',
    download_already: '✅ Hoàn tất tải xuống',
    download_this_file: 'Tải file này',
    file_choose_method: 'Chọn phương thức chuyển đổi',
    file_ask: 'Bạn muốn chuyển đổi toàn bộ file hay chọn từng phần kết quả?',
    file_all: 'Toàn bộ',
    file_seperate: 'Từng phần',
    file_processing: '⏳ Đang xử lý...',
    file_process_temp: '✅ Đã lấy dữ liệu tạm. Chuyển màn hình...',
    file_converted_success: '✅ Chuyển đổi thành công',
    file_converted_error: '❌ Lỗi khi chuyển đổi',
    file_cannot_out: 'Không thể thoát',
    file_cannot_out2:
        'Đang trong quá trình chuyển đổi. Vui lòng chờ hoàn tất trước khi quay lại.',
    file_history_title: 'Xem lịch sử chuyển đổi',
    file_hasbeensaved: '✅ Ảnh đã lưu vào thư viện!',
    file_open: 'MỞ NGAY',
    file_download: '⏳ Đang tải ảnh',
    file_downloading: '⏳ Đang tải',
    file_image: 'ảnh...',
    file_image_hasbeenchose: 'Đã chọn:',
    file_image_see: 'Xem ảnh',
    downloading_image: '⏳ Đang tải ảnh...',
    cannot_open_file: '❌ Không thể tải ảnh',
    no_image_to_download: 'Không có ảnh nào để tải',
    download_all_image: '⏳ Đang tải tất cả ảnh...',
    file_saved: '✅ Đã lưu',
    image_to_gallery: 'ảnh vào thư viện!',
    open_gallery: '📸 Mở thư viện',
    cannot_loading: 'Không thể tải lịch sử.',
    no_image_saved: 'Không có ảnh được lưu.',
    download_already_all_image: '✅ Tải xong tất cả ảnh!',
    font_bold_word: 'Hãy bôi đen (chọn) văn bản để đổi Font!',
    font_cannot_open: '⚠️ Không thể mở file:',
    font_download_error: '⚠️ Lỗi tải file:',
    font_error_export: '⚠️ Lỗi export:',
    font_edit: 'Chỉnh sửa Font',
    font_tip: '💡 Mẹo: Bôi đen văn bản rồi chọn Font ở trên để đổi.',
    font_content: 'Nội dung văn bản...',
    font_export_DOCX: 'Xuất DOCX',
    font_export_PDF: 'Xuất PDF',
    font_error_file: '❌ Lỗi: Không lấy được đường dẫn file',
    font_converted: '✅ Đã chuyển đổi toàn bộ sang',
    font_link_below: 'Link tải bên dưới.',
    font_no_text: 'File không có nội dung text!',
    font_install: 'Vui lòng cài Word/Office trên Google Store.',
    font_instruction: 'Hướng dẫn',
    font_history: 'Lịch sử',
    font_done: 'Hoàn tất!',
    font_download_again: 'Đang tải lại...',
    font_history_screen: 'Lịch sử chuyển đổi Font',
    font_delete: 'Xóa mục này?',
    font_delete_sure: 'Bạn có chắc muốn xóa mục này?',
    image_downloaded: '✅ Đã tải',
    image: 'ảnh',
    image_open_library: 'và mở thư viện thành công',
    image_please_choose: '⚠️ Vui lòng chọn ít nhất 1 ảnh!',
    image_exported_success: '✅ Xuất thành công! Đang mở lịch sử...',
    image_adjust_sepe: 'Tùy chỉnh từng ảnh',
    image_all: 'Tất cả',
    image_cancel: 'Bỏ chọn',
    image_page: 'Trang',
    image_type: 'Đuôi',
    image_tap_to_choose: 'Chạm để chọn',
    image_exported: 'XUẤT',
    image_to_history: 'ẢNH VÀO LỊCH SỬ',
    language_detected: '🌐 Phát hiện:',
    language_translating: '⏳ Đang dịch...',
    language_hasbeen_detected: '✅ Ngôn ngữ phát hiện được:',
    language_error_file: '❌ Lỗi khi tải file:',
    language_hasbeen_exported: '✅ Đã xuất file:',
    language_being_exportPDF: '⏳ Đang tạo PDF, vui lòng chờ...',
    language_PDF: '✅ Đã xuất PDF:',
    language_doc: 'Biên tập tài liệu',
    language_typing: 'Nhập bản dịch...',
    language_translate_again: 'Dịch lại',
    language_done: 'Xong',
    language_tutorial_detail: 'Hướng dẫn chi tiết',
    language_tutorial_choose: 'Có 2 kiểu dịch: Tất cả và Từng đoạn',
    language_understand: 'Đã hiểu, Bắt đầu ngay!',
    language_step:
        'Bước 1: Nhấn vào Dropdown ngôn ngữ mới để chọn ngôn ngữ bạn muốn dịch.',
    language_step2:
        'Bước 2: Nhấp Tải tệp lên (Storage/Drive), chọn file. Khi Dialog hiện ra, chọn "Dịch tất cả" và chờ hệ thống trả file về.',
    language_step3:
        'Bước 1: Nhấp vào Tải tệp lên và màn hình Storage + Google Drive sẽ xuất hiện.',
    language_step4:
        'Bước 2: Tìm chọn file. Tại Dialog, nhấp ngay "Dịch từng đoạn". Màn hình chi tiết sẽ xuất hiện.',
    language_step5:
        'Bước 3: Tìm những đoạn muốn đổi, nhấp vào từ/đoạn đó để đổi ngôn ngữ hoặc chỉnh sửa theo ý muốn.',
    language_step6:
        'Bước 4: Sau khi chỉnh xong, nhấn vào góc phải trên cùng chọn Xuất DOCX hoặc PDF.',
    font_step:
        'Bước 1: Nhấn vào Dropdown phông chữ mới để chọn kiểu Font chữ mới bạn muốn chuyển đổi.',
    font_step2:
        'Bước 2: Nhấp vào Tải tệp lên, chọn file từ Storage hoặc Drive. Khi Dialog xuất hiện, nhấp ngay "Toàn bộ" và chờ hệ thống trả file về.',
    font_step3:
        'Bước 1: Nhấp vào Tải tệp lên và màn hình Storage + Google Drive sẽ xuất hiện.',
    font_step4:
        'Bước 2: Tìm và chọn file. Tại Dialog, nhấp ngay "Từng đoạn". Màn hình chuyển đổi từng phần sẽ xuất hiện.',
    font_step5:
        'Bước 3: Chọn những đoạn muốn đổi Font bằng cách nhấp vào đoạn đó. Trường hợp từng chữ thì nhấn vào để gõ lại hoặc xóa.',
    font_step6:
        'Bước 4: Sau khi chỉnh xong, nhấn vào nút góc phải ở trên cùng để xuất File dưới dạng DOCX hoặc PDF.',
    image_step:
        'Bước 1: Nhấn vào Dropdown loại tệp ảnh mới để chọn tệp ảnh bạn muốn chuyển đổi (PNG, JPG...).',
    image_step2:
        'Bước 2: Nhấp vào Tải tệp lên, chọn file. Khi Dialog xuất hiện, nhấp ngay "Toàn bộ" và chờ hệ thống trả file về.',
    image_step3:
        'Bước 1: Nhấp vào Tải tệp lên và màn hình Storage + Google Drive sẽ xuất hiện.',
    image_step4:
        'Bước 2: Tìm và chọn file. Tại Dialog, nhấp ngay "Từng phần". Màn hình chuyển đổi từng phần sẽ xuất hiện.',
    image_step5:
        'Bước 3: Tại màn hình này, bạn chọn những hình ảnh muốn đổi bằng cách nhấp vào từng ảnh theo mong muốn.',
    image_step6:
        'Bước 4: Sau khi chỉnh xong, nhấn vào nút màu xanh lá ở dưới cùng để xuất file.',
    understand: 'Đã hiểu, Bắt đầu ngay!',
    language_swip: 'Vuốt sang trái hoặc nhấn vào đây để xem tiếp',
    image_select: 'Có 2 kiểu chuyển đổi: "Toàn bộ" và "Từng phần"',
    image_seperate: 'Chuyển đổi từng phần',
    font_select: 'Có 2 kiểu chuyển đổi: "Toàn bộ" và "Từng đoạn"',
    seperate: 'Từng đoạn',
    home_tutorial1: '1. Chọn Font chữ',
    home_quote1: 'Chạm vào đây để chọn loại Font bạn muốn thử.',
    home_tutorial2: '2. Nhập văn bản',
    home_quote2: 'Gõ nội dung bạn muốn thử vào ô này.',
    home_tutorial3: '3. Định dạng văn bản',
    home_quote3:
        'Tùy chỉnh In đậm, Nghiêng, Gạch chân hoặc Đổi màu chữ tại đây.',
    home_tutorial4: '4. Kết quả',
    home_quote4: 'Văn bản sau khi được nhập, tùy chỉnh sẽ xuất hiện ở đây.',
    home_tutorial5: '5. Thao tác nhanh',
    home_quote5: 'Sao chép kết quả hoặc xóa để làm lại.',
    home_tutorial6: '6. Thanh điều hướng',
    home_quote6:
        'Chuyển đổi qua lại giữa các màn hình: Hồ sơ, Giới thiệu, Công cụ, Cài đặt và Đăng xuất.',
    home_tutorial7: '7. Thông tin cá nhân',
    home_quote7: 'Xem thông tin của bạn.',
    home_tutorial8: '8. Giới thiệu App',
    home_quote8: 'Tìm hiểu thêm về thông tin ứng dụng và các chức năng.',
    home_tutorial9: '9. Lựa chọn công cụ',
    home_quote9: 'Nơi lựa chọn các công cụ để chuyển đổi chữ theo mong muốn.',
    home_tutorial10: '10. Cài đặt',
    home_quote10:
        'Tùy chỉnh giao diện, ngôn ngữ ứng dụng \n và Các Chính sách bảo mật & Điều khoản và điều kiện.',
    home_tutorial11: '11. Đăng xuất',
    home_quote11: 'Đăng xuất khỏi tài khoản hiện tại.',
    privacy_term: 'Chính sách & Điều khoản',
    notify: 'Thông báo',
    update_pdf:
        'Tính năng Xuất PDF đang trong quá trình phát triển.\nVui lòng quay lại sau!',
    vietnamese: 'Tiếng Việt',
    english: 'Tiếng Anh',
    german: 'Tiếng Đức',
    french: 'Tiếng Pháp',
    italian: 'Tiếng Ý',
    spanish: 'Tiếng Tây Ban Nha',
    portuguese: 'Tiếng Bồ Đào Nha',
    chinese: 'Tiếng Trung (Giản thể)',
    korean: 'Tiếng Hàn',
    japanese: 'Tiếng Nhật',
    russian: 'Tiếng Nga',
    language_download_successed: '✅ Tải thành công! Bạn muốn mở file không?',
  };
}
