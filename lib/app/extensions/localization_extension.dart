import 'package:flutter/widgets.dart';

import '/app/gen/l10n/l10n.dart';

final AppLocalizations _fallbackLocalizations = AppLocalizationsRu();

extension LocalizationContextExtension on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this) ?? _fallbackLocalizations;
  }
}