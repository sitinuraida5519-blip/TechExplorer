import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/main.dart';

class FailingMaterialCatalogStore extends MaterialCatalogStore {
  @override
  Future<bool> save(List<MaterialData> catalog) async => false;
}

class FailingQuizQuestionStore extends QuizQuestionStore {
  @override
  Future<QuizQuestionSaveResult> add(
    QuizQuestion question, {
    required Iterable<QuizQuestion> existingQuestions,
  }) async => QuizQuestionSaveResult.failed;
}

Future<void> startQuiz(
  WidgetTester tester, {
  QuizDifficulty difficulty = QuizDifficulty.easy,
}) async {
  await tester.ensureVisible(
    find.byKey(ValueKey('difficulty-${difficulty.name}')),
  );
  await tester.tap(find.byKey(ValueKey('difficulty-${difficulty.name}')));
  await tester.pump();
  await tester.ensureVisible(find.byKey(const ValueKey('start-quiz')));
  await tester.tap(find.byKey(const ValueKey('start-quiz')));
  await tester.pump();
}

Future<void> fillQuizQuestionForm(
  WidgetTester tester, {
  String prompt = 'Pertanyaan admin baru?',
}) async {
  await tester.enterText(
    find.byKey(const ValueKey('quiz-question-field')),
    prompt,
  );
  for (var index = 0; index < 4; index++) {
    await tester.enterText(
      find.byKey(ValueKey('quiz-option-$index')),
      'Jawaban ${String.fromCharCode(65 + index)}',
    );
  }
  await tester.pump();
  tester.testTextInput.hide();
  await tester.pump();
}

void main() {
  testWidgets('difficulty selection filters real questions and starts timer', (
    WidgetTester tester,
  ) async {
    for (final difficulty in QuizDifficulty.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: QuizPage(
            key: ValueKey('quiz-${difficulty.name}'),
            duration: const Duration(minutes: 2),
            questionBank: quizQuestions,
          ),
        ),
      );

      await tester.ensureVisible(find.byKey(const ValueKey('start-quiz')));
      await tester.tap(find.byKey(const ValueKey('start-quiz')));
      await tester.pump();
      expect(find.text('Pilih Tingkat Kesulitan'), findsOneWidget);
      expect(find.text('Sisa Waktu'), findsNothing);

      final questions = questionsForDifficulty(quizQuestions, difficulty);
      expect(questions, isNotEmpty);
      expect(
        questions.every((question) => question.difficulty == difficulty),
        isTrue,
      );
      expect(
        find.descendant(
          of: find.byKey(ValueKey('difficulty-${difficulty.name}')),
          matching: find.text('${questions.length} soal'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(ValueKey('difficulty-${difficulty.name}')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('start-quiz')));
      await tester.pump();

      expect(find.text(questions.first.question), findsOneWidget);
      expect(find.text('Soal 1 dari ${questions.length}'), findsOneWidget);
      expect(find.text('Tingkat: ${difficulty.label}'), findsOneWidget);
      expect(find.text('02:00'), findsOneWidget);
    }
  });

  testWidgets('difficulty without questions reports an error and stays idle', (
    WidgetTester tester,
  ) async {
    final easyQuestion = QuizQuestion(
      question: 'Pertanyaan mudah',
      options: ['A', 'B'],
      correctAnswer: 0,
      difficulty: QuizDifficulty.easy,
    );
    await tester.pumpWidget(
      MaterialApp(home: QuizPage(questionBank: [easyQuestion])),
    );

    expect(find.text('Tidak tersedia'), findsNWidgets(2));
    await tester.tap(find.byKey(const ValueKey('difficulty-hard')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('start-quiz')));
    await tester.pump();

    expect(find.text('Belum ada soal untuk tingkat Sulit.'), findsOneWidget);
    expect(find.text('Pilih Tingkat Kesulitan'), findsOneWidget);
    expect(find.text('Sisa Waktu'), findsNothing);
  });

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

  testWidgets('login shell fits phone and wide viewports without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(360, 640), const Size(1100, 820)]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('login-email-field')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('login-password-field')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('login-button')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    addTearDown(tester.view.resetPhysicalSize);
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

  testWidgets('admin edit updates selected material and persists the catalog', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final originalCatalog = materials.map((item) => item.copyWith()).toList();
    addTearDown(() {
      materials
        ..clear()
        ..addAll(originalCatalog);
      SharedPreferences.setMockInitialValues({});
    });
    final selected = materials[0];
    final selectedId = selected.id;
    final otherId = materials[1].id;
    final otherTitle = materials[1].title;
    var changeNotifications = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminMaterialPage(onChanged: () => changeNotifications++),
        ),
      ),
    );
    await tester.tap(find.byKey(ValueKey('edit-material-$selectedId')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('material-title-field')),
          )
          .initialValue,
      selected.title,
    );
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('material-content-field')),
          )
          .initialValue,
      selected.content,
    );

    await tester.enterText(
      find.byKey(const ValueKey('material-title-field')),
      'Judul Materi Diperbarui',
    );
    await tester.enterText(
      find.byKey(const ValueKey('material-description-field')),
      'Deskripsi materi yang telah diperbarui.',
    );
    await tester.enterText(
      find.byKey(const ValueKey('material-content-field')),
      'Isi materi terbaru.',
    );
    await tester.pump();
    tester.testTextInput.hide();
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('save-material')));
    await tester.tap(find.byKey(const ValueKey('save-material')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final updated = materials.singleWhere((item) => item.id == selectedId);
    expect(updated.title, 'Judul Materi Diperbarui');
    expect(updated.description, 'Deskripsi materi yang telah diperbarui.');
    expect(updated.content, 'Isi materi terbaru.');
    expect(
      materials.singleWhere((item) => item.id == otherId).title,
      otherTitle,
    );
    expect(changeNotifications, 1);

    final restored = await MaterialCatalogStore().load();
    expect(restored, isNotNull);
    expect(restored!.length, originalCatalog.length);
    expect(
      restored.singleWhere((item) => item.id == selectedId).title,
      updated.title,
    );
    expect(
      restored.singleWhere((item) => item.id == otherId).title,
      otherTitle,
    );

    final history = MaterialHistoryStore(userEmail: 'admin@example.com');
    await history.load();
    await tester.pumpWidget(
      MaterialApp(
        home: MaterialDetailPage(
          material: updated,
          bookmarks: <String>{},
          historyStore: history,
          onBookmarkChanged: () {},
        ),
      ),
    );
    expect(find.text(updated.title), findsOneWidget);
    expect(find.text(updated.description), findsOneWidget);
    expect(find.text(updated.content), findsOneWidget);
    history.dispose();
  });

  testWidgets('edit validation and cancel preserve original material', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final originalCatalog = materials.map((item) => item.copyWith()).toList();
    addTearDown(() {
      materials
        ..clear()
        ..addAll(originalCatalog);
      SharedPreferences.setMockInitialValues({});
    });
    final material = materials.first;
    final originalTitle = material.title;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AdminMaterialPage(onChanged: () {})),
      ),
    );
    await tester.tap(find.byKey(ValueKey('edit-material-${material.id}')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('material-title-field')),
      '',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('save-material')));
    await tester.tap(find.byKey(const ValueKey('save-material')));
    await tester.pump();
    expect(find.text('Judul materi wajib diisi.'), findsOneWidget);
    expect(materials.first.title, originalTitle);

    await tester.enterText(
      find.byKey(const ValueKey('material-title-field')),
      'Perubahan yang dibatalkan',
    );
    await tester.pump();
    tester.testTextInput.hide();
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cancel-material')));
    await tester.pump();
    expect(find.text('Buang perubahan?'), findsOneWidget);
    await tester.tap(find.text('Buang perubahan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(materials.first.title, originalTitle);
    expect(find.text('Edit Materi'), findsNothing);
  });

  testWidgets('failed material persistence keeps the edit form and input', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final material = materials.first;
    final originalTitle = material.title;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminMaterialPage(
            onChanged: () {},
            catalogStore: FailingMaterialCatalogStore(),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(ValueKey('edit-material-${material.id}')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('material-title-field')),
      'Input tetap tersimpan',
    );
    await tester.pump();
    tester.testTextInput.hide();
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('save-material')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Edit Materi'), findsOneWidget);
    expect(
      find.text(
        'Perubahan belum tersimpan. Periksa penyimpanan lalu coba lagi.',
      ),
      findsOneWidget,
    );
    expect(find.text('Input tetap tersimpan'), findsOneWidget);
    expect(materials.first.title, originalTitle);
  });

  testWidgets(
    'admin adds a persisted question that appears in its level quiz',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final originalQuestions = List<QuizQuestion>.of(quizQuestions);
      addTearDown(() {
        quizQuestions
          ..clear()
          ..addAll(originalQuestions);
        SharedPreferences.setMockInitialValues({});
      });

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AdminQuizPage())),
      );
      await tester.tap(find.byKey(const ValueKey('add-quiz-question')));
      await tester.pumpAndSettle();
      await fillQuizQuestionForm(tester);

      await tester.ensureVisible(
        find.byKey(const ValueKey('quiz-category-field')),
      );
      await tester.tap(find.byKey(const ValueKey('quiz-category-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Networking').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('quiz-difficulty-field')),
      );
      await tester.tap(find.byKey(const ValueKey('quiz-difficulty-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sedang').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('quiz-correct-answer-field')),
      );
      await tester.tap(find.byKey(const ValueKey('quiz-correct-answer-field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pilihan C').last);
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('save-quiz-question')),
      );
      await tester.tap(find.byKey(const ValueKey('save-quiz-question')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final added = quizQuestions.singleWhere(
        (question) => question.question == 'Pertanyaan admin baru?',
      );
      expect(added.options, [
        'Jawaban A',
        'Jawaban B',
        'Jawaban C',
        'Jawaban D',
      ]);
      expect(added.correctAnswer, 2);
      expect(added.category, 'Networking');
      expect(added.difficulty, QuizDifficulty.medium);
      expect(added.isActive, isTrue);
      await tester.ensureVisible(
        find.byKey(const ValueKey('quiz-question-search')),
      );
      await tester.enterText(
        find.byKey(const ValueKey('quiz-question-search')),
        added.question,
      );
      await tester.pump();
      expect(
        find.text('Networking · Sedang · Pilihan ganda · Aktif'),
        findsOneWidget,
      );

      final storedQuestions = await QuizQuestionStore().load();
      expect(storedQuestions, hasLength(1));
      expect(storedQuestions!.single.id, added.id);

      final historyCount = quizHistory.length;
      await tester.pumpWidget(
        MaterialApp(
          home: QuizPage(
            questionBank: quizQuestions,
            duration: const Duration(minutes: 2),
          ),
        ),
      );
      await startQuiz(tester, difficulty: QuizDifficulty.medium);
      final mediumQuestions = questionsForDifficulty(
        quizQuestions,
        QuizDifficulty.medium,
      );
      expect(mediumQuestions.last.id, added.id);
      for (var index = 0; index < mediumQuestions.length; index++) {
        final question = mediumQuestions[index];
        expect(find.text(question.question), findsOneWidget);
        await tester.ensureVisible(
          find.text(question.options[question.correctAnswer]),
        );
        await tester.tap(find.text(question.options[question.correctAnswer]));
        await tester.pump();
        final nextLabel = index == mediumQuestions.length - 1
            ? 'Selesai'
            : 'Soal Berikutnya';
        await tester.ensureVisible(find.text(nextLabel));
        await tester.pump(const Duration(milliseconds: 250));
        await tester.tap(find.text(nextLabel));
        await tester.pump();
      }
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(QuizResultPage), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(
        find.text(
          '${mediumQuestions.length} benar dari ${mediumQuestions.length} soal',
        ),
        findsOneWidget,
      );
      expect(quizHistory, hasLength(historyCount + 1));
      expect(quizHistory.last['correct'], mediumQuestions.length);
      expect(quizHistory.last['total'], mediumQuestions.length);
      expect(quizHistory.last['difficulty'], 'medium');
    },
  );

  testWidgets('new question form rejects missing question and choices', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final originalCount = quizQuestions.length;
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AdminQuizPage())),
    );
    await tester.tap(find.byKey(const ValueKey('add-quiz-question')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-quiz-question')));
    await tester.pump();

    expect(find.text('Pertanyaan wajib diisi.'), findsOneWidget);
    expect(find.text('Semua pilihan jawaban wajib diisi.'), findsNWidgets(4));
    expect(find.byKey(const ValueKey('quiz-question-field')), findsOneWidget);
    expect(quizQuestions, hasLength(originalCount));
    expect(await QuizQuestionStore().load(), isEmpty);
  });

  testWidgets('failed question storage keeps form input and bank unchanged', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final originalCount = quizQuestions.length;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminQuizPage(questionStore: FailingQuizQuestionStore()),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('add-quiz-question')));
    await tester.pumpAndSettle();
    await fillQuizQuestionForm(tester, prompt: 'Soal gagal tersimpan');
    await tester.tap(find.byKey(const ValueKey('save-quiz-question')));
    await tester.pump();

    expect(
      find.text('Soal gagal disimpan. Periksa penyimpanan lalu coba lagi.'),
      findsOneWidget,
    );
    expect(find.text('Soal gagal tersimpan'), findsOneWidget);
    expect(quizQuestions, hasLength(originalCount));
    expect(await QuizQuestionStore().load(), isEmpty);
  });

  test(
    'question store rejects duplicate IDs and inactive questions are filtered',
    () async {
      SharedPreferences.setMockInitialValues({});
      final store = QuizQuestionStore();
      final existing = quizQuestions.first;
      final duplicate = QuizQuestion(
        id: existing.id,
        question: 'ID duplikat',
        options: const ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
      );
      expect(
        await store.add(duplicate, existingQuestions: quizQuestions),
        QuizQuestionSaveResult.duplicateId,
      );
      expect(await store.load(), isEmpty);

      final inactive = QuizQuestion(
        question: 'Soal nonaktif',
        options: const ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
        difficulty: QuizDifficulty.easy,
        isActive: false,
      );
      expect(questionsForDifficulty([inactive], QuizDifficulty.easy), isEmpty);
    },
  );

  test('question store updates by ID and persists the unchanged ID', () async {
    SharedPreferences.setMockInitialValues({});
    final store = QuizQuestionStore();
    final question = QuizQuestion(
      id: 'editable-question',
      question: 'Pertanyaan lama',
      options: const ['A', 'B', 'C', 'D'],
      correctAnswer: 1,
    );
    quizQuestions.add(question);
    addTearDown(
      () => quizQuestions.removeWhere((item) => item.id == question.id),
    );

    final updated = question.copyWith(question: 'Pertanyaan baru');
    expect(
      await store.update(updated, existingQuestions: quizQuestions),
      QuizQuestionMutationResult.saved,
    );
    final reloaded = await QuizQuestionStore().load();
    expect(reloaded, hasLength(1));
    expect(reloaded!.single.id, question.id);
    expect(reloaded.single.question, 'Pertanyaan baru');
    expect(
      await store.update(updated, existingQuestions: const <QuizQuestion>[]),
      QuizQuestionMutationResult.notFound,
    );
  });

  testWidgets('admin edits a question in place and persists the changes', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final question = QuizQuestion(
      id: 'admin-edit-question',
      question: 'Pertanyaan sebelum edit',
      options: const ['Jawaban A', 'Jawaban B', 'Jawaban C', 'Jawaban D'],
      correctAnswer: 1,
      explanation: 'Pembahasan lama',
    );
    quizQuestions.add(question);
    addTearDown(
      () => quizQuestions.removeWhere((item) => item.id == question.id),
    );
    await QuizQuestionStore().update(
      question,
      existingQuestions: quizQuestions,
    );

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AdminQuizPage())),
    );
    await tester.enterText(
      find.byKey(const ValueKey('quiz-question-search')),
      question.question,
    );
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('edit-quiz-${question.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Edit Soal'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const ValueKey('quiz-question-field')),
          )
          .initialValue,
      question.question,
    );
    await tester.enterText(
      find.byKey(const ValueKey('quiz-question-field')),
      'Pertanyaan sesudah edit',
    );
    await tester.enterText(
      find.byKey(const ValueKey('quiz-option-1')),
      'Jawaban B diperbarui',
    );
    tester.testTextInput.hide();
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('save-quiz-question')));
    await tester.pumpAndSettle();

    expect(quizQuestions.where((item) => item.id == question.id), hasLength(1));
    final edited = quizQuestions.singleWhere((item) => item.id == question.id);
    expect(edited.question, 'Pertanyaan sesudah edit');
    expect(edited.options[1], 'Jawaban B diperbarui');
    expect(edited.correctAnswer, 1);
    expect(find.text('Perubahan soal berhasil disimpan.'), findsOneWidget);
    final stored = await QuizQuestionStore().load();
    expect(stored, hasLength(1));
    expect(stored!.single.id, question.id);
    expect(stored.single.question, 'Pertanyaan sesudah edit');
  });

  testWidgets('admin confirms soft deletion and cancel keeps question active', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final selected = QuizQuestion(
      id: 'admin-delete-question',
      question: 'Soal yang akan dinonaktifkan',
      options: const ['A', 'B', 'C', 'D'],
      correctAnswer: 0,
    );
    final other = QuizQuestion(
      id: 'admin-keep-question',
      question: 'Soal yang tetap aktif',
      options: const ['A', 'B', 'C', 'D'],
      correctAnswer: 0,
    );
    quizQuestions.addAll([selected, other]);
    addTearDown(
      () => quizQuestions.removeWhere(
        (item) => item.id == selected.id || item.id == other.id,
      ),
    );
    final store = QuizQuestionStore();
    await store.update(selected, existingQuestions: quizQuestions);
    await store.update(other, existingQuestions: quizQuestions);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AdminQuizPage())),
    );
    await tester.enterText(
      find.byKey(const ValueKey('quiz-question-search')),
      selected.question,
    );
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('delete-quiz-${selected.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Hapus Soal Kuis?'), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('cancel-delete-quiz-${selected.id}')));
    await tester.pumpAndSettle();
    expect(selected.isActive, isTrue);

    await tester.tap(find.byKey(ValueKey('delete-quiz-${selected.id}')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(ValueKey('confirm-delete-quiz-${selected.id}')),
    );
    await tester.pumpAndSettle();

    expect(
      quizQuestions.singleWhere((item) => item.id == selected.id).isActive,
      isFalse,
    );
    expect(
      quizQuestions.singleWhere((item) => item.id == other.id).isActive,
      isTrue,
    );
    final stored = await store.load();
    expect(stored, hasLength(2));
    expect(
      stored!.singleWhere((item) => item.id == selected.id).isActive,
      isFalse,
    );
    expect(stored.singleWhere((item) => item.id == other.id).isActive, isTrue);
    expect(
      questionsForDifficulty([
        quizQuestions.singleWhere((item) => item.id == selected.id),
      ], selected.difficulty),
      isEmpty,
    );
  });

  testWidgets('theme preference defaults to light and persists live changes', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await appThemeController.load();
    expect(appThemeController.themeMode, ThemeMode.light);

    await tester.pumpWidget(const TechExplorerApp());
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.light,
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(LoginPage))).brightness,
      Brightness.dark,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('tech_explorer_theme'), 'dark');

    await tester.tap(find.text('Registrasi'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(RegisterPage))).brightness,
      Brightness.dark,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    final restoredController = ThemeController();
    await restoredController.load();
    expect(restoredController.themeMode, ThemeMode.dark);
    restoredController.dispose();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(preferences.getString('tech_explorer_theme'), 'light');
    expect(
      Theme.of(tester.element(find.byType(LoginPage))).brightness,
      Brightness.light,
    );
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

    await startQuiz(tester, difficulty: QuizDifficulty.easy);
    final questions = questionsForDifficulty(
      quizQuestions,
      QuizDifficulty.easy,
    );
    expect(find.text('Sisa Waktu'), findsOneWidget);
    expect(find.text('15:00'), findsOneWidget);
    final firstQuestion = questions.first;
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
    expect(find.text(questions[1].question), findsOneWidget);
    expect(find.text('14:59'), findsOneWidget);

    for (var index = 1; index < questions.length; index++) {
      final question = questions[index];
      debugPrint(
        'Quiz question ${question.question}; answer ${question.options[question.correctAnswer]}; matches ${find.text(question.options[question.correctAnswer]).evaluate().length}',
      );
      await tester.ensureVisible(
        find.text(question.options[question.correctAnswer]),
      );
      await tester.tap(find.text(question.options[question.correctAnswer]));
      await tester.pump();
      final nextLabel = index == questions.length - 1
          ? 'Selesai'
          : 'Soal Berikutnya';
      debugPrint(
        'Quiz action label "$nextLabel": ${find.text(nextLabel).evaluate().length} widgets',
      );
      await tester.ensureVisible(find.text(nextLabel));
      await tester.tap(find.text(nextLabel));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    expect(find.byType(QuizResultPage), findsOneWidget);
    expect(
      find.text('${questions.length} benar dari ${questions.length} soal'),
      findsOneWidget,
    );
    expect(find.text('Tingkat: Mudah'), findsOneWidget);
    expect(quizHistory, hasLength(1));
    expect(quizHistory.single['difficulty'], 'easy');
    expect(quizHistory.single['difficultyLabel'], 'Mudah');
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

    await startQuiz(tester, difficulty: QuizDifficulty.easy);
    final questions = questionsForDifficulty(
      quizQuestions,
      QuizDifficulty.easy,
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

    final firstQuestion = questions.first;
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
    expect(find.text('1 benar dari ${questions.length} soal'), findsOneWidget);
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
    await startQuiz(tester);
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
    await tester.pumpWidget(
      MaterialApp(
        home: QuizPage(
          duration: const Duration(seconds: 5),
          clock: () => now,
          onQuizFinished: () => completionCount++,
        ),
      ),
    );
    await startQuiz(tester);
    final questions = questionsForDifficulty(
      quizQuestions,
      QuizDifficulty.easy,
    );
    final firstQuestion = questions.first;
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
    expect(find.text('0 benar dari ${questions.length} soal'), findsOneWidget);
    expect(quizHistory, hasLength(1));
    expect(quizHistory.single['correct'], 0);
    expect(completionCount, 1);
  });

  testWidgets('number navigation preserves answers and timer progress', (
    WidgetTester tester,
  ) async {
    var now = DateTime(2026, 1, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: QuizPage(duration: const Duration(minutes: 15), clock: () => now),
      ),
    );

    await startQuiz(tester, difficulty: QuizDifficulty.medium);
    final questions = questionsForDifficulty(
      quizQuestions,
      QuizDifficulty.medium,
    );
    expect(find.byKey(const ValueKey('question-number-0')), findsOneWidget);
    expect(
      find.byKey(ValueKey('question-number-${questions.length - 1}')),
      findsOneWidget,
    );
    await tester.ensureVisible(
      find.text(questions[0].options[questions[0].correctAnswer]),
    );
    await tester.tap(
      find.text(questions[0].options[questions[0].correctAnswer]),
    );
    await tester.pump();
    now = now.add(const Duration(seconds: 4));
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('14:56'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('question-number-2')));
    await tester.pump();
    expect(find.text(questions[2].question), findsOneWidget);
    expect(find.text('14:56'), findsOneWidget);
    expect(find.text('Terjawab: 1 dari ${questions.length}'), findsOneWidget);

    await tester.ensureVisible(find.text(questions[2].options[0]));
    await tester.tap(find.text(questions[2].options[0]));
    await tester.pump();
    expect(find.text('Terjawab: 2 dari ${questions.length}'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('question-number-0')));
    await tester.pump();
    expect(find.text(questions[0].question), findsOneWidget);
    final savedAnswer = tester.widget<OutlinedButton>(
      find.byKey(ValueKey('answer-0-${questions[0].correctAnswer}')),
    );
    expect(
      savedAnswer.style?.backgroundColor?.resolve({}),
      Theme.of(tester.element(find.byType(QuizPage)))
          .colorScheme
          .primaryContainer,
    );

    await tester.ensureVisible(find.text(questions[0].options[0]));
    await tester.tap(find.text(questions[0].options[0]));
    await tester.pump();
    expect(find.text('Terjawab: 2 dari ${questions.length}'), findsOneWidget);
    final changedAnswer = tester.widget<OutlinedButton>(
      find.byKey(const ValueKey('answer-0-0')),
    );
    expect(
      changedAnswer.style?.backgroundColor?.resolve({}),
      Theme.of(tester.element(find.byType(QuizPage)))
          .colorScheme
          .primaryContainer,
    );

    await tester.ensureVisible(find.text('Soal Berikutnya'));
    await tester.tap(find.text('Soal Berikutnya'));
    await tester.pump();
    expect(find.text(questions[1].question), findsOneWidget);
    await tester.ensureVisible(find.text('Sebelumnya'));
    await tester.tap(find.text('Sebelumnya'));
    await tester.pump();
    expect(find.text(questions[0].question), findsOneWidget);
    expect(find.text('14:56'), findsOneWidget);
    final restoredAnswer = tester.widget<OutlinedButton>(
      find.byKey(const ValueKey('answer-0-0')),
    );
    expect(
      restoredAnswer.style?.backgroundColor?.resolve({}),
      Theme.of(tester.element(find.byType(QuizPage)))
          .colorScheme
          .primaryContainer,
    );
  });

  testWidgets('incomplete quiz asks before submitting', (
    WidgetTester tester,
  ) async {
    quizHistory.clear();
    await tester.pumpWidget(
      const MaterialApp(home: QuizPage(duration: Duration(minutes: 15))),
    );

    await startQuiz(tester, difficulty: QuizDifficulty.easy);
    final questions = questionsForDifficulty(
      quizQuestions,
      QuizDifficulty.easy,
    );
    await tester.tap(
      find.byKey(ValueKey('question-number-${questions.length - 1}')),
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Selesai'));
    await tester.tap(find.text('Selesai'));
    await tester.pump();
    expect(find.text('Masih ada soal belum dijawab'), findsOneWidget);
    expect(quizHistory, isEmpty);

    await tester.tap(find.text('Kembali'));
    await tester.pump();
    expect(find.byType(QuizResultPage), findsNothing);
    expect(quizHistory, isEmpty);

    await tester.ensureVisible(find.text('Selesai'));
    await tester.tap(find.text('Selesai'));
    await tester.pump();
    await tester.tap(find.text('Kumpulkan'));
    await tester.pumpAndSettle();
    expect(find.byType(QuizResultPage), findsOneWidget);
    expect(find.text('0 benar dari ${questions.length} soal'), findsOneWidget);
    expect(quizHistory, hasLength(1));
  });
}
