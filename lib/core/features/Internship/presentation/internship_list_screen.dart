import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med/core/features/Internship/presentation/internship_card.dart';

import 'package:med/core/features/Internship/providers/ineternship_provider.dart';
import 'package:med/core/features/etudiant/presentation/widgets/appbare.dart';

class InternshipListScreen extends ConsumerStatefulWidget {
  const InternshipListScreen({super.key});

  @override
  ConsumerState<InternshipListScreen> createState() =>
      _InternshipListScreenState();
}

class _InternshipListScreenState extends ConsumerState<InternshipListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Watch the search provider with the current search query
    final filteredInternshipsAsync =
        ref.watch(searchInternshipsProvider(_searchQuery));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarEtudiant(),
      body: Column(
        children: [
          // Search / Filter Bar
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              height: 140, // Reduced height for cuter look
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16), // Rounded corners for container
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1), // Lighter shadow
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.06), // Even lighter shadow
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Optional: Add a cute title
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0, left: 4.0),
                      child: Text(
                        'Consulter nos offres de Stages',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
            
                    // Search field
                    Container(
                      height: 50, // Smaller height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25), // More rounded
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by department or doctor...',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.search_rounded,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim();
                          });
                        },
                      ),
                    ),
            
                    
                  ],
                ),
              ),
            ),
          ),

          // Internships List
          Expanded(
            child: filteredInternshipsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error: ${error.toString()}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              data: (internships) {
                if (internships.isEmpty) {
                  return const Center(child: Text('No internships found'));
                }

                return ListView.builder(
                  itemCount: internships.length,
                  itemBuilder: (context, index) {
                    final internship = internships[index];
                    return InternshipCard(internship: internship);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
