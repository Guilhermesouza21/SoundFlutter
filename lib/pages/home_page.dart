import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(int)? onTabChange;

  const HomePage({
    super.key,
    this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'INÍCIO',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Olá! 🎧',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bem-vindo ao seu aplicativo de música. O que gostaria de fazer hoje?',
                style: TextStyle(
                  fontSize: 15,
                  color: const Color(0x99FFFFFF),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Acesso Rápido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 16),
              
              // Card para acessar a aba de Busca
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0x0DFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.search_rounded, 
                        size: 24, 
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'Pesquisar Músicas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      'Encontre faixas e artistas na biblioteca do iTunes',
                      style: TextStyle(
                        color: Color(0x80FFFFFF),
                        fontSize: 13,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                    onTap: () => onTabChange?.call(1),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Card para acessar a aba de Favoritos
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0x0DFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded, 
                        size: 24, 
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'Minhas Músicas Favoritas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      'Veja suas faixas curtidas salvas offline',
                      style: TextStyle(
                        color: Color(0x80FFFFFF),
                        fontSize: 13,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                    onTap: () => onTabChange?.call(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}