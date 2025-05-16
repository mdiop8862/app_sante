import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utils/FirebaseManagement.dart';
import '../utils/automatiqueDetection.dart';
import '../widgets/custom_loader.dart'; // ou utils, selon où tu l’as mis


class CustomFormBuilderPage extends StatefulWidget {
  final String userId;
  final String title;
  final String? subtitle;
  final List<CustomFormField> formFields;
  final Function(Map<String, String>) onSubmit;

  const CustomFormBuilderPage({
    super.key,
    required this.userId,
    required this.title,
    this.subtitle,
    required this.formFields,
    required this.onSubmit,
  });



  @override
  State<CustomFormBuilderPage> createState() => _CustomFormBuilderPageState();
}

class _CustomFormBuilderPageState extends State<CustomFormBuilderPage> {
  final Map<String, String> _formValues = {};
  final Map<String, TextEditingController> _controllers = {};
  bool isModification = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadExistingData();
  }

  void _initControllers() {
    for (var field in widget.formFields) {
      _controllers[field.title] = TextEditingController();
    }
  }

  Future<void> _loadExistingData() async {
    final userData = await getUserTestData(widget.userId);
    final tests = userData['tests'] ?? {};
    final category = detectCategory(widget.title.toLowerCase());
    final testKey = normalizeTestKey(widget.formFields.first.title);

    final existingData = tests[category]?[testKey];
    if (existingData != null) {
      isModification = true ;
      for (var entry in existingData.entries) {
        final controller = _controllers[entry.key];
        if (controller != null) {
          controller.text = entry.value.toString();
          _formValues[entry.key] = entry.value.toString();
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void _handleSubmit() async {
    widget.onSubmit(_formValues);

    final String category = detectCategory(widget.title.toLowerCase());
    final String testKey = normalizeTestKey(widget.formFields.first.title);

    await saveFormDataToUserDoc(
      userId: widget.userId,
      category: category,
      testKey: testKey,
      data: _formValues,
    );

    Get.back(); // ou Navigator.pop(context);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const  CustomLoader(message: 'Récupération des données...')
          : Column(
        children: [
          if (widget.subtitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
                widget.subtitle!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              itemCount: widget.formFields.length,
              separatorBuilder: (_, __) => const SizedBox(height: 30),
              itemBuilder: (context, index) {
                final field = widget.formFields[index];
                final controller = _controllers[field.title]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      field.labelText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF8E8E8E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      cursorColor: AppColor.appWhite,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: const Color(0xFF111111),
                        filled: true,
                        hintText: field.hintText,
                        hintStyle: const TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _formValues[field.title] = value;
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 40, top: 15),
        child: ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(isModification ? 'Modifier' : 'Terminer'),
        ),
      ),
    );
  }
}

class CustomFormField {
  final String title;
  final String labelText;
  final String? hintText;

  CustomFormField({
    required this.title,
    required this.labelText,
    this.hintText,
  });
}
