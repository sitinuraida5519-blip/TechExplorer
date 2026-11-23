import 'dart:async';
import 'dart:convert';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeController appThemeController = ThemeController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appThemeController.load();
  final storedMaterials = await materialCatalogStore.load();
  if (storedMaterials != null) {
    materials
      ..clear()
      ..addAll(storedMaterials);
    final migrated = migrateMaterialCategories(materials);
    if (migrated && !await materialCatalogStore.save(materials)) {
      debugPrint(
        'TechExplorer: failed to persist migrated material categories.',
      );
    }
  }
  final storedCategories = await categoryStore.load();
  if (storedCategories != null) {
    categoryData
      ..clear()
      ..addAll(storedCategories.map(categoryDetails));
  } else if (!await categoryStore.save(categoryData)) {
    debugPrint('TechExplorer: failed to persist default categories.');
  }
  final storedUsers = await userStore.load();
  if (storedUsers != null) {
    users
      ..clear()
      ..addAll(storedUsers);
  } else if (!await userStore.save(users)) {
    debugPrint('TechExplorer: failed to persist default account.');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TechExplorerApp();
  }
}

// ============================================================
// WARNA APLIKASI
// ============================================================

const Color primaryColor = Color(0xFF2878FF);
const Color darkBlue = Color(0xFF0B1530);
const Color backgroundColor = Color(0xFFF3F6FC);
const Color electricBlue = Color(0xFF2878FF);
const Color techCyan = Color(0xFF29D7E8);
const Color techViolet = Color(0xFF8C68F6);

class ThemeController extends ChangeNotifier {
  static const String _preferenceKey = 'tech_explorer_theme';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      _themeMode = preferences.getString(_preferenceKey) == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light;
    } catch (_) {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    final nextMode = isDark ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode == nextMode) return;
    _themeMode = nextMode;
    notifyListeners();
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_preferenceKey, isDark ? 'dark' : 'light');
    } catch (_) {
      // Keep the active theme usable even if preferences are unavailable.
    }
  }
}

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: electricBlue,
        brightness: brightness,
      ).copyWith(
        primary: isDark ? const Color(0xFF72A7FF) : electricBlue,
        onPrimary: isDark ? const Color(0xFF061126) : Colors.white,
        secondary: isDark ? const Color(0xFF54E3ED) : const Color(0xFF008C9E),
        onSecondary: const Color(0xFF04191D),
        tertiary: isDark ? const Color(0xFFB49AFF) : techViolet,
        surface: isDark ? const Color(0xFF121D35) : Colors.white,
        onSurface: isDark ? const Color(0xFFEAF0FF) : const Color(0xFF17223B),
        surfaceTint: Colors.transparent,
      );
  final background = isDark ? const Color(0xFF091225) : backgroundColor;
  final outline = isDark ? const Color(0xFF34435F) : const Color(0xFFDCE4F1);

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    visualDensity: VisualDensity.standard,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    textTheme: ThemeData(brightness: brightness).textTheme.copyWith(
      headlineSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 15,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        height: 1.45,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: isDark ? 2 : 1,
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.2)
          : const Color(0xFF17366A).withValues(alpha: 0.07),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: outline.withValues(alpha: isDark ? 0.65 : 0.8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF17233D) : const Color(0xFFF8FAFE),
      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      prefixIconColor: colorScheme.onSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.secondary, width: 1.7),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.error, width: 1.7),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style:
          FilledButton.styleFrom(
            minimumSize: const Size(48, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ).copyWith(
            animationDuration: const Duration(milliseconds: 140),
            overlayColor: _interactiveOverlay(colorScheme.primary),
          ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            minimumSize: const Size(48, 50),
            backgroundColor: electricBlue,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: electricBlue.withValues(alpha: 0.24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ).copyWith(
            animationDuration: const Duration(milliseconds: 140),
            overlayColor: _interactiveOverlay(Colors.white),
          ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            minimumSize: const Size(44, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: BorderSide(color: outline),
          ).copyWith(
            animationDuration: const Duration(milliseconds: 140),
            overlayColor: _interactiveOverlay(colorScheme.primary),
          ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom().copyWith(
        animationDuration: const Duration(milliseconds: 140),
        overlayColor: _interactiveOverlay(colorScheme.primary),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 140),
        overlayColor: _interactiveOverlay(colorScheme.primary),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: outline),
      selectedColor: colorScheme.primaryContainer,
      secondarySelectedColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(color: colorScheme.onSurface),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      elevation: 12,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      showUnselectedLabels: true,
    ),
    dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
    ),
  );
}

WidgetStateProperty<Color?> _interactiveOverlay(Color color) =>
    WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return color.withValues(alpha: 0.16);
      }
      if (states.contains(WidgetState.hovered)) {
        return color.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return color.withValues(alpha: 0.12);
      }
      return null;
    });

class InteractiveFeedback extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const InteractiveFeedback({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<InteractiveFeedback> createState() => _InteractiveFeedbackState();
}

class _InteractiveFeedbackState extends State<InteractiveFeedback> {
  bool _isPressed = false;
  bool _isHovered = false;
  int? _activePointer;

  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.enabled || event.buttons == 0) return;
    _activePointer = event.pointer;
    setState(() => _isPressed = true);
  }

  void _handlePointerEnd(PointerEvent event) {
    if (_activePointer != event.pointer) return;
    _activePointer = null;
    if (mounted) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 130);
    final scale = !widget.enabled
        ? 1.0
        : _isPressed
        ? 0.97
        : _isHovered
        ? 1.015
        : 1.0;

    return MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _isHovered = false) : null,
      child: Listener(
        onPointerDown: _handlePointerDown,
        onPointerUp: _handlePointerEnd,
        onPointerCancel: _handlePointerEnd,
        child: AnimatedScale(
          scale: scale,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

class AnimatedTechBackground extends StatefulWidget {
  final Widget child;

  const AnimatedTechBackground({super.key, required this.child});

  @override
  State<AnimatedTechBackground> createState() => _AnimatedTechBackgroundState();
}

class _AnimatedTechBackgroundState extends State<AnimatedTechBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..forward();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final phase = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + phase * 0.35, -1),
              end: Alignment(1, 1 - phase * 0.3),
              colors: [
                const Color(0xFF071127),
                Color.lerp(
                  const Color(0xFF102B66),
                  const Color(0xFF25306D),
                  phase,
                )!,
                const Color(0xFF101B3C),
              ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _CircuitPatternPainter(phase)),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _CircuitPatternPainter extends CustomPainter {
  final double phase;

  const _CircuitPatternPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF83DFFF).withValues(alpha: 0.11)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final glowPaint = Paint()
      ..color = const Color(0xFF57CFFF).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final shift = phase * 46;
    final path = Path();

    for (var row = 0; row < 6; row++) {
      final y = size.height * (0.12 + row * 0.16) + shift;
      final startX = size.width * (row.isEven ? 0.58 : 0.72);
      final endX = size.width * (row.isEven ? 1.12 : 0.98);
      path
        ..moveTo(startX, y)
        ..lineTo(startX + 24, y)
        ..lineTo(startX + 24, y + 22)
        ..lineTo(endX, y + 22);
      canvas.drawCircle(Offset(startX + 24, y), 2.2, glowPaint);
    }
    for (var column = 0; column < 5; column++) {
      final x = size.width * (0.08 + column * 0.2) - shift;
      path
        ..moveTo(x, size.height * 0.04)
        ..lineTo(x, size.height * 0.1)
        ..lineTo(x + 26, size.height * 0.1)
        ..lineTo(x + 26, size.height * 0.18);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _CircuitPatternPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

class TechBrandMark extends StatelessWidget {
  final double size;

  const TechBrandMark({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5DA7FF), Color(0xFF37D8E8), Color(0xFF8C68F6)],
        ),
        boxShadow: [
          BoxShadow(
            color: techCyan.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(Icons.memory_rounded, size: size * 0.57, color: Colors.white),
    );
  }
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withValues(alpha: 0.19)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class GradientActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;

  const GradientActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.65,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF3185FF), Color(0xFF25C7E3)],
          ),
          boxShadow: [
            BoxShadow(
              color: electricBlue.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InteractiveFeedback(
            enabled: enabled,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: enabled ? onPressed : null,
              child: SizedBox(
                height: 54,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 21,
                          height: 21,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : DefaultTextStyle.merge(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          child: child,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthScreenShell extends StatelessWidget {
  final Animation<double> animation;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final VoidCallback? onBack;

  const AuthScreenShell({
    super.key,
    required this.animation,
    required this.subtitle,
    required this.child,
    this.footer,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTechBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight > 50
                    ? constraints.maxHeight - 50
                    : 0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 470),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.055),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (onBack != null)
                                IconButton(
                                  onPressed: onBack,
                                  tooltip: 'Kembali',
                                  color: Colors.white,
                                  icon: const Icon(Icons.arrow_back_rounded),
                                )
                              else
                                const SizedBox(width: 48),
                              const Spacer(),
                              const TechBrandMark(size: 70),
                              const Spacer(),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'TechExplorer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          GlassPanel(child: child),
                          if (footer != null) ...[
                            const SizedBox(height: 14),
                            footer!,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _authInputDecoration(String label, IconData icon) =>
    InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.68)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.07),
      prefixIconColor: const Color(0xFF78DFEA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF61DDEB), width: 1.5),
      ),
    );

// ============================================================
// MODEL MATERI
// ============================================================

IconData _materialIconForCodePoint(int codePoint) {
  for (final material in materials) {
    if (material.icon.codePoint == codePoint) return material.icon;
  }
  return Icons.menu_book;
}

class MaterialData {
  final String id;
  String title;
  String category;
  String description;
  String content;
  String importantPoints;
  IconData icon;

  MaterialData({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.content,
    required this.importantPoints,
    required this.icon,
  });

  MaterialData copyWith({
    String? title,
    String? category,
    String? description,
    String? content,
    String? importantPoints,
    IconData? icon,
  }) => MaterialData(
    id: id,
    title: title ?? this.title,
    category: category ?? this.category,
    description: description ?? this.description,
    content: content ?? this.content,
    importantPoints: importantPoints ?? this.importantPoints,
    icon: icon ?? this.icon,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'content': content,
    'importantPoints': importantPoints,
    'iconCodePoint': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
    'iconFontPackage': icon.fontPackage,
    'iconMatchTextDirection': icon.matchTextDirection,
  };

  static MaterialData? fromJson(dynamic value) {
    if (value is! Map) return null;
    final id = value['id'];
    final title = value['title'];
    final category = value['category'];
    final description = value['description'];
    final content = value['content'];
    final importantPoints = value['importantPoints'];
    final iconCodePoint = value['iconCodePoint'];
    if (id is! String ||
        title is! String ||
        category is! String ||
        description is! String ||
        content is! String ||
        importantPoints is! String ||
        iconCodePoint is! int) {
      return null;
    }
    return MaterialData(
      id: id,
      title: title,
      category: category,
      description: description,
      content: content,
      importantPoints: importantPoints,
      icon: _materialIconForCodePoint(iconCodePoint),
    );
  }
}

class MaterialCatalogStore {
  static const String _storageKey = 'tech_explorer_material_catalog_v1';

  Future<List<MaterialData>?> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final rawValue = preferences.getString(_storageKey);
      if (rawValue == null) return null;
      final decoded = jsonDecode(rawValue);
      if (decoded is! List) return null;

      final restored = <MaterialData>[];
      for (final value in decoded) {
        final material = MaterialData.fromJson(value);
        if (material == null) return null;
        restored.add(material);
      }
      return restored;
    } catch (_) {
      return null;
    }
  }

  Future<bool> save(List<MaterialData> catalog) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return await preferences.setString(
        _storageKey,
        jsonEncode(catalog.map((material) => material.toJson()).toList()),
      );
    } catch (_) {
      return false;
    }
  }
}

