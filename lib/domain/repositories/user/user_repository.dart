import 'package:car_ticket/domain/models/user/model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<MyUser> signUpWithEmailAndPassword(MyUser myUser, String password);

  Future<void> signOut();

  Future<void> setUserData({required MyUser user});

  Future<void> updateUserData({required MyUser user});

  Future<MyUser> getUserData();

  Future<void> updateProfilePhoto({required String photoUrl});
}
