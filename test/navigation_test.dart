import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_hub/main.dart';

void main() {
  testWidgets('Navigacija, prijenos podataka i povratak', (tester) async {
    await tester.pumpWidget(const NavigacijaApp());
    await tester.tap(find.text('Otvori detalje i pošalji poruku'));
    await tester.pumpAndSettle();
    expect(find.text('Pozdrav s početne!'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(NavigationDestination, 'Kartice'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Tab, 'Primjer'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ovo je druga kartica.'), findsOneWidget);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Profil'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ime: Student'), findsOneWidget);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Kartice'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Ovo je druga kartica.'), findsOneWidget);
    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Početna'));
    await tester.pumpAndSettle();
    expect(find.text('Otvori detalje i pošalji poruku'), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold).first).isDrawerOpen,
      isFalse,
    );
    await tester.tap(find.byTooltip('Više mogućnosti'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('O aplikaciji'));
    await tester.pumpAndSettle();
    expect(find.text('Jednostavan Flutter primjer.'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Otvori detalje i pošalji poruku'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mali zaslon i uvećan tekst', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const NavigacijaApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.widgetWithText(NavigationDestination, 'Kartice'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
