import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/palabra_model.dart';
import '../../viewmodels/traductor_viewmodel.dart';

class ResultadoScreen extends StatefulWidget {
  final PalabraModel palabra;

  const ResultadoScreen({super.key, required this.palabra});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  @override
  void initState() {
    super.initState();
    // Al entrar a la pantalla, validamos de inmediato si esta palabra ya está en favoritos locales
    if (widget.palabra.idPalabra != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TraductorViewModel>(context, listen: false)
            .verificarFavoritoStatus(widget.palabra.idPalabra!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TraductorViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Traducción',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Botón de estrella interactivo conectado a SQLite
          if (widget.palabra.idPalabra != null)
            IconButton(
              icon: Icon(
                vm.esPalabraFavorita ? Icons.star_rounded : Icons.star_border_rounded,
                color: vm.esPalabraFavorita ? Colors.amber : Colors.white,
                size: 28,
              ),
              onPressed: () => vm.toggleFavorito(widget.palabra),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // Tarjeta Principal de Resultados (UI/UX Limpia y Académica)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Término en Español
                  Text(
                    'ESPAÑOL',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.grey.shade500,
                      letterSpacing: 1
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.palabra.terminoEspanol,
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: AppTheme.primaryColor
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  ),

                  // Término en Náhuatl
                  Text(
                    'NÁHUATL',
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.grey.shade500,
                      letterSpacing: 1
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.palabra.terminoNahuatl,
                    style: const TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: AppTheme.accentColor
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Transcripción Fonética Normalizada (AFI)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.volume_up_rounded, size: 18, color: AppTheme.accentColor),
                        const SizedBox(width: 8),
                        Text(
                          'Pronunciación: ${widget.palabra.transcripcionFonetica}',
                          style: TextStyle(
                            fontSize: 13