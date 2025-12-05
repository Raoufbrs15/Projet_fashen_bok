import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import 'page_detail.dart';

class PageCategorie extends StatelessWidget {
  final String titre;
  final List<Product> products;

  const PageCategorie({
    super.key,
    required this.titre,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titre)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Nombre de colonnes selon la largeur de l'écran jai fait le standrad siz
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1100) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 800) {
            crossAxisCount = 3;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.70, // hauteur des cartes
            ),
            itemBuilder: (context, index) {
              final p = products[index];
              return _ProductCard(product: p);
            },
          );
        },
      ),
    );
  }
}

//Carte produit le styyle de la page
class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Aller à la page détail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageDetail(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image avec Hero
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Hero(
                    tag: product.id,
                    child: Image.asset(
                      product.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Nom
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

              // Prix
              Text(
                '${product.price.toStringAsFixed(2)} \$',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 6),

              // Ligne boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageDetail(product: product),
                        ),
                      );
                    },
                    child: const Text('Voir détail'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      Cart.add(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('${product.name} ajouté au panier'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
