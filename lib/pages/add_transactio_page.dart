import 'package:expense_tracker/pages/add_category_page.dart';
import 'package:expense_tracker/services/category_class.dart';
import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/widgets/category_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  bool _isExpense = true;
  bool _isIncome = false;

  MyCategory? _selectedCategoryObject;
  String _selectedCategoryName = "";

  DateTime _selectedDate = DateTime.now();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void>? _categoriesFuture;

  @override
  void initState() {
    super.initState();
    // Adăugăm un listener pentru a forța UI-ul să se updateze când utilizatorul tastează suma
    amountController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<MyUser?>(context);
    if (user != null && _categoriesFuture == null) {
      _categoriesFuture = DBService().fetchCategories(user);
    }
  }

  void _showDeleteDialog(MyUser user, MyCategory cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Delete Category",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete '${cat.name}'?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (cat.id.isNotEmpty) {
                try {
                  await DBService()
                      .deleteCategory(user.uid, cat.id)
                      .timeout(const Duration(seconds: 5));

                  if (mounted) Navigator.pop(context);

                  setState(() {
                    user.categories.removeWhere(
                      (element) => element.id == cat.id,
                    );
                    if (_selectedCategoryName == cat.name) {
                      _selectedCategoryName = "";
                      _selectedCategoryObject = null;
                    }
                  });
                } catch (e) {
                  debugPrint("❌ Eroare la ștergere: $e");
                }
              } else {
                setState(() {
                  user.categories.removeWhere(
                    (element) => element.name == cat.name,
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.globalAccentColor,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.globalTextMainColor),
        backgroundColor: AppColors.globalAccentColor,
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: AppColors.globalTextMainColor),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.surface,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildAmountInput(),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Categories',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    _buildCategoriesContent(user),
                    const SizedBox(height: 20),
                    _buildDatePickerBtn(),
                    const SizedBox(height: 20),
                    _buildDescriptionField(),
                    const SizedBox(height: 30),
                    _buildSaveButton(user),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildTypeSelector() {
    return Container(
      color: AppColors.globalAccentColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _typeBtn(
            "Expense",
            _isExpense,
            () => setState(() {
              _isExpense = true;
              _isIncome = false;
              _selectedCategoryObject = null;
              _selectedCategoryName = "";
            }),
          ),
          _typeBtn(
            "Income",
            _isIncome,
            () => setState(() {
              _isExpense = false;
              _isIncome = true;
              _selectedCategoryObject = null;
              _selectedCategoryName = "";
            }),
          ),
        ],
      ),
    );
  }

  Widget _typeBtn(String label, bool active, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.globalTextMainColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          decoration: active ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            style: const TextStyle(color: Colors.white, fontSize: 28),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: "0",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        const Text(' RON', style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    );
  }

  Widget _buildCategoriesContent(MyUser? user) {
    return FutureBuilder(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            (user?.categories.isEmpty ?? true)) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.globalAccentColor,
            ),
          );
        }

        final filtered =
            user?.categories
                .where(
                  (cat) =>
                      _isExpense ? cat.type == "Expense" : cat.type == "Income",
                )
                .toList() ??
            [];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: filtered.length + 1,
          itemBuilder: (context, index) {
            if (index == filtered.length) {
              return _addCategoryBtn(user);
            }
            final cat = filtered[index];
            final bool isSelected =
                cat.id == _selectedCategoryObject?.id ||
                cat.name == _selectedCategoryName;

            return GestureDetector(
              onLongPress: () => _showDeleteDialog(user!, cat),
              onTap: () {
                setState(() {
                  _selectedCategoryName = cat.name;
                  _selectedCategoryObject = cat;
                });
              },
              child: CategoryContainer(
                category: cat,
                isSelected: isSelected, // Acesta va colora iconița/bordura
                onTap: () {
                  setState(() {
                    _selectedCategoryName = cat.name;
                    _selectedCategoryObject = cat;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _addCategoryBtn(MyUser? user) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCategoryPage()),
        );
        setState(() {
          _categoriesFuture = DBService().fetchCategories(user!);
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const Text(
            "Add",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerBtn() {
    return TextButton.icon(
      onPressed: () => _selectDate(context),
      icon: const Icon(
        Icons.calendar_today,
        color: AppColors.globalAccentColor,
      ),
      label: Text(
        "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}",
        style: const TextStyle(color: Colors.white),
      ),
      style: TextButton.styleFrom(
        backgroundColor: AppColors.globalAccentColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: AppColors.globalAccentColor),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: descriptionController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Description',
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.globalAccentColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(MyUser? user) {
    bool isReady =
        amountController.text.isNotEmpty && _selectedCategoryObject != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.globalAccentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () => _handleSave(user),
          child: Text(
            _isIncome ? "Save Income" : "Save Expense",
            style: TextStyle(
              color: AppColors.globalTextSecondaryColor,
              fontWeight: FontWeight.bold,

              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave(MyUser? user) async {
    final amount = amountController.text.trim();

    if (user != null && amount.isNotEmpty && _selectedCategoryObject != null) {
      try {
        await DBService().saveTransaction(
          uid: user.uid,
          amount: double.parse(amount),
          title: _selectedCategoryName,
          transactionType: _isIncome ? 'income' : 'expenses',
          date: _selectedDate.toIso8601String(),
          comment: descriptionController.text.trim(),
          category: _selectedCategoryObject!,
        );
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving transaction!")),
        );
      }
    } else {
      String missing = "";
      if (amount.isEmpty) missing = "amount";
      if (_selectedCategoryObject == null)
        missing += missing.isEmpty ? "category" : " and category";

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please provide $missing")));
    }
  }
}
