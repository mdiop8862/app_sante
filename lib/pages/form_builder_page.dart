import 'package:appli_ap_sante/pages/test_result_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomFormBuilderPage extends StatefulWidget {
  const CustomFormBuilderPage({super.key, required this.title, required this.formFields});
  final String title;
  final List<CustomFormField> formFields;
  @override
  State<CustomFormBuilderPage> createState() => _CustomFormBuilderPageState();
}

class _CustomFormBuilderPageState extends State<CustomFormBuilderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 30),
        padding: const EdgeInsets.symmetric(horizontal: 25).copyWith(top: 20),
        itemCount: widget.formFields.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.formFields[index].title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
            ),
            const SizedBox(height: 16),
            Text(
              widget.formFields[index].labelText,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0xFF8E8E8E)),
            ),
            const SizedBox(height: 20),
            TextField(
              cursorColor: AppColor.appWhite,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: const Color(0xFF111111),
                filled: true,
                hintText: widget.formFields[index].hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 40, top: 15),
        child: ElevatedButton(
          onPressed: () => Get.off(() => const TestResultPage()),
          style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45)),
          child: const Text('Terminer'),
        ),
      ),
    );
  }
}

class CustomFormField {
  final String title, labelText;
  final String? hintText;
  CustomFormField({required this.title, required this.labelText, this.hintText});
}
