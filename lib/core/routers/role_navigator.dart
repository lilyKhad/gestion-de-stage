

String _getRouteForRole(String role) {
  switch (role.toLowerCase()) {
    case 'etudiant':
      return '/etudiant';
    case 'medecin':
      return '/medecin';
    case 'hopital':
    case 'epsp': // Handle both variations if necessary
      return '/hopital';
    case 'admin': // 
      return '/admin';
    default:
      return '/'; // Default fallback
  }
}
