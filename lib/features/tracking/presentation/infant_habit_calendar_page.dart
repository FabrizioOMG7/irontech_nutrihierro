import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/monthly_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';

class InfantHabitCalendarPage extends ConsumerStatefulWidget {
  final Child child;

  const InfantHabitCalendarPage({super.key, required this.child});

  @override
  ConsumerState<InfantHabitCalendarPage> createState() => _InfantHabitCalendarPageState();
}

class _InfantHabitCalendarPageState extends ConsumerState<InfantHabitCalendarPage> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = MonthlyRecordsQuery(
      childId: widget.child.id,
      month: _currentMonth.month,
      year: _currentMonth.year,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Suplementos')),
      body: ResponsiveContent(
        child: Column(
          children: [
            _MonthSelector(
              currentMonth: _currentMonth,
              onPrevious: _previousMonth,
              onNext: _nextMonth,
            ),
            Expanded(
              child: AsyncValueView(
                value: ref.watch(monthlyRecordsProvider(query)),
                errorPrefix: 'Error al cargar historial',
                loadingMessage: 'Cargando registros...',
                dataBuilder: (records) {
                  return _CalendarGrid(
                    currentMonth: _currentMonth,
                    records: records,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.currentMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    final monthName = months[currentMonth.month - 1];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Text(
            '$monthName ${currentMonth.year}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime currentMonth;
  final List<DailyRecord> records;

  const _CalendarGrid({
    required this.currentMonth,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    // Suplementos days map for quick lookup
    final Map<int, bool> daysWithSupplement = {};
    for (final record in records) {
      if (record.sourceType == IronSourceType.supplement) {
        daysWithSupplement[record.date.day] = true;
      }
    }

    // Days of week header
    final daysOfWeek = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: daysOfWeek.map((day) =>
                SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                  )
                )
              ).toList(),
            ),
            const SizedBox(height: AppSpacing.sm),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
              ),
              itemCount: daysInMonth + startingWeekday - 1,
              itemBuilder: (context, index) {
                if (index < startingWeekday - 1) {
                  return const SizedBox.shrink(); // Empty slots before 1st day
                }

                final dayNumber = index - startingWeekday + 2;
                final isCompleted = daysWithSupplement[dayNumber] == true;
                final dayDate = DateTime(currentMonth.year, currentMonth.month, dayNumber);
                final isPast = dayDate.isBefore(normalizedToday);
                final isMissed = !isCompleted && isPast;
                final dayColors = _resolveDayColors(
                  isCompleted: isCompleted,
                  isMissed: isMissed,
                );

                return Container(
                  decoration: BoxDecoration(
                    color: dayColors.fill,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dayColors.border,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: AppColors.success, size: 20)
                        : Text('$dayNumber', style: TextStyle(color: dayColors.text)),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(40),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.success, width: 2),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text('Dosis completada'),
                const SizedBox(width: AppSpacing.md),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(30),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.error, width: 2),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text('Olvido'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _DayColors {
  final Color fill;
  final Color border;
  final Color text;

  const _DayColors({
    required this.fill,
    required this.border,
    required this.text,
  });
}

_DayColors _resolveDayColors({required bool isCompleted, required bool isMissed}) {
  if (isCompleted) {
    return _DayColors(
      fill: AppColors.success.withAlpha(40),
      border: AppColors.success,
      text: AppColors.success,
    );
  }
  if (isMissed) {
    return _DayColors(
      fill: AppColors.error.withAlpha(30),
      border: AppColors.error,
      text: AppColors.error,
    );
  }
  return _DayColors(
    fill: Colors.grey.withAlpha(20),
    border: Colors.grey.withAlpha(50),
    text: Colors.grey.shade600,
  );
}
