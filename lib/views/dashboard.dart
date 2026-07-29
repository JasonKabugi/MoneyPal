import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // ---- Mock data (swap these out once real data is wired up) ----
  final double totalBalance = 24500;
  final double monthlyIncome = 45000;
  final double monthlyExpenses = 20500;

  final List<_CategorySpend> categorySpending = const [
    _CategorySpend("Food", 8200, Colors.orange),
    _CategorySpend("Transport", 4500, Colors.blue),
    _CategorySpend("Bills", 5300, Colors.purple),
    _CategorySpend("Shopping", 1800, Colors.pink),
    _CategorySpend("Other", 700, Colors.teal),
  ];

  final List<_BudgetCategory> budgets = const [
    _BudgetCategory("Food", 8200, 10000, Colors.orange),
    _BudgetCategory("Transport", 4500, 5000, Colors.blue),
    _BudgetCategory("Bills", 5300, 6000, Colors.purple),
  ];

  String formatKsh(double value) {
    return "KSh ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tertiaryColor,
        foregroundColor: Colors.white,
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _balanceCard(),
            const SizedBox(height: 16),
            _incomeExpenseRow(),
            const SizedBox(height: 24),
            const Text(
              "Spending by Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _spendingPieChart(),
            const SizedBox(height: 24),
            const Text(
              "Budget Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _budgetRings(),
          ],
        ),
      ),
    );
  }

  Widget _balanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tertiaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            formatKsh(totalBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _incomeExpenseRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            "Income",
            formatKsh(monthlyIncome),
            Icons.arrow_downward,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            "Expenses",
            formatKsh(monthlyExpenses),
            Icons.arrow_upward,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _spendingPieChart() {
    final total = categorySpending.fold<double>(0, (sum, c) => sum + c.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: categorySpending.map((c) {
                  final percent = (c.amount / total * 100);
                  return PieChartSectionData(
                    value: c.amount,
                    color: c.color,
                    title: "${percent.toStringAsFixed(0)}%",
                    radius: 40,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categorySpending.map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: c.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c.label,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _budgetRings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: budgets.map((b) {
        final percent = (b.spent / b.limit).clamp(0.0, 1.0);
        return Column(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 8,
                      backgroundColor: b.color.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(b.color),
                    ),
                  ),
                  Text(
                    "${(percent * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              b.label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              "${formatKsh(b.spent)} / ${formatKsh(b.limit)}",
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _CategorySpend {
  final String label;
  final double amount;
  final Color color;
  const _CategorySpend(this.label, this.amount, this.color);
}

class _BudgetCategory {
  final String label;
  final double spent;
  final double limit;
  final Color color;
  const _BudgetCategory(this.label, this.spent, this.limit, this.color);
}
