import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med/features/etudiant/presentation/widgets/appbare.dart';
import 'package:med/features/etudiant/presentation/widgets/sidebare.dart';
import 'package:med/features/etudiant/presentation/widgets/sidebareItem.dart';
import 'package:med/features/etudiant/providers/student_providers.dart';


class SidebarWrapper extends ConsumerWidget {
  final Widget Function(BuildContext, WidgetRef, int) builder;

  const SidebarWrapper({super.key, required this.builder});

  static const List<SidebarItem> sidebarItems = [
    SidebarItem(title: 'Mes Candidatures', icon: Icons.assignment_late_rounded), // Index 0
    SidebarItem(title: 'Ajouter Documents', icon: Icons.document_scanner_outlined), // Index 1
    SidebarItem(title: 'COMPTE', icon: Icons.person, isHeader: true), // Index 2 (header)
    SidebarItem(title: 'Mes Informations', icon: Icons.info_outline), // Index 3
    SidebarItem(title: 'Paramètres', icon: Icons.settings), // Index 4
    SidebarItem(title: 'Déconnexion', icon: Icons.logout, isLogout: true), // Index 5
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(sidebarSelectedIndexProvider);
    final expanded = ref.watch(sidebarExpandedProvider);

    return Scaffold(
      appBar: const AppbarEtudiant(),
      body: Row(
        children: [
          Sidebar(
            items: sidebarItems,
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              if (sidebarItems[index].isLogout) {
                _handleLogout(context,ref);
              } else {
                ref.read(sidebarSelectedIndexProvider.notifier).state = index;
              }
            },
            isExpanded: expanded,
          ),
          Expanded(child: builder(context, ref, selectedIndex)),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Déconnexion'),
      content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () async {
            // 1. Sign out from Firebase
            await FirebaseAuth.instance.signOut();

            // 2. Reset sidebar selected index
            ref.read(sidebarSelectedIndexProvider.notifier).state = 0;

            // 3. Navigate to login page
            if (context.mounted) {
              context.go('/login');
            }

            // Close the dialog
            Navigator.pop(context);
          },
          child: const Text('Déconnexion'),
        ),
      ],
    ),
  );
}

}
