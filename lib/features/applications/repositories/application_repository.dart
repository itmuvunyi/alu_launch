import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../models/application.dart';

class ApplicationRepository {
  ApplicationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _applicationsRef =>
      _firestore.collection(FirestoreCollections.applications);

  Stream<List<Application>> watchStudentApplications(String studentId) {
    return _applicationsRef
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => Application.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Stream<List<Application>> watchOpportunityApplications(String opportunityId) {
    return _applicationsRef
        .where('opportunityId', isEqualTo: opportunityId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => Application.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Stream<List<Application>> watchStartupApplications(String startupId) {
    return _applicationsRef
        .where('startupId', isEqualTo: startupId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => Application.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Stream<Application?> watchApplicationById(String id) {
    return _applicationsRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Application.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  Future<void> submitApplication(Application application) async {
    await _applicationsRef.doc(application.id).set(application.toJson());
  }

  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus newStatus,
    String? notes,
  }) async {
    final docRef = _applicationsRef.doc(applicationId);
    
    // Use Firestore transactions or updates to modify status and append timeline event
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception('Application not found');
      
      final currentData = snapshot.data()!;
      final currentTimeline = (currentData['timeline'] as List<dynamic>?) ?? [];
      
      final newEvent = {
        'status': newStatus.name,
        'time': Timestamp.now(),
        'notes': notes,
      };
      
      final updatedTimeline = [...currentTimeline, newEvent];
      
      final oldStatus = currentData['status'] as String?;
      if (oldStatus != newStatus.name) {
        transaction.update(docRef, {
          'status': newStatus.name,
          'timeline': updatedTimeline,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Generate a notification document atomically inside the same transaction
        final studentId = currentData['studentId'] as String;
        final opportunityTitle = currentData['opportunityTitle'] as String;
        
        String statusDescription;
        switch (newStatus) {
          case ApplicationStatus.applied:
            statusDescription = 'submitted';
            break;
          case ApplicationStatus.underReview:
            statusDescription = 'put under review';
            break;
          case ApplicationStatus.shortlisted:
            statusDescription = 'shortlisted';
            break;
          case ApplicationStatus.interviewScheduled:
            statusDescription = 'scheduled for an interview';
            break;
          case ApplicationStatus.accepted:
            statusDescription = 'accepted';
            break;
          case ApplicationStatus.rejected:
            statusDescription = 'rejected';
            break;
        }

        final notificationRef = _firestore.collection(FirestoreCollections.notifications).doc();
        transaction.set(notificationRef, {
          'userId': studentId,
          'title': 'Application Status Update',
          'body': 'Your application for $opportunityTitle has been $statusDescription.',
          'type': 'applicationStatusChanged',
          'payload': {
            'applicationId': applicationId,
            'status': newStatus.name,
          },
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}
