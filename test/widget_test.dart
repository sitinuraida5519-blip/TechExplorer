import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    adminSession.clear();
  });

  testWidgets('student home shows the eight computer-learning categories', (
    tester,
  ) async {
    final history = MaterialHistoryStore(userEmail: 'siswa@example.com');
    await history.load();
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          userName: 'Siswa',
          userEmail: 'siswa@example.com',
          userClass: 'X TJKT 1',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pengenalan Komputer'), findsOneWidget);
    expect(find.text('Hardware (Perangkat Keras)'), findsOneWidget);
    expect(find.text('Software (Perangkat Lunak)'), findsOneWidget);
    expect(find.text('Sistem Operasi'), findsOneWidget);
    expect(find.text('Perangkat Input dan Output'), findsOneWidget);
    expect(find.text('Dasar Jaringan Komputer'), findsOneWidget);
    expect(find.text('Perangkat Jaringan'), findsOneWidget);
    expect(find.text('Istilah-Istilah Komputer'), findsOneWidget);
    expect(find.text('Quiz'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    history.dispose();
  });

  testWidgets('admin dashboard remains protected without an admin session', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AdminDashboard()));

    expect(find.text('Akses admin diperlukan'), findsOneWidget);
    expect(find.text('Kelola Kategori'), findsNothing);
  });

  testWidgets('admin can add and persist a learning category', (tester) async {
    adminSession.authenticate();
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AdminCategoryPage())),
    );
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Keamanan Komputer');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Keamanan Komputer'), findsOneWidget);
    expect(await categoryStore.load(), contains('Keamanan Komputer'));
  });

  test('account and material stores preserve data across reloads', () async {
    final accounts = [
      {
        'name': 'Siswa Kelas X',
        'email': 'x-tkj@example.com',
        'password': 'secret',
        'class': 'X TKJ 1',
      },
    ];
    expect(await userStore.save(accounts), isTrue);
    expect(await userStore.load(), accounts);

    final catalog = [
      MaterialData(
        id: 'test-motherboard',
        title: 'Motherboard',
        category: 'Hardware (Perangkat Keras)',
        description: 'Papan utama komputer.',
        content: 'Menghubungkan komponen komputer.',
        importantPoints: 'Komponen utama.',
        icon: Icons.developer_board,
      ),
    ];
    expect(await materialCatalogStore.save(catalog), isTrue);
    final restored = await materialCatalogStore.load();
    expect(restored, hasLength(1));
    expect(restored!.single.title, 'Motherboard');
    expect(restored.single.category, 'Hardware (Perangkat Keras)');
  });

  testWidgets('student login opens the computer dictionary home', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    await tester.enterText(
      find.byKey(const ValueKey('login-email-field')),
      'siswa@gmail.com',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password-field')),
      '123456',
    );
    await tester.tap(find.byKey(const ValueKey('login-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text('Halo, Siswa TKJ'), findsOneWidget);
    expect(find.text('Kategori Materi'), findsOneWidget);
    expect(adminSession.isAuthenticated, isFalse);
  });
}
