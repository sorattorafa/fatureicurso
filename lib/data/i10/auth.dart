import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class LabelOverrides extends PtLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Digite seu email';

  @override
  String get passwordInputLabel => 'Digite sua senha';

  @override
  String get emailIsNotVerifiedText => "Seu email ainda não foi verificado";

  @override
  String get sendVerificationEmailLabel => "Enviar email de verificação";

  @override
  String get dismissButtonLabel => "Ignorar";
}
