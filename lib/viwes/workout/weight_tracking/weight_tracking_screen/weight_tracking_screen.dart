import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_cheloper/viwes/workout/weight_tracking/weight_tracking_controller/weight_tracking_controller.dart';

class WeightTrackingScreen extends StatelessWidget {
  const WeightTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeightTrackingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Weight Chart Card
              _buildWeightChart(controller),

              SizedBox(height: 20.h),

              // Weight In Button
              _buildWeightInButton(controller, context),

              SizedBox(height: 20.h),

              // Weight Details
              Obx(() => _buildWeightDetails(controller)),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightChart(WeightTrackingController controller) {
    return Obx(() {
      final entries = controller.weightEntries.take(10).toList().reversed.toList();
      if (entries.isEmpty) {
        return Center(child: Text("Add weight entries to see chart"));
      }

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Column(
              children: [
                Text(
                  "Weight Chart",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  height: 1.h, // slightly thicker red line
                  width: 380.w,
                  color: Colors.black38,
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Chart
            SizedBox(
              height: 140.h, // more space for weight labels
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minY: entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 2,
                  maxY: entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: entries.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.weight);
                      }).toList(),
                      isCurved: false,
                      color: Colors.black,
                      barWidth: 3, // thicker line
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5, // slightly bigger dot
                            color: Colors.red,
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Weight Labels Above Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: entries.asMap().entries.map((entry) {
                final weight = entry.value.weight;
                return Container(
                  margin: EdgeInsets.only(bottom: 4.h), // move labels slightly higher
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: Colors.red),
                    color: Colors.white,
                  ),
                  child: Text(
                    "${weight.toStringAsFixed(1)} kg",
                    style: TextStyle(fontSize: 10.sp, color: Colors.red),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 12.h),

            Container(height: 3.h, color: Colors.red),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: entries.map((entry) {
                final date = entry.date;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    "${date.day}/${date.month}/${date.year.toString().substring(2)}",
                    style: TextStyle(fontSize: 10.sp, color: Colors.black87),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      );
    });
  }


  Widget _buildWeightInButton(WeightTrackingController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => controller.showWeightInputDialog(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Color(0xffFF0000),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            'Weight in',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightDetails(WeightTrackingController controller) {
    final entry = controller.latestEntry;
    if (entry == null) {
      return Center(
        child: Text(
          'No weight data available',
          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
        ),
      );
    }

    return Column(
      children: [
        _buildDetailRow('Weight', '${entry.weight} kg'),
        Divider(color: Colors.grey[300], thickness: 1.h),
        _buildDetailRow('Date', '${entry.date.month}/${entry.date.day}/${entry.date.year.toString().substring(2)}'),
        Divider(color: Colors.grey[300], thickness: 1.h),
        if (entry.bodyFat != null) ...[
          _buildDetailRow('Body Fat', '${entry.bodyFat}%'),
          Divider(color: Colors.grey[300], thickness: 1.h),
        ],
        if (entry.waist != null) ...[
          _buildDetailRow('Waist', '${entry.waist} cm'),
          Divider(color: Colors.grey[300], thickness: 1.h),
        ],
        if (entry.neck != null) ...[
          _buildDetailRow('Neck', '${entry.neck} cm'),
          Divider(color: Colors.grey[300], thickness: 1.h),
        ],
        if (entry.arm != null) ...[
          _buildDetailRow('Arm', '${entry.arm} cm'),
          Divider(color: Colors.grey[300], thickness: 1.h),
        ],
        if (entry.calves != null) ...[
          _buildDetailRow('Calves', '${entry.calves} cm'),
          Divider(color: Colors.grey[300], thickness: 1.h),
        ],
        if (entry.thigh != null)
          _buildDetailRow('Thigh', '${entry.thigh} cm'),
      ],
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

