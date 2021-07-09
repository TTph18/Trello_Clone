import 'package:firebase_auth/firebase_auth.dart';
import 'package:trello_clone/services/database.dart';

Future<String?> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return "Signed In";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' ) {
      print(e.toString());
      return "Tài khoản không tồn tại";
    }
    if (e.code == 'wrong-password' ) {
      print(e.toString());
      return "Mật khẩu sai";
    }
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

Future<String?> register(String email, String password, String userName, String profileName) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value)  {
          var newUID = value.user!.uid;
          var newEmail = value.user!.email;
        DatabaseService.addUser(newUID, newEmail!, userName, profileName);
        });
    return "Registered";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return "Mật khẩu yếu";
    } else if (e.code == 'email-already-in-use') {
      print(e.toString());
      return "Tài khoản sử dụng email đã tồn tại";
    }
  } catch (e) {
    return e.toString();
  }
}