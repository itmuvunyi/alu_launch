import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../authentication/providers/auth_providers.dart';
import '../models/application.dart';
import '../repositories/application_repository.dart';

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepository();
});

final studentApplicationsStreamProvider = StreamProvider<List<Application>>((ref) {
  final userId = ref.watch(currentUserIdProvider).valueOrNull;
  if (userId == null) return Stream.value([]);
  return ref.watch(applicationRepositoryProvider).watchStudentApplications(userId);
});

final applicationDetailsStreamProvider = StreamProvider.family<Application?, String>((ref, id) {
  return ref.watch(applicationRepositoryProvider).watchApplicationById(id);
});

final startupApplicationsStreamProvider = StreamProvider.family<List<Application>, String>((ref, startupId) {
  return ref.watch(applicationRepositoryProvider).watchStartupApplications(startupId);
});

class ApplyController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit({
    required String opportunityId,
    required String opportunityTitle,
    required String startupId,
    required String startupName,
    required String studentResumeUrl,
  }) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user == null) throw Exception('Must be signed in to apply');

      final firestore = ref.read(firestoreProvider);

      // 1. Check duplicate prevention
      final existing = await firestore
          .collection('applications')
          .where('studentId', isEqualTo: user.uid)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1)
          .get();
      if (existing.docs.isNotEmpty) {
        throw Exception('You have already applied to this opportunity.');
      }

      // 2. Check only approved opportunities can accept applications
      final oppSnapshot = await firestore.collection('internships').doc(opportunityId).get();
      if (!oppSnapshot.exists) {
        throw Exception('Opportunity not found.');
      }
      final oppStatus = oppSnapshot.data()?['status'] as String?;
      if (oppStatus != 'approved') {
        throw Exception('This opportunity is not active or approved for applications.');
      }

      final repo = ref.read(applicationRepositoryProvider);
      final id = firestore.collection('applications').doc().id;

      final application = Application(
        id: id,
        opportunityId: opportunityId,
        opportunityTitle: opportunityTitle,
        startupId: startupId,
        startupName: startupName,
        studentId: user.uid,
        studentName: user.displayName,
        studentEmail: user.email,
        studentResumeUrl: studentResumeUrl,
        status: ApplicationStatus.applied,
        timeline: [
          ApplicationTimelineEvent(
            status: ApplicationStatus.applied,
            time: DateTime.now(),
            notes: 'Application submitted successfully.',
          )
        ],
        createdAt: DateTime.now(),
      );

      await repo.submitApplication(application);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final applyControllerProvider = AutoDisposeAsyncNotifierProvider<ApplyController, void>(ApplyController.new);
