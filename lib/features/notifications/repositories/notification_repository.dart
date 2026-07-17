import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/firestore_paths.dart';
import '../models/notification.dart';

class NotificationRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestoreCollections.notifications);

  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => NotificationModel.fromJson({
                    ...doc.data(),
                    'id': doc.id,
                  }))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  Future<void> markAsRead(String id) async {
    await _collection.doc(id).update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  Future<void> markOpportunityNotificationAsRead(String userId, String opportunityId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'newOpportunity')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    var hasUpdates = false;
    for (var doc in snapshot.docs) {
      final payload = doc.data()['payload'] as Map<String, dynamic>?;
      if (payload != null && payload['opportunityId'] == opportunityId) {
        batch.update(doc.reference, {'isRead': true});
        hasUpdates = true;
      }
    }
    if (hasUpdates) {
      await batch.commit();
    }
  }

  Future<void> markApplicationNotificationAsRead(String userId, String applicationId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'applicationStatusChanged')
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    var hasUpdates = false;
    for (var doc in snapshot.docs) {
      final payload = doc.data()['payload'] as Map<String, dynamic>?;
      if (payload != null && payload['applicationId'] == applicationId) {
        batch.update(doc.reference, {'isRead': true});
        hasUpdates = true;
      }
    }
    if (hasUpdates) {
      await batch.commit();
    }
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? payload,
  }) async {
    await _collection.add({
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'payload': payload,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
