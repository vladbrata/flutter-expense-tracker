import 'package:flutter/material.dart';
import 'package:expense_tracker/services/category_class.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4),
          // Eliminăm padding-ul manual (EdgeInsets.all(12)) pentru că IconButton adaugă spațiu
          // Folosim constrângeri pentru a păstra dimensiunea exactă a cercului
          width:
              44, // Dimensiunea totală a cercului (20 icon + ~24 padding implicit)
          height: 44,
          decoration: BoxDecoration(
            color: category.color, // Verde (Succes/Profit)
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: IconButton(
            // Eliminăm padding-ul implicit al IconButton pentru a centra perfect iconița
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              category.icon,
              color: isSelected ? Colors.green : Colors.white,
              size: 20, // Păstrăm dimensiunea iconiței cerută anterior
            ),
            onPressed: onTap,
          ),
        ),
        Text(
          category.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
