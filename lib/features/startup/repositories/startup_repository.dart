import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../models/startup.dart';

class StartupRepository {
  StartupRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _startupsRef =>
      _firestore.collection(FirestoreCollections.startups);

  Future<Startup?> getStartupById(String id) async {
    final doc = await _startupsRef.doc(id).get();
    if (!doc.exists) return null;
    return Startup.fromJson({...doc.data()!, 'id': doc.id});
  }

  Stream<Startup?> watchStartupById(String id) {
    return _startupsRef.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Startup.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  Future<void> createStartup(Startup startup) async {
    await _startupsRef.doc(startup.id).set(startup.toJson());
  }

  Future<void> updateStartup(Startup startup) async {
    await _startupsRef.doc(startup.id).update(startup.toJson());
  }
}
