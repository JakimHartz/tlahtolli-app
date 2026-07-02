import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/traductor_viewmodel.dart';
import 'views/widgets/custom_bottom_nav.dart'; // Importamos la nueva pantalla de navegación

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TlahtolliApp());
}

class TlahtolliApp extends StatelessWidget {
  const TlahtolliApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inyectamos el ViewModel en la raíz para que sea accesible desde cualquier pantalla
    return ChangeNotifierProvider(
      create: (context) => TraductorViewModel()..cargarHistorial()..cargarFavoritos(),
      child: MaterialApp(
        title: 'Tlahtolli',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainScreen(), // <-- Cambiamos esto a MainScreen
      ),
    );
  }
}