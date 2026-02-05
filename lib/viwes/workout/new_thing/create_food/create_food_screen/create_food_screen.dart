import 'package:flutter/material.dart';

class CreateFoodPopup extends StatefulWidget {
  const CreateFoodPopup({Key? key}) : super(key: key);

  @override
  State<CreateFoodPopup> createState() => _CreateFoodPopupState();
}

class _CreateFoodPopupState extends State<CreateFoodPopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _servingWeightController =
  TextEditingController(text: '150g');
  final TextEditingController _caloriesController =
  TextEditingController(text: '350 kCal');
  final TextEditingController _carbsController =
  TextEditingController(text: '350 Cal');
  final TextEditingController _proteinController =
  TextEditingController(text: '350 Cal');
  final TextEditingController _fatController =
  TextEditingController(text: '350 Cal');

  @override
  void dispose() {
    _nameController.dispose();
    _servingWeightController.dispose();
    _caloriesController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Create Food',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field - just text label
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 20),

                  // Serving weight Field
                  _buildInlineField('Serving weight', _servingWeightController, '150g'),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 16),

                  // Calories Field
                  _buildInlineField('Calories', _caloriesController, '350 kCal'),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 16),

                  // Carbs Field
                  _buildInlineField('Carbs', _carbsController, '350 Cal'),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 16),

                  // Protein Field
                  _buildInlineField('Protein', _proteinController, '350 Cal'),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Color(0xFFE0E0E0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 16),

                  // Fat Field
                  _buildInlineField('Fat', _fatController, '350 Cal'),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            // Add In Food Button
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle add food action
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add In Food',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Inline field with label on left and input on right
  Widget _buildInlineField(String label, TextEditingController controller, String placeholder) {
    return Row(
      children: [
        // Label on left
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
          ),
        ),
        const Spacer(),
        // Input box on right
        _buildInlineTextField(controller, placeholder),
      ],
    );
  }

  Widget _buildInlineTextField(TextEditingController controller, String placeholder) {
    return Container(
      width: 111,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF4E4E4E),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF666666),
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF999999),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
        ),
      ),
    );
  }
}

// Example usage:
void showCreateFoodPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return const CreateFoodPopup();
    },
  );
}