import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../inicio/traductor_screen.dart';
import '../favoritos/favoritos_screen.dart';
import '../historial/historial_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista de las pantallas principales asociadas a cada pestaña de navegación
  final List<Widget> _pantallas = [
    const TraductorScreen(),
    const FavoritosScreen(),
    const HistorialScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // KeepAlive automático para las vistas usando IndexedStack (evita que se reinicie el estado al cambiar de pestaña)
      body: IndexedStack(
        index: _currentIndex,
        children: _pantallas,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // Configuración estética alineada a la justificación cultural y académica
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.accentColor,   // Verde Turquesa / Jade para el elemento activo
          unselectedItemColor: Colors.grey.shade500, // Gris suave para los inactivos
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.translate_rounded),
              activeIcon: Icon(Icons.translate_rounded, size: 28),
              label: 'Traductor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border_rounded),
              activeIcon: Icon(Icons.star_rounded, size: 28),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_toggle_off_rounded, size: 28),
              label: 'Historial',
            ),
          ],
        ),
      ),
    );
  }
}