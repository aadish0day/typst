// === BudgetLite: CA1 Mini Project (50% Submission) ===
// Master Typst Document for Course ASDT
// Author: Aadish das | UID: 24BIT010 | Roll No: 10

#set document(
  title: "BudgetLite — CA1 Mini Project (50% Submission)",
  author: "Aadish das",
  date: auto,
)

#set page(
  paper: "a4",
  margin: (left: 1.25in, right: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center,
)

// Cross-Platform Font Fallbacks
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

// Table Cell Styling
#show table.cell: set text(size: 9.5pt)
#show table.cell.where(y: 0): set text(size: 9.5pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Raw Code Block Styling
#show raw.where(block: true): it => block(
  fill: rgb("F8F9FA"),
  stroke: 0.5pt + rgb("D0D5DD"),
  inset: (x: 9pt, y: 7pt),
  radius: 3pt,
  width: 100%,
  text(
    font: ("Fira Code", "DejaVu Sans Mono", "Courier New"),
    size: 8.5pt,
    it
  )
)

#show raw.where(block: false): it => text(
  font: ("Fira Code", "DejaVu Sans Mono", "Courier New"),
  size: 9pt,
  fill: rgb("0D7377"),
  weight: "medium",
  it
)

// Academic Styled Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + rgb("0D7377"), bottom: 1.2pt + rgb("0D7377")) } else { 0.4pt + luma(200) },
  fill: (x, y) => if y == 0 { rgb("E8F4F4") } else if calc.even(y) { rgb("FAFCFC") } else { none },
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 9.5pt, weight: "bold", fill: rgb("0D7377"))[#h]])),
  ..rows.pos().map(cell => text(size: 9pt)[#cell])
)

// Callout Box Helper
#let callout(title: "", body, color: rgb("0D7377")) = block(
  fill: color.lighten(92%),
  stroke: (left: 3.5pt + color, rest: 0.4pt + color.lighten(60%)),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 3pt),
  width: 100%,
  [
    #if title != "" [
      #text(weight: "bold", size: 10pt, fill: color)[#title]\
      #v(3pt)
    ]
    #text(size: 9.5pt)[#body]
  ]
)

// Responsive Diagram Image Helper (Full Page Width)
#let responsive-image(path, width: 100%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

// ==========================================
// TITLE & METADATA HEADER
// ==========================================

#align(center)[
  #block(
    fill: rgb("F0F7F7"),
    stroke: 1pt + rgb("0D7377"),
    inset: (x: 16pt, y: 14pt),
    radius: 6pt,
    width: 100%,
    [
      #text(size: 18pt, weight: "bold", fill: rgb("0D7377"))[BudgetLite]\
      #v(2pt)
      #text(size: 13pt, weight: "bold")[Smart Budgeting, Simplified.]\
      #v(4pt)
      #text(size: 11pt, style: "italic")[A Premium Offline-First Personal Budgeting Application for Android]\
      #v(8pt)
      #line(length: 60%, stroke: 0.6pt + rgb("0D7377"))
      #v(6pt)
      #grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [
          #text(size: 9.5pt)[*Subject:* ASDT]\
          #text(size: 9.5pt)[*Assessment:* CA1 Mini Project (50% Weightage)]\
          #text(size: 9.5pt)[*Platform:* Android (Flutter 3.x / Dart)]
        ],
        [
          #text(size: 9.5pt)[*Student Name:* Aadish das]\
          #text(size: 9.5pt)[*UID:* 24BIT010 | *Roll No:* 10]\
          #text(size: 9.5pt)[*Version:* 1.0.0+1 (Snapshot `b5376d0`)]
        ]
      )
    ]
  )
]

#v(8pt)

#styled-table(
  columns: (1.5fr, 3.5fr),
  headers: ("Project Metadata", "Technical Specification"),
  "Application Name", "BudgetLite: Offline-First Personal Budgeting App",
  "Target Platform", "Android (SDK 24+, with iOS and Web scaffolds included)",
  "Framework & UI", "Flutter 3.x / Dart 3.x with Material 3 Design System",
  "State Management", "Riverpod 2.x (StateNotifier + FutureProvider + Notifier)",
  "Local Database", "Drift 2.x (Type-safe ORM / DAO over local SQLite)",
  "Source Snapshot", "Commit b5376d0 — \"feat: add biometric lock, theme system, settings overhaul, and budget notifications\" (Jul 24, 2026)",
  "Course Code / Title", "ASDT — Continuous Assessment 1 (CA1 Mini Project — 50%)",
  "Submission Date", "July / August 2026"
)

#v(10pt)

// ==========================================
// TABLE OF CONTENTS
// ==========================================

#outline(
  title: [Table of Contents],
  indent: 1.5em,
  depth: 2,
)

#v(12pt)
#line(length: 100%, stroke: 0.4pt + luma(180))
#v(12pt)

