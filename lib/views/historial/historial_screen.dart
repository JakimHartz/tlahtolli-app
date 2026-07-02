import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/traductor_viewmodel.dart';
import '../detalle/resultado_screen.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  @override
  void initState() {
    super.initState();
    // Forzamos la actualización de la lista cronológica local al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TraductorViewModel>(context, listen: false).cargarHistorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TraductorViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial de Consultas',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          // Botón de acción rápida para vaciar la tabla en SQLite
          if (vm.historial.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 26),
              tooltip: 'Vaciar historial',
              onPressed: () {
                _mostrarDialogoConfirmacion(context, vm);
              },
            ),
        ],
      ),
      body: vm.historial.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Historial vacío',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tus consultas recientes aparecerán aquí.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.historial.length,
              itemBuilder: (context, index) {
                final palabra = vm.historial[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.backgroundColor,
                      child: Icon(Icons.search_rounded, color: AppTheme.primaryColor, size: 20),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          palabra.terminoNahuatl,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                      ],
                    ),
                    subtitle: Text(
                      'Español: ${palabra.terminoEspanol}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    onTap: () {
                      // Permite al usuario volver a consultar la palabra desde el historial
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultadoScreen(palabra: palabra),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  /// **Cuadro de diálogo de confirmación (Buenas prácticas UX/UI)**
  void _mostrarDialogoConfirmacion(BuildContext context, TraductorViewModel vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('¿Borrar historial?', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Esta acción eliminará de forma permanente el registro de todas tus consultas de traducción locales.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCELAR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () async {
                await vm.borrarHistorial();
                if (!context.mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Historial limpiado correctamente'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('ELIMINAR', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}