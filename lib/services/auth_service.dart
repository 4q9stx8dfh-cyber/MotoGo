import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Future<UserCredential> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String userType,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final uid = credential.user!.uid;

    final user = UserModel(
      uid: uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      userType: userType,
      status: userType == 'driver' ? 'pending_documents' : 'active',
    );

    await _firestoreService.saveUser(user);

    return credential;
  }

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> resetPassword({
    required String email,
  }) {
    return _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}