// ==========================================
// SECTION 1: ABSTRACT
// ==========================================

= Abstract

*BudgetLite* is an offline-first personal budgeting application for Android developed using Flutter, Riverpod, and Drift SQLite. The *50% Submission* milestone marks a major architectural expansion from the baseline ledger and SMS parser of the 25% milestone to a full-fledged offline financial intelligence suite.

Captured at commit `b5376d0` (July 24, 2026), the application provides:
1. *Financial Insights & Analytics Suite*: A quartile-based contribution activity heatmap (GitHub-style), an interactive spend calendar (month and week views), daily spending velocity, merchant frequency ranking, and top category metrics.
2. *PDF Statement Generation & Printing*: On-device compilation of custom date-range financial statements into formatted, multi-page PDF documents using the `pdf` and `printing` packages with system share sheet integration.
3. *Hardware Biometric Security*: Biometric authentication (fingerprint/PIN/face) powered by `local_auth` and `FlutterFragmentActivity`, with privacy blur overlays and configurable background auto-lock durations (immediately, 1m, 5m, 15m).
4. *Proactive Budget Notifications*: Push alerts triggered at 80% and 100% budget utilization with category deep linking.
5. *Multi-Category Transaction Splitting*: Interactive allocation sheets enabling a single purchase to be divided across multiple spending buckets.
6. *'What-If' Savings Goal Simulator*: Interactive slider-based forecasting tool calculating accelerated savings goal target dates when specific category budgets are reduced.
7. *System Theme & Data Management*: Light/Dark/System theme switching with custom accent colors, complete JSON database backup/restore, and delimiter-resilient CSV imports.

All processing and storage remains 100% on-device with zero server dependencies or telemetry.

// ==========================================
// SECTION 2: PROBLEM STATEMENT
// ==========================================

= Problem Statement

Modern mobile users face severe privacy and functional compromises with existing budgeting software:

+ *Cloud Privacy Hazards:* Mainstream expense trackers require cloud sync, transmitting banking SMS logs, merchant names, and net worth data to remote commercial servers.
+ *Lack of Actionable Visual Intelligence:* Most offline apps only show basic tabular transaction lists without spend velocity trends, daily heatmaps, or projections.
+ *Absence of Portable Statements:* Offline users cannot generate printable or auditable statements for tax preparation or expense claims without manually reconstructing spreadsheets.
+ *Unprotected Device Access:* Many apps lack localized hardware authentication, exposing sensitive financial balances whenever an unlocked phone is handed to family or colleagues.
+ *Rigid Single-Category Limits:* Real-world transactions (e.g., supermarket bills containing both food and household utilities) cannot be cleanly split.

BudgetLite's 50% milestone solves these challenges by combining strict local privacy with hardware-level security, analytical depth, portable PDF statement generation, and flexible multi-category allocation.

// ==========================================
// SECTION 3: OBJECTIVES & EXPANDED USE CASES
// ==========================================

= Objectives & Expanded Use Cases

== 50% Milestone Objectives

- *Advanced Spending Analytics:* Build a reactive insights engine calculating daily/weekly/monthly burn rates, quartile-based activity graphs, and spending calendar views.
- *Standalone PDF Statement Builder:* Compile structured financial reports into A4 PDF documents on-device without cloud rendering.
- *Biometric Security Guard:* Implement hardware biometric authentication with auto-lock timeout policies and background app switching privacy blur.
- *Envelope Budgeting & Push Alerts:* Implement proactive local notifications at 80% and 100% category limit thresholds with direct navigation hooks.
- *Multi-Category Transaction Splitting:* Enable users to split complex transactions across arbitrary categories with balance validation.
- *Interactive What-If Goal Simulator:* Implement financial scenario modeling projecting goal completion dates based on category budget cuts.
- *Complete Data Portability:* Provide AES-compatible JSON database backups and robust CSV import/export facilities.
- *Polished Theming:* Deliver a full Material 3 design system supporting Light, Dark, and System modes with dynamic teal accenting (`#0D7377`).

#pagebreak(weak: true)

== UML Use Case Diagram

The expanded system interactions for the 50% milestone are depicted in @fig-use-case:

#figure(
  responsive-image("attachments/use_case_diagram.svg", width: 95%),
  caption: [UML Use Case Diagram (50% Milestone) — Expanded Analytics, Security, and Workflows],
) <fig-use-case>

// ==========================================
// SECTION 4: TECHNOLOGY STACK
// ==========================================

= Technology Stack

BudgetLite's 50% architecture incorporates pure on-device compilation libraries:

