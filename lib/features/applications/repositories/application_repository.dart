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
      
      transaction.update(docRef, {
        'status': newStatus.name,
        'timeline': updatedTimeline,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
