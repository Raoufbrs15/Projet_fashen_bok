import 'package:flutter/material.dart';
import '../data/products_data.dart';
import '../models/user.dart';
import 'page_categorie.dart';
import 'page_panier.dart';
import 'page_profil.dart';
import 'page_menu.dart';
import 'page_search.dart';


/// PAGE 2 : Accueil stylisée
class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  int _indexBas = 0;

  void _onItemTapped(int index) {
    setState(() {
      _indexBas = index;
    });

    if (index == 1) {
      // Menu
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PageMenu(),
        ),
      );
    } else if (index == 2) {
      // Panier
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PagePanier(),
        ),
      );
    } else if (index == 3) {
      // Profil
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PageProfil(),
        ),
      ).then((_) {
        
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   final bool logged = AuthState.isLoggedIn;
final User? loggedUser = UserSession.loggedUser;

final String greeting = logged && loggedUser != null
    ? 'Bonjour, ${loggedUser.fullName} 👋'
    : 'Bienvenue invité 👋';



    return Scaffold(
      backgroundColor: const Color(0xFFE5F6F6),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                const SizedBox(height: 10),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
// Barre de recherche
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12.0),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: TextField(
      decoration: const InputDecoration(
        icon: Icon(Icons.search, color: Colors.grey),
        hintText: 'Rechercher un produit...',
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        final query = value.trim();
        if (query.isEmpty) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PageSearch(initialQuery: query),
          ),
        );
      },
    ),
  ),
),

const SizedBox(height: 16),

                // SCROLLABLE
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Carte promo SOLDES
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'assets/images/soldes_50.png',
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Grille des catégories AGRANDIE
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: Wrap(
                            spacing: 30,
                            runSpacing: 30,
                            alignment: WrapAlignment.center,
                            children: [
                              // T-SHIRT
                              CategorieCard(
                                label: "T-SHIRT",
                                imagePath: 'assets/images/tshirt.png',
                                imageHeight: 140,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PageCategorie(
                                        titre: "T-shirts",
                                        products: tshirtProducts,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // CHOES
                              CategorieCard(
                                label: "CHOES",
                                imagePath: 'assets/images/shoes.png',
                                imageHeight: 140,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PageCategorie(
                                        titre: "Chaussures",
                                        products: shoesProducts,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // PANTALON
                              CategorieCard(
                                label: "PANTALON",
                                imagePath: 'assets/images/pantalon.png',
                                imageHeight: 140,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PageCategorie(
                                        titre: "Pantalons",
                                        products: pantalonProducts,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // barre nav en bas
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexBas,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Panier"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

// Carte catégorie plus grande
class CategorieCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final double imageHeight;
  final VoidCallback onTap;

  const CategorieCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.imageHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 200,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