#styled-table(
  columns: (1.2fr, 1.4fr, 2.4fr),
  headers: ("Layer / Subsystem", "Technology Choice", "Architectural Role & Description"),
  "Framework & UI", "Flutter 3.x / Dart", "Cross-platform declarative client framework compiling to native ARM binaries.",
  "State Management", "Riverpod 2.x", "Compile-safe reactive state injection (`StateNotifier`, `FutureProvider`, `Notifier`).",
  "Local Database", "Drift 2.x (SQLite)", "Reactive relational database with generated DAOs, migrations, and stream queries.",
  "Document Generation", "pdf & printing", "Pure Dart vector PDF builder with native Android print/share sheet integration.",
  "Data Visualization", "fl_chart", "Hardware-accelerated pie charts, bar charts, and historical balance line graphs.",
  "Biometric Security", "local_auth", "Hardware-backed biometric fingerprint, face, and device PIN lock screen.",
  "Local Notifications", "flutter_local_notifications", "On-device scheduled alerts for 80% and 100% budget threshold limits.",
  "Micro-Animations", "flutter_animate", "Declarative staggered entrances, spring scale transitions, and shimmer skeleton loaders.",
  "Iconography", "lucide_icons_flutter", "Crisp outline icons across all navigation tabs, category badges, and action sheets.",
  "Typography", "Google Fonts", "Three-font hierarchy: *DM Sans* (Headings), *Inter* (Body/UI), and *JetBrains Mono* (Numeric values).",
  "Data Portability", "csv, file_picker, share_plus", "JSON database backup exporter/importer and quote-safe CSV statement parser.",
  "Native Layer", "FlutterFragmentActivity", "Android fragment activity enabling native biometric prompt lifecycle binding."
)

// ==========================================
// SECTION 5: DATABASE SCHEMA & ER DIAGRAM
// ==========================================

= Database Schema & Data Models

The database schema (schema version 2) is maintained in `lib/core/database/tables.dart` and compiled into Drift DAOs.

#pagebreak(weak: true)

== Entity Relationship (ER) Diagram

#figure(
  responsive-image("attachments/er_diagram.svg", width: 95%),
  caption: [PlantUML Entity Relationship Diagram (Schema v2) for SQLite Tables],
) <fig-er-diagram>

== Declarative Table Definitions

```dart
// lib/core/database/tables.dart (essential table definitions)
import 'package:drift/drift.dart';

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get balance => real().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('INR'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().withDefault(const Constant('category'))();
  IntColumn get color => integer().withDefault(const Constant(0xFF0D7377))();
  TextColumn get type => text().withDefault(const Constant('expense'))(); // expense | income

  @override
  Set<Column> get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()(); // + = expense, - = income
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  BoolColumn get isRecurringInstance => boolean().withDefault(const Constant(false))();
  TextColumn get recurringInterval => text().nullable()();
  TextColumn get receiptImagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get month => text()(); // YYYY-MM format
  RealColumn get allocatedAmount => real()();
  BoolColumn get rollover => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  IntColumn get color => integer().withDefault(const Constant(0xFF0D7377))();
  TextColumn get icon => text().withDefault(const Constant('target'))();

  @override
  Set<Column> get primaryKey => {id};
}

class MonthlyIncome extends Table {
  TextColumn get id => text()();
  TextColumn get month => text()(); // YYYY-MM
  RealColumn get amount => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
```

== Data Dictionary

#styled-table(
  columns: (1fr, 1.4fr, 2.6fr),
  headers: ("Table Name", "Domain Purpose", "Key Columns & Integrity Constraints"),
  "accounts", "Financial accounts with live balance tracking", "`id` (PK, TEXT), `name` (TEXT), `balance` (REAL, default 0), `currency` (TEXT, default 'INR')",
  "categories", "Category taxonomy for income & expenses", "`id` (PK, TEXT), `name` (TEXT), `icon` (TEXT), `color` (INT), `type` (TEXT: expense/income)",
  "transactions", "Core financial ledger of movements", "`id` (PK, TEXT), `amount` (REAL), `categoryId` (FK -> categories.id), `accountId` (FK -> accounts.id), `date` (DATETIME), `note` (TEXT), `isRecurring` (BOOL), `isRecurringInstance` (BOOL), `recurringInterval` (TEXT)",
  "budgets", "Monthly envelope spending allocations", "`id` (PK, TEXT), `categoryId` (FK -> categories.id), `month` (TEXT, YYYY-MM), `allocatedAmount` (REAL), `rollover` (BOOL)",
  "goals", "Savings targets with progress tracking", "`id` (PK, TEXT), `name` (TEXT), `targetAmount` (REAL), `currentAmount` (REAL), `targetDate` (DATETIME)",
  "monthly_income", "Declared monthly income baseline", "`id` (PK, TEXT), `month` (TEXT, YYYY-MM), `amount` (REAL)",
  "app_settings", "Key-value configuration & rules store", "`key` (PK, TEXT), `value` (TEXT, JSON-serialized preferences & rules)"
)

// ==========================================
// SECTION 6: ARCHITECTURE & COMPONENT DESIGN
// ==========================================

