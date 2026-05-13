import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codelearn/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email'],
            );

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final ref = _firestore.collection('users').doc(user.uid);
      final doc = await ref.get();

      if (doc.exists) {
        await ref.set({
          'lastLoginAt': Timestamp.now(),
        }, SetOptions(merge: true));

        final updatedDoc = await ref.get();
        return UserModel.fromFirestore(updatedDoc);
      }

      return _ensureUserDocument(user);
    });
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await userCredential.user!.updateDisplayName(fullName);

      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email.trim(),
        fullName: fullName.trim(),
        createdAt: DateTime.now(),
        lastloginAt: DateTime.now(),
        role: role,
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toFirestore());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = userCredential.user!.uid;

      final ref = _firestore.collection('users').doc(uid);
      final doc = await ref.get();

      if (!doc.exists) {
        return _ensureUserDocument(userCredential.user!);
      }

      await ref.set({
        'lastLoginAt': Timestamp.now(),
      }, SetOptions(merge: true));

      final updatedDoc = await ref.get();

      return UserModel.fromFirestore(updatedDoc);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final auth = await account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final fbUser = userCredential.user!;

      return await _ensureUserDocument(fbUser);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}

    await _firebaseAuth.signOut();
  }

  Future<void> updateProfile({
    String? fullName,
    String? photoUrl,
    String? phoneNumber,
    String? bio,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('User not found');
      }

      final updates = <String, dynamic>{};

      if (fullName != null && fullName.trim().isNotEmpty) {
        await user.updateDisplayName(fullName.trim());
        updates['fullName'] = fullName.trim();
      }

      if (photoUrl != null && photoUrl.trim().isNotEmpty) {
        await user.updatePhotoURL(photoUrl.trim());
        updates['photoUrl'] = photoUrl.trim();
      }

      if (phoneNumber != null) {
        updates['phoneNumber'] = phoneNumber.trim();
      }

      if (bio != null) {
        updates['bio'] = bio.trim();
      }

      updates['updatedAt'] = Timestamp.now();

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).set(
              updates,
              SetOptions(merge: true),
            );
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> _ensureUserDocument(User fbUser) async {
    final ref = _firestore.collection('users').doc(fbUser.uid);

    final snap = await ref.get();

    if (snap.exists) {
      await ref.set({
        'lastLoginAt': Timestamp.now(),
      }, SetOptions(merge: true));

      final updatedDoc = await ref.get();

      return UserModel.fromFirestore(updatedDoc);
    }

    final user = UserModel(
      uid: fbUser.uid,
      email: fbUser.email ?? '',
      fullName: fbUser.displayName ??
          (fbUser.email != null
              ? fbUser.email!.split('@').first
              : 'User'),
      createdAt: DateTime.now(),
      lastloginAt: DateTime.now(),
      role: UserRole.student,
      photoUrl: fbUser.photoURL,
    );

    await ref.set(user.toFirestore());

    return user;
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password should be at least 6 characters long';

      case 'email-already-in-use':
        return 'An account already exists with this email';

      case 'user-not-found':
        return 'No account found with this email';

      case 'wrong-password':
        return 'Incorrect password';

      case 'invalid-email':
        return 'Please enter a valid email address';

      case 'user-disabled':
        return 'This account has been disabled';

      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later';

      case 'invalid-credential':
        return 'Invalid login credential';

      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in credential';

      case 'network-request-failed':
        return 'No internet connection';

      default:
        return e.message ?? 'An unexpected error occurred';
    }
  }
}