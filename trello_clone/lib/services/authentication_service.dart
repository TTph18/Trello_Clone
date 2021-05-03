import 'package:firebase_auth/firebase_auth.dart';

Future<String?> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return "Signed In";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' )
    return "Tài khoản không tồn tại";
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}

Future<bool> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('Mật khẩu yếu');
    } else if (e.code == 'email-already-in-use') {
      print('Tài khoản sử dụng email đã tồn tại');
    }
    return false;
  } catch (e) {
    print(e.toString());
    return false;
  }
}