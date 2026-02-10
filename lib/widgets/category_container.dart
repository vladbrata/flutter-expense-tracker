import 'package:expense_tracker/services/user_class.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/services/category_class.dart';
import 'package:expense_tracker/style/app_styles.dart'; // Asigură-te că importi stilurile pentru globalAccentColor
import 'package:provider/provider.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final MyCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Acesta declanșează selecția în pagina AddTransactionPage
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 4),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              // Culoarea cercului rămâne cea salvată în categorie
              color: category.color,
              shape: BoxShape.circle,
              // Adăugăm o bordură albă sau aurie la selecție pentru a evidenția cercul
              border: isSelected
                  ? Border.all(color: AppColors.globalAccentColor, width: 3)
                  : Border.all(color: Colors.transparent, width: 3),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.globalAccentColor.withOpacity(0.4),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              category.icon,
              // Culoarea iconiței se schimbă în funcție de selecție
              color: isSelected ? AppColors.globalAccentColor : Colors.white,
              size: 22,
            ),
          ),
          SizedBox(
            width: 60, // Limitează lățimea textului pentru a nu strica grid-ul
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.globalAccentColor : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
