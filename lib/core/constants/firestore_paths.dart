/// Firestore collection names
class FirestoreCollections {
  FirestoreCollections._();

  static const users = 'users';
  static const startups = 'startups';
  static const startupRequests = 'startup_requests';
  static const internships = 'internships';
  static const applications = 'applications';
  static const bookmarks = 'bookmarks';
  static const messages = 'messages';
  static const notifications = 'notifications';
  static const interviews = 'interviews';
  static const reports = 'reports';
  static const adminLogs = 'admin_logs';
}

enum UserRole { student, startupFounder, admin }

enum OpportunityStatus { draft, pendingReview, approved, rejected, expired }

enum ApplicationStatus {
  applied,
  underReview,
  shortlisted,
  interviewScheduled,
  accepted,
  rejected,
}

enum VerificationStatus { pending, verified, rejected }