final MaterialCatalogStore materialCatalogStore = MaterialCatalogStore();

class UserStore {
  static const String _storageKey = 'tech_explorer_accounts_v1';

  Future<List<Map<String, String>>?> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final rawValue = preferences.getString(_storageKey);
      if (rawValue == null) return null;
      final decoded = jsonDecode(rawValue);
      if (decoded is! List) return null;
      final restored = <Map<String, String>>[];
      for (final item in decoded) {
        if (item is! Map ||
            item['name'] is! String ||
            item['email'] is! String ||
            item['password'] is! String ||
            item['class'] is! String) {
          return null;
        }
        restored.add({
          'name': item['name'] as String,
          'email': item['email'] as String,
          'password': item['password'] as String,
          'class': item['class'] as String,
        });
      }
      return restored;
    } catch (_) {
      return null;
    }
  }

  Future<bool> save(List<Map<String, String>> accounts) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.setString(_storageKey, jsonEncode(accounts));
    } catch (_) {
      return false;
    }
  }
}

final UserStore userStore = UserStore();

class MaterialHistoryEntry {
  final String materialId;
  final String title;
  final String category;
  final DateTime lastOpened;

  const MaterialHistoryEntry({
    required this.materialId,
    required this.title,
    required this.category,
    required this.lastOpened,
  });

  Map<String, dynamic> toJson() => {
    'materialId': materialId,
    'title': title,
    'category': category,
    'lastOpened': lastOpened.toIso8601String(),
  };

  static MaterialHistoryEntry? fromJson(dynamic value) {
    if (value is! Map) return null;
    final materialId = value['materialId'];
    final title = value['title'];
    final category = value['category'];
    final timestamp = value['lastOpened'];
    if (materialId is! String ||
        title is! String ||
        category is! String ||
        timestamp is! String) {
      return null;
    }
    final lastOpened = DateTime.tryParse(timestamp);
    if (lastOpened == null) return null;
    return MaterialHistoryEntry(
      materialId: materialId,
      title: title,
      category: category,
      lastOpened: lastOpened,
    );
  }
}

class MaterialHistoryStore extends ChangeNotifier {
  MaterialHistoryStore({required String userEmail})
    : _storageKey = 'recent_materials_${userEmail.trim().toLowerCase()}';

  final String _storageKey;
  final List<MaterialHistoryEntry> _entries = [];
  Future<void>? _loadOperation;
  bool _isLoaded = false;
  bool _storageFailed = false;

  List<MaterialHistoryEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _isLoaded;
  bool get storageFailed => _storageFailed;

  Future<void> load() {
    if (_isLoaded) return Future<void>.value();
    return _loadOperation ??= _load();
  }

  Future<void> _load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final rawValue = preferences.getString(_storageKey);
      if (rawValue != null) {
        final decoded = jsonDecode(rawValue);
        if (decoded is List) {
          final uniqueEntries = <String, MaterialHistoryEntry>{};
          for (final value in decoded) {
            final entry = MaterialHistoryEntry.fromJson(value);
            if (entry != null && !uniqueEntries.containsKey(entry.materialId)) {
              uniqueEntries[entry.materialId] = entry;
            }
          }
          _entries
            ..clear()
            ..addAll(uniqueEntries.values);
          _entries.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
        }
      }
    } catch (_) {
      _storageFailed = true;
      _entries.clear();
    }
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> record(MaterialData material) async {
    if (!_isLoaded) await load();
    final entry = MaterialHistoryEntry(
      materialId: material.id,
      title: material.title,
      category: material.category,
      lastOpened: DateTime.now(),
    );
    _entries.removeWhere((item) => item.materialId == material.id);
    _entries.insert(0, entry);
    await _save();
    notifyListeners();
  }

  Future<void> remove(String materialId) async {
    if (!_isLoaded) await load();
    _entries.removeWhere((entry) => entry.materialId == materialId);
    await _save();
    notifyListeners();
  }

  Future<void> clear() async {
    if (!_isLoaded) await load();
    _entries.clear();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final success = await preferences.setString(
        _storageKey,
        jsonEncode(_entries.map((entry) => entry.toJson()).toList()),
      );
      _storageFailed = !success;
    } catch (_) {
      _storageFailed = true;
    }
  }
}

// ============================================================
class AdminSession {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void authenticate() => _isAuthenticated = true;

  void clear() => _isAuthenticated = false;
}

final AdminSession adminSession = AdminSession();

// ============================================================
// DATA MATERI TECH EXPLORER
// ============================================================

List<MaterialData> materials = [
  MaterialData(
    id: 'computer-basics-introduction',
    title: 'Pengertian Komputer',
    category: 'Pengenalan Komputer',
    description: 'Komputer adalah mesin elektronik yang menerima data, mengolahnya, dan menghasilkan informasi yang berguna bagi manusia.',
    content:
        'Komputer adalah perangkat elektronik yang digunakan untuk menerima data, mengolahnya, menyimpannya, dan menghasilkan informasi. Proses kerja komputer secara umum terdiri dari input, process, output, dan storage.\n\n'
        'Pada tahap input, pengguna memasukkan data melalui keyboard, mouse, scanner, atau perangkat masukan lainnya. Data kemudian diproses oleh processor sesuai instruksi program. Hasil pengolahan ditampilkan pada monitor, speaker, atau dicetak melalui printer. Setelah itu, data dapat disimpan dalam media penyimpanan seperti HDD, SSD, atau flash drive.\n\n'
        'Contoh penggunaan komputer adalah mengetik dokumen, mengolah angka, browsing internet, membuat presentasi, dan mengedit gambar. Manfaat komputer sangat luas, mulai dari pendidikan, pekerjaan, komunikasi, hingga hiburan. Dengan komputer, manusia dapat menyelesaikan pekerjaan lebih cepat, akurat, dan efisien.',
    importantPoints:
        '• Input adalah proses memasukkan data.\n'
        '• Process dilakukan oleh processor.\n'
        '• Output adalah hasil informasi yang ditampilkan.\n'
        '• Storage digunakan untuk menyimpan data.\n'
        '• Komputer membantu pekerjaan, belajar, dan komunikasi.',
    icon: Icons.computer,
  ),

  MaterialData(
    id: 'computer-basics-system',
    title: 'Sistem Komputer',
    category: 'Pengenalan Komputer',
    description: 'Sistem komputer terdiri dari perangkat keras, perangkat lunak, dan pengguna yang saling bekerja sama.',
    content:
        'Sistem komputer merupakan gabungan dari perangkat keras (hardware), perangkat lunak (software), dan pengguna (brainware) yang bekerja bersama untuk menjalankan proses komputasi. Hardware adalah komponen fisik seperti monitor, keyboard, mouse, CPU, dan printer. Software adalah program yang mengendalikan kerja komputer, seperti sistem operasi, Microsoft Word, dan browser. Brainware adalah manusia yang menggunakan komputer untuk menjalankan tugas tertentu.\n\n'
        'Contoh sistem komputer dapat dilihat saat seseorang membuka aplikasi belajar, mengetik tugas, dan menyimpannya ke hard disk. Ketiga komponen ini saling bergantung: hardware menyediakan alat, software memberi perintah, dan brainware mengoperasikan sistem. Manfaat sistem komputer adalah memudahkan manusia dalam mengelola, memproses, dan menyimpan data dengan cepat dan akurat.',
    importantPoints:
        '• Hardware adalah perangkat fisik komputer.\n'
        '• Software adalah program dan aplikasi.\n'
        '• Brainware adalah manusia pengguna komputer.\n'
        '• Ketiga komponen saling berhubungan.\n'
        '• Sistem komputer membantu pekerjaan lebih efisien.',
    icon: Icons.devices,
  ),

  MaterialData(
    id: 'hardware-motherboard',
    title: 'Motherboard',
    category: 'Hardware (Perangkat Keras)',
    description: 'Motherboard adalah papan utama yang menjadi pusat hubungan semua komponen komputer.',
    content:
        'Motherboard atau papan induk adalah komponen utama pada komputer yang menjadi tempat pemasangan processor, RAM, kartu grafis, kartu jaringan, media penyimpanan, dan perangkat lain. Motherboard berfungsi sebagai pusat penghubung dan koordinasi kerja semua komponen agar komputer dapat berjalan dengan baik.\n\n'
        'Pada motherboard terdapat socket processor, slot RAM, slot ekspansi, konektor daya, dan port USB. Semua komponen terhubung melalui jalur elektronik pada motherboard. Contoh perangkat yang terhubung adalah CPU, RAM, SSD, keyboard, mouse, dan monitor.\n\n'
        'Manfaat motherboard sangat besar karena tanpa papan induk, komponen-komponen komputer tidak dapat bekerja secara terkoordinasi. Motherboard memungkinkan data dan sinyal listrik mengalir ke seluruh sistem, sehingga komputer dapat melakukan proses pengolahan dan komunikasi antar bagian.',
    importantPoints:
        '• Motherboard adalah papan utama komputer.\n'
        '• Menghubungkan processor, RAM, dan perangkat lain.\n'
        '• Memiliki slot, port, dan konektor.\n'
        '• Menjadi pusat komunikasi antar komponen.\n'
        '• Tanpa motherboard, sistem komputer tidak dapat berfungsi.',
    icon: Icons.developer_board,
  ),

  MaterialData(
    id: 'hardware-processor',
    title: 'Processor',
    category: 'Hardware (Perangkat Keras)',
    description: 'Processor adalah otak komputer yang menjalankan instruksi dan mengolah data.',
    content:
        'Processor atau CPU (Central Processing Unit) adalah komponen yang bertanggung jawab untuk menjalankan instruksi dan mengolah data. Processor membaca program, memproses perintah, dan menghasilkan hasil yang dibutuhkan pengguna. Dalam setiap komputer, processor menjadi pusat operasi utama.\n\n'
        'Processor memiliki kecepatan yang diukur dalam GHz dan biasanya dilengkapi beberapa core. Semakin tinggi kecepatan dan jumlah core, semakin cepat komputer dapat menjalankan aplikasi. Contoh penerapannya adalah saat membuka browser, memutar video, atau menjalankan game.\n\n'
        'Manfaat processor sangat penting karena ia menentukan kemampuan komputer dalam menjalankan berbagai program. Processor yang kuat membuat tugas seperti editing video, analisis data, dan simulasi komputer dapat berjalan lebih cepat dan lancar.',
    importantPoints:
        '• Processor adalah otak komputer.\n'
        '• Mengolah instruksi dan data.\n'
        '• Kecepatan processor memengaruhi performa komputer.\n'
        '• Memiliki core untuk menjalankan beberapa tugas.\n'
        '• Processor menentukan kemampuan komputer dalam menjalankan aplikasi.',
    icon: Icons.memory,
  ),

  MaterialData(
    id: 'hardware-ram',
    title: 'RAM',
    category: 'Hardware (Perangkat Keras)',
    description: 'RAM adalah memori sementara yang dipakai saat komputer aktif untuk menjalankan program dan data yang sedang dibuka.',
    content:
        'RAM atau Random Access Memory adalah memori yang digunakan untuk menyimpan data dan instruksi sementara ketika komputer sedang aktif. Data di RAM dapat diakses dengan cepat oleh processor saat program sedang berjalan. RAM berfungsi sebagai ruang kerja sementara bagi komputer.\n\n'
        'Saat seseorang membuka browser, Microsoft Word, dan aplikasi musik sekaligus, semua data aktif akan disimpan sementara di RAM. Semakin besar kapasitas RAM, semakin banyak aplikasi yang dapat dijalankan tanpa terasa lambat. Namun, RAM bersifat sementara, sehingga data di dalamnya akan hilang saat komputer dimatikan atau di-restart.\n\n'
        'Manfaat RAM adalah mempercepat akses data dan meningkatkan kemampuan multitasking. Dengan RAM yang cukup besar, user dapat bekerja lebih nyaman dan aplikasi dapat berjalan dengan cepat.',
    importantPoints:
        '• RAM adalah memori sementara.\n'
        '• Dipakai saat komputer aktif.\n'
        '• Menyimpan data program yang sedang dibuka.\n'
        '• Data RAM hilang saat komputer dimatikan.\n'
        '• Kapasitas RAM memengaruhi kecepatan multitasking.',
    icon: Icons.storage,
  ),

  MaterialData(
    id: 'hardware-storage-hdd-ssd',
    title: 'Hard Disk dan SSD',
    category: 'Hardware (Perangkat Keras)',
    description: 'Hard disk dan SSD adalah media penyimpanan utama yang digunakan untuk menyimpan data, aplikasi, dan sistem operasi.',
    content:
        'Hard Disk Drive (HDD) dan Solid State Drive (SSD) adalah perangkat penyimpanan data yang berfungsi menyimpan sistem operasi, aplikasi, file, foto, video, dan dokumen. HDD menggunakan piringan magnetik, sedangkan SSD menggunakan chip flash memory. Kedua perangkat ini memiliki fungsi yang sama, yaitu menyimpan data dalam jangka waktu lama.\n\n'
        'Contohnya, sistem operasi Windows atau Linux biasanya berada dalam SSD atau HDD, sedangkan file tugas sekolah, foto keluarga, dan permainan digital juga tersimpan di sana. SSD umumnya lebih cepat, lebih ringan, dan lebih tahan guncangan dibanding HDD.\n\n'
        'Manfaat media penyimpanan adalah memungkinkan data disimpan secara permanen dan dibuka kembali saat dibutuhkan. Dengan penyimpanan yang baik, komputer dapat menyimpan banyak file dan menjalankan aplikasi tanpa kehilangan data.',
    importantPoints:
        '• HDD menggunakan piringan magnetik.\n'
        '• SSD menggunakan flash memory.\n'
        '• Keduanya menyimpan data jangka panjang.\n'
        '• SSD biasanya lebih cepat dari HDD.\n'
        '• Menyimpan OS, aplikasi, dan file penting.',
    icon: Icons.storage,
  ),

  MaterialData(
    id: 'software-operating-system',
    title: 'Sistem Operasi',
    category: 'Sistem Operasi',
    description: 'Sistem operasi adalah perangkat lunak yang mengelola sumber daya komputer dan menjadi penghubung antara pengguna dan hardware.',
    content:
        'Sistem operasi (Operating System) adalah perangkat lunak yang mengelola sumber daya komputer dan bekerja sebagai penghubung antara pengguna, aplikasi, dan perangkat keras. Fungsi utamanya adalah mengatur penggunaan CPU, RAM, penyimpanan, perangkat input-output, serta menjalankan program.\n\n'
        'Contoh sistem operasi adalah Windows, Linux, dan macOS. Saat pengguna membuka aplikasi seperti browser atau Microsoft Word, sistem operasi mengatur bagaimana aplikasi tersebut berjalan dan menggunakan sumber daya komputer. Sistem operasi juga mengelola file, folder, dan memory, serta menjaga agar komputer bisa berjalan dengan tertib.\n\n'
        'Manfaat sistem operasi adalah membuat komputer mudah digunakan, aman, dan terorganisir. Tanpa sistem operasi, komputer tidak akan bisa menjalankan program dan tugas-tugas sehari-hari menjadi sulit dilakukan.',
    importantPoints:
        '• Sistem operasi mengatur hardware dan software.\n'
        '• Menjadi penghubung user dengan komputer.\n'
        '• Mengelola file, memori, dan proses aplikasi.\n'
        '• Contoh: Windows, Linux, macOS.\n'
        '• Membuat komputer mudah digunakan dan aman.',
    icon: Icons.desktop_windows,
  ),

  MaterialData(
    id: 'software-driver',
    title: 'Driver',
    category: 'Software (Perangkat Lunak)',
    description: 'Driver adalah perangkat lunak yang memungkinkan sistem operasi berkomunikasi dengan perangkat keras tertentu.',
    content:
        'Driver adalah program khusus yang memungkinkan sistem operasi mengenali dan mengendalikan perangkat keras tertentu. Tanpa driver, perangkat seperti printer, kartu grafis, Wi-Fi, dan scanner tidak dapat berfungsi dengan baik. Driver berperan sebagai penerjemah antara hardware dan software.\n\n'
        'Contoh driver adalah driver printer untuk kegiatan cetak, driver kartu grafis untuk menampilkan gambar di monitor, dan driver jaringan untuk menghubungkan komputer ke internet. Jika driver tidak sesuai atau rusak, perangkat mungkin tidak terdeteksi atau tampil error.\n\n'
        'Manfaat driver adalah memastikan perangkat keras bisa berfungsi normal dan kompatibel dengan sistem operasi. Dengan driver yang tepat, user dapat bekerja dengan komputer secara optimal dan stabil.',
    importantPoints:
        '• Driver menghubungkan software dengan hardware.\n'
        '• Membuat hardware bisa dikenali sistem operasi.\n'
        '• Contoh: driver printer, VGA, Wi-Fi.\n'
        '• Driver harus sesuai dengan perangkat.\n'
        '• Tanpa driver, hardware tidak bekerja maksimal.',
    icon: Icons.settings_applications,
  ),

  MaterialData(
    id: 'networking-fundamentals',
    title: 'Jaringan Komputer',
    category: 'Dasar Jaringan Komputer',
    description: 'Jaringan komputer adalah hubungan antara beberapa perangkat yang memungkinkan komunikasi dan berbagi sumber daya.',
    content:
        'Jaringan komputer adalah kumpulan perangkat yang saling terhubung agar dapat bertukar data dan berbagi sumber daya. Perangkat yang terhubung bisa berupa komputer, laptop, printer, server, dan smartphone. Jaringan dapat dibuat dengan kabel maupun tanpa kabel.\n\n'
        'Contoh jaringan komputer adalah Wi-Fi di rumah, jaringan komputer di sekolah, dan internet yang menghubungkan seluruh dunia. Dalam jaringan, data dikirim dalam bentuk paket dan diterima oleh perangkat tujuan.\n\n'
        'Manfaat jaringan komputer adalah memudahkan komunikasi, berbagi file, menggunakan printer bersama, dan mengakses internet. Jaringan juga membantu kerja tim karena data dapat dibagikan secara cepat dan mudah.',
    importantPoints:
        '• Jaringan menghubungkan beberapa perangkat.\n'
        '• Memungkinkan pertukaran data.\n'
        '• Bisa menggunakan kabel atau nirkabel.\n'
        '• Mempermudah berbagi sumber daya.\n'
        '• Jaringan memungkinkan internet dan komunikasi.',
    icon: Icons.lan,
  ),

  MaterialData(
    id: 'networking-lan-man-wan',
    title: 'LAN, MAN, dan WAN',
    category: 'Dasar Jaringan Komputer',
    description: 'Jenis jaringan dibedakan berdasarkan jangkauan wilayahnya: LAN, MAN, dan WAN.',
    content:
        'LAN (Local Area Network) adalah jaringan yang mencakup wilayah kecil seperti rumah, kantor, atau laboratorium komputer. Jaringan ini biasanya menghubungkan beberapa komputer yang berdekatan.\n\n'
        'MAN (Metropolitan Area Network) memiliki cakupan yang lebih luas, biasanya mencakup kota atau kampus besar. WAN (Wide Area Network) adalah jaringan dengan cakupan yang sangat luas, bahkan bisa menghubungkan antar negara. Contoh WAN adalah internet.\n\n'
        'Contoh LAN adalah jaringan komputer di sekolah, contoh MAN adalah jaringan antara gedung di satu kota, dan contoh WAN adalah internet global. Manfaat memahami jenis-jenis jaringan adalah untuk menentukan desain yang sesuai dengan kebutuhan pengguna serta memudahkan pengelolaan jaringan.',
    importantPoints:
        '• LAN: cakupan kecil seperti rumah atau sekolah.\n'
        '• MAN: cakupan kota atau kampus.\n'
        '• WAN: cakupan luas seperti internet.\n'
        '• Perbedaannya berdasarkan luas wilayah.\n'
        '• Jenis jaringan dipilih sesuai kebutuhan.',
    icon: Icons.account_tree,
  ),

  MaterialData(
    id: 'networking-ip-address',
    title: 'IP Address',
    category: 'Istilah-Istilah Komputer',
    description: 'IP Address adalah alamat unik yang digunakan untuk mengidentifikasi perangkat dalam jaringan.',
    content:
        'IP Address atau alamat IP adalah identitas numerik yang diberikan kepada perangkat agar dapat dikenal dalam jaringan. Setiap komputer, smartphone, router, atau server mempunyai IP untuk memastikan data dikirim ke perangkat yang benar.\n\n'
        'Pada IPv4, alamat IP ditulis dalam empat blok angka desimal seperti 192.168.1.10. IP Address dapat diberikan secara manual atau otomatis menggunakan DHCP. Selain IP, jaringan juga memerlukan subnet mask, gateway, dan DNS agar komunikasi berjalan dengan baik.\n\n'
        'Contoh penggunaan IP Address adalah laptop yang mendapat alamat 192.168.0.5 agar dapat terhubung ke router dan internet. Manfaat utama IP Address adalah memastikan data sampai ke tujuan yang tepat dalam jaringan besar seperti internet.',
    importantPoints:
        '• IP Address adalah identitas perangkat dalam jaringan.\n'
        '• IPv4 bentuknya seperti 192.168.1.10.\n'
        '• Dapat diatur manual atau otomatis.\n'
        '• Digunakan agar data sampai ke perangkat tujuan.\n'
        '• Memungkinkan komunikasi antar perangkat di jaringan.',
    icon: Icons.language,
  ),

  MaterialData(
    id: 'networking-topologies',
    title: 'Topologi Jaringan',
    category: 'Dasar Jaringan Komputer',
    description: 'Topologi jaringan menggambarkan bentuk hubungan antarperangkat dalam suatu jaringan.',
    content:
        'Topologi jaringan adalah pola atau bentuk hubungan antarperangkat dalam sebuah jaringan komputer. Topologi menjelaskan bagaimana komputer, switch, router, dan perangkat lain terhubung satu sama lain.\n\n'
        'Beberapa topologi yang umum adalah bus, star, ring, mesh, dan tree. Topologi star sering digunakan di sekolah dan kantor karena semua perangkat terhubung ke satu titik pusat seperti switch. Topologi bus menggunakan jalur utama, sedangkan mesh memiliki banyak jalur koneksi antar perangkat.\n\n'
        'Manfaat mempelajari topologi jaringan adalah memahami cara kerja jaringan, menentukan desain yang tepat, dan memperbaiki masalah saat gangguan terjadi. Dengan topologi yang tepat, jaringan dapat lebih stabil, mudah dikelola, dan efisien.',
    importantPoints:
        '• Topologi menunjukkan pola hubungan perangkat.\n'
        '• Star menggunakan perangkat pusat.\n'
        '• Bus menggunakan jalur utama bersama.\n'
        '• Setiap topologi memiliki kelebihan dan kekurangan.\n'
        '• Topologi penting untuk desain jaringan yang baik.',
    icon: Icons.hub,
  ),

  MaterialData(
    id: 'network-device-router',
    title: 'Router',
    category: 'Perangkat Jaringan',
    description: 'Router adalah perangkat yang menghubungkan jaringan yang berbeda dan meneruskan data ke tujuan yang tepat.',
    content:
        'Router adalah perangkat jaringan yang berfungsi menghubungkan beberapa jaringan menjadi satu sistem. Router bekerja dengan meneruskan paket data berdasarkan alamat tujuan agar data sampai ke jaringan yang benar.\n\n'
        'Router sering digunakan untuk menghubungkan jaringan lokal dengan internet. Dalam rumah atau sekolah, router memungkinkan komputer, laptop, dan smartphone terhubung ke internet dan berbagi koneksi. Router juga dapat memilih jalur terbaik agar data dikirim dengan cepat dan efisien.\n\n'
        'Contoh penerapannya adalah router Wi-Fi rumah yang menghubungkan perangkat ke internet. Manfaat router adalah memungkinkan banyak perangkat terhubung sekaligus, bekerja dalam jaringan lokal, dan melakukan akses internet dengan satu sambungan utama.',
    importantPoints:
        '• Router menghubungkan jaringan yang berbeda.\n'
        '• Meneruskan paket data berdasarkan tujuan.\n'
        '• Sering dipakai untuk akses internet.\n'
        '• Menetapkan jalur terbaik untuk data.\n'
        '• Menghubungkan LAN dengan internet.',
    icon: Icons.router,
  ),

  MaterialData(
    id: 'network-device-switch',
    title: 'Switch',
    category: 'Perangkat Jaringan',
    description: 'Switch adalah perangkat jaringan yang menghubungkan banyak perangkat dalam satu jaringan lokal secara lebih efisien.',
    content:
        'Switch adalah perangkat jaringan yang berfungsi menghubungkan beberapa perangkat dalam satu jaringan lokal, seperti komputer, printer, server, dan laptop. Switch bekerja dengan meneruskan data berdasarkan alamat MAC, sehingga pengiriman data lebih cepat dan lebih tepat sasaran.\n\n'
        'Dalam jaringan LAN, switch sangat penting karena memungkinkan perangkat untuk bertukar informasi dengan lancar dalam area yang sama. Switch biasanya memiliki beberapa port sehingga banyak perangkat dapat terhubung sekaligus.\n\n'
        'Contoh penggunaannya adalah di laboratorium komputer sekolah, dimana semua komputer terhubung ke switch. Manfaat switch adalah membuat komunikasi antar perangkat dalam jaringan lokal menjadi lebih efektif, stabil, dan cepat dibandingkan hanya menggunakan hub.',
    importantPoints:
        '• Switch menghubungkan perangkat dalam LAN.\n'
        '• Meneruskan data berdasarkan alamat MAC.\n'
        '• Memiliki banyak port.\n'
        '• Digunakan dalam satu jaringan lokal.\n'
        '• Meningkatkan efisiensi komunikasi jaringan.',
    icon: Icons.swap_horiz,
  ),

  MaterialData(
    id: 'network-device-access-point',
    title: 'Access Point',
    category: 'Perangkat Jaringan',
    description: 'Access Point adalah perangkat yang menyediakan koneksi nirkabel agar perangkat dapat terhubung ke jaringan Wi-Fi.',
    content:
        'Access Point (AP) adalah perangkat jaringan yang menyediakan akses nirkabel menggunakan teknologi Wi-Fi. AP biasanya terhubung ke router atau switch melalui kabel, lalu menyebarkan sinyal Wi-Fi ke perangkat seperti laptop, smartphone, dan tablet.\n\n'
        'Contoh penggunaannya dapat ditemukan di sekolah, kantor, cafe, rumah, dan area publik. Banyak perangkat dapat terhubung ke jaringan tanpa perlu kabel. AP membantu mobilitas pengguna karena mereka bisa bergerak di area jangkauan Wi-Fi sambil tetap terhubung ke jaringan.\n\n'
        'Manfaat Access Point adalah memudahkan akses internet secara nirkabel, meningkatkan kenyamanan pengguna, dan memungkinkan banyak perangkat terhubung ke jaringan dengan cepat dan praktis.',
    importantPoints:
        '• Access Point menyediakan koneksi Wi-Fi.\n'
        '• Menghubungkan perangkat wireless ke jaringan.\n'
        '• Biasanya terhubung ke router atau switch.\n'
        '• Memudahkan akses internet secara nirkabel.\n'
        '• Digunakan di sekolah, kantor, dan rumah.',
    icon: Icons.wifi,
  ),

  MaterialData(
    id: 'troubleshooting-network',
    title: 'Troubleshooting Jaringan',
    category: 'Dasar Jaringan Komputer',
    description: 'Troubleshooting jaringan adalah proses mencari dan memperbaiki gangguan agar jaringan kembali berfungsi normal.',
    content:
        'Troubleshooting jaringan merupakan langkah sistematis untuk menemukan penyebab gangguan pada jaringan komputer lalu memperbaikinya. Gangguan bisa terjadi karena kabel putus, IP tidak sesuai, router rusak, atau sinyal Wi-Fi lemah. Proses ini penting agar jaringan dapat kembali berfungsi seperti semula.\n\n'
        'Langkah umum troubleshooting adalah memeriksa kabel dan port, mengecek status perangkat, menguji koneksi menggunakan ping, memeriksa konfigurasi IP Address, gateway, dan DNS, serta melihat apakah router atau switch berfungsi dengan baik. Contohnya, saat internet tidak bisa diakses, teknisi akan mengecek apakah modem atau router hidup, apakah kabel LAN terhubung, dan apakah perangkat menerima IP yang benar.\n\n'
        'Manfaat troubleshooting adalah menjaga jaringan tetap stabil, mengurangi gangguan, dan memastikan layanan seperti internet, komunikasi, dan berbagi file dapat terus digunakan tanpa hambatan.',
    importantPoints:
        '• Troubleshooting adalah proses mencari penyebab gangguan.\n'
        '• Cek kabel, perangkat, dan konfigurasi jaringan.\n'
        '• Gunakan ping untuk menguji koneksi.\n'
        '• Periksa IP, gateway, dan DNS.\n'
        '• Tujuannya adalah jaringan kembali normal dan stabil.',
    icon: Icons.build,
  ),
  MaterialData(
    id: 'input-keyboard-mouse',
    title: 'Keyboard dan Mouse',
    category: 'Perangkat Input dan Output',
    description: 'Keyboard dan mouse merupakan perangkat input untuk memasukkan perintah serta mengendalikan pointer pada komputer.',
    content:
        'Perangkat input digunakan untuk memasukkan data atau perintah ke komputer. Keyboard membantu pengguna mengetik teks, angka, dan kombinasi tombol. Mouse digunakan untuk menggerakkan pointer, memilih objek, membuka menu, serta menjalankan perintah dengan klik.\n\n'
        'Perangkat ini dapat terhubung melalui kabel USB atau secara nirkabel. Contoh penggunaannya adalah mengetik tugas sekolah dengan keyboard dan memilih file menggunakan mouse.',
    importantPoints:
        '• Keyboard memasukkan teks, angka, dan perintah.\n'
        '• Mouse mengendalikan pointer dan memilih objek.\n'
        '• Keduanya termasuk perangkat input.',
    icon: Icons.keyboard,
  ),
  MaterialData(
    id: 'output-monitor-printer',
    title: 'Monitor dan Printer',
    category: 'Perangkat Input dan Output',
    description: 'Monitor dan printer menyajikan hasil pengolahan komputer dalam bentuk visual dan cetakan.',
    content:
        'Perangkat output menampilkan hasil pengolahan data komputer kepada pengguna. Monitor menampilkan teks, gambar, dan video pada layar. Printer menghasilkan salinan fisik dokumen atau gambar ke media kertas.\n\n'
        'Kualitas monitor dapat dilihat dari ukuran, resolusi, dan jenis panel. Printer dapat menggunakan teknologi inkjet atau laser, bergantung pada kebutuhan pencetakan.',
    importantPoints:
        '• Monitor menampilkan keluaran secara visual.\n'
        '• Printer mencetak dokumen ke kertas.\n'
        '• Keduanya termasuk perangkat output.',
    icon: Icons.print,
  ),
  MaterialData(
    id: 'software-application',
    title: 'Aplikasi Komputer',
    category: 'Software (Perangkat Lunak)',
    description: 'Aplikasi adalah perangkat lunak yang membantu pengguna menyelesaikan tugas tertentu.',
    content:
        'Aplikasi komputer merupakan program yang dibuat untuk menjalankan pekerjaan tertentu. Contohnya aplikasi pengolah kata untuk membuat dokumen, spreadsheet untuk mengolah angka, browser untuk membuka halaman web, dan aplikasi presentasi untuk menyusun bahan paparan.\n\n'
        'Aplikasi berjalan dengan dukungan sistem operasi. Pengguna sebaiknya memilih aplikasi sesuai kebutuhan, memasangnya dari sumber tepercaya, dan memperbaruinya secara berkala.',
    importantPoints:
        '• Aplikasi membantu tugas tertentu.\n'
        '• Contohnya pengolah kata, browser, dan spreadsheet.\n'
        '• Aplikasi berjalan di atas sistem operasi.',
    icon: Icons.apps,
  ),
  MaterialData(
    id: 'computer-terminology-data-information',
    title: 'Data dan Informasi',
    category: 'Istilah-Istilah Komputer',
    description: 'Data adalah fakta yang belum diolah, sedangkan informasi merupakan hasil pengolahan data yang bermakna.',
    content:
        'Data dapat berupa angka, teks, gambar, atau suara yang dimasukkan ke komputer. Setelah data diproses dan disusun sesuai tujuan, hasilnya menjadi informasi yang dapat dipahami dan digunakan.\n\n'
        'Sebagai contoh, daftar nilai siswa merupakan data. Rata-rata nilai yang dihitung dari daftar tersebut menjadi informasi untuk membantu memahami hasil belajar.',
    importantPoints:
        '• Data merupakan bahan yang diolah komputer.\n'
        '• Informasi adalah hasil pengolahan data.\n'
        '• Informasi membantu pengguna mengambil keputusan.',
    icon: Icons.data_object,
  ),
];

bool migrateMaterialCategories(List<MaterialData> catalog) {
  var changed = false;
  for (final material in catalog) {
    final category = switch (material.category) {
      'Computer Basics' => 'Pengenalan Komputer',
      'Hardware' => 'Hardware (Perangkat Keras)',
      'Software' =>
        material.title == 'Sistem Operasi'
            ? 'Sistem Operasi'
            : 'Software (Perangkat Lunak)',
      'Networking' =>
        material.title == 'IP Address'
            ? 'Istilah-Istilah Komputer'
            : 'Dasar Jaringan Komputer',
      'Network Devices' => 'Perangkat Jaringan',
      'Troubleshooting' => 'Dasar Jaringan Komputer',
      _ => material.category,
    };
    if (category != material.category) {
      material.category = category;
      changed = true;
    }
  }
  return changed;
}

// ============================================================
// DATA USER
// ============================================================

List<Map<String, String>> users = [
  {
    'name': 'Siswa TKJ',
    'email': 'siswa@gmail.com',
    'password': '123456',
    'class': 'X TKJ 1',
  },
];

// ============================================================
// APP
// ============================================================

class TechExplorerApp extends StatelessWidget {
  const TechExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appThemeController,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TechExplorer',
        theme: buildAppTheme(Brightness.light),
        darkTheme: buildAppTheme(Brightness.dark),
        themeMode: appThemeController.themeMode,
        home: const SplashScreen(),
      ),
    );
  }
}

