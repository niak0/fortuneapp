import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../models/fortune_model.dart';
import 'fortune_repository.dart';

const _logName = 'fortune_repo';

// Firestore'da users/{uid}/fortunes alt-koleksiyonu üzerinden çalışır.
class FirestoreFortuneRepository implements FortuneRepository {
  FirestoreFortuneRepository({
    FirebaseFirestore? firestore,
    fb.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? fb.FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final fb.FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>>? _coll() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      developer.log('coll: uid yok', name: _logName);
      return null;
    }
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('fortunes');
  }

  ContentModel _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return ContentModel(
      id: doc.id,
      createdTime: (data['createdTime'] as Timestamp?)?.toDate(),
      unlockTime: (data['unlockTime'] as Timestamp?)?.toDate(),
      fortune: data['fortune'] as String?,
      userId: data['userId'] as String?,
      fortuneType: data['fortuneType'] as String?,
      fortuneTopic: data['fortuneTopic'] as String?,
      isRead: data['isRead'] as bool? ?? false,
      isAccessible: data['isAccessible'] as bool? ?? false,
    );
  }

  @override
  Stream<List<ContentModel>> watchAll() {
    final coll = _coll();
    if (coll == null) return const Stream.empty();
    return coll
        .orderBy('createdTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  @override
  Future<List<ContentModel>> fetchAll() async {
    final coll = _coll();
    if (coll == null) return const [];
    final snap = await coll.orderBy('createdTime', descending: true).get();
    return snap.docs.map(_fromDoc).toList();
  }

  @override
  Future<bool> add({
    required String content,
    required String contentType,
    required String? fortuneTopic,
  }) async {
    final coll = _coll();
    if (coll == null) return false;
    try {
      final now = DateTime.now();
      await coll.add({
        'fortune': content,
        'fortuneType': contentType,
        'fortuneTopic': fortuneTopic,
        'createdTime': Timestamp.fromDate(now),
        'unlockTime': Timestamp.fromDate(now),
        'isRead': false,
        'isAccessible': true,
        'userId': _auth.currentUser?.uid,
      });
      developer.log('fortune eklendi', name: _logName);
      return true;
    } catch (e, s) {
      developer.log('add HATA', name: _logName, error: e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<void> setAccess(String fortuneId) async {
    await _coll()?.doc(fortuneId).update({'isAccessible': true});
  }

  @override
  Future<void> markAsRead(String fortuneId) async {
    await _coll()?.doc(fortuneId).update({'isRead': true});
  }

  @override
  Future<void> delete(String documentId) async {
    await _coll()?.doc(documentId).delete();
  }
}
