// import 'package:flutter/material.dart';
//
// class FoodPopup extends StatefulWidget {
//   const FoodPopup({Key? key}) : super(key: key);
//
//   @override
//   State<FoodPopup> createState() => _FoodPopupState();
// }
//
// class _FoodPopupState extends State<FoodPopup> {
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _servingController = TextEditingController();
//   bool _isFavorite = false;
//
//   @override
//   void dispose() {
//     _quantityController.dispose();
//     _servingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: 24,
//           right: 24,
//           top: 24,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Expanded(
//                   child: Text(
//                     'Turkey & Queso Magro Wraps',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1A1A),
//                       height: 1.3,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 // Favorite Button
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _isFavorite = !_isFavorite;
//                     });
//                   },
//                   child: Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: _isFavorite
//                           ? const Color(0xFFFF0000)
//                           : const Color(0xFFFFE5E5),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       _isFavorite ? Icons.favorite : Icons.favorite,
//                       color: _isFavorite
//                           ? Colors.white
//                           : const Color(0xFFFF0000),
//                       size: 22,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Close Button
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     width: 48,
//                     height: 48,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFF0F0F0),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.close,
//                       color: Color(0xFF666666),
//                       size: 22,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),
//
//             // Nutrition Cards Grid
//             Row(
//               children: [
//                 _buildNutritionCard('179', 'kCal'),
//                 const SizedBox(width: 12),
//                 _buildNutritionCard('23.5 g', 'Protein'),
//                 const SizedBox(width: 12),
//                 _buildNutritionCard('23.5 g', 'Carbs'),
//                 const SizedBox(width: 12),
//                 _buildNutritionCard('23.5 g', 'Fat'),
//               ],
//             ),
//             const SizedBox(height: 32),
//
//             // Input Fields
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Quantity',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildTextField(_quantityController),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Serving',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildTextField(_servingController),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             // Add Food Button
//             SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle add food action
//                   print('Quantity: ${_quantityController.text}');
//                   print('Serving: ${_servingController.text}');
//                   Navigator.of(context).pop();
//
//                   // Show success message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Food added successfully!'),
//                       backgroundColor: Color(0xFF4CAF50),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFF0000),
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(28),
//                   ),
//                 ),
//                 child: const Text(
//                   'Add Food',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNutritionCard(String value, String label) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF0F0F0),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1A1A1A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w400,
//                 color: Color(0xFF666666),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller) {
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: const Color(0xFFE0E0E0),
//           width: 2,
//         ),
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//         style: const TextStyle(
//           fontSize: 15,
//           color: Color(0xFF1A1A1A),
//         ),
//       ),
//     );
//   }
// }