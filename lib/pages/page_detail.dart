import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import 'page_panier.dart';

class PageDetail extends StatelessWidget {
  final Product product;

  const PageDetail({super.key, required this.product});

  String _generateDescription() {
    return "Découvrez notre ${product.name} à un excellent rapport qualité/prix. "
        "Un choix parfait pour compléter votre style au quotidien.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image avec Hero
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Hero(
                      tag: product.id, // même tag que dans PageCategorie
                      child: Image.asset(
                        product.imagePath,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nom + prix
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${product.price.toStringAsFixed(2)} \$",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _generateDescription(),
                style: const TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Cart.add(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text("${product.name} ajouté au panier"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Ajouter au panier"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Cart.add(product);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PagePanier(),
                          ),
                        );
                      },
                      child: const Text("Acheter maintenant"),
                    ),
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
gi