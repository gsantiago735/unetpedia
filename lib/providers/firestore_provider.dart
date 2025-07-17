import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unetpedia/models/generic/generic_enums.dart';
import 'package:unetpedia/models/authentication/register_request_model.dart';

class FirestoreProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _userCollection = "users";

  // ========================================================================
  //  Users
  // ========================================================================

  Future<void> createUserDocument(RegisterRequestModel user, String uid) async {
    final DocumentReference ref = _db.collection(_userCollection).doc(uid);

    return await ref.set({
      "uid": uid,
      "name": user.name,
      "lastName": user.lastName,
      "email": user.email,
      "photoUrl": user.photoUrl,
      "role": user.role,
      "description": user.description,
      "careerId": user.careerId,
      "registerDate": DateTime.now(),
      "lastSignIn": DateTime.now(),
      "platform": "app",
    }, SetOptions(merge: true));
    // merge: true indica que en caso de ya existir el documento en la base
    // de datos hace un update de los mismos y si no existe hace un set
    // escribiendo un documento nuevo.
    //
    // En cambio si se pone merge como false en caso de que el documento exista
    // lo sobreescribe eliminando el documento anterior.
    //
    // La diferencia con un merge true o un update es que si tenias un campo
    // que no viene en el nuevo setData y estaba anteriormente en ese documento
    // seria eliminado.
  }

  // Update user profile url in user document
  Future<void> updateProfileUrl(String uid, String url) async {
    final DocumentReference ref = _db.collection(_userCollection).doc(uid);

    await ref.update({"photoUrl": url});
  }

  /// This function returns the url of an image uploaded
  Future<String> uploadImage({
    required StoragePath storagePath,
    required String path,
    required File image,
  }) async {
    late String url;

    try {
      // Creating path -> storagePath/path/image.jpg
      final Reference reference = _storage
          .ref()
          .child(storagePath.toPath())
          .child(path);

      // Uploading Asset
      final UploadTask imageToUpload = reference.putFile(image);

      // Getting download url
      await imageToUpload.then(
        (task) async => url = await task.ref.getDownloadURL(),
      );

      return url;
    } catch (e) {
      return "Error";
    }
  }
}
