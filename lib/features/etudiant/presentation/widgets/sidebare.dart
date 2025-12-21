import 'package:flutter/material.dart';
import 'package:med/features/etudiant/presentation/widgets/sidebareItem.dart';


class Sidebar extends StatelessWidget {
  final List<SidebarItem> items;
  final int selectedIndex;
  final bool isExpanded;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: AnimatedContainer(
        width: isExpanded ? 240 : 70,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(2, 0),
            )
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
      
                  if (item.isHeader) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: isExpanded ? 13 : 0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    );
                  }
      
                  final isSelected = index == selectedIndex;
      
                  return InkWell(
                    onTap: () => onItemSelected(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon,
                              size: 22,
                              color: isSelected ? Colors.blue : Colors.grey.shade700),
                          if (isExpanded) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isSelected ? Colors.blue : Colors.grey.shade800,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