= Architecture & Component Design

#pagebreak(weak: true)

== 5-Tier Layered Architecture Diagram

#figure(
  responsive-image("attachments/component_diagram.svg", width: 95%),
  caption: [BudgetLite 5-Tier Layered Architecture Diagram (50% Milestone)],
) <fig-component-diagram>

== Source Layout

BudgetLite organizes 44+ Dart files into a feature-driven modular structure:

```
lib/
├── main.dart                                # Entry point, orientation lock & quick actions
├── app.dart                                 # App shell, biometric lock, 5-tab nav, theme switch
├── core/
│   ├── theme/                               # colors.dart, app_theme.dart (Material 3 tokens)
│   ├── database/                            # tables.dart, database.dart, database.g.dart
│   ├── utils/                               # sms_parser, categorization_rule, duplicate_detector,
│   │                                        # formatters, notification_service, csv_importer,
│   │                                        # demo_data, icon_helper, constants
│   └── widgets/                             # arc_progress, animated_number, insight_cards
├── features/
│   ├── home/                                # Dashboard, balance hero, editable balance
│   ├── transactions/                        # Ledger list, add modal, split transaction sheet
│   ├── budget/                              # Envelope budget setup, threshold highlight
│   ├── goals/                               # Savings goals & what-if reduction simulator
│   ├── insights/                            # Contribution graph, spend calendar, PDF generator
│   ├── settings/                            # Biometrics, theme switcher, JSON/CSV backup
│   ├── sms/                                 # SMS review queue & pending approvals
│   ├── subscriptions/                       # Recurring bills audit
│   └── onboarding/                          # First-launch onboarding
├── providers/                               # Riverpod providers (transactions, budgets, goals,
│                                            # insights, settings, navigation, database)
└── services/                                # sms_listener_service.dart
```

#pagebreak(weak: true)

== Object-Oriented Class Diagram

#figure(
  responsive-image("attachments/class_diagram.svg", width: 75%, max-height: 500pt),
  caption: [PlantUML Class Diagram — Domain Entities, Analytics Models, Notifiers, and Utilities],
) <fig-class-diagram>

== Provider Hierarchy (50% Milestone)

```
databaseProvider (Drift Database Instance)
├── categoriesProvider ─────────────────> List<Category>
├── accountsListProvider ───────────────> List<Account>
├── transactionsProvider ───────────────> List<Transaction>
├── thisMonthTransactionsProvider ──────> List<Transaction>
├── thisMonthBudgetsProvider ───────────> List<Budget>
├── goalsProvider ──────────────────────> List<Goal>
├── incomeByMonthProvider(monthKey) ────> double
├── spendingByMonthProvider(monthKey) ──> double
├── netByMonthProvider(monthKey) ───────> double
├── customReportDataProvider(range) ────> CustomReportData
├── dailySpendingHeatmapProvider ───────> Map<DateTime, double>
├── biometricLockEnabledProvider ───────> bool
├── autoLockDurationProvider ───────────> Duration
├── themeModeProvider ──────────────────> ThemeModeOption
├── budgetHighlightProvider ────────────> String? (deep link focus)
└── smsReviewQueueProvider ─────────────> List<ParsedSmsTxn>
```

// ==========================================
// SECTION 7: CORE BUSINESS LOGIC & ENGINES
// ==========================================

= Core Business Logic & Feature Engines

== Financial Insights & Analytics Engine

The insights engine (`insights_provider.dart`) dynamically aggregates transaction history to produce statistical distributions and visual telemetry:
- *Daily Spending Velocity:* Calculates average burn rate per day and projects end-of-month expenditure.
- *Quartile Heatmap Distribution:* Categorizes each calendar day into 4 intensity levels based on spending quartiles (Level 0: ₹0, Level 1: 1st quartile, Level 2: median, Level 3: 3rd quartile, Level 4: peak expenditure).
- *Merchant Frequency & Top Categories:* Groups and ranks spending to highlight primary outflow channels.

```dart
// lib/providers/insights_provider.dart (core aggregations)
final incomeByMonthProvider = FutureProvider.family<double, String>((ref, monthKey) async {
  final db = ref.read(databaseProvider);
  final year = int.parse(monthKey.split('-')[0]);
  final month = int.parse(monthKey.split('-')[1]);
  final transactions = await (db.select(db.transactions)
        ..where((t) => t.date.year.equals(year))
        ..where((t) => t.date.month.equals(month)))
      .get();
  return transactions
      .where((t) => t.amount < 0)
      .fold<double>(0.0, (sum, t) => sum + t.amount.abs());
});

final spendingByMonthProvider = FutureProvider.family<double, String>((ref, monthKey) async {
  final db = ref.read(databaseProvider);
  final year = int.parse(monthKey.split('-')[0]);
  final month = int.parse(monthKey.split('-')[1]);
  final transactions = await (db.select(db.transactions)
        ..where((t) => t.date.year.equals(year))
        ..where((t) => t.date.month.equals(month)))
      .get();
  return transactions
      .where((t) => t.amount > 0 && t.categoryId != 'transfer')
      .fold<double>(0.0, (sum, t) => sum + t.amount);
});
```

