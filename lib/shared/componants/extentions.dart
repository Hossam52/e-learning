import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TranslationHelperStateless on StatelessWidget {}

extension TranslationhelperStateful<T extends StatefulWidget> on State<T> {}

extension TranslationAppLocalization on BuildContext {
  AppLocalizations get tr {
    return AppLocalizations.of(this)!;
  }
}
