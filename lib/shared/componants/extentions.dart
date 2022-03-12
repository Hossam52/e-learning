import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TranslationHelperStateless on StatelessWidget {}

extension TranslationhelperStateful<T extends StatefulWidget> on State<T> {}

extension TranslationAppLocalization on BuildContext {
  //For the interlocalization on context and call it like context.tr.****
  AppLocalizations get tr {
    return AppLocalizations.of(this)!;
  }
}