#pagebreak(weak: true)

== PDF Financial Report Generator & Export

`PdfReportGenerator` compiles arbitrary date-range transaction data into structured, professional A4 financial reports on-device using the `pdf` package.

#figure(
  responsive-image("attachments/insights_pdf_sequence.svg", width: 95%),
  caption: [Sequence Diagram — Financial Insights Aggregation and On-Device PDF Compilation],
) <fig-pdf-sequence>

```dart
// lib/features/insights/pdf_report_generator.dart (core structure)
class PdfReportGenerator {
  static Future<Uint8List> generateReportPdf(CustomReportData report) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2);
    final periodStr = '${dateFormat.format(report.startDate)} - ${dateFormat.format(report.endDate)}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // Header Banner
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.teal900,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text('BudgetLite Financial Report',
                style: pw.TextStyle(color: PdfColors.white, fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 16),
          // Financial Summary Cards
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryCard('Total Income', currencyFormat.format(report.totalIncome), PdfColors.green),
              _buildSummaryCard('Total Spending', currencyFormat.format(report.totalExpense), PdfColors.red),
              _buildSummaryCard('Net Savings', currencyFormat.format(report.netSavings), PdfColors.blue),
            ],
          ),
          pw.SizedBox(height: 20),
          // Category Breakdown Table & Detailed Transaction Ledger...
        ],
      ),
    );
    return pdf.save();
  }
}
```

#pagebreak(weak: true)

== Biometric Hardware Security & Auto-Lock

`BiometricGuard` wraps the application root in `lib/app.dart`. When the app is paused, a timestamp is recorded; upon resume, if elapsed time exceeds `autoLockDurationProvider`, a privacy blur overlay is applied and `local_auth` requests hardware verification.

#figure(
  responsive-image("attachments/biometric_sequence.svg", width: 95%),
  caption: [Sequence Diagram — Biometric Security Guard and Background Auto-Lock],
) <fig-bio-sequence>

```dart
// lib/app.dart (Biometric Lifecycle & Privacy Blur)
class _AppEntryState extends ConsumerState<_AppEntry> with WidgetsBindingObserver {
  DateTime? _pausedAt;
  bool _isLocked = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final lockEnabled = ref.read(biometricLockEnabledProvider).valueOrNull ?? false;
      final autoLockDuration = ref.read(autoLockDurationProvider).valueOrNull ?? Duration.zero;
      if (lockEnabled && _pausedAt != null) {
        if (DateTime.now().difference(_pausedAt!) >= autoLockDuration) {
          setState(() => _isLocked = true);
          _authenticate();
        }
      }
    }
  }

  Future<void> _authenticate() async {
    final auth = LocalAuthentication();
    final success = await auth.authenticate(
      localizedReason: 'Unlock BudgetLite to access your financial records',
      options: const AuthenticationOptions(biometricOnly: false, stickyAuth: true),
    );
    if (success) setState(() => _isLocked = false);
  }
}
```

== Proactive Budget Notifications & Category Deep Linking

`NotificationService` monitors category expenditures after each recorded transaction. When spending reaches 80% (approaching limit) or 100% (over budget), a push notification is dispatched. Tapping the notification updates `budgetHighlightProvider` and routes directly to the relevant category in `BudgetScreen`.

```dart
// lib/core/utils/notification_service.dart (core alert dispatch)
class NotificationService {
  static Future<void> showBudgetAlert({
    required String categoryName,
    required double percentage,
    required double spent,
    required double allocated,
  }) async {
    final isExceeded = percentage >= 100;
    final title = isExceeded ? '⚠️ Budget Exceeded!' : '⚡ Budget Alert';
    final body = isExceeded
        ? '$categoryName is over budget! Spent ₹${spent.toStringAsFixed(0)} of ₹${allocated.toStringAsFixed(0)}'
        : '$categoryName is at ${percentage.toStringAsFixed(0)}% of monthly budget.';

    await _plugin.show(
      categoryName.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'budget_alerts_channel',
          'Budget Limit Alerts',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'budget_category:$categoryName',
    );
  }
}
```

== Multi-Category Transaction Splitting

`SplitTransactionSheet` (`split_transaction_sheet.dart`) allows a total transaction amount to be divided into multiple line items with different categories. It verifies that the sum of split amounts strictly equals the total amount before performing an atomic database insert.

