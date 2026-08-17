import 'package:flutter/material.dart';

class VerificationForm extends StatelessWidget {
  const VerificationForm({
    super.key,
    required this.formKey,
    required this.profileIdController,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.predecessorIdController,
    required this.validateRequired,
    required this.validateEmail,
    required this.validateLineage,
    required this.isObscured,
    required this.onToggleObscure,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController profileIdController;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController predecessorIdController;
  final String? Function(String?, String) validateRequired;
  final String? Function(String?) validateEmail;
  final String? Function(String?) validateLineage;
  final bool isObscured;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: profileIdController,
            validator: (value) => validateRequired(value, 'Profile ID'),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'LSA Profile ID',
              hintText: 'e.g. LSA-070826-001',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: fullNameController,
            validator: (value) => validateRequired(value, 'Full name'),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: emailController,
            validator: validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: phoneController,
            validator: (value) => validateRequired(value, 'Phone number'),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: predecessorIdController,
            validator: validateLineage,
            obscureText: isObscured,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Predecessor ID',
              hintText: 'Required for data lineage',
              prefixIcon: const Icon(Icons.account_tree_outlined),
              suffixIcon: IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  isObscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
