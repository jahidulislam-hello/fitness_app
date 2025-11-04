//
// // Slider for weight change
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gym_cheloper/viwes/screens/auths/controller/calculate_controller.dart';
//
// class WeightSlider extends StatefulWidget {
//   const WeightSlider({super.key});
//
//   @override
//   State<WeightSlider> createState() => _WeightSliderState();
// }
//
// class _WeightSliderState extends State<WeightSlider> {
//   double _value = 0.8; // initial
//   final CalculateController calculateController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Labels
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               _LabelBox(text: "0.1 kg"),
//               _LabelBox(text: "0.8 kg"),
//               _LabelBox(text: "1.5 kg"),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         // Slider
//         SliderTheme(
//           data: SliderTheme.of(context).copyWith(
//             trackHeight: 12,
//             inactiveTrackColor: Colors.grey.shade300,
//             activeTrackColor: Colors.black87,
//             thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
//             overlayShape: SliderComponentShape.noOverlay,
//           ),
//           child: Slider(
//             min: 0.1,
//             max: 1.5,
//             value: _value,
//             onChanged: (val) {
//               setState(() => _value = val);
//               calculateController.weightChangeValue = val;
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _LabelBox extends StatelessWidget {
//   final String text;
//   const _LabelBox({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(6),
//         color: Colors.white,
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 12, color: Colors.black87),
//       ),
//     );
//   }
// }
