import 'package:flutter_localization/flutter_localization.dart';

// ignore: constant_identifier_names
const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("de", LocaleData.DE),
  MapLocale("fr", LocaleData.FR),
  MapLocale("es", LocaleData.ES),
  MapLocale("it", LocaleData.IT),
  MapLocale("pt", LocaleData.PT),
  MapLocale("cn", LocaleData.CN),
  MapLocale("kr", LocaleData.KR),
  MapLocale("jp", LocaleData.JP),
  MapLocale("ru", LocaleData.RU),
  MapLocale("vn", LocaleData.VN),
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

  // ignore: constant_identifier_names
  static const Map<String, dynamic> EN = {
    title: 'Welcome to Écolive',
    title2: 'This is where we save ink together',
    title3: 'This is where we plant trees just by searching for information',
    title4: 'This is where we share a sustainable lifestyle together',
    body: 'Are you ready to live a sustainable lifestyle?',
    body2: 'Are you ready to live a sustainable lifestyle?',
    body3: 'Are you ready to live a sustainable lifestyle?',
    body4: 'Are you ready to live a sustainable lifestyle?',
    skip: 'Skip',
    next: 'Next',
    finish: 'Finish',
    settings: 'Settings',
    light_darkmode: 'Light / Dark Mode',
    language: 'Language',
    app_name: 'Eco Font Converter',
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
    appdescription:
        'Écolive Converter helps you convert text into an eco-friendly font, reducing ink usage and minimizing the carbon footprint.',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> DE = {
    title: 'Willkommen bei Écolive',
    title2: 'Hier sparen wir gemeinsam Tinte',
    title3: 'Hier pflanzen wir Bäume, nur indem wir Informationen suchen',
    title4: 'Hier teilen wir gemeinsam einen nachhaltigen Lebensstil',
    body: 'Sind Sie bereit, einen nachhaltigen Lebensstil zu leben?',
    body2: 'Sind Sie bereit, einen nachhaltigen Lebensstil zu leben?',
    body3: 'Sind Sie bereit, einen nachhaltigen Lebensstil zu leben?',
    body4: 'Sind Sie bereit, einen nachhaltigen Lebensstil zu leben?',
    skip: 'Überspringen',
    next: 'Nächster',
    finish: 'Fertig',
    settings: 'Einstellungen',
    light_darkmode: 'Hell / Dunkel Modus',
    language: 'Sprache',
    app_name: 'Eco Font konverter',
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
    appdescription:
        'Der Écolive Converter hilft Ihnen, Text in eine umweltfreundliche Schriftart zu konvertieren, den Tintenverbrauch zu reduzieren und den CO2-Fußabdruck zu minimieren.',
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
  };

  // ignore: constant_identifier_names
  // ignore: constant_identifier_names
  // ignore: constant_identifier_names
  // ignore: constant_identifier_names
  static const Map<String, dynamic> FR = {
    title: 'Bienvenue sur Écolive',
    title2: 'C\'est ici que nous économisons de l\'encre ensemble',
    title3:
        'C\'est ici que nous plantons des arbres juste en cherchant des informations',
    title4: 'C\'est ici que nous partageons ensemble un mode de vie durable',
    body: 'Êtes-vous prêt à vivre un mode de vie durable ?',
    body2: 'Êtes-vous prêt à vivre un mode de vie durable ?',
    body3: 'Êtes-vous prêt à vivre un mode de vie durable ?',
    body4: 'Êtes-vous prêt à vivre un mode de vie durable ?',
    skip: 'Passer',
    next: 'Suivant',
    finish: 'Terminer',
    settings: 'Paramètres',
    light_darkmode: 'Mode clair / sombre',
    language: 'Langue',
    app_name: 'Eco Font Convertisseur',
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
    appdescription:
        'Le convertisseur Écolive vous aide à convertir du texte en une police écologique, réduisant ainsi la consommation d\'encre et minimisant l\'empreinte carbone.',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> ES = {
    title: 'Bienvenido a Écolive',
    title2: 'Aquí es donde ahorramos tinta juntos',
    title3: 'Aquí es donde plantamos árboles solo buscando información',
    title4: 'Aquí es donde compartimos un estilo de vida sostenible juntos',
    body: '¿Estás listo para vivir un estilo de vida sostenible?',
    body2: '¿Estás listo para vivir un estilo de vida sostenible?',
    body3: '¿Estás listo para vivir un estilo de vida sostenible?',
    body4: '¿Estás listo para vivir un estilo de vida sostenible?',
    skip: 'Saltar',
    next: 'Siguiente',
    finish: 'Terminar',
    settings: 'Configuraciones',
    light_darkmode: 'Modo claro / oscuro',
    language: 'Idioma',
    app_name: 'Eco Font Convertidor',
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
    appdescription:
        'El convertidor Écolive te ayuda a convertir texto en una fuente ecológica, reduciendo el uso de tinta y minimizando la huella de carbono.',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> IT = {
    title: 'Benvenuto in Écolive',
    title2: 'Qui è dove risparmiamo inchiostro insieme',
    title3: 'Qui è dove piantiamo alberi solo cercando informazioni',
    title4: 'Qui è dove condividiamo insieme uno stile di vita sostenibile',
    body: 'Sei pronto a vivere uno stile di vita sostenibile?',
    body2: 'Sei pronto a vivere uno stile di vita sostenibile?',
    body3: 'Sei pronto a vivere uno stile di vita sostenibile?',
    body4: 'Sei pronto a vivere uno stile di vita sostenibile?',
    skip: 'Salta',
    next: 'Prossimo',
    finish: 'Fine',
    settings: 'Impostazioni',
    light_darkmode: 'Modalità chiara / scura',
    language: 'Lingua',
    app_name: 'Eco Font Convertitore',
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
    appdescription:
        'Il convertitore Écolive ti aiuta a convertire il testo in un carattere ecologico, riducendo l\'uso di inchiostro e minimizzando l\'impronta di carbonio.',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> PT = {
    title: 'Bem-vindo ao Écolive',
    title2: 'Aqui é onde economizamos tinta juntos',
    title3: 'Aqui é onde plantamos árvores apenas pesquisando informações',
    title4: 'Aqui é onde compartilhamos um estilo de vida sustentável juntos',
    body: 'Você está pronto para viver um estilo de vida sustentável?',
    body2: 'Você está pronto para viver um estilo de vida sustentável?',
    body3: 'Você está pronto para viver um estilo de vida sustentável?',
    body4: 'Você está pronto para viver um estilo de vida sustentável?',
    skip: 'Pular',
    next: 'Próximo',
    finish: 'Concluir',
    settings: 'Configurações',
    light_darkmode: 'Modo claro / escuro',
    language: 'Idioma',
    app_name: 'Eco Font Conversor',
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
    appdescription:
        'O conversor Écolive ajuda você a converter texto em uma fonte ecológica, reduzindo o uso de tinta e minimizando a pegada de carbono.',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> CN = {
    title: '欢迎来到Écolive',
    title2: '这是我们一起节省墨水的地方',
    title3: '这是我们通过搜索信息来种树的地方',
    title4: '这是我们共同分享可持续生活方式的地方',
    body: '你准备好过上可持续的生活方式了吗？',
    body2: '你准备好过上可持续的生活方式了吗？',
    body3: '你准备好过上可持续的生活方式了吗？',
    body4: '你准备好过上可持续的生活方式了吗？',
    skip: '跳过',
    next: '下一个',
    finish: '完成',
    settings: '设置',
    light_darkmode: '明亮/黑暗模式',
    language: '语言',
    app_name: '生态字体转换器',
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
    appdescription: 'Écolive转换器帮助您将文本转换为环保字体，减少墨水使用并最小化碳足迹。',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> KR = {
    title: 'Écolive에 오신 것을 환영합니다',
    title2: '여기서 우리는 함께 잉크를 절약합니다',
    title3: '정보를 검색하는 것만으로 나무를 심는 곳입니다',
    title4: '여기서 우리는 함께 지속 가능한 라이프스타일을 공유합니다',
    body: '지속 가능한 라이프스타일을 살 준비가 되셨습니까?',
    body2: '지속 가능한 라이프스타일을 살 준비가 되셨습니까?',
    body3: '지속 가능한 라이프스타일을 살 준비가 되셨습니까?',
    body4: '지속 가능한 라이프스타일을 살 준비가 되셨습니까?',
    skip: '건너뛰기',
    next: '다음',
    finish: '완료',
    settings: '설정',
    light_darkmode: '라이트 / 다크 모드',
    language: '언어',
    app_name: '에코 폰트 변환기',
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
    appdescription:
        'Écolive 변환기는 텍스트를 친환경 글꼴로 변환하여 잉크 사용을 줄이고 탄소 발자국을 최소화하는 데 도움을 줍니다.',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> JP = {
    title: 'Écoliveへようこそ',
    title2: 'ここでは、私たちが一緒にインクを節約します',
    title3: '情報を検索するだけで木を植える場所です',
    title4: 'ここでは、私たちが一緒に持続可能なライフスタイルを共有します',
    body: '持続可能なライフスタイルを生きる準備はできていますか？',
    body2: '持続可能なライフスタイルを生きる準備はできていますか？',
    body3: '持続可能なライフスタイルを生きる準備はできていますか？',
    body4: '持続可能なライフスタイルを生きる準備はできていますか？',
    skip: 'スキップ',
    next: '次へ',
    finish: '終了',
    settings: '設定',
    light_darkmode: 'ライト / ダークモード',
    language: '言語',
    app_name: 'エコフォントコンバーター',
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
    appdescription:
        'Écoliveコンバーターは、テキストをエコフォントに変換するのに役立ち、インクの使用を減らし、カーボンフットプリントを最小限に抑えます。',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> RU = {
    title: 'Добро пожаловать в Écolive',
    title2: 'Здесь мы вместе экономим чернила',
    title3: 'Здесь мы сажаем деревья, просто ища информацию',
    title4: 'Здесь мы вместе делимся устойчивым образом жизни',
    body: 'Вы готовы жить устойчивым образом жизни?',
    body2: 'Вы готовы жить устойчивым образом жизни?',
    body3: 'Вы готовы жить устойчивым образом жизни?',
    body4: 'Вы готовы жить устойчивым образом жизни?',
    skip: 'Пропустить',
    next: 'Далее',
    finish: 'Завершить',
    settings: 'Настройки',
    light_darkmode: 'Светлый / Темный режим',
    language: 'Язык',
    app_name: 'Конвертер шрифтов Eco',
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
  };

  // ignore: constant_identifier_names
  static const Map<String, dynamic> VN = {
    title: 'Chào mừng bạn đến với Écolive',
    title2: 'Đây là nơi chúng tôi tiết kiệm mực cùng nhau',
    title3: 'Đây là nơi chúng tôi trồng cây chỉ bằng cách tìm kiếm thông tin',
    title4: 'Đây là nơi chúng tôi chia sẻ lối sống bền vững cùng nhau',
    body: 'Bạn đã sẵn sàng để sống một lối sống bền vững chưa?',
    body2: 'Bạn đã sẵn sàng để sống một lối sống bền vững chưa?',
    body3: 'Bạn đã sẵn sàng để sống một lối sống bền vững chưa?',
    body4: 'Bạn đã sẵn sàng để sống một lối sống bền vững chưa?',
    skip: 'Bỏ qua',
    next: 'Tiếp theo',
    finish: 'Kết thúc',
    settings: 'Cài đặt',
    light_darkmode: 'Chế độ sáng / tối',
    language: 'Ngôn ngữ',
    app_name: 'Trình chuyển đổi phông chữ Eco',
    enter_text: 'Nhập văn bản',
    converted_text: 'Văn bản đã chuyển đổi',
    converted_text_description:
        'Văn bản đã chuyển đổi của bạn sẽ xuất hiện ở đây...',
    copy: 'Sao chép',
    reset: 'Đặt lại',
    savePDF: 'Lưu dưới dạng PDF',
    saveWord: 'Lưu dưới dạng Word',
    profile: 'Hồ sơ',
    feeds: 'Nguồn cấp dữ liệu',
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
  """, // Dấu phẩy ở cuối là rất quan trọng
    // appdescription:
    //     'Bộ chuyển đổi Écolive giúp bạn chuyển đổi văn bản thành phông chữ thân thiện với môi trường, giảm việc sử dụng mực và tối thiểu hóa dấu chân carbon.',
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
    cancel: 'Hủy bỏ',
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
  };
}
