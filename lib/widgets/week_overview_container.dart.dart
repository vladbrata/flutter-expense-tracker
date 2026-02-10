import 'package:flutter/material.dart';
import 'package:expense_tracker/services/transaction_service.dart';
import 'package:expense_tracker/style/app_styles.dart';

class WeekOverviewContainer extends StatefulWidget {
  final List<Expense> expenses;

  const WeekOverviewContainer({super.key, required this.expenses});

  @override
  State<WeekOverviewContainer> createState() => _WeekOverviewContainerState();
}

class _WeekOverviewContainerState extends State<WeekOverviewContainer> {
  // Inițial nul pentru a afișa totalul săptămânii la început
  int? _selectedWeekday;

  Map<int, double> _calculateDailyTotals() {
    Map<int, double> totals = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    for (var expense in widget.expenses) {
      if (expense.date.isAfter(
        startOfWeek.subtract(const Duration(seconds: 1)),
      )) {
        int weekday = expense.date.weekday;
        totals[weekday] = (totals[weekday] ?? 0) + expense.amount;
      }
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final dailyTotals = _calculateDailyTotals();
    final double maxAmount = dailyTotals.values.reduce((a, b) => a > b ? a : b);
    final double totalWeek = dailyTotals.values.fold(
      0,
      (sum, item) => sum + item,
    );

    // Determinăm ce sumă și ce etichetă afișăm în antet
    final double displayAmount = _selectedWeekday == null
        ? totalWeek
        : (dailyTotals[_selectedWeekday] ?? 0);

    final String displayLabel = _selectedWeekday == null
        ? "This Week"
        : _getWeekdayName(_selectedWeekday!);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${displayAmount.toStringAsFixed(0)} RON",
                style: TextStyle(
                  color: _selectedWeekday == null
                      ? Colors.grey
                      : AppColors.globalAccentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 1; i <= 7; i++)
                _buildBar(i, _getShortDayName(i), dailyTotals[i]!, maxAmount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index, String day, double amount, double maxAmount) {
    bool isSelected = _selectedWeekday == index;
    // Dacă nimic nu e selectat manual, putem evidenția opțional ziua curentă,
    // dar aici am lăsat selecția să fie strict la tap pentru claritate.

    double height = maxAmount > 0 ? (amount / maxAmount) * 120 : 0;
    if (height < 6 && amount > 0) height = 6;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Dacă apeși pe aceeași zi deja selectată, revenim la totalul săptămânii
          if (_selectedWeekday == index) {
            _selectedWeekday = null;
          } else {
            _selectedWeekday = index;
          }
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height > 0 ? height : 5,
            width: 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.globalAccentColor
                  : const Color(0xFF21262D),
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.globalAccentColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _getShortDayName(int day) {
    const names = {
      1: "Mon",
      2: "Tue",
      3: "Wed",
      4: "Thu",
      5: "Fri",
      6: "Sat",
      7: "Sun",
    };
    return names[day] ?? "";
  }

  String _getWeekdayName(int day) {
    const names = {
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday",
      7: "Sunday",
    };
    return names[day] ?? "";
  }
}
