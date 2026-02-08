import 'package:expense_tracker/pages/add_category_page.dart';
import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/transaction_service.dart';
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
  String _selectedCategory = "";
  DateTime _selectedDate = DateTime.now(); // Variabilă pentru data selectată
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Funcție pentru deschiderea calendarului în stilul aplicației
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors
                  .globalAccentColor, // Culoarea de selecție (galben/auriu)
              onPrimary: Colors.black, // Culoarea textului pe selecție
              surface: AppColors.surface, // Fundalul ferestrei
              onSurface: Colors.white, // Culoarea textului calendarului
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors
                    .globalAccentColor, // Culoarea butoanelor OK/Cancel
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    if (user != null) {
      DBService().fetchCategories(user);
    }

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
              // Header pentru comutare Expense/Income
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: AppColors.globalAccentColor,
                ),
                height: 50,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => setState(() {
                          _isExpense = true;
                          _isIncome = false;
                        }),
                        child: Text(
                          'Expense',
                          style: TextStyle(
                            color: AppColors.globalTextMainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            decoration: _isExpense
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setState(() {
                          _isExpense = false;
                          _isIncome = true;
                        }),
                        child: Text(
                          'Income',
                          style: TextStyle(
                            color: AppColors.globalTextMainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            decoration: _isIncome
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Container principal
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.only(bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.surface,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Input Sumă
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              color: AppColors.globalTextMainColor,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: "0",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const Text(
                          ' RON',
                          style: TextStyle(
                            color: AppColors.globalTextMainColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Secțiune Categorii
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              color: AppColors.globalTextMainColor,
                            ),
                          ),
                        ),
                        _buildCategoriesContent(user),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // BUTON CALENDAR (Uniformizat)
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(
                          Icons.calendar_today,
                          color: AppColors.globalAccentColor,
                        ),
                        label: Text(
                          "Data: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          backgroundColor: AppColors.globalAccentColor
                              .withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: AppColors.globalAccentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 15,
                      ),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        child: Center(
                          child: TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Add a Description',
                              labelStyle: TextStyle(
                                color: AppColors.globalTextMainColor,
                              ),

                              // Border-ul normal
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              // Border-ul când este apăsat
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: AppColors.globalAccentColor,
                                  width: 2.0,
                                ),
                              ),

                              // 2. STILUL PENTRU EROARE (Red text & Red border)
                              errorStyle: const TextStyle(color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Buton Salvare
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _handleSave(user),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.globalAccentColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            _isExpense ? "Save Expense" : "Save Income",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Logica de salvare
  Future<void> _handleSave(MyUser? user) async {
    if (user != null &&
        amountController.text.isNotEmpty &&
        _selectedCategory.isNotEmpty) {
      try {
        double amount = double.parse(amountController.text.trim());
        String type = _isIncome ? 'income' : 'expenses';

        // Salvare în Firebase
        await DBService().saveTransaction(
          uid: user.uid,
          amount: amount,
          title: _selectedCategory,
          transactionType: type,
          date: _selectedDate.toIso8601String(),
          comment: descriptionController.text.trim(),
        );

        // Adăugare locală pentru refresh instant
        if (_isExpense) {
          user.expenses.add(
            Expense(
              id: DateTime.now().toString(),
              userId: user.uid,
              amount: amount,
              title: _selectedCategory,
              date: _selectedDate,
              comment: descriptionController.text.trim(),
            ),
          );
        } else {
          user.incomes.add(
            Income(
              id: DateTime.now().toString(),
              userId: user.uid,
              amount: amount,
              title: _selectedCategory,
              date: _selectedDate,
              comment: descriptionController.text.trim(),
            ),
          );
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving transaction!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category and amount!")),
      );
    }
  }

  Widget _buildCategoriesContent(MyUser? user) {
    if (user == null) return const Center(child: CircularProgressIndicator());

    final filteredCategories = user.categories.where((cat) {
      return _isExpense ? cat.type == "Expense" : cat.type == "Income";
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Am mărit puțin dimensiunea pentru vizibilitate
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: filteredCategories.length + 1,
      itemBuilder: (context, index) {
        if (index == filteredCategories.length) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCategoryPage()),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
                const Text(
                  "Add",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        }
        final cat = filteredCategories[index];
        return CategoryContainer(
          category: cat,
          isSelected: cat.name == _selectedCategory,
          onTap: () => setState(() => _selectedCategory = cat.name),
        );
      },
    );
  }
}
