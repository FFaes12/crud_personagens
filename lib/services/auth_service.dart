import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Aqui fica o Vigia: emite o usuário (ou null) sempre que a sessão muda
  Stream<User?> get estadoSessao => _auth.authStateChanges();

  User? get usuarioAtual => _auth.currentUser;

  // Chamada única que dispara o fluxo de login
  Future<void> entrar(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> cadastrar(String email, String senha) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: senha,
    );

    if (credential.user != null) {
      // Cria o documento de perfil do usuário na coleção raiz "usuarios"
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(credential.user!.uid)
          .set({
        'email': credential.user!.email,
        'dataCriacao': FieldValue.serverTimestamp(),
      });
    }
  }
   
  Future<void> sair() => _auth.signOut();
}