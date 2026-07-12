import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/firebase_providers.dart';
import '../models/opportunity.dart';
import '../repositories/internship_repository.dart';

final internshipRepositoryProvider = Provider<InternshipRepository>((ref) {
  return InternshipRepository();
});

final opportunitiesStreamProvider = StreamProvider<List<Opportunity>>((ref) {
  return ref.watch(internshipRepositoryProvider).watchOpportunities();
});

final bookmarkedIdsStreamProvider = StreamProvider<List<String>>((ref) {
  final userId = ref.watch(currentUserIdProvider).valueOrNull;
  if (userId == null) return Stream.value([]);
  return ref.watch(internshipRepositoryProvider).watchBookmarkedIds(userId);
});

final bookmarkedOpportunitiesStreamProvider = StreamProvider<List<Opportunity>>((ref) {
  final opportunities = ref.watch(opportunitiesStreamProvider).valueOrNull ?? [];
  final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).valueOrNull ?? [];
  return Stream.value(
    opportunities.where((opp) => bookmarkedIds.contains(opp.id)).toList(),
  );
});

final opportunityDetailsProvider = FutureProvider.family<Opportunity?, String>((ref, id) {
  return ref.watch(internshipRepositoryProvider).getOpportunityById(id);
});
