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
  TextEditingController amountController = TextEditingController();
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
              Container(
                decoration: BoxDecoration(
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
                        onPressed: () {
                          setState(() {
                            _isExpense = true;
                            _isIncome = false;
                          });
                        },
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
                        onPressed: () {
                          setState(() {
                            _isExpense = false;
                            _isIncome = true;
                          });
                        },
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
              if (_isExpense)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.surface,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: amountController,
                              decoration: InputDecoration(),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                color: AppColors.globalTextMainColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          Text(
                            'RON cheltuit',
                            style: TextStyle(
                              color: AppColors.globalTextMainColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: _buildCategoriesContent(user),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // 1. Preluăm userul din Provider (cel setat în main.dart)
                            final user = Provider.of<MyUser?>(
                              context,
                              listen: false,
                            );

                            print(amountController.text);
                            // 2. Validăm datele (să nu fie goale)
                            if (user != null &&
                                amountController.text.isNotEmpty) {
                              print(
                                "User: ${user.name} vrea sa adauge o cheltuiala cu suma: ${amountController.text}",
                              );
                              try {
                                // Convertim textul în număr
                                double amount = double.parse(
                                  amountController.text.trim(),
                                );

                                // 3. Apelăm funcția din DBService
                                await DBService().saveTransaction(
                                  uid: user.uid,
                                  amount: amount,
                                  title: _selectedCategory,
                                  transactionType: _isIncome
                                      ? 'income'
                                      : 'expenses',
                                );

                                // 4. Succes! Închidem pagina sau arătăm un mesaj
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Expense Saved Successfully",
                                      ),
                                    ),
                                  );
                                  user.expenses.add(
                                    Expense(
                                      id: DateTime.now().toString(),
                                      userId: user.uid,
                                      amount: double.parse(
                                        amountController.text,
                                      ),
                                      title: _selectedCategory,
                                    ),
                                  );
                                  Navigator.pop(
                                    context,
                                    true,
                                  ); // Ne întoarcem la pagina anterioară
                                }
                              } catch (e) {
                                // Gestionăm eroarea (ex: dacă utilizatorul scrie litere în loc de cifre)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error: Invalid input!"),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.globalAccentColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: const Text("Save Expense"),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.surface,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: amountController,
                              decoration: InputDecoration(),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                color: AppColors.globalTextMainColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          Text(
                            'RON cheltuit',
                            style: TextStyle(
                              color: AppColors.globalTextMainColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: _buildCategoriesContent(user),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // 1. Preluăm userul din Provider (cel setat în main.dart)
                            final user = Provider.of<MyUser?>(
                              context,
                              listen: false,
                            );

                            print(amountController.text);
                            // 2. Validăm datele (să nu fie goale)
                            if (user != null &&
                                amountController.text.isNotEmpty) {
                              print(
                                "User: ${user.name} vrea sa adauge venit cu suma: ${amountController.text}",
                              );
                              try {
                                // Convertim textul în număr
                                double amount = double.parse(
                                  amountController.text.trim(),
                                );

                                // 3. Apelăm funcția din DBService
                                await DBService().saveTransaction(
                                  uid: user.uid,
                                  amount: amount,
                                  title: _selectedCategory,
                                  transactionType: _isIncome
                                      ? 'income'
                                      : 'expenses',
                                );

                                user.incomes.add(
                                  Income(
                                    id: DateTime.now().toString(),
                                    userId: user.uid,
                                    amount: double.parse(amountController.text),
                                    title: _selectedCategory,
                                  ),
                                );
                                // 4. Succes! Închidem pagina sau arătăm un mesaj
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Income saved successfully!",
                                      ),
                                    ),
                                  );
                                  Navigator.pop(
                                    context,
                                    true,
                                  ); // Ne întoarcem la pagina anterioară
                                }
                              } catch (e) {
                                // Gestionăm eroarea (ex: dacă utilizatorul scrie litere în loc de cifre)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Error: Invalid input!"),
                                  ),
                                );
                              }
                              print(user.incomes.last.title);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.globalAccentColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text("Save Income"),
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

  Widget _buildCategoriesContent(MyUser? user) {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtrăm categoriile în funcție de tipul selectat (Expense/Income)
    final filteredCategories = user.categories.where((cat) {
      if (_isExpense) return cat.type == "Expense";
      if (_isIncome) return cat.type == "Income";
      return false;
    }).toList();

    // Folosim +1 la itemCount pentru a face loc butonului de adăugare
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 0.85,
      ),
      itemCount:
          filteredCategories.length + 1, // Lista filtrată + butonul de plus
      itemBuilder: (context, index) {
        // Verificăm dacă suntem la ultimul element din Grid
        if (index == filteredCategories.length) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCategoryPage(),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // Folosim aceleași dimensiuni (padding 12) ca în CategoryContainer
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors
                        .grey[800], // O culoare neutră pentru butonul de adăugare
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppColors.globalTextMainColor,
                    size: 20, // Aceeași dimensiune ca iconițele tale
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Add",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        // Altfel, returnăm categoria normală din lista filtrată
        final cat = filteredCategories[index];
        return CategoryContainer(
          category: cat,
          isSelected: cat.name == _selectedCategory,
          onTap: () {
            setState(() {
              _selectedCategory = cat.name;
            });
            print("Selected category: $_selectedCategory");
          },
        );
      },
    );
  }
}
