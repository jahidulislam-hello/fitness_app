import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_cheloper/daily_marcos/daily_macros_controller.dart';


class DailyMacroSheet extends StatelessWidget {
  DailyMacroSheet({super.key});

  final controller = Get.put(DailyMacroController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F3F3),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(34),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [


          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 14),

          /// Title
          const Text(
            "Daily Macro Goals",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          /// Calories Row
          _infoRow(
            title: "Calories",
            value: "2200 kCal",
          ),

          const Divider(height: 26),

          /// Carbs
          Obx(() => _macroRow(
            title: "Carbs",
            percent: controller.carbsPercent.value,
            value: "${controller.carbsGram.value.toInt()} g",
          )),

          const Divider(height: 26),

          /// Protein
          Obx(() => _macroRow(
            title: "Protein",
            percent: controller.proteinPercent.value,
            value: "${controller.proteinGram.value.toInt()} g",
          )),

          const Divider(height: 26),

          /// Fat
          Obx(() => _macroRow(
            title: "Fat",
            percent: controller.fatPercent.value,
            value: "${controller.fatGram.value.toInt()} g",
          )),

          const SizedBox(height: 28),

          /// Done Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: controller.done,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Done",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// Calculate Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: controller.calculateMacros,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text(
                "Calculate Macros",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Static Row (Calories)
  Widget _infoRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15),
        ),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }

  /// Macro Row With Progress
  Widget _macroRow({
    required String title,
    required double percent,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Title
        SizedBox(
          width: 70,
          child: Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
        ),

        const SizedBox(width: 10),

        /// Progress
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "${percent.toInt()}%",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        /// Value Box
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}