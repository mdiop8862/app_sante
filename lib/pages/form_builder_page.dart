import 'package:appli_ap_sante/pages/test_result_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomFormBuilderPage extends StatefulWidget {
  const CustomFormBuilderPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.formFields,
    required this.onSubmit,
  });

  final String title;
  final String? subtitle;
  final List<CustomFormField> formFields;
  final Function(Map<String, String>) onSubmit;

  @override
  State<CustomFormBuilderPage> createState() => _CustomFormBuilderPageState();
}

class _CustomFormBuilderPageState extends State<CustomFormBuilderPage> {
  final Map<String, String> _formValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Text(
              widget.subtitle ?? "",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              itemCount: widget.formFields.length,
              separatorBuilder: (_, __) => const SizedBox(height: 30),
              itemBuilder: (context, index) {
                final field = widget.formFields[index];

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

                    // Sélecteur ou champ texte
                    if (field.isSelectable && field.options != null)
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.grey[900],
                        value: _formValues[field.title],
                        onChanged: (value) {
                          setState(() {
                            if (value != null) _formValues[field.title] = value;
                          });
                        },
                        items: field.options!
                            .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option,
                              style:
                              const TextStyle(color: Colors.white)),
                        ))
                            .toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF111111),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        style:
                        const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    else
                      TextField(
                        cursorColor: AppColor.appWhite,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 30)
            .copyWith(bottom: 40, top: 15),
        child: ElevatedButton(
          onPressed: () {
            widget.onSubmit(_formValues);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Terminer'),
        ),
      ),
    );
  }
}

class CustomFormField {
  final String title;
  final String labelText;
  final String? hintText;
  final bool isSelectable;
  final List<String>? options;

  CustomFormField({
    required this.title,
    required this.labelText,
    this.hintText,
    this.isSelectable = false,
    this.options,
  });
}