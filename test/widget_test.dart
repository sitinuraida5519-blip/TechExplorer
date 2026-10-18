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

  testWidgets('quiz timer counts down and is not reset between questions', (
    WidgetTester tester,
  ) async {
    quizHistory.clear();
    var completionCount = 0;
    var now = DateTime(2026, 1, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: QuizPage(
          clock: () => now,
          onQuizFinished: () => completionCount++,
        ),
      ),
    );

    expect(find.text('Sisa Waktu'), findsOneWidget);
    expect(find.text('15:00'), findsOneWidget);
    final firstQuestion = quizQuestions.first;
    await tester.ensureVisible(
      find.text(firstQuestion.options[firstQuestion.correctAnswer]),
    );
    await tester.tap(
      find.text(firstQuestion.options[firstQuestion.correctAnswer]),
    );
    await tester.pump();
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('14:59'), findsOneWidget);

    await tester.ensureVisible(find.text('Soal Berikutnya'));
    await tester.tap(find.text('Soal Berikutnya'));
    await tester.pump();
    expect(find.text(quizQuestions[1].question), findsOneWidget);
    expect(find.text('14:59'), findsOneWidget);

    for (var index = 1; index < quizQuestions.length; index++) {
      final question = quizQuestions[index];
      await tester.ensureVisible(
        find.text(question.options[question.correctAnswer]),
      );
      await tester.tap(find.text(question.options[question.correctAnswer]));
      await tester.pump();
      final nextLabel = index == quizQuestions.length - 1
          ? 'Selesai'
          : 'Soal Berikutnya';
      await tester.ensureVisible(find.text(nextLabel));
      await tester.tap(find.text(nextLabel));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    expect(find.byType(QuizResultPage), findsOneWidget);
    expect(find.text('10 benar dari 10 soal'), findsOneWidget);
    expect(quizHistory, hasLength(1));
    expect(completionCount, 1);

    await tester.pump(const Duration(minutes: 15));
    expect(quizHistory, hasLength(1));
    expect(completionCount, 1);
  });

  testWidgets('quiz timeout scores the selected answer and completes once', (
    WidgetTester tester,
  ) async {
    quizHistory.clear();
    var completionCount = 0;
    var now = DateTime(2026, 1, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: QuizPage(
          duration: const Duration(seconds: 5),
          clock: () => now,
          onQuizFinished: () => completionCount++,
        ),
      ),
    );

    expect(find.text('00:05'), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    final timer = tester.widget<Container>(
      find.byKey(const ValueKey('quiz-timer')),
    );
    expect(
      (timer.decoration! as BoxDecoration).color,
      Theme.of(tester.element(find.byType(QuizPage)))
          .colorScheme
          .errorContainer,
    );

    final firstQuestion = quizQuestions.first;
    await tester.ensureVisible(
      find.text(firstQuestion.options[firstQuestion.correctAnswer]),
    );
    await tester.tap(
      find.text(firstQuestion.options[firstQuestion.correctAnswer]),
    );
    await tester.pump();
    now = now.add(const Duration(seconds: 4));
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('00:01'), findsOneWidget);
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(QuizResultPage), findsOneWidget);
    expect(
      find.text('Waktu habis. Kuis telah diselesaikan otomatis.'),
      findsOneWidget,
    );
    expect(
      find.text('1 benar dari ${quizQuestions.length} soal'),
      findsOneWidget,
    );
    expect(quizHistory, hasLength(1));
    expect(quizHistory.single['correct'], 1);
    expect(completionCount, 1);

    await tester.pump(const Duration(seconds: 5));
    expect(quizHistory, hasLength(1));
    expect(completionCount, 1);
  });

  testWidgets('leaving quiz cancels the timer without recording a result', (
    WidgetTester tester,
  ) async {
    quizHistory.clear();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) =>
                      const QuizPage(duration: Duration(seconds: 5)),
                ),
              ),
              child: const Text('Mulai Kuis'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mulai Kuis'));
    await tester.pumpAndSettle();
    expect(find.text('00:05'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 6));

    expect(find.byType(QuizResultPage), findsNothing);
    expect(quizHistory, isEmpty);
  });

  testWidgets('deadline wins over an answer tap before the next timer tick', (
    WidgetTester tester,
  ) async {
    quizHistory.clear();
    var completionCount = 0;
    var now = DateTime(2026, 1, 1);
    final firstQuestion = quizQuestions.first;
    await tester.pumpWidget(
      MaterialApp(
        home: QuizPage(
          duration: const Duration(seconds: 5),
          clock: () => now,
          onQuizFinished: () => completionCount++,
        ),
      ),
    );

    final wrongAnswer = firstQuestion.correctAnswer == 0 ? 1 : 0;
    await tester.ensureVisible(find.text(firstQuestion.options[wrongAnswer]));
    await tester.tap(find.text(firstQuestion.options[wrongAnswer]));
    await tester.pump();
    now = now.add(const Duration(seconds: 5));

    await tester.tap(
      find.text(firstQuestion.options[firstQuestion.correctAnswer]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(QuizResultPage), findsOneWidget);
    expect(find.text('0 benar dari ${quizQuestions.length} soal'), findsOneWidget);
    expect(quizHistory, hasLength(1));
    expect(quizHistory.single['correct'], 0);
    expect(completionCount, 1);
  });
}
