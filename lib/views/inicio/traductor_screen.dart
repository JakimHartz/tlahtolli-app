import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/traductor_viewmodel.dart';
import '../detalle/resultado_screen.dart';

class TraductorScreen extends StatefulWidget {
  const TraductorScreen({super.key});

  @override
  State<TraductorScreen> createState() => _TraductorScreenState();
}

class _TraductorScreenState extends State<TraductorScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _procesarBusqueda(TraductorViewModel vm) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    // Simulación de red: asumimos que hay internet (puedes cambiarlo a false para probar el fallback offline de SQLite)
    const bool tieneInternetSimulado = true;

    await vm.ejecutarTraduccion(query, tieneInternetSimulado);

    if (vm.mensajeError == null && vm.resultados.isNotEmpty) {
      // Navegación automática a la pantalla de detalle con el primer resultado encontrado
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoScreen(palabra: vm.resultados.first),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TraductorViewModel>(context);

    // Definición de etiquetas dinámicas según la dirección seleccionada en el ViewModel
    final esEspToNah = vm.direccionTraduccion == 'es_to_nah';
    final idiomaOrigen = esEspToNah ? 'Español' : 'Náhuatl';
    final idiomaDestino = esEspToNah ? 'Náhuatl' : 'Español';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TLAHTOLLI',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            
            // Selector / Alternador de Idioma (UI/UX Moderna)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    idiomaOrigen,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz_rounded, color: AppTheme.accentColor, size: 28),
                    onPressed: () => vm.alternarDireccion(),
                  ),
                  Text(
                    idiomaDestino,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // Entrada de Texto
            Text(
              'Término a buscar:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _procesarBusqueda(vm),
              decoration: InputDecoration(
                hintText: esEspToNah ? 'Ej. Hablar, Maíz, Sol...' : 'Ej. Tlahtoa, Cintli, Tonatiuh...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (text) => setState(() {}),
            ),
            
            const SizedBox(height: 24),

            // Botón de Acción Principal (Estilizado con Guinda)
            ElevatedButton(
              onPressed: vm.estaCargando ? null : () => _procesarBusqueda(vm),
              child: vm.estaCargando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'TRADUCIR',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1),
                    ),
            ),

            const SizedBox(height: 20),

            // Manejo Visual de Errores en la Vista
            if (vm.mensajeError != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  vm.mensajeError!,
                  style: TextStyle(color: Colors.red.shade900, fontSize: 14),
                  textAlign: TextAlign.center, // <-- Corregido aquí
                ),
              ),
          ],
        ),
      ),
    );
  }
}