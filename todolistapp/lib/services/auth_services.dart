import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

//Login
  Future<User?> signInWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

//Cadastro

  Future<User?> registerWithEmailAndPassword(String email, String password)async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

// Sair

  Future<void> signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }




}