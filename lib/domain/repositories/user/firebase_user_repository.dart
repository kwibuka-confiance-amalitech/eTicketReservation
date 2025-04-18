import 'dart:developer';

import 'package:car_ticket/domain/models/user/user.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:car_ticket/domain/repositories/user/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth _firebaseAuth;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final currentUser = FirebaseAuth.instance.currentUser;
  final TicketAppSharedPreferenceRepository
      _ticketAppSharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();

  FirebaseUserRepository({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) => firebaseUser);
  }

  @override
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUpWithEmailAndPassword(
      MyUser myUser, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: myUser.email, password: password);
      await userCredential.user!.updateDisplayName(myUser.name);

      myUser = myUser.copyWith(id: userCredential.user!.uid);
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData({required MyUser user}) async {
    try {
      // Ensure the timestamp and bookings count are included
      Map<String, dynamic> userData = {
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'photoUrl': user.photoUrl,
        'createdAt':
            user.createdAt ?? DateTime.now(), // Ensure createdAt is set
        'bookingsCount': user.bookingsCount ?? 0, // Initialize bookings count
      };

      await userCollection.doc(user.id).set(userData);
    } catch (e) {
      throw FirebaseException(
        plugin: 'firebase_firestore',
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _ticketAppSharedPreferenceRepository.clearUser();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> getUserData() async {
    // currentUser!.reload();
    final user0 = await _ticketAppSharedPreferenceRepository.getUser();
    try {
      final MyUser user = MyUser.empty;
      final userDoc = await userCollection.doc(user0.id).get();
      if (userDoc.exists) {
        return user.copyWith(
            id: userDoc.data()!['id'],
            email: userDoc.data()!['email'],
            name: userDoc.data()!['name'],
            photoUrl: userDoc.data()!['photoUrl']);
      }
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateProfilePhoto({required String photoUrl}) async {
    try {
      await _firebaseAuth.currentUser!.updatePhotoURL(photoUrl);
      await userCollection.doc(_firebaseAuth.currentUser!.uid).update({
        'photoUrl': photoUrl,
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateUserData({required MyUser user}) async {
    try {
      await currentUser!.updateDisplayName(user.name);
      await currentUser!.updatePhotoURL(user.photoUrl!);
      final ref = userCollection.doc(user.id);
      ref.get().then((value) async {
        if (value.exists) {
          await ref.update(user.toEntity().toDocument());
        } else {
          await ref.set(user.toEntity().toDocument());
        }
      });

      print("serId: ${user.id}");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

// Add this to an admin controller or utility class
Future<void> updateExistingUsersWithTimestamp() async {
  try {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in usersSnapshot.docs) {
      if (doc.data()['createdAt'] == null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .update({
          'createdAt': DateTime.now(), // Current time as fallback
          'bookingsCount': 0, // Initialize booking count
        });
        print('Updated user ${doc.id} with timestamp and booking count');
      }
    }

    print('Completed updating users');
  } catch (e) {
    print('Error updating users: $e');
  }
}
