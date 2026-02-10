import 'package:expense_tracker/pages/add_category_page.dart';
import 'package:expense_tracker/services/category_class.dart';
import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/widgets/category_container.dart';
import 'package:firebase_database/firebase_database.dart';
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
  String _selectedCategory = "";
  DateTime _selectedDate = DateTime.now();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void>? _categoriesFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<MyUser?>(context);
    if (user != null && _categoriesFuture == null) {
      _categoriesFuture = DBService().fetchCategories(user);
    }
  }

  // --- LOGICA ȘTERGERE CATEGORIE ---
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
          // Buton Cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          // Buton Delete
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              // DEBUG: Verificăm în consolă dacă avem ID-ul necesar
              print("--- LOGICĂ ȘTERGERE ---");
              print("ID Categorie: ${cat.id}");
              print("Nume Categorie: ${cat.name}");

              if (cat.id.isNotEmpty) {
                print("✅ ID valid, ștergem din Firebase...");
                try {
                  // 1. Ștergere din Firebase
                  await DBService()
                      .deleteCategory(user.uid, cat.id)
                      .timeout(const Duration(seconds: 5));
                  print("✅ Șters din Firebase");

                  // 2. Închidem dialogul
                  if (mounted) Navigator.pop(context);

                  // 3. Update UI local - ACESTA face refresh-ul vizual
                  setState(() {
                    // Eliminăm din lista locală a utilizatorului
                    user.categories.removeWhere(
                      (element) => element.id == cat.id,
                    );

                    // Dacă era categoria selectată, resetăm selecția
                    if (_selectedCategory == cat.name) {
                      _selectedCategory = "";
                    }
                  });

                  print("✅ UI Actualizat local");
                } catch (e) {
                  print("❌ Eroare la ștergere: $e");
                }
              } else {
                print(
                  "⚠️ Eroare: Categoria nu are ID (este o categorie veche)",
                );
                // Chiar dacă n-are ID în DB, o scoatem din listă să nu o mai vadă userul
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
              // Selector Tip Tranzactie
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

                    // Sectiune Categorii
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
            }),
          ),
          _typeBtn(
            "Income",
            _isIncome,
            () => setState(() {
              _isExpense = false;
              _isIncome = true;
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
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            return GestureDetector(
              onLongPress: () => _showDeleteDialog(user!, cat),
              child: CategoryContainer(
                category: cat,
                isSelected: cat.name == _selectedCategory,
                onTap: () => setState(() => _selectedCategory = cat.name),
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
          child: const Text(
            "Save Transaction",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave(MyUser? user) async {
    if (user != null &&
        amountController.text.isNotEmpty &&
        _selectedCategory.isNotEmpty) {
      try {
        await DBService().saveTransaction(
          uid: user.uid,
          amount: double.parse(amountController.text),
          title: _selectedCategory,
          transactionType: _isIncome ? 'income' : 'expenses',
          date: _selectedDate.toIso8601String(),
          comment: descriptionController.text,
        );
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error saving!")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Complete all fields!")));
    }
  }
}