class ThemeModeTile extends StatelessWidget {
  final Color? textColor;
  final Color? secondaryTextColor;

  const ThemeModeTile({super.key, this.textColor, this.secondaryTextColor});

  @override
  Widget build(BuildContext context) {
    final isDark = appThemeController.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      secondary: Icon(
        isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        color: colorScheme.primary,
      ),
      title: Text(
        isDark ? 'Mode Gelap' : 'Mode Terang',
        style: textColor == null ? null : TextStyle(color: textColor),
      ),
      subtitle: Text(
        'Beralih ke ${isDark ? 'Mode Terang' : 'Mode Gelap'}',
        style: secondaryTextColor == null
            ? null
            : TextStyle(color: secondaryTextColor),
      ),
      value: isDark,
      onChanged: appThemeController.setDarkMode,
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedTechBackground(
        child: Center(
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _entryController,
              curve: Curves.easeOut,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.88, end: 1).animate(
                CurvedAnimation(
                  parent: _entryController,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TechBrandMark(size: 104),
                  const SizedBox(height: 27),
                  const Text(
                    'TechExplorer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belajar Teknik Komputer dan Jaringan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.74),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: 94,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        minHeight: 4,
                        backgroundColor: Color(0x3356D7EB),
                        color: Color(0xFF59DCEA),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN PAGE
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool _isLoggingIn = false;
  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..forward();

  Future<void> login() async {
    if (_isLoggingIn) return;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Email dan password harus diisi.');
      return;
    }

    setState(() => _isLoggingIn = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;

    if (email == 'admin@gmail.com' && password == 'admin123') {
      adminSession.authenticate();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );

      return;
    }

    adminSession.clear();
    final user = users.where(
      (user) => user['email'] == email && user['password'] == password,
    );

    if (user.isNotEmpty) {
      final className = user.first['class']?.trim().toUpperCase() ?? '';
      if (!className.startsWith('X ') ||
          !(className.contains('TKJ') || className.contains('TJKT'))) {
        setState(() => _isLoggingIn = false);
        showMessage('Login hanya tersedia untuk siswa kelas X TKJ/TJKT.');
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            userName: user.first['name']!,
            userEmail: user.first['email']!,
            userClass: user.first['class']!,
          ),
        ),
      );
    } else {
      setState(() => _isLoggingIn = false);
      showMessage('Email atau password salah.');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenShell(
        animation: _entryController,
        subtitle: 'Kamus digital dasar komputer untuk kelas X TKJ/TJKT',
        footer: Column(
          children: [
            ThemeModeTile(
              textColor: Colors.white,
              secondaryTextColor: Colors.white70,
            ),
            const SizedBox(height: 4),
            Text(
              'Siswa: siswa@gmail.com / 123456   ·   Admin: admin@gmail.com / admin123',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 10,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selamat Datang',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Masuk untuk mulai belajar bersama TechExplorer.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),
            TextField(
              key: const ValueKey('login-email-field'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: _authInputDecoration(
                'Email',
                Icons.alternate_email_rounded,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              key: const ValueKey('login-password-field'),
              controller: passwordController,
              obscureText: obscurePassword,
              style: const TextStyle(color: Colors.white),
              decoration:
                  _authInputDecoration(
                    'Password',
                    Icons.lock_outline_rounded,
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: _isLoggingIn
                          ? null
                          : () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                      color: Colors.white70,
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            GradientActionButton(
              key: const ValueKey('login-button'),
              onPressed: _isLoggingIn ? null : login,
              isLoading: _isLoggingIn,
              child: const Text('Login'),
            ),
            const SizedBox(height: 8),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Belum memiliki akun?',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 13,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoggingIn
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6DE5F0),
                    ),
                    child: const Text('Registrasi'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REGISTER
// ============================================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final classController = TextEditingController();
  final passwordController = TextEditingController();
  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  )..forward();

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final className = classController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        className.isEmpty ||
        password.isEmpty) {
      showMessage('Semua data harus diisi.');
      return;
    }
    final normalizedClass = className.toUpperCase();
    if (!normalizedClass.startsWith('X ') ||
        !(normalizedClass.contains('TKJ') ||
            normalizedClass.contains('TJKT'))) {
      showMessage('Pendaftaran hanya untuk siswa kelas X TKJ/TJKT.');
      return;
    }

    final emailExists = users.any((user) => user['email'] == email);

    if (emailExists) {
      showMessage('Email sudah terdaftar.');
      return;
    }

    final account = {
      'name': name,
      'email': email,
      'password': password,
      'class': className,
    };
    if (!await userStore.save([...users, account])) {
      showMessage('Akun gagal disimpan. Periksa penyimpanan lalu coba lagi.');
      return;
    }
    users.add(account);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrasi Berhasil'),
        content: const Text(
          'Akun berhasil dibuat. Silakan login menggunakan akun tersebut.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    classController.dispose();
    passwordController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registrasi'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: AuthScreenShell(
        animation: _entryController,
        subtitle: 'Satu akun untuk mulai menjelajahi teknologi.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Buat Akun',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _authInputDecoration(
                'Nama Lengkap',
                Icons.person_outline_rounded,
              ),
            ),
            const SizedBox(height: 13),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: _authInputDecoration(
                'Email',
                Icons.alternate_email_rounded,
              ),
            ),
            const SizedBox(height: 13),
            TextField(
              controller: classController,
              decoration: _authInputDecoration(
                'Kelas (contoh: X TKJ 1)',
                Icons.school_outlined,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 13),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _authInputDecoration(
                'Password',
                Icons.lock_outline_rounded,
              ),
            ),
            const SizedBox(height: 22),
            GradientActionButton(
              key: const ValueKey('register-button'),
              onPressed: register,
              child: const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userClass;

  const HomePage({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userClass = 'X TKJ/TJKT',
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  late final MaterialHistoryStore _historyStore;

  Set<String> bookmarks = {};

  @override
  void initState() {
    super.initState();
    _historyStore = MaterialHistoryStore(userEmail: widget.userEmail);
    _historyStore.load();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final stored = preferences.getStringList(_bookmarkStorageKey);
      if (!mounted) return;
      setState(() {
        bookmarks = (stored ?? <String>[]).map((value) {
          return materials
                  .where(
                    (material) =>
                        material.id == value || material.title == value,
                  )
                  .firstOrNull
                  ?.id ??
              value;
        }).toSet();
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bookmark gagal dimuat: $error')));
    }
  }

  String get _bookmarkStorageKey =>
      'tech_explorer_bookmarks_${widget.userEmail.trim().toLowerCase()}';

  Future<void> _bookmarksChanged() async {
    setState(() {});
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setStringList(
        _bookmarkStorageKey,
        bookmarks.toList(),
      );
      if (!saved && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark gagal disimpan.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bookmark gagal disimpan: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _historyStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHome(),
      LearnPage(
        bookmarks: bookmarks,
        historyStore: _historyStore,
        onBookmarkChanged: _bookmarksChanged,
      ),
      BookmarkPage(
        bookmarks: bookmarks,
        historyStore: _historyStore,
        onBookmarkChanged: _bookmarksChanged,
      ),
      ProfilePage(
        userName: widget.userName,
        email: widget.userEmail,
        studentClass: widget.userClass,
        historyStore: _historyStore,
        bookmarks: bookmarks,
        onBookmarkChanged: _bookmarksChanged,
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.015, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: pages[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Materi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KAMUS DIGITAL KOMPUTER',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Halo, ${widget.userName}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Materi dasar komputer untuk kelas X TKJ/TJKT',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const TechBrandMark(size: 48),
              ],
            ),

            const SizedBox(height: 25),

            InteractiveFeedback(
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchPage(
                        bookmarks: bookmarks,
                        historyStore: _historyStore,
                        onBookmarkChanged: _bookmarksChanged,
                      ),
                    ),
                  );
                },
                decoration: inputDecoration('Cari materi...', Icons.search),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF123B83),
                    Color(0xFF2878FF),
                    Color(0xFF16AFC7),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: electricBlue.withValues(alpha: 0.2),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kamus Digital Komputer',
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Belajar istilah dan materi komputer dasar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 1,
                      minHeight: 8,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Kategori Materi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (_, index) {
                final category = categoryData[index];

                return InteractiveFeedback(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryPage(
                            category: category['name'] as String,
                            bookmarks: bookmarks,
                            historyStore: _historyStore,
                            onBookmarkChanged: _bookmarksChanged,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            (category['accent'] as Color).withValues(
                              alpha:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? 0.16
                                  : 0.07,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(
                          color: (category['accent'] as Color).withValues(
                            alpha: 0.22,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (category['accent'] as Color).withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: (category['accent'] as Color).withValues(
                                alpha: 0.13,
                              ),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: Icon(
                              category['icon'] as IconData,
                              size: 29,
                              color: category['accent'] as Color,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            category['name'] as String,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Materi Terbaru',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...materials.take(3).map((material) {
              return InteractiveFeedback(
                child: Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      child: Icon(
                        material.icon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(material.title),
                    subtitle: Text(material.category),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MaterialDetailPage(
                            material: material,
                            bookmarks: bookmarks,
                            historyStore: _historyStore,
                            onBookmarkChanged: _bookmarksChanged,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            AnimatedBuilder(
              animation: _historyStore,
              builder: (context, _) {
                final recentEntries = _historyStore.entries.take(5).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Terakhir Dipelajari',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MaterialHistoryPage(
                                  historyStore: _historyStore,
                                  bookmarks: bookmarks,
                                  onBookmarkChanged: _bookmarksChanged,
                                ),
                              ),
                            );
                          },
                          child: const Text('Lihat semua'),
                        ),
                      ],
                    ),
                    if (recentEntries.isEmpty)
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.history,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text('Belum ada materi yang dipelajari'),
                        ),
                      )
                    else
                      ...recentEntries.map((entry) {
                        final material = findMaterialById(entry.materialId);
                        return InteractiveFeedback(
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Icon(
                                  material?.icon ?? Icons.menu_book,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(entry.title),
                              subtitle: Text(
                                '${entry.category} · ${formatHistoryTime(entry.lastOpened)}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => openHistoryEntry(
                                context,
                                entry,
                                historyStore: _historyStore,
                                bookmarks: bookmarks,
                                onBookmarkChanged: _bookmarksChanged,
                              ),
                            ),
                          ),
                        );
                      }),
                    if (_historyStore.storageFailed)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Riwayat belum dapat disimpan di perangkat.',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DATA KATEGORI
// ============================================================

Map<String, dynamic> categoryDetails(String name) {
  final details = switch (name) {
    'Pengenalan Komputer' => (Icons.computer, const Color(0xFF3785F5)),
    'Hardware (Perangkat Keras)' => (Icons.memory, const Color(0xFF15AFC0)),
    'Software (Perangkat Lunak)' => (Icons.apps, const Color(0xFF8C68F6)),
    'Sistem Operasi' => (Icons.settings_suggest, const Color(0xFF16A3A8)),
    'Perangkat Input dan Output' => (
      Icons.keyboard_alt_outlined,
      const Color(0xFF4D75DE),
    ),
    'Dasar Jaringan Komputer' => (Icons.wifi, const Color(0xFF16A3A8)),
    'Perangkat Jaringan' => (Icons.router, const Color(0xFF4D75DE)),
    'Istilah-Istilah Komputer' => (Icons.terminal, const Color(0xFF8C68F6)),
    _ => (Icons.folder_outlined, const Color(0xFF3785F5)),
  };
  return {'name': name, 'icon': details.$1, 'accent': details.$2};
}

final List<Map<String, dynamic>> categoryData = [
  categoryDetails('Pengenalan Komputer'),
  categoryDetails('Hardware (Perangkat Keras)'),
  categoryDetails('Software (Perangkat Lunak)'),
  categoryDetails('Sistem Operasi'),
  categoryDetails('Perangkat Input dan Output'),
  categoryDetails('Dasar Jaringan Komputer'),
  categoryDetails('Perangkat Jaringan'),
  categoryDetails('Istilah-Istilah Komputer'),
];

class CategoryStore {
  static const String _storageKey = 'tech_explorer_categories_v1';

  Future<List<String>?> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final rawValue = preferences.getString(_storageKey);
      if (rawValue == null) return null;
      final decoded = jsonDecode(rawValue);
      if (decoded is! List || !decoded.every((item) => item is String)) {
        return null;
      }
      return decoded.cast<String>();
    } catch (_) {
      return null;
    }
  }

  Future<bool> save(Iterable<Map<String, dynamic>> categories) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.setString(
        _storageKey,
        jsonEncode(categories.map((item) => item['name']).toList()),
      );
    } catch (_) {
      return false;
    }
  }
}

final CategoryStore categoryStore = CategoryStore();

// ============================================================
// LEARN PAGE
// ============================================================

class LearnPage extends StatefulWidget {
  final Set<String> bookmarks;
  final MaterialHistoryStore historyStore;
  final VoidCallback onBookmarkChanged;

  const LearnPage({
    super.key,
    required this.bookmarks,
    required this.historyStore,
    required this.onBookmarkChanged,
  });

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = materials.where((material) {
      final query = search.toLowerCase();
      return material.title.toLowerCase().contains(query) ||
          material.category.toLowerCase().contains(query) ||
          material.description.toLowerCase().contains(query) ||
          material.content.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: Text(
              'Materi Pembelajaran',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Jelajahi istilah dan materi komputer dasar.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: inputDecoration('Cari materi...', Icons.search),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Materi tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final material = filtered[index];

                      final saved = widget.bookmarks.contains(material.id);

                      return InteractiveFeedback(
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                material.icon,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              material.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(material.category),
                            trailing: IconButton(
                              icon: Icon(
                                saved ? Icons.bookmark : Icons.bookmark_border,
                                color: saved
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                              ),
                              onPressed: () {
                                if (saved) {
                                  widget.bookmarks.remove(material.id);
                                } else {
                                  widget.bookmarks.add(material.id);
                                }

                                widget.onBookmarkChanged();

                                setState(() {});
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MaterialDetailPage(
                                    material: material,
                                    bookmarks: widget.bookmarks,
                                    historyStore: widget.historyStore,
                                    onBookmarkChanged: widget.onBookmarkChanged,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SEARCH PAGE
// ============================================================

class SearchPage extends StatefulWidget {
  final Set<String> bookmarks;
  final MaterialHistoryStore historyStore;
  final VoidCallback onBookmarkChanged;

  const SearchPage({
    super.key,
    required this.bookmarks,
    required this.historyStore,
    required this.onBookmarkChanged,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final result = materials.where((material) {
      final query = search.toLowerCase();
      return material.title.toLowerCase().contains(query) ||
          material.category.toLowerCase().contains(query) ||
          material.description.toLowerCase().contains(query) ||
          material.content.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Materi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
              decoration: inputDecoration(
                'Cari istilah atau materi...',
                Icons.search,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (_, index) {
                final material = result[index];

                return InteractiveFeedback(
                  child: ListTile(
                    leading: Icon(
                      material.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(material.title),
                    subtitle: Text(material.category),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MaterialDetailPage(
                            material: material,
                            bookmarks: widget.bookmarks,
                            historyStore: widget.historyStore,
                            onBookmarkChanged: widget.onBookmarkChanged,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CATEGORY PAGE
// ============================================================

class CategoryPage extends StatelessWidget {
  final String category;
  final Set<String> bookmarks;
  final MaterialHistoryStore historyStore;
  final VoidCallback onBookmarkChanged;

  const CategoryPage({
    super.key,
    required this.category,
    required this.bookmarks,
    required this.historyStore,
    required this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = materials
        .where((material) => material.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: filtered.isEmpty
          ? const Center(child: Text('Belum ada materi.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filtered.length,
              itemBuilder: (_, index) {
                final material = filtered[index];

                return InteractiveFeedback(
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                        child: Icon(
                          material.icon,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        material.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(material.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MaterialDetailPage(
                              material: material,
                              bookmarks: bookmarks,
                              historyStore: historyStore,
                              onBookmarkChanged: onBookmarkChanged,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ============================================================
// DETAIL MATERI
// ============================================================

class MaterialDetailPage extends StatefulWidget {
  final MaterialData material;
  final Set<String> bookmarks;
  final MaterialHistoryStore historyStore;
  final VoidCallback onBookmarkChanged;

  const MaterialDetailPage({
    super.key,
    required this.material,
    required this.bookmarks,
    required this.historyStore,
    required this.onBookmarkChanged,
  });

  @override
  State<MaterialDetailPage> createState() => _MaterialDetailPageState();
}

class _MaterialDetailPageState extends State<MaterialDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.historyStore.record(widget.material);
  }

  @override
  Widget build(BuildContext context) {
    final saved = widget.bookmarks.contains(widget.material.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Materi'),
        actions: [
          IconButton(
            tooltip: saved ? 'Hapus bookmark' : 'Simpan bookmark',
            onPressed: () {
              setState(() {
                if (saved) {
                  widget.bookmarks.remove(widget.material.id);
                } else {
                  widget.bookmarks.add(widget.material.id);
                }
              });

              widget.onBookmarkChanged();
            },
            icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF113979),
                    Color(0xFF2878FF),
                    Color(0xFF20BCCD),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: electricBlue.withValues(alpha: 0.19),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -16,
                    bottom: -27,
                    child: Icon(
                      widget.material.icon,
                      size: 190,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    bottom: 22,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Text(
                        widget.material.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              widget.material.category,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.material.title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontSize: 29, height: 1.18),
            ),

            const SizedBox(height: 15),

            Text(
              widget.material.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Pembahasan',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              widget.material.content,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(height: 1.8),
            ),

            const SizedBox(height: 25),

            const Text(
              'Poin Penting',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                widget.material.importantPoints,
                style: const TextStyle(fontSize: 15, height: 1.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MaterialData? findMaterialById(String materialId) {
  for (final material in materials) {
    if (material.id == materialId) return material;
  }
  return null;
}

String formatHistoryTime(DateTime timestamp) {
  final difference = DateTime.now().difference(timestamp);
  if (difference.isNegative || difference.inSeconds < 60) {
    return 'Baru saja';
  }
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} menit lalu';
  }
  if (difference.inHours < 24) {
    return '${difference.inHours} jam lalu';
  }
  if (difference.inDays < 7) {
    return '${difference.inDays} hari lalu';
  }
  final localTime = timestamp.toLocal();
  final day = localTime.day.toString().padLeft(2, '0');
  final month = localTime.month.toString().padLeft(2, '0');
  return '$day/$month/${localTime.year}';
}

void openHistoryEntry(
  BuildContext context,
  MaterialHistoryEntry entry, {
  required MaterialHistoryStore historyStore,
  required Set<String> bookmarks,
  required VoidCallback onBookmarkChanged,
}) {
  final material = findMaterialById(entry.materialId);
  if (material == null) {
    historyStore.remove(entry.materialId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Materi ini sudah tidak tersedia.')),
    );
    return;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MaterialDetailPage(
        material: material,
        bookmarks: bookmarks,
        historyStore: historyStore,
        onBookmarkChanged: onBookmarkChanged,
      ),
    ),
  );
}

class MaterialHistoryPage extends StatelessWidget {
  final MaterialHistoryStore historyStore;
  final Set<String> bookmarks;
  final VoidCallback onBookmarkChanged;

  const MaterialHistoryPage({
    super.key,
    required this.historyStore,
    required this.bookmarks,
    required this.onBookmarkChanged,
  });

  Future<void> _confirmClear(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus semua riwayat?'),
        content: const Text('Semua materi dari riwayat belajar akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus semua'),
          ),
        ],
      ),
    );
    if (shouldClear == true) await historyStore.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Materi'),
        actions: [
          AnimatedBuilder(
            animation: historyStore,
            builder: (context, _) => IconButton(
              tooltip: 'Hapus semua riwayat',
              onPressed: historyStore.entries.isEmpty
                  ? null
                  : () => _confirmClear(context),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: historyStore,
        builder: (context, _) {
          final entries = historyStore.entries;
          if (!historyStore.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history,
                    size: 56,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  const Text('Belum ada materi yang dipelajari'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final material = findMaterialById(entry.materialId);
              return InteractiveFeedback(
                child: Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      child: Icon(
                        material?.icon ?? Icons.menu_book,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(entry.title),
                    subtitle: Text(
                      '${entry.category} · ${formatHistoryTime(entry.lastOpened)}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Hapus dari riwayat',
                      icon: const Icon(Icons.close),
                      onPressed: () => historyStore.remove(entry.materialId),
                    ),
                    onTap: () => openHistoryEntry(
                      context,
                      entry,
                      historyStore: historyStore,
                      bookmarks: bookmarks,
                      onBookmarkChanged: onBookmarkChanged,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ============================================================
// BOOKMARK
// ============================================================

class BookmarkPage extends StatelessWidget {
  final Set<String> bookmarks;
  final MaterialHistoryStore historyStore;
  final VoidCallback onBookmarkChanged;

  const BookmarkPage({
    super.key,
    required this.bookmarks,
    required this.historyStore,
    required this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final savedMaterials = materials
        .where((material) => bookmarks.contains(material.id))
        .toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: Text(
              'Bookmark',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Materi yang kamu simpan.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: savedMaterials.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 70,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 15),
                        const Text('Belum ada materi yang disimpan.'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: savedMaterials.length,
                    itemBuilder: (_, index) {
                      final material = savedMaterials[index];

                      return InteractiveFeedback(
                        child: Card(
                          child: ListTile(
                            leading: Icon(
                              material.icon,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(material.title),
                            subtitle: Text(material.category),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.bookmark,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                bookmarks.remove(material.id);

                                onBookmarkChanged();
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MaterialDetailPage(
                                    material: material,
                                    bookmarks: bookmarks,
                                    historyStore: historyStore,
                                    onBookmarkChanged: onBookmarkChanged,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfilePage extends StatelessWidget {
  final String userName;
  final String email;
  final String studentClass;
  final MaterialHistoryStore historyStore;
  final Set<String> bookmarks;
  final VoidCallback onBookmarkChanged;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.email,
    this.studentClass = 'X TKJ/TJKT',
    required this.historyStore,
    required this.bookmarks,
    required this.onBookmarkChanged,
  });

  void logout(BuildContext context) {
    adminSession.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF102F69),
                    Color(0xFF2878FF),
                    Color(0xFF14A9BD),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Nama'),
                    subtitle: Text(userName),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(email),
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('Jurusan'),
                    subtitle: Text(studentClass),
                  ),

                  const Divider(height: 1),

                  AnimatedBuilder(
                    animation: historyStore,
                    builder: (context, _) => ListTile(
                      leading: const Icon(Icons.menu_book),
                      title: const Text('Riwayat Materi'),
                      subtitle: Text(
                        '${historyStore.entries.length} materi pernah dibaca',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MaterialHistoryPage(
                            historyStore: historyStore,
                            bookmarks: bookmarks,
                            onBookmarkChanged: onBookmarkChanged,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Card(child: ThemeModeTile()),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADMIN DASHBOARD
// ============================================================

Widget buildAdminAccessDenied(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Akses admin diperlukan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk menggunakan akun admin untuk mengelola konten.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const ValueKey('return-to-login'),
                onPressed: () {
                  adminSession.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text('Kembali ke login'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentIndex = 0;

  void logout() {
    adminSession.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!adminSession.isAuthenticated) {
      return buildAdminAccessDenied(context);
    }

    final pages = [
      buildDashboard(),
      AdminMaterialPage(
        onChanged: () {
          setState(() {});
        },
      ),
      const AdminCategoryPage(),
      const AdminUserPage(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.015, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: pages[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Materi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Pengguna',
          ),
        ],
      ),
    );
  }

  Widget buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            Row(
              children: [
                const TechBrandMark(size: 48),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ADMIN CONSOLE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Dashboard Admin',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Logout',
                  onPressed: logout,
                  icon: const Icon(Icons.logout_rounded),
                ),
              ],
            ),

            Text(
              'Kelola konten aplikasi TechExplorer.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 12),

            const Card(child: ThemeModeTile()),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: statCard(
                    'Materi',
                    materials.length.toString(),
                    Icons.menu_book,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: statCard(
                    'Kategori',
                    categoryData.length.toString(),
                    Icons.category,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: statCard(
                    'Pengguna',
                    users.length.toString(),
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: statCard(
                    'Pengguna',
                    users.length.toString(),
                    Icons.people,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Kategori',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...categoryData.map((category) {
              final count = materials
                  .where((material) => material.category == category['name'])
                  .length;

              return Card(
                child: ListTile(
                  leading: Icon(
                    category['icon'] as IconData,
                    color: category['accent'] as Color,
                  ),
                  title: Text(category['name'] as String),
                  trailing: Text('$count materi'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = switch (icon) {
      Icons.menu_book => colorScheme.primary,
      Icons.people => colorScheme.tertiary,
      _ => const Color(0xFFDF9A4D),
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            accent.withValues(
              alpha: colorScheme.brightness == Brightness.dark ? 0.16 : 0.08,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 27),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontSize: 24, color: accent),
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ADMIN MATERI
// ============================================================

class AdminMaterialPage extends StatefulWidget {
  final VoidCallback onChanged;
  final MaterialCatalogStore? catalogStore;

  const AdminMaterialPage({
    super.key,
    required this.onChanged,
    this.catalogStore,
  });

  @override
  State<AdminMaterialPage> createState() => _AdminMaterialPageState();
}

class _AdminMaterialPageState extends State<AdminMaterialPage> {
  MaterialCatalogStore get _catalogStore =>
      widget.catalogStore ?? materialCatalogStore;

  Future<bool> _saveCatalog(List<MaterialData> catalog) async {
    if (!await _catalogStore.save(catalog)) return false;
    materials
      ..clear()
      ..addAll(catalog);
    if (mounted) {
      setState(() {});
      widget.onChanged();
    }
    return true;
  }

  void addMaterial() => _showMaterialForm();

  void editMaterial(MaterialData material) =>
      _showMaterialForm(material: material);

  Future<void> _showMaterialForm({MaterialData? material}) async {
    final pageContext = context;
    var title = material?.title ?? '';
    var description = material?.description ?? '';
    var content = material?.content ?? '';
    var importantPoints =
        material?.importantPoints ?? 'Materi ditambahkan oleh admin.';
    final formKey = GlobalKey<FormState>();
    final originalCategory = material?.category ?? 'Hardware';
    final categories = categoryData
        .map((item) => item['name'] as String)
        .toSet()
        .toList();
    if (!categories.contains(originalCategory)) {
      categories.insert(0, originalCategory);
    }
    var category = originalCategory;
    var isSaving = false;
    String? saveError;

    bool hasChanges() =>
        title != (material?.title ?? '') ||
        description != (material?.description ?? '') ||
        content != (material?.content ?? '') ||
        importantPoints !=
            (material?.importantPoints ?? 'Materi ditambahkan oleh admin.') ||
        category != originalCategory;

    await showDialog<void>(
      context: pageContext,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(material == null ? 'Tambah Materi' : 'Edit Materi'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('material-title-field'),
                    initialValue: title,
                    onChanged: (value) => title = value,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Judul Materi',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Judul materi wajib diisi.'
                        : null,
                  ),
                  TextFormField(
                    key: const ValueKey('material-description-field'),
                    initialValue: description,
                    onChanged: (value) => description = value,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Deskripsi wajib diisi.'
                        : null,
                  ),
                  TextFormField(
                    key: const ValueKey('material-content-field'),
                    initialValue: content,
                    onChanged: (value) => content = value,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Pembahasan'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Pembahasan wajib diisi.'
                        : null,
                  ),
                  TextFormField(
                    key: const ValueKey('material-important-points-field'),
                    initialValue: importantPoints,
                    onChanged: (value) => importantPoints = value,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Poin Penting',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('material-category-field'),
                    initialValue: category,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: categories
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() {
                        category = value;
                      });
                    },
                  ),
                  if (saveError != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        saveError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              key: const ValueKey('cancel-material'),
              onPressed: isSaving
                  ? null
                  : () async {
                      if (hasChanges()) {
                        final discard = await showDialog<bool>(
                          context: context,
                          builder: (confirmationContext) => AlertDialog(
                            title: const Text('Buang perubahan?'),
                            content: const Text(
                              'Perubahan yang belum disimpan akan hilang.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(confirmationContext, false),
                                child: const Text('Lanjut edit'),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.pop(confirmationContext, true),
                                child: const Text('Buang perubahan'),
                              ),
                            ],
                          ),
                        );
                        if (discard != true) return;
                      }
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              key: const ValueKey('save-material'),
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      setDialogState(() {
                        isSaving = true;
                        saveError = null;
                      });

                      final updatedMaterial = material == null
                          ? MaterialData(
                              id: 'admin-material-${DateTime.now().microsecondsSinceEpoch}',
                              title: title.trim(),
                              category: category,
                              description: description.trim(),
                              content: content.trim(),
                              importantPoints: importantPoints.trim(),
                              icon: Icons.menu_book,
                            )
                          : material.copyWith(
                              title: title.trim(),
                              category: category,
                              description: description.trim(),
                              content: content.trim(),
                              importantPoints: importantPoints.trim(),
                            );
                      final updatedCatalog = List<MaterialData>.of(materials);
                      final existingIndex = material == null
                          ? -1
                          : updatedCatalog.indexWhere(
                              (item) => item.id == material.id,
                            );
                      if (material != null && existingIndex == -1) {
                        setDialogState(() {
                          isSaving = false;
                          saveError = 'Materi tidak lagi tersedia.';
                        });
                        return;
                      }
                      if (existingIndex == -1) {
                        updatedCatalog.add(updatedMaterial);
                      } else {
                        updatedCatalog[existingIndex] = updatedMaterial;
                      }

                      final saved = await _saveCatalog(updatedCatalog);
                      if (!saved) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() {
                          isSaving = false;
                          saveError = 'Perubahan belum tersimpan. Periksa penyimpanan lalu coba lagi.';
                        });
                        return;
                      }

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                      if (!pageContext.mounted) return;
                      ScaffoldMessenger.of(pageContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            material == null
                                ? 'Materi berhasil ditambahkan.'
                                : 'Perubahan materi berhasil disimpan.',
                          ),
                        ),
                      );
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(material == null ? 'Simpan' : 'Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteMaterial(MaterialData material) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Materi'),
        content: Text('Hapus materi "${material.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedCatalog = materials
                  .where((item) => item.id != material.id)
                  .toList();
              if (!await _saveCatalog(updatedCatalog)) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Materi gagal dihapus karena penyimpanan gagal.',
                      ),
                    ),
                  );
                }
                return;
              }
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kelola Materi',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                FloatingActionButton.small(
                  onPressed: addMaterial,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: materials.length,
              itemBuilder: (_, index) {
                final material = materials[index];

                return Card(
                  child: ListTile(
                    leading: Icon(
                      material.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(material.title),
                    subtitle: Text(material.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: ValueKey('edit-material-${material.id}'),
                          tooltip: 'Edit materi ${material.title}',
                          onPressed: () => editMaterial(material),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Hapus materi ${material.title}',
                          onPressed: () => deleteMaterial(material),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AdminCategoryPage extends StatefulWidget {
  const AdminCategoryPage({super.key});

  @override
  State<AdminCategoryPage> createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  Future<bool> _saveCategories(List<String> names, {int? removedIndex}) async {
    final previousNames = categoryData
        .map((category) => category['name'] as String)
        .toList();
    final updatedMaterials = materials.map((material) {
      final index = previousNames.indexOf(material.category);
      if (index < 0 || index >= previousNames.length) {
        return material.copyWith();
      }
      final nextIndex = removedIndex != null && index > removedIndex
          ? index - 1
          : index;
      if (nextIndex >= names.length) return material.copyWith();
      return material.copyWith(category: names[nextIndex]);
    }).toList();
    if (!await categoryStore.save(names.map(categoryDetails))) return false;
    if (!await materialCatalogStore.save(updatedMaterials)) {
      await categoryStore.save(previousNames.map(categoryDetails));
      return false;
    }
    categoryData
      ..clear()
      ..addAll(names.map(categoryDetails));
    materials
      ..clear()
      ..addAll(updatedMaterials);
    if (mounted) setState(() {});
    return true;
  }

  Future<void> _editCategory({int? index}) async {
    final original = index == null ? '' : categoryData[index]['name'] as String;
    final controller = TextEditingController(text: original);
    final formKey = GlobalKey<FormState>();
    var saving = false;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(index == null ? 'Tambah Kategori' : 'Edit Kategori'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              maxLength: 48,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nama kategori'),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) return 'Nama kategori wajib diisi.';
                if (categoryData.any(
                  (item) =>
                      item['name'] != original &&
                      (item['name'] as String).toLowerCase() ==
                          name.toLowerCase(),
                )) {
                  return 'Kategori tersebut sudah ada.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      setDialogState(() => saving = true);
                      final names = categoryData
                          .map((item) => item['name'] as String)
                          .toList();
                      if (index == null) {
                        names.add(controller.text.trim());
                      } else {
                        names[index] = controller.text.trim();
                      }
                      if (!await _saveCategories(names)) {
                        if (!dialogContext.mounted) return;
                        setDialogState(() => saving = false);
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Kategori gagal disimpan. Periksa penyimpanan lalu coba lagi.',
                            ),
                          ),
                        );
                        return;
                      }
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                    },
              child: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }

  Future<void> _deleteCategory(int index) async {
    final category = categoryData[index]['name'] as String;
    final usesCategory = materials.any(
      (material) => material.category == category,
    );
    if (usesCategory) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kategori masih digunakan materi. Pindahkan materi terlebih dahulu.',
          ),
        ),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Hapus kategori "$category"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final names = categoryData.map((item) => item['name'] as String).toList()
      ..removeAt(index);
    if (!await _saveCategories(names, removedIndex: index) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kategori gagal dihapus.')));
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Kelola Kategori',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              FilledButton.icon(
                onPressed: () => _editCategory(),
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryData.length,
            itemBuilder: (context, index) {
              final item = categoryData[index];
              final name = item['name'] as String;
              final count = materials
                  .where((material) => material.category == name)
                  .length;
              return Card(
                child: ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: item['accent'] as Color,
                  ),
                  title: Text(name),
                  subtitle: Text('$count materi'),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: 'Edit kategori $name',
                        onPressed: () => _editCategory(index: index),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Hapus kategori $name',
                        onPressed: () => _deleteCategory(index),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

// ============================================================
// ADMIN USER
// ============================================================

class AdminUserPage extends StatelessWidget {
  const AdminUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 25, 20, 5),
            child: Text(
              'Data Pengguna',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Daftar pengguna aplikasi TechExplorer.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(user['name'] ?? ''),
                    subtitle: Text('${user['email']}\n${user['class']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INPUT DECORATION
// ============================================================

InputDecoration inputDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}
