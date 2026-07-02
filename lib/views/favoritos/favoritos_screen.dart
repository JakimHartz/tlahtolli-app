import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/traductor_viewmodel.dart';
import '../detalle/resultado_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState(); // <-- Aseguramos este nombre
}

class _FavoritosScreenState extends State<FavoritosScreen> { // <-- Cambiado aquí
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TraductorViewModel>(context, listen: false).cargarFavoritos();
    });
  }
// ... El resto del código sigue igual hasta llegar al Card de abajo

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TraductorViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Términos Favoritos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: vm.favoritos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border_rounded, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes palabras guardadas',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Presiona la estrella al traducir para verlas aquí.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.favoritos.length,
              itemBuilder: (context, index) {
                final palabra = vm.favoritos[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    title: Text(
                      palabra.terminoNahuatl,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.accentColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Significado: ${palabra.terminoEspanol}',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                        ),
                        Text(
                          'Pronunciación: ${palabra.transcripcionFonetica}',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: () async {
                        // Eliminación reactiva instantánea desde la lista offline
                        await vm.verificarFavoritoStatus(palabra.idPalabra!);
                        await vm.toggleFavorito(palabra);
                      },
                    ),
                    onTap: () {
                      // Permite al usuario regresar a la vista de detalle
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
}