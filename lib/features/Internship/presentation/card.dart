import 'package:flutter/material.dart';
import 'package:med/features/Internship/domain/entity/internship.dart';
import 'package:med/features/Internship/presentation/InternshipDetailsScreen.dart';
// For date formatting if needed

class InternshipCard extends StatelessWidget {
  final Internship internship;

  const InternshipCard({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9098B1).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Navigate to Detail Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CondidatureDetailScreen(
                  internshipId: internship.id,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // 1. Medical Visual Anchor (Gradient Box)
                _buildMedicalThumbnail(),

                const SizedBox(width: 16),

                // 2. Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Department Title
                      Text(
                        internship.department,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222B45),
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Doctor Name
                      Text(
                        "Dr. ${internship.doctorName}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),

                      const SizedBox(height: 10),
                      
                      // Divider Line
                      Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      
                      const SizedBox(height: 10),

                      // Footer: Hospital & Date
                      Row(
                        children: [
                          _buildIconText(
                            Icons.local_hospital_rounded, 
                            internship.hospital,
                            const Color(0xFFFF7777), // Soft Red
                          ),
                          const Spacer(),
                          _buildIconText(
                            Icons.calendar_month_rounded, 
                            _formatDate(internship.startDate),
                            const Color(0xFFFFB74D), // Orange
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 3. Arrow Icon
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFFC5CEE0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildMedicalThumbnail() {
    return Container(
      height: 80,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4AC7FF), // Bright Blue
            Color(0xFF007AFF), // Deep Blue
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.medical_services_outlined,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(
          text.length > 10 ? '${text.substring(0, 10)}...' : text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}";
  }
}