```dart
// lib/features/transactions/split_transaction_sheet.dart (validation & insert)
void _submitSplits() async {
  final total = double.tryParse(_totalCtrl.text.replaceAll(',', '')) ?? 0.0;
  final splitSum = _splits.fold<double>(0.0, (sum, item) => sum + (double.tryParse(item.amount) ?? 0.0));

  if ((total - splitSum).abs() > 0.01) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Splits total (₹$splitSum) must match transaction total (₹$total)')),
    );
    return;
  }

  await ref.read(transactionNotifierProvider.notifier).insertSplitTransaction(
    totalAmount: total,
    splits: _splits,
    paymentMethod: _paymentMethod,
    date: _selectedDate,
  );
  Navigator.pop(context);
}
```

== 'What-If' Savings Goal Simulator

The simulator (`what_if_simulator_sheet.dart`) models financial adjustments: users adjust sliders to reduce monthly allocations in selected categories, and the engine computes the accelerated completion date for active savings goals.

$ "Monthly Extra Savings" = sum_(c in "Categories") ("Allocated"_c times "Reduction Ratio"_c) $

$ "Accelerated Time to Goal" = frac("Target Amount" - "Current Amount", "Standard Monthly Savings" + "Monthly Extra Savings") $

== SMS Bank Transaction Parser & Heuristics

The on-device SMS parser filters financial debit and spend alerts via regex, extracting amount, merchant name, and category before enqueuing to `smsReviewQueueProvider` for manual confirmation.

== Keyword-Based Auto-Categorization

Persisted rules in `app_settings` match keywords (e.g., `"zomato"`, `"uber"`, `"electricity"`) to category taxonomy with case-insensitive regular expressions.

== JSON Database Backup & CSV Data Importer

- *JSON Backup Engine:* `exportJsonBackup()` serializes all 7 Drift tables into a structured JSON file; `importJsonBackup()` restores records inside an atomic database transaction.
- *CSV Data Importer:* Ingests external bank CSV statements with automatic column mapping and duplicate suppression.

// ==========================================
// SECTION 8: APP ENTRY & NAVIGATION SHELL
// ==========================================

= App Entry, Lifecycle & Navigation Shell

`app.dart` defines the root `BudgetLiteApp` widget, integrating theme switching, biometric lifecycle listeners, and 5-tab bottom navigation:

```dart
// lib/app.dart (Root Application Navigation)
Scaffold(
  body: _screens[currentTab],
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: currentTab,
    onTap: (i) {
      HapticFeedback.selectionClick();
      ref.read(currentTabProvider.notifier).state = i;
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(LucideIcons.receipt), label: 'Transactions'),
      BottomNavigationBarItem(icon: Icon(LucideIcons.pieChart), label: 'Budget'),
      BottomNavigationBarItem(icon: Icon(LucideIcons.target), label: 'Goals'),
      BottomNavigationBarItem(icon: Icon(LucideIcons.trendingUp), label: 'Insights'),
    ],
  ),
)
```

// ==========================================
// SECTION 9: UI SCREEN ARCHITECTURE
// ==========================================

= UI Screen Architecture & Layouts

#styled-table(
  columns: (1.5fr, 3.5fr),
  headers: ("Screen", "Core Architectural UI Components"),
  "Home Dashboard", "Balance Hero with Circular Arc, Monthly Income / Spent pills, Account Card Switcher, Upcoming Recurring Bills, Quick Entry CTA.",
  "Transactions Ledger", "Search Bar, Category Filter Chips, Date-Grouped Transaction Cards, Split Transaction Sheet, Swipe-to-Delete.",
  "Budget Screen", "Envelope Spending Meters, 80%/100% Usage Color Highlights, Deep-Linked Category Focus, Quick Budget Allocator.",
  "Savings Goals", "Visual Target Cards, Percent Progress Bars, What-If Simulator Bottom Sheet with Interactive Sliders.",
  "Insights Screen", "Quartile-Based Activity Heatmap (GitHub style), Spend Calendar View, Velocity Metric Cards, PDF Report Builder & Share Sheet.",
  "Settings & Security", "Biometric Lock Toggle, Auto-Lock Duration Selector, Theme Switcher (Light/Dark/System), JSON Backup/Restore, Auto-Category Rules Editor."
)

// ==========================================
// SECTION 10: OUTPUT & VERIFICATION
// ==========================================

= Verifiable Outputs

== Static Analysis

```bash
$ cd BudgetLite && flutter analyze
Analyzing code...
No issues found! (ran in 3.4s)
```

The entire codebase compiles with *zero static analysis warnings or errors*.

== Unit & Regression Test Execution

```bash
$ flutter test test/duplicate_detector_test.dart
00:00 +0: DuplicateDetector Tests Detects exact duplicate debit transaction
00:00 +1: DuplicateDetector Tests Ignores transaction outside date tolerance
00:00 +2: DuplicateDetector Tests Detects income duplicate
00:00 +3: All tests passed!
```

== Sample Engine Outputs & PDF Compilation

#styled-table(
  columns: (1.5fr, 2.0fr, 1.5fr),
  headers: ("Subsystem", "Input Conditions", "Output Result"),
  "PDF Report Generator", "July 1 – July 24 Date Range", "Valid A4 Binary PDF byte stream with Summary, Tables, and Category breakdown.",
  "Quartile Heatmap", "90-day expense array (₹0 – ₹4,500)", "Normalized intensity levels: Level 0 (₹0), Level 1 (₹1–₹250), Level 2 (₹250–₹750), Level 3 (₹750–₹1,800), Level 4 (>₹1,800).",
  "What-If Simulator", "Cut Food 20% (₹1.6k) + Shop 30% (₹1.2k)", "Extra Monthly Savings: ₹2,800 -> Goal \"MacBook\" accelerated by 2.4 months.",
  "Budget Alert Engine", "Category \"Food\" reaches ₹6,450 / ₹8,000", "Dispatches 80% Threshold Push Notification with Category Deep Link payload."
)

== Demo Data Seeding

Deterministic seeder (`demo_data.dart`) seeds:
- 9 Primary categories with pre-assigned color tokens and Lucide icons.
- 90 days of synthetic transactions (~180 records) using `Random(42)`.
- 5 Monthly envelope budgets (Food ₹8k, Transport ₹3k, Rent ₹13k, Shopping ₹4k, Bills ₹3k).
- 2 Active savings goals (Emergency Fund ₹50,000, Laptop ₹80,000).

== UI Wireframe Mockups

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 10pt,
  block(
    stroke: 0.8pt + rgb("0D7377"),
    radius: 4pt,
    inset: 8pt,
    fill: rgb("FBFDFD"),
    [
      #align(center)[#text(weight: "bold", size: 9pt, fill: rgb("0D7377"))[Home Dashboard]]
      #v(4pt)
      #line(length: 100%, stroke: 0.4pt + luma(180))
      #v(4pt)
      #text(size: 8pt)[
        *9:41* #h(1fr) *100%*\
        #text(size: 10pt, weight: "bold")[July 2026]\
        #v(2pt)
        #block(fill: rgb("E8F4F4"), inset: 5pt, radius: 3pt, width: 100%)[
          #text(size: 7.5pt)[Total Balance]\
          #text(size: 11pt, weight: "bold", fill: rgb("0D7377"))[₹ 32,450]\
          #text(size: 7pt, fill: luma(100))[Spent: ₹18,200 | Income: ₹45k]
        ]
        #v(3pt)
        *Monthly Budgets*\
        Food: ₹6.4k / ₹8k (80% ⚡)\
        Rent: ₹13k / ₹13k (100% ⚠️)\
        #v(3pt)
        *Upcoming Bills*\
        Rent ₹13k (5d) • Netflix (1d)
      ]
    ]
  ),
  block(
    stroke: 0.8pt + rgb("0D7377"),
    radius: 4pt,
    inset: 8pt,
    fill: rgb("FBFDFD"),
    [
      #align(center)[#text(weight: "bold", size: 9pt, fill: rgb("0D7377"))[Insights & Analytics]]
      #v(4pt)
      #line(length: 100%, stroke: 0.4pt + luma(180))
      #v(4pt)
      #text(size: 8pt)[
        *9:41* #h(1fr) *100%*\
        #text(size: 10pt, weight: "bold")[Spending Insights]\
        #v(2pt)
        *Activity Heatmap (Jul 2026)*\
        #text(size: 7.5pt, fill: rgb("0D7377"))[■ ■ ■ ■ ■ ■ ■ (Quartiles)]\
        #v(3pt)
        *Spend Calendar*\
        M  T  W  T  F  S  S\
        1  2  3  4  5  6  7\
        •  •• •  ••• • •• •\
        #v(3pt)
        *Burn Rate:* ₹606 / day\
        #text(size: 7.5pt, weight: "bold", fill: rgb("0D7377"))[[Download PDF Report]]
      ]
    ]
  ),
  block(
    stroke: 0.8pt + rgb("0D7377"),
    radius: 4pt,
    inset: 8pt,
    fill: rgb("FBFDFD"),
    [
      #align(center)[#text(weight: "bold", size: 9pt, fill: rgb("0D7377"))[PDF Report Preview]]
      #v(4pt)
      #line(length: 100%, stroke: 0.4pt + luma(180))
      #v(4pt)
      #text(size: 8pt)[
        #block(fill: rgb("0D7377"), inset: 4pt, radius: 2pt, width: 100%)[
          #text(size: 7.5pt, fill: white, weight: "bold")[BudgetLite Report]\
          #text(size: 6pt, fill: white)[Jul 1 - Jul 24, 2026]
        ]
        #v(3pt)
        *Income:* ₹45,000\
        *Expenses:* ₹18,200\
        *Net Savings:* ₹26,800\
        #v(3pt)
        *Category Breakdown*\
        Food: ₹6,400 (42%)\
        Rent: ₹13,000 (48%)\
        #v(3pt)
        #text(size: 7pt, fill: luma(100))[Generated on-device via pdf/printing]
      ]
    ]
  )
)

// ==========================================
// SECTION 11: CONCLUSION & ROADMAP
// ==========================================

= Conclusion & CA2 (75%) Roadmap

At the *50% Submission milestone* (commit `b5376d0`), BudgetLite has successfully evolved into a secure, comprehensive, offline financial management system. The core reactive architecture guarantees zero cloud leakage while delivering advanced features such as on-device PDF generation, biometric security, visual spending heatmaps, and proactive budget alerts.

*Roadmap for CA2 (75% Submission):*
- *Dynamic Multi-Currency Engine:* Local offline exchange rate caching and conversion across INR, USD, EUR, and GBP.
- *Automated Encrypted Cloud Bridge:* Optional end-to-end encrypted backup syncing to personal WebDAV/Google Drive storage.
- *On-Device Receipt OCR:* Camera-driven receipt scanner extracting line-item totals using Google ML Kit.
- *Advanced Export Customizer:* Custom CSV and Excel export templates with filtering by payment mode and tags.

// ==========================================
// SECTION 12: APPENDIX - SOURCE INVENTORY
// ==========================================

= Appendix: Source File Inventory

The complete source snapshot at commit `b5376d0` comprises the following key modules:

#styled-table(
  columns: (2.2fr, 3.2fr),
  headers: ("Source File Path", "Core Architectural Responsibility"),
  "lib/main.dart", "Application entry point, orientation lock, Quick Actions setup.",
  "lib/app.dart", "App shell, biometric authentication guard, theme switcher, 5-tab navigation.",
  "lib/core/database/tables.dart", "Declarative Drift table definitions (7 relational tables).",
  "lib/core/database/database.dart", "Database class, DAOs, schema versioning (v1 -> v2), category seeding.",
  "lib/core/theme/app_theme.dart", "Material 3 light/dark theme specifications and typography tokens.",
  "lib/core/theme/colors.dart", "Custom teal accent palette and semantic color tokens.",
  "lib/core/utils/notification_service.dart", "Local notification scheduling and budget limit push alerts.",
  "lib/core/utils/sms_parser.dart", "Regex heuristics and merchant parsing for bank SMS alerts.",
  "lib/core/utils/duplicate_detector.dart", "Fuzzy duplicate transaction detector algorithm.",
  "lib/core/utils/categorization_rule.dart", "User-configurable keyword regex auto-categorization engine.",
  "lib/core/utils/csv_importer.dart", "Quote-safe CSV bank statement ingestion utility.",
  "lib/core/utils/demo_data.dart", "Deterministic 90-day demo dataset generator (Random(42)).",
  "lib/features/insights/pdf_report_generator.dart", "Multi-page A4 PDF financial statement builder.",
  "lib/features/insights/insights_screen.dart", "Visual analytics hub, cash flow velocity, top merchants.",
  "lib/features/insights/contribution_graph.dart", "Quartile-based GitHub-style activity heatmap widget.",
  "lib/features/insights/spend_calendar.dart", "Interactive monthly/weekly spend intensity calendar.",
  "lib/features/goals/what_if_simulator_sheet.dart", "Slider-driven scenario simulator for accelerated savings.",
  "lib/features/transactions/split_transaction_sheet.dart", "Multi-category transaction allocation modal.",
  "lib/features/settings/settings_screen.dart", "Biometrics toggle, auto-lock timeout, theme selector, backup.",
  "lib/providers/insights_provider.dart", "Reactive analytics, date-range filtering, and quartile calculations.",
  "lib/providers/transaction_provider.dart", "Ledger CRUD, multi-category splits, recurring auto-posting.",
  "lib/providers/budget_provider.dart", "Monthly envelopes, threshold alerts, category deep link focus.",
  "lib/providers/goal_provider.dart", "Savings goal target tracking and what-if simulation states.",
  "lib/providers/settings_provider.dart", "JSON backup/restore, biometrics settings, custom rule persistence.",
  "test/duplicate_detector_test.dart", "Unit tests for transaction duplicate detection.",
  "test/sms_parser_test.dart", "Heuristic parser test suite across diverse bank SMS formats."
)

#v(20pt)
#align(center)[
  #text(size: 8.5pt, fill: luma(120), style: "italic")[
    BudgetLite — CA1 Mini Project (50% Submission) • Course ASDT • Aadish das (UID: 24BIT010, Roll No: 10)\
    Snapshot: commit b5376d0 (Jul 24, 2026) • Built with Flutter, Riverpod, and Drift.
  ]
]
