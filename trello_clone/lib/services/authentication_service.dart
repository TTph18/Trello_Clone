import 'package:firebase_auth/firebase_auth.dart';

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
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}

Future<String?> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return "Registerd";
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