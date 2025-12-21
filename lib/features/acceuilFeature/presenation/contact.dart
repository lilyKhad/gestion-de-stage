import 'package:flutter/material.dart';
import 'package:med/core/Theme/appColors.dart';
import 'package:med/core/Theme/backgroundTheme.dart';
import 'package:med/core/constants/Strings.dart';
import 'package:med/features/acceuilFeature/presenation/maps.dart';
import 'package:med/features/widgets/appbar.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Container(
        decoration: Backgroundtheme.getGradientBackground(),
        child: const Padding(
           padding:  EdgeInsets.fromLTRB(50, 20, 50, 10),
          child: _ContactLayout(),

        ),
      ),
    );
  }
}

class _ContactLayout extends StatelessWidget {
  const _ContactLayout();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Partie GAUCHE - Contacts
        Expanded(
          flex: 2,
          child: _ContactInfoSection(),
        ),
        
        SizedBox(width: 30),
        
        // Partie DROITE - Formulaire
        Expanded(
          flex: 1,
          child: _ContactForm(),
        ),
        
      ],
    );
  }
}

class _ContactInfoSection extends StatelessWidget {
  const _ContactInfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppStrings.contactTitre1,
            const SizedBox(height: 10),
            AppStrings.contactSub1,
            const SizedBox(height: 20),
            const Text('info@univ-boumerdes.dz \n 055-805-6876'),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: const [
                  _ContactItem(
                    title: AppStrings.contactTitre2,
                    subtitle: AppStrings.contactSub2,
                  ),
                  _ContactItem(
                    title: AppStrings.contactTitre3,
                    subtitle: AppStrings.contactSub3,
                  ),
                  _ContactItem(
                    title: AppStrings.contactTitre4,
                    subtitle: AppStrings.contactSub4,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.5)),
              height:183 ,
              width:417 ,
              child: const OpenStreetMapScreen(),
            )
          ],
        );
    
    
  }
}

class _ContactItem extends StatelessWidget {
  final Text title;
  final Text subtitle;
  const _ContactItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 6),
          subtitle,
        ],
      ),
    );
  }
}

class _ContactForm extends StatelessWidget {
  const _ContactForm();
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.6,
      width: size.width*0.2,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FormHeader(),
          SizedBox(height: 20),
          _NameFields(),
          SizedBox(height: 12),
          _EmailField(),
          SizedBox(height: 12),
          _PhoneField(),
          SizedBox(height: 12),
          _MessageField(),
          SizedBox(height: 16),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contactez nous',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Vous pouvez nous joindre à tout moment.',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _NameFields extends StatelessWidget {
  const _NameFields();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _FormField(
            label: 'Prénom',
            height: 30,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _FormField(
            label: 'Nom',
            height: 30,
          ),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return const _FormField(
      label: 'Votre email',
      icon: Icons.email,
      height: 30,
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField();

  @override
  Widget build(BuildContext context) {
    return const _FormField(
      label: 'Numéro de téléphone',
      icon: Icons.phone,
      height: 30,
    );
  }
}

class _MessageField extends StatelessWidget {
  const _MessageField();

  @override
  Widget build(BuildContext context) {
    return const _FormField(
      label: 'Comment pouvons-nous vous aider ?',
      maxLines: 3,
      height: 70,
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final int maxLines;
  final double height;

  const _FormField({
    required this.label,
    this.icon,
    this.maxLines = 1,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.gery,
          ),
          suffixIcon: icon != null 
              ? Icon(icon, color: AppColors.gery, size: 16)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.gery,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.gery,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Envoyer',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}