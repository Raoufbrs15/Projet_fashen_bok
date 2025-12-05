import 'package:flutter/material.dart';
import '../data/products_data.dart';
import 'page_categorie.dart';

class PageMenu extends StatelessWidget {
  const PageMenu({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Catégories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const Divider(),

          // T-SHIRT
          ListTile(
            leading: const Icon(Icons.checkroom),
            title: const Text('T-shirts'),
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

          // CHAUSSURES
          ListTile(
            leading: const Icon(Icons.directions_run),
            title: const Text('Chaussures'),
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

          // PANTALONS
          ListTile(
            leading: const Icon(Icons.checkroom),
            title: const Text('Pantalons'),
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
    );
  }
}
