import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_cheloper/global widget/custom_button.dart';
import 'package:gym_cheloper/viwes/workout/popup/create_receipe/create_receipe_controller.dart';

class CreateRecipePopup extends StatefulWidget {
  const CreateRecipePopup({super.key});

  @override
  State<CreateRecipePopup> createState() => _CreateRecipePopupState();
}

class _CreateRecipePopupState extends State<CreateRecipePopup> {
  late final CreateRecipeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CreateRecipeController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onDone() {
    _controller.saveRecipe(
      onSuccess: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recipe saved successfully!'),
            backgroundColor: Color(0xFFE53935),
          ),
        );
        Navigator.of(context).pop();
      },
      onError: (msg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red.shade800,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            _buildHeader(),
            Expanded(
              child: _buildBody(),
            ),
            _buildFooter(),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              color: Colors.black87,
              size: 24.sp,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Create Recipe',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w), // Balance the close icon
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecipeNameField(),
          SizedBox(height: 16.h),
          _buildAddFoodButton(),
          SizedBox(height: 12.h),
          if (_controller.foodItems.isNotEmpty)
            ..._controller.foodItems
                .map((item) => _buildFoodItemCard(item))
                .toList(),
        ],
      ),
    );
  }

  Widget _buildRecipeNameField() {
    return TextField(
      controller: _controller.recipeNameController,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: 'Name of the Recipe',
        hintStyle: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w400,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE53935), width: 1.8),
        ),
      ),
    );
  }



  Widget _buildAddFoodButton() {
    return CustomButton(
      text: 'Add new Food',
      color: Colors.grey.shade400,
      textColor: Colors.white,
      radius: 10,
      onTap: _controller.addFoodItem,
    );
  }

  Widget _buildFoodItemCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) =>
                      _controller.updateFoodItemName(item.id, v),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Food name',
                    hintStyle:
                    TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFFE53935), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _controller.removeFoodItem(item.id),
                child: Icon(Icons.close_rounded,
                    size: 20, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) =>
                      _controller.updateFoodItemQuantity(item.id, v),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    hintStyle:
                    TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFFE53935), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (v) =>
                      _controller.updateFoodItemUnit(item.id, v),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Unit (g, ml, pcs…)',
                    hintStyle:
                    TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFFE53935), width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      child: _controller.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE53935),
              ),
            )
          : CustomButton(
              text: 'Done',
              color: const Color(0xFFE53935),
              textColor: Colors.white,
              radius: 10,
              onTap: _onDone,
            ),
    );
  }
}