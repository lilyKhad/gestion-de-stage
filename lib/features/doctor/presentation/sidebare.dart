import 'package:flutter/material.dart';

class MedStageSidebar extends StatefulWidget {
  final Function(int) onIndexChanged;

  const MedStageSidebar({super.key, required this.onIndexChanged});

  @override
  State<MedStageSidebar> createState() => _MedStageSidebarState();
}

class _MedStageSidebarState extends State<MedStageSidebar> {
  // L'index 1 est sélectionné par défaut comme sur l'image ("Mes Etudiants")
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Largeur fixe pour la sidebar
      color: Colors.white, // Fond blanc
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 2. MENU PRINCIPAL
          _buildSectionTitle("Menu Principale"),
          _buildMenuItem(
            index: 1,
            icon: Icons.person_search_outlined,
            title: "Les Demandes",
          ),
          // _buildMenuItem(
          //   index: 2,
          //   icon: Icons.mark_as_unread_outlined, // Ou Icons.help_outline
          //   title: "Evaluation",
          // ),
          const SizedBox(height: 40), // Espace avant la section Compte

          // 3. COMPTE
          _buildSectionTitle("COMPTE"),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                // Logique de déconnexion ici
                print("Déconnexion");
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: const Row(
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      "Deconnexion",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget pour le titre des sections (Menu Principale, COMPTE)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget pour un élément du menu
  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    bool isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            widget.onIndexChanged(index); // Notifier le parent
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade50 : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.blue : Colors.grey,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}