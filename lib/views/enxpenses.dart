import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Map<String, dynamic>> expenses = [
    {"name": "Groceries", "category": "Food", "amount": 2500, "date": "12 Jul"},
    {
      "name": "Uber ride",
      "category": "Transport",
      "amount": 450,
      "date": "14 Jul",
    },
    {
      "name": "Electricity bill",
      "category": "Bills",
      "amount": 1800,
      "date": "15 Jul",
    },
    {
      "name": "New shoes",
      "category": "Shopping",
      "amount": 3200,
      "date": "18 Jul",
    },
    {"name": "Netflix", "category": "Other", "amount": 1100, "date": "20 Jul"},
  ];

  List<Map<String, dynamic>> filteredExpenses = [];
  final TextEditingController searchController = TextEditingController();

  final Map<String, IconData> categoryIcons = {
    "Food": Icons.restaurant,
    "Transport": Icons.directions_car,
    "Bills": Icons.receipt_long,
    "Shopping": Icons.shopping_bag,
    "Other": Icons.category,
  };

  final Map<String, Color> categoryColors = {
    "Food": Colors.orange,
    "Transport": Colors.blue,
    "Bills": Colors.purple,
    "Shopping": Colors.pink,
    "Other": Colors.teal,
  };

  @override
  void initState() {
    super.initState();
    filteredExpenses = List.from(expenses);
    searchController.addListener(_filterExpenses);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterExpenses() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredExpenses = expenses
          .where((e) => e["name"].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  String formatKsh(num value) {
    return "KSh ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}";
  }

  void _deleteExpense(Map<String, dynamic> expense) {
    setState(() {
      expenses.remove(expense);
      filteredExpenses.remove(expense);
    });
  }

  void _showExpenseDialog({Map<String, dynamic>? existing}) {
    final nameController = TextEditingController(text: existing?["name"] ?? "");
    final amountController = TextEditingController(
      text: existing != null ? existing["amount"].toString() : "",
    );
    String selectedCategory = existing?["category"] ?? "Food";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(existing == null ? "Add Expense" : "Edit Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Expense name",
                    ),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount (KSh)",
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: categoryIcons.keys
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() => selectedCategory = value!);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final amount = num.tryParse(amountController.text) ?? 0;
                    if (name.isEmpty || amount <= 0) return;

                    setState(() {
                      if (existing == null) {
                        expenses.add({
                          "name": name,
                          "category": selectedCategory,
                          "amount": amount,
                          "date": "Today",
                        });
                      } else {
                        existing["name"] = name;
                        existing["amount"] = amount;
                        existing["category"] = selectedCategory;
                      }
                      filteredExpenses = List.from(expenses);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expenses"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseDialog(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search expenses...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredExpenses.isEmpty
                  ? const Center(child: Text("No expenses found"))
                  : ListView.builder(
                      itemCount: filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        final category = expense["category"];
                        final color = categoryColors[category] ?? Colors.grey;

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color.withValues(alpha: 0.15),
                              child: Icon(
                                categoryIcons[category] ?? Icons.category,
                                color: color,
                              ),
                            ),
                            title: Text(
                              expense["name"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Category: $category\n"
                              "${formatKsh(expense["amount"])} · ${expense["date"]}",
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      _showExpenseDialog(existing: expense),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _deleteExpense(expense),
                                  icon: const Icon(
                                    Icons.delete,
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
      ),
    );
  }
}
