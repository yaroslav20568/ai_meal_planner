import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:ai_meal_planner/models/index.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> saveUserProfile({
    required String userId,
    required UserProfile profile,
  }) async {
    try {
      _logger.i('Saving user profile for userId: $userId');

      final profileData = profile.toJson();
      profileData.remove('id');

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('data')
          .set(profileData, SetOptions(merge: true));

      _logger.i('User profile saved successfully');
    } catch (e) {
      _logger.e('Error saving user profile: $e');
      rethrow;
    }
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      _logger.i('Loading user profile for userId: $userId');

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('data')
          .get();

      if (!doc.exists) {
        _logger.i('User profile not found');
        return null;
      }

      final data = doc.data();
      if (data == null) {
        _logger.i('User profile data is null');
        return null;
      }

      final profile = UserProfile.fromJson(data);
      _logger.i('User profile loaded successfully');
      return profile;
    } catch (e) {
      _logger.e('Error loading user profile: $e');
      rethrow;
    }
  }

  Future<String> saveMealPlan({
    required String userId,
    required MealPlan mealPlan,
  }) async {
    try {
      _logger.i('Saving meal plan for userId: $userId');

      final mealPlanData = mealPlan.toJson();
      mealPlanData.remove('id');

      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .add(mealPlanData);

      _logger.i('Meal plan saved successfully with id: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      _logger.e('Error saving meal plan: $e');
      rethrow;
    }
  }

  Future<List<MealPlan>> getMealPlans(String userId) async {
    try {
      _logger.i('Loading meal plans for userId: $userId');

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .orderBy('createdAt', descending: true)
          .get();

      final mealPlans = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return MealPlan.fromJson(data);
      }).toList();

      _logger.i('Loaded ${mealPlans.length} meal plans');
      return mealPlans;
    } catch (e) {
      _logger.e('Error loading meal plans: $e');
      rethrow;
    }
  }

  Future<MealPlan?> getMealPlan({
    required String userId,
    required String mealPlanId,
  }) async {
    try {
      _logger.i('Loading meal plan $mealPlanId for userId: $userId');

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('mealPlans')
          .doc(mealPlanId)
          .get();

      if (!doc.exists) {
        _logger.i('Meal plan not found');
        return null;
      }

      final data = doc.data();
      if (data == null) {
        _logger.i('Meal plan data is null');
        return null;
      }

      data['id'] = doc.id;
      final mealPlan = MealPlan.fromJson(data);

      _logger.i('Meal plan loaded successfully');
      return mealPlan;
    } catch (e) {
      _logger.e('Error loading meal plan: $e');
      rethrow;
    }
  }
}
