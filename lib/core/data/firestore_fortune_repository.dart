import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../enums/fortune_topic.dart';
import '../../enums/gpt_content_type.dart';
import '../models/fortune_model.dart';
import 'fortune_repository.dart';

const _logName = 'fortune_repo';

// Firestore'da users/{uid}/fortunes alt-koleksiyonu üzerinden çalışır.
class FirestoreFortuneRepository implements FortuneRepository {
  FirestoreFortuneRepository({
    FirebaseFirestore? firestore,
    fb.FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? fb.FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final fb.FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>>? _coll() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      developer.log('coll: uid yok', name: _logName);
      return null;
    }
    return _firestore.collection('users').doc(uid).collection('fortunes');
  }

  FortuneModel _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    // Converter'lar Timestamp ve enum string'lerini güvenle çözer.
    return FortuneModel.fromJson(doc.data())..id = doc.id;
  }

  @override
  Stream<List<FortuneModel>> watchAll() {
    final coll = _coll();
    if (coll == null) return const Stream.empty();
    return coll
        .orderBy('createdTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  @override
  Future<List<FortuneModel>> fetchAll() async {
    final coll = _coll();
    if (coll == null) return const [];
    final snap = await coll.orderBy('createdTime', descending: true).get();
    return snap.docs.map(_fromDoc).toList();
  }

  @override
  Future<bool> create({
    required ContentType contentType,
    required Map<String, dynamic> request,
    FortuneTopic? fortuneTopic,
  }) async {
    final coll = _coll();
    if (coll == null) return false;
    try {
      final now = DateTime.now();
      // 'pending' yazılır; Cloud Function trigger'ı fortune+status'ü doldurur.
      await coll.add({
        'status': 'pending',
        'fortune': null,
        'fortuneType': contentType.name,
        'fortuneTopic': fortuneTopic?.name,
        'request': request,
        'createdTime': Timestamp.fromDate(now),
        'unlockTime': Timestamp.fromDate(now),
        'isRead': false,
        'isAccessible': false,
        'userId': _auth.currentUser?.uid,
      });
      developer.log('pending fortune eklendi', name: _logName);
      return true;
    } catch (e, s) {
      developer.log('create HATA', name: _logName, error: e, stackTrace: s);
      return false;
    }
  }

  @override
  Future<void> setAccess(String fortuneId) => _mutate(
    'setAccess',
    (coll) => coll.doc(fortuneId).update({'isAccessible': true}),
  );

  @override
  Future<void> markAsRead(String fortuneId) => _mutate(
    'markAsRead',
    (coll) => coll.doc(fortuneId).update({'isRead': true}),
  );

  @override
  Future<void> delete(String documentId) =>
      _mutate('delete', (coll) => coll.doc(documentId).delete());

  // Koleksiyon yoksa uyarı, hata olursa hatayı loglar — sessizce yutmaz.
  Future<void> _mutate(
    String op,
    Future<void> Function(CollectionReference<Map<String, dynamic>> coll)
    action,
  ) async {
    final coll = _coll();
    if (coll == null) {
      developer.log('$op atlandı: uid yok', name: _logName, level: 900);
      return;
    }
    try {
      await action(coll);
    } catch (e, s) {
      developer.log('$op HATA', name: _logName, error: e, stackTrace: s);
    }
  }
}
