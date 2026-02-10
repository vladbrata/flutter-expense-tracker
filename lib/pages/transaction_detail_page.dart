// import 'package:expense_tracker/services/transaction_service.dart';
// import 'package:expense_tracker/style/app_styles.dart';
// import 'package:flutter/material.dart';

// class TransactionDetailPage extends StatefulWidget {
//   TransactionDetailPage({
//     Key? key,
//     required this.transaction,
//     required this.category,
//   }) : super(key: key);

//   final dynamic transaction;
//   final dynamic category;

//   @override
//   _TransactionDetailPageState createState() => _TransactionDetailPageState();
// }

// class _TransactionDetailPageState extends State<TransactionDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.globalBackgroundColor,
//       appBar: AppBar(
//         title: Text(
//           widget.transaction is Income ? "Income Details" : "Expense Details",
//           textAlign: TextAlign.center,
//           style: TextStyle(color: AppColors.globalTextMainColor),
//         ),
//         backgroundColor: AppColors.globalAccentColor,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             child: Column(
//               children: [
//                 Container(
//                   height: 150,
//                   width: double.infinity,
//                   color: AppColors.globalAccentColor,
//                   child: Column(children: [widget.category.icon]),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
