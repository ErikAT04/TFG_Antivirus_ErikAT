import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:magik_antivirus/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Se inicia sesión correctamente", (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      "isUserRegistered": false,
      "userName": "",
      "userPass": "",
      "chosenLang": "es",
      "themeMode": "light",
      "colorR": 14,
      "colorG": 54,
      "colorB": 111,
    });

    app.main();
    await Future.delayed(
        Duration(seconds: 10)); //Para que cargue todo correctamente
    await tester.pumpAndSettle();

    ScaffoldState state = tester.firstState(find.byType(Scaffold));

    BuildContext context = state.context;

    expect(find.byType(TextField), findsNWidgets(2));

    await tester.tap(find.text(AppLocalizations.of(context)!.logIn).first);
    await tester.pumpAndSettle();

    expect(find.text(AppLocalizations.of(context)!.errorEmptyField),
        findsNWidgets(2));

    await tester.tap(find.byKey(Key("user")));
    await tester.enterText(find.byKey(Key("user")), "Prueba");
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppLocalizations.of(context)!.logIn).first);
    await tester.pumpAndSettle();

    expect(find.text(AppLocalizations.of(context)!.errorEmptyField),
        findsOneWidget);

    await tester.tap(find.byKey(Key("pass")));
    await tester.enterText(find.byKey(Key("pass")), "prueba123");
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppLocalizations.of(context)!.logIn).first);
    await tester.pumpAndSettle();

    expect(
        find.text(AppLocalizations.of(context)!.errorNotFound), findsOneWidget);

    await tester.tap(find.byKey(Key("user")));
    await tester.enterText(find.byKey(Key("user")), "prueba@gmail.com");
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppLocalizations.of(context)!.logIn).first);
    await tester.pumpAndSettle();

    expect(find.text(AppLocalizations.of(context)!.errorWrongPass),
        findsOneWidget);

    await tester.tap(find.byKey(Key("pass")));
    await tester.enterText(find.byKey(Key("pass")), "prueba1234");
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppLocalizations.of(context)!.logIn).first);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
  });
}
