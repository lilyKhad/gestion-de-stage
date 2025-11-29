import 'package:flutter/material.dart';
import 'package:med/core/features/Condidature/presentation/condidature.dart';
import 'package:med/core/features/Internship/domain/entity/internship.dart';

class InternshipCard extends StatelessWidget {
  final Internship internship;
  
  const InternshipCard({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.fromLTRB(38, 10, 38, 10),
      child: Container(
        height: size.height * 0.22, // smaller height
        width: size.width * 0.35,   // smaller width
        margin: const EdgeInsets.all(6), // smaller margin
        padding: const EdgeInsets.all(8), // smaller padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              blurRadius: 15,
              spreadRadius: -5,
              offset: Offset(0, 7),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 8,
              spreadRadius: -3,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image section
            _buildInternshipImage(size),
            const SizedBox(width: 8),
      
            // Details column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            internship.department,
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 16, // smaller font
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Dr ${internship.doctorName}',
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 14, // smaller font
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CondidatureDetailScreen(
                                internshipId: internship.id,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8), // smaller button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Consulter', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
      
                  // Icons row
                  Row(
                    children: [
                      IconText(icon: Icons.place_rounded, text: internship.hospital),
                      const SizedBox(width: 12),
                      IconText(icon: Icons.alarm_rounded, text: _formatDate(internship.startDate)),
                      const Spacer(),
                      const Icon(Icons.bookmark, color: Colors.grey, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInternshipImage(Size size) {
    // Check if internship has a valid picture
    final hasValidPicture = internship.pictureUrl != null && 
                           internship.pictureUrl!.isNotEmpty &&
                           internship.pictureUrl!.startsWith('http');

    return Container(
      height: double.infinity,
      width: size.width * 0.15, // smaller image
      decoration: BoxDecoration(
        color: hasValidPicture ? Colors.transparent : Colors.red, // Only red if no image
        borderRadius: BorderRadius.circular(8),
        image: hasValidPicture ? DecorationImage(
          image: NetworkImage(internship.pictureUrl!),
          fit: BoxFit.cover,
        ) : null,
      ),
      child: hasValidPicture ? null : _buildDefaultImageContent(),
    );
  }

  Widget _buildDefaultImageContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.medical_services,
          color: Colors.white,
          size: 24, // smaller icon
        ),
        const SizedBox(height: 4),
        Text(
          internship.department.length > 10 
            ? '${internship.department.substring(0, 10)}...' 
            : internship.department,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10, // smaller font
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day;
    final month = _getMonthName(date.month);
    return '$day $month';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month - 1];
  }
}

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 14), // smaller icon
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 12, // smaller font
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}