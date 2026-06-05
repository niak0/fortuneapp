import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../models/user_model.dart';
import 'user_repository.dart';

const _logName = 'user_repo';

// Firestore'da users/{uid} dokümanını kullanan kullanıcı profili repository'si.
class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository({FirebaseFirestore? firestore, fb.FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? fb.FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final fb.FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>>? _userDoc() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      developer.log('fetchCurrent: aktif kullanıcı yok', name: _logName);
      return null;
    }
    return _firestore.collection('users').doc(uid);
  }

  @override
  Future<UserModel?> fetchCurrent() async {
    final doc = _userDoc();
    if (doc == null) return null;
    try {
      final snap = await doc.get();
      if (!snap.exists) {
        developer.log(
          'users/${doc.id} dokümanı yok — null döner',
          name: _logName,
        );
        return null;
      }
      developer.log('users/${doc.id} okundu', name: _logName);
      return UserModel.fromJson(snap.data()!);
    } catch (e, s) {
      developer.log(
        'fetchCurrent HATA',
        name: _logName,
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<UserModel?> fetchOrCreate(UserModel Function() createDefault) async {
    final doc = _userDoc();
    if (doc == null) return null;
    try {
      final snap = await doc.get();
      if (snap.exists) return UserModel.fromJson(snap.data()!);
      // Profil yok — anon kullanıcı için varsayılan profili oluştur.
      final now = DateTime.now();
      final created = createDefault().copyWith(createdAt: now, updatedAt: now);
      await doc.set(created.toJson(), SetOptions(merge: true));
      developer.log('users/${doc.id} otomatik oluşturuldu', name: _logName);
      return created;
    } catch (e, s) {
      developer.log(
        'fetchOrCreate HATA',
        name: _logName,
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> update(UserModel user) async {
    final doc = _userDoc();
    if (doc == null) return;
    try {
      // Her güncellemede updatedAt damgalanır (audit alanı).
      final stamped = user.copyWith(updatedAt: DateTime.now());
      await doc.set(stamped.toJson(), SetOptions(merge: true));
      developer.log('users/${doc.id} güncellendi', name: _logName);
    } catch (e, s) {
      developer.log('update HATA', name: _logName, error: e, stackTrace: s);
      rethrow;
    }
  }
}
