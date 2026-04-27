import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/local/app_database.dart';
import 'data/remote/note_remote_service.dart';
import 'features/auth/auth_service.dart';
import 'features/notes/note_repository.dart';
import 'features/notes/notes_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar dependencias
  final database = AppDatabase();
  final remoteService = NoteRemoteService();
  final repository = NoteRepository(
    localDb: database,
    remoteService: remoteService,
  );
  final authService = AuthService();

  runApp(BetsApp(repository: repository, authService: authService));
}

class BetsApp extends StatelessWidget {
  final NoteRepository repository;
  final AuthService authService;

  const BetsApp({
    super.key,
    required this.repository,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fight Picks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      // Auth desactivada temporalmente — va directo a notas
      home: NotesPage(
        repository: repository,
        authService: authService,
      ),
    );
  }
}
