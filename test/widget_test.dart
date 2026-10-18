import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('TechExplorer app loads and navigates to login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('TechExplorer'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(
      find.text('Masuk untuk mulai belajar bersama TechExplorer.'),
      findsOneWidget,
    );
  });

  test(
    'history persists, moves reopened materials to the top, and deduplicates',
    () async {
      SharedPreferences.setMockInitialValues({});
      final history = MaterialHistoryStore(userEmail: 'siswa@example.com');
      await history.load();

      await history.record(materials[0]);
      await history.record(materials[1]);
      await history.record(materials[0]);

      expect(history.entries, hasLength(2));
      expect(history.entries.first.materialId, materials[0].id);

      final reopened = MaterialHistoryStore(userEmail: 'siswa@example.com');
      await reopened.load();
      expect(reopened.entries.map((entry) => entry.materialId), [
        materials[0].id,
        materials[1].id,
      ]);

      final anotherAccount = MaterialHistoryStore(
        userEmail: 'akun-lain@example.com',
      );
      await anotherAccount.load();
      expect(anotherAccount.entries, isEmpty);

      await reopened.remove(materials[1].id);
      expect(reopened.entries, hasLength(1));
      expect(reopened.entries.single.materialId, materials[0].id);
      await reopened.clear();
      expect(reopened.entries, isEmpty);

      history.dispose();
      reopened.dispose();
      anotherAccount.dispose();
    },
  );

  testWidgets('history opens the original material and confirms clearing', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final history = MaterialHistoryStore(userEmail: 'siswa@example.com');
    await history.load();
    await history.record(materials[0]);
    await history.record(materials[1]);

    await tester.pumpWidget(
      MaterialApp(
        home: MaterialHistoryPage(
          historyStore: history,
          bookmarks: <String>{},
          onBookmarkChanged: () {},
        ),
      ),
    );

    expect(find.text('Sistem Komputer'), findsOneWidget);
    await tester.tap(find.text('Sistem Komputer'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Materi'), findsOneWidget);
    expect(find.text('Sistem Komputer'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Hapus semua riwayat'));
    await tester.pumpAndSettle();
    expect(find.text('Hapus semua riwayat?'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(history.entries, hasLength(2));

    await tester.tap(find.byTooltip('Hapus semua riwayat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus semua'));
    await tester.pumpAndSettle();
    expect(history.entries, isEmpty);

    history.dispose();
  });

  testWidgets('theme preference defaults to light and persists live changes', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await appThemeController.load();
    expect(appThemeController.themeMode, ThemeMode.light);

    await tester.pumpWidget(const TechExplorerApp());
    expect(Theme.of(tester.element(find.byType(Scaffold))).brightness, Brightness.light);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.byType(LoginPage))).brightness, Brightness.dark);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('tech_explorer_theme'), 'dark');

    await tester.tap(find.text('Registrasi'));
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.byType(RegisterPage))).brightness, Brightness.dark);
    await tester.pageBack();
    await tester.pumpAndSettle();

    final restoredController = ThemeController();
    await restoredController.load();
    expect(restoredController.themeMode, ThemeMode.dark);
    restoredController.dispose();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(preferences.getString('tech_explorer_theme'), 'light');
    expect(Theme.of(tester.element(find.byType(LoginPage))).brightness, Brightness.light);
    await appThemeController.setDarkMode(false);
  });
}
