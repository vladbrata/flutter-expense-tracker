import 'package:expense_tracker/services/db_service.dart';
import 'package:expense_tracker/services/user_class.dart';
import 'package:expense_tracker/style/app_styles.dart';
import 'package:expense_tracker/widgets/income_category_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/services/category_class.dart';
import 'package:provider/provider.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  late ValueNotifier<Color> _selectedCategoryColor;
  late ValueNotifier<String> _selectedType;
  late ValueNotifier<IconData> _selectedExpenseIcon;
  late ValueNotifier<IconData> _selectedIncomeIcon;
  late TextEditingController categoryNameController;

  final List<Color> _categoryColors = const [
    Color(0xFF4CAF50), // Verde (Succes/Profit)
    Color(0xFFF44336), // Roșu (Cheltuieli/Urgențe)
    Color(0xFF2196F3), // Albastru (Facturi/Educație)
    Color(0xFFFFEB3B), // Galben (Divertisment)
    Color(0xFF9C27B0), // Violet (Sănătate/Lifestyle)
    Color(0xFFFF9800), // Portocaliu (Transport)
    Color(0xFF00BCD4), // Turcoaz (Cumpărături)
    Color(0xFFE91E63), // Roz (Cadouri)
    Color(0xFF795548), // Maro (Diverse)
    Color(0xFF607D8B), // Gri-Albastru (Economii)
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryColor = ValueNotifier<Color>(const Color(0xFF4CAF50));
    _selectedType = ValueNotifier<String>("Expense");
    _selectedExpenseIcon = ValueNotifier<IconData>(Icons.shopping_cart);
    _selectedIncomeIcon = ValueNotifier<IconData>(Icons.payments);
    categoryNameController = TextEditingController();
  }

  @override
  void dispose() {
    _selectedCategoryColor.dispose();
    _selectedType.dispose();
    _selectedExpenseIcon.dispose();
    _selectedIncomeIcon.dispose();
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    // Lista de iconițe specifice cheltuielilor

    return Scaffold(
      backgroundColor: AppColors.globalBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.globalTextMainColor),
        backgroundColor: AppColors.globalAccentColor,
        title: const Text(
          'Add Category',
          style: TextStyle(color: AppColors.globalTextMainColor),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            height: 525,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: TextStyle(color: AppColors.globalTextMainColor),
                  controller: categoryNameController,

                  // 1. Validarea: returnează textul de eroare dacă e gol
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Category name cannot be empty';
                    }
                    return null;
                  },

                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    labelStyle: TextStyle(color: AppColors.globalTextMainColor),

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
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ValueListenableBuilder<String>(
                    valueListenable: _selectedType,
                    builder: (context, currentType, child) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              // Butonul Expense
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _selectedType.value = "Expense",

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentType == "Expense"
                                        ? AppColors.globalAccentColor
                                        : Colors.grey,
                                    foregroundColor: currentType == "Expense"
                                        ? Colors.black
                                        : Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: currentType == "Expense" ? 4 : 0,
                                  ),
                                  child: const Text(
                                    "Expense",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 15),

                              // Butonul Income
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _selectedType.value = "Income";
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentType == "Income"
                                        ? AppColors.globalAccentColor
                                        : Colors.grey,
                                    foregroundColor: currentType == "Income"
                                        ? Colors.black
                                        : Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: currentType == "Income" ? 4 : 0,
                                  ),
                                  child: const Text(
                                    "Income",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _selectedType.value == "Expense"
                              ? Column(
                                  children: [
                                    Text(
                                      "Choose an icon",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.globalAccentColor,
                                      ),
                                    ),
                                    ExpenseIconSelector(
                                      selectedExpenseIcon: _selectedExpenseIcon,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                      "Choose an icon",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.globalAccentColor,
                                      ),
                                    ),
                                    IncomeIconSelector(
                                      selectedIncomeIcon: _selectedIncomeIcon,
                                    ),
                                  ],
                                ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Choose a color",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.globalAccentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                _buildColorSelector(),
              ],
            ),
          ),

          Spacer(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              onPressed: () async {
                if (categoryNameController.text.isNotEmpty) {
                  // 1. Generăm referința și cheia UNICĂ în prealabil
                  final ref = FirebaseDatabase.instance
                      .ref("users/${user!.uid}/categories")
                      .push();
                  final String generatedId =
                      ref.key!; // Acesta este ID-ul tău sigur

                  // 2. Creăm obiectul și îi dăm ID-ul generat mai sus
                  MyCategory.current = MyCategory(
                    id: generatedId, // <--- ID-ul este acum cel din Firebase
                    name: categoryNameController.text.trim(),
                    type: _selectedType.value,
                    icon: _selectedExpenseIcon.value,
                    color: _selectedCategoryColor.value,
                  );

                  try {
                    // 3. Trimitem obiectul către DBService
                    // Poți modifica addNewCategory să folosească direct MyCategory.current!.id
                    await DBService().addNewCategory(
                      MyCategory.current!,
                      user!,
                    );

                    print("✅ Categoria a fost salvată cu ID-ul: $generatedId");

                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    print("❌ Eroare la salvare: $e");
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error saving category: $e")),
                      );
                    }
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
              child: const Text("Save Category"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return ValueListenableBuilder<Color>(
      valueListenable: _selectedCategoryColor,
      builder: (context, selectedColor, _) {
        return Container(
          height: 70,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categoryColors.length,
            itemBuilder: (context, index) {
              Color color = _categoryColors[index];
              bool isSelected = selectedColor == color;

              return GestureDetector(
                onTap: () {
                  // AICI se salvează preferința în variabilă la fiecare apăsare
                  _selectedCategoryColor.value = color;
                  print("Culoare selectată: ${color.toString()}");
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    // Feedback vizual: contur alb dacă e selectată
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : Border.all(color: Colors.transparent),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: AppColors.globalAccentColor,
                          size: 24,
                        )
                      : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ExpenseIconSelector extends StatefulWidget {
  const ExpenseIconSelector({Key? key, required this.selectedExpenseIcon})
    : super(key: key);

  final ValueNotifier<IconData> selectedExpenseIcon;

  @override
  _ExpenseIconSelectorState createState() => _ExpenseIconSelectorState();
}

class _ExpenseIconSelectorState extends State<ExpenseIconSelector> {
  final List<IconData> _expenseIcons = [
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.directions_car,
    Icons.home,
    Icons.bolt,
    Icons.water_drop,
    Icons.wifi,
    Icons.movie,
    Icons.fitness_center,
    Icons.medical_services,
    Icons.school,
    Icons.card_giftcard,
    Icons.flight,
    Icons.pets,
    Icons.checkroom,
    Icons.build,
    Icons.commute,
    Icons.coffee,
    Icons.lunch_dining,
    Icons.local_bar,
    Icons.icecream,
    Icons.theater_comedy,
    Icons.sports_esports,
    Icons.piano,
    Icons.brush,
    Icons.camera_alt,
    Icons.phone_android,
    Icons.laptop,
    Icons.watch,
    Icons.print,
    Icons.subscriptions,
    Icons.security,
    Icons.cleaning_services,
    Icons.handyman,
    Icons.eco,
    Icons.volunteer_activism,
    Icons.account_balance_wallet,
    Icons.savings,
    Icons.receipt_long,
    Icons.shopping_bag,
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<IconData>(
      valueListenable: widget.selectedExpenseIcon,
      builder: (context, selectedIcon, _) {
        return Container(
          height: 180, // Înălțime pentru a afișa cam 2-3 rânduri de iconițe
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: GridView.builder(
            scrollDirection:
                Axis.horizontal, // Defilare de la stânga la dreapta
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 rânduri de iconițe pe înălțime
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _expenseIcons.length,
            itemBuilder: (context, index) {
              IconData iconData = _expenseIcons[index];
              bool isSelected = selectedIcon == iconData;

              return GestureDetector(
                onTap: () => widget.selectedExpenseIcon.value = iconData,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.globalAccentColor
                        : Colors.grey[800]!.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Icon(
                    iconData,
                    color: isSelected ? Colors.black : Colors.white70,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class IncomeIconSelector extends StatefulWidget {
  const IncomeIconSelector({Key? key, required this.selectedIncomeIcon})
    : super(key: key);

  final ValueNotifier<IconData> selectedIncomeIcon;

  @override
  _IncomeIconSelectorState createState() => _IncomeIconSelectorState();
}

class _IncomeIconSelectorState extends State<IncomeIconSelector> {
  final List<IconData> _incomeIcons = [
    Icons.payments,
    Icons.account_balance,
    Icons.trending_up,
    Icons.monetization_on,
    Icons.savings,
    Icons.redeem,
    Icons.work,
    Icons.currency_exchange,
    Icons.card_giftcard,
    Icons.stars,
    Icons.add_chart,
    Icons.account_balance_wallet,
    Icons.sell,
    Icons.storefront,
    Icons.auto_graph,
    Icons.business_center,
    Icons.euro,
    Icons.attach_money,
    Icons.paid,
    Icons.inventory,
    Icons.diamond,
    Icons.volunteer_activism,
    Icons.token,
    Icons.qr_code_2,
    Icons.handshake,
    Icons.rocket_launch,
    Icons.celebration,
    Icons.local_atm,
    Icons.pie_chart,
    Icons.analytics,
    Icons.receipt,
    Icons.request_quote,
    Icons.wallet_membership,
    Icons.moving,
    Icons.workspace_premium,
    Icons.apartment,
    Icons.agriculture,
    Icons.laptop_mac,
    Icons.smartphone,
    Icons.groups,
    Icons.military_tech,
    Icons.card_membership,
    Icons.savings_outlined,
    Icons.price_check,
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<IconData>(
      valueListenable: widget.selectedIncomeIcon,
      builder: (context, selectedIcon, _) {
        return Container(
          height: 180, // Înălțime pentru a afișa cam 2-3 rânduri de iconițe
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: GridView.builder(
            scrollDirection:
                Axis.horizontal, // Defilare de la stânga la dreapta
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 rânduri de iconițe pe înălțime
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _incomeIcons.length,
            itemBuilder: (context, index) {
              IconData iconData = _incomeIcons[index];
              bool isSelected = selectedIcon == iconData;

              return GestureDetector(
                onTap: () => widget.selectedIncomeIcon.value = iconData,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.globalAccentColor
                        : Colors.grey[800]!.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Icon(
                    iconData,
                    color: isSelected ? Colors.black : Colors.white70,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
