import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../models/opportunity.dart';

class InternshipRepository {
  InternshipRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _opportunitiesRef =>
      _firestore.collection(FirestoreCollections.internships);

  CollectionReference<Map<String, dynamic>> get _bookmarksRef =>
      _firestore.collection(FirestoreCollections.bookmarks);

  /// Fetch all approved opportunities
  Future<List<Opportunity>> getOpportunities() async {
    final snapshot = await _opportunitiesRef
        .where('status', isEqualTo: OpportunityStatus.approved.name)
        .get();
    final list = snapshot.docs
        .map((doc) => Opportunity.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// Watch approved opportunities
  Stream<List<Opportunity>> watchOpportunities() {
    return _opportunitiesRef
        .where('status', isEqualTo: OpportunityStatus.approved.name)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => Opportunity.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  /// Get single opportunity
  Future<Opportunity?> getOpportunityById(String id) async {
    final doc = await _opportunitiesRef.doc(id).get();
    if (!doc.exists) return null;
    return Opportunity.fromJson({...doc.data()!, 'id': doc.id});
  }

  /// Watch opportunity bookmarks for a user
  Stream<List<String>> watchBookmarkedIds(String userId) {
    return _bookmarksRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['opportunityId'] as String)
          .toList();
    });
  }

  /// Toggle bookmark status
  Future<void> toggleBookmark({required String userId, required String opportunityId}) async {
    final docId = '${userId}_$opportunityId';
    final docRef = _bookmarksRef.doc(docId);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    } else {
      await docRef.set({
        'userId': userId,
        'opportunityId': opportunityId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Create opportunity (used by startups)
  Future<void> createOpportunity(Opportunity opportunity) async {
    await _opportunitiesRef.doc(opportunity.id).set(opportunity.toJson());
  }
}
