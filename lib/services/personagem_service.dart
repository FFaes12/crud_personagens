import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonagemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Usuário não está logado");
    return user.uid;
  }

  // --- PARTE 1: CRUD DE PERSONAGENS ---
  // Adicionamos a tipagem exata <Map<String, dynamic>> aqui para a tela não reclamar
  CollectionReference<Map<String, dynamic>> get _personagensRef =>
      _firestore.collection('usuarios').doc(_uid).collection('personagens');

  Stream<QuerySnapshot<Map<String, dynamic>>> listarPersonagens() {
    return _personagensRef.snapshots();
  }

  Future<void> criarHeroi(dynamic heroi) async {
    Map<String, dynamic> dados;
    
    if (heroi is Map) {
      dados = Map<String, dynamic>.from(heroi);
    } else {
      dados = heroi.toMap(); 
    }

    dados.remove('userId');
    await _personagensRef.add(dados);
  }

  Future<void> tomarDano(String id, int novaVida) async {
    await _personagensRef.doc(id).update({'vida': novaVida});
  }

  Future<void> deletarPersonagem(String id) async {
    await _personagensRef.doc(id).delete();
  }

  // --- PARTE 3: FUNCIONALIDADE DE MISSÕES ---
  CollectionReference<Map<String, dynamic>> get _missoesRef =>
      _firestore.collection('usuarios').doc(_uid).collection('missoes');

  Stream<QuerySnapshot<Map<String, dynamic>>> getMissoes() {
    return _missoesRef.snapshots();
  }

  Future<void> registrarMissaoConcluida(String titulo) {
    return _missoesRef.add({
      'titulo': titulo,
      'concluidaEm': FieldValue.serverTimestamp(),
    });
  }
}