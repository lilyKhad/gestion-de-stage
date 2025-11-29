import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:med/core/features/auth/provider/loginProviders.dart';
import 'package:med/core/routers/role_navigation.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    
    // Check if user is already authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authStateProvider).value;
      if (user != null) {
        RoleNavigator.navigateBasedOnRole(context, user.role);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final formData = _formKey.currentState!.value;
        await ref.read(loginControllerProvider.notifier).login(
              email: formData['email'].toString().trim(),
              password: formData['password'].toString().trim(),
            );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginControllerProvider);
    final size = MediaQuery.of(context).size;
   
    // Listen for successful login
    if (authState.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final user = authState.value!;
        print('🎯 LoginScreen: User authenticated - ${user.email}, Role: ${user.role}');
        print('🎯 LoginScreen: Attempting navigation to role: ${user.role}');
        RoleNavigator.navigateBasedOnRole(context, user.role);
      });
    }

    // Listen for errors
    if (authState.hasError && _isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: size.height * 0.9,
            width: size.width * 0.4,
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 300,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Title Section
                    const _LoginHeader(),
                    const SizedBox(height: 40),
                    
                    // Email Field
                    _EmailField(),
                    const SizedBox(height: 20),
                    
                    // Password Field
                    _PasswordField(
                      isPasswordVisible: _isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                  
                    // Submit Button
                    _SubmitButton(
                      isLoading: _isLoading,
                      onSubmit: _submitForm,
                    ),
                    
                    // Error Display
                    if (authState.hasError) ...[
                      const SizedBox(height: 16),
                      _ErrorDisplay(error: authState.error.toString()),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// HEADER SECTION
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.medical_services,
            size: 40,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Med Stage',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connectez-vous à votre compte',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// EMAIL FIELD
class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'email',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Adresse email',
        hintText: 'entrez votre email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Veuillez entrer votre email'),
        FormBuilderValidators.email(errorText: 'Veuillez entrer un email valide'),
      ]),
    );
  }
}

// PASSWORD FIELD
class _PasswordField extends StatelessWidget {
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;

  const _PasswordField({
    required this.isPasswordVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'password',
      obscureText: !isPasswordVisible,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        hintText: 'entrez votre mot de passe',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Veuillez entrer votre mot de passe'),
        FormBuilderValidators.minLength(6, errorText: 'Le mot de passe doit contenir au moins 6 caractères'),
      ]),
      onSubmitted: (value) {
        if (value != null && value.isNotEmpty) {
          final form = FormBuilder.of(context);
          if (form?.saveAndValidate() ?? false) {
            // Form is valid, trigger submission
          }
        }
      },
    );
  }
}

// SUBMIT BUTTON
class _SubmitButton extends ConsumerWidget {
  final bool isLoading;
  final VoidCallback onSubmit;

  const _SubmitButton({
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Se Connecter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}



// ERROR DISPLAY
class _ErrorDisplay extends StatelessWidget {
  final String error;

  const _ErrorDisplay({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _cleanErrorMessage(error),
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cleanErrorMessage(String error) {
    // Remove "Exception: " prefix if present
    return error.replaceAll('Exception: ', '');
  }
}


