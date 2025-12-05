import 'package:flutter/material.dart';
import '../models/user.dart';

import '../models/order.dart';

class PageProfil extends StatefulWidget {
  const PageProfil({super.key});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  final _formKeySignup = GlobalKey<FormState>();
  final _formKeyLogin = GlobalKey<FormState>();

  // Inscription
  final _fullNameController = TextEditingController();
  final _emailSignUpController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordSignUpController = TextEditingController();

  // Connexion
  final _emailLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();

  bool _showLogin = false; // false = inscription, true = connexion

  @override
  void initState() {
    super.initState();
    // Si un compte existe déjà, on montre "Se connecter" par défaut
    _showLogin = UserSession.registeredUser != null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailSignUpController.dispose();
    _phoneController.dispose();
    _passwordSignUpController.dispose();
    _emailLoginController.dispose();
    _passwordLoginController.dispose();
    super.dispose();
  }

  void _registerUser() {
    if (_formKeySignup.currentState?.validate() != true) return;

    final user = User(
      fullName: _fullNameController.text.trim(),
      email: _emailSignUpController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordSignUpController.text.trim(),
    );

    UserSession.registeredUser = user;
    UserSession.loggedUser = user;
    AuthState.isLoggedIn = true;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Compte créé et connecté ✅')));

    setState(() {});
  }

  void _loginUser() {
    if (_formKeyLogin.currentState?.validate() != true) return;

    final reg = UserSession.registeredUser;
    if (reg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aucun compte enregistré, veuillez vous inscrire."),
        ),
      );
      return;
    }

    if (_emailLoginController.text.trim() != reg.email ||
        _passwordLoginController.text.trim() != reg.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou mot de passe incorrect')),
      );
      return;
    }

    UserSession.loggedUser = reg;
    AuthState.isLoggedIn = true;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Connexion réussie ✔')));

    setState(() {});
  }

  void _logoutUser() {
    AuthState.isLoggedIn = false;
    UserSession.loggedUser = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = AuthState.isLoggedIn;
    final User? logged = UserSession.loggedUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil / Connexion')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoggedIn && logged != null
                ? _buildLoggedView(logged)
                : _buildAuthTabs(),
          ),
        ),
      ),
    );
  }

  /// Vue quand l'utilisateur est connecté (version stylée)
  /// Vue quand l'utilisateur est connecté (version stylée + historique)
  Widget _buildLoggedView(User logged) {
    final orders = OrderStore.orders;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Avatar
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.blue.shade200,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),

          const SizedBox(height: 15),

          Text(
            logged.fullName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          // Carte infos
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.email, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(logged.email, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(logged.phone, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Historique des commandes
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Historique des commandes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 10),

          if (orders.isEmpty)
            const Text(
              "Aucune commande pour le moment.",
              style: TextStyle(color: Colors.grey),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final o = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text(
                      'Commande du ${o.date.day}/${o.date.month}/${o.date.year}',
                    ),
                    subtitle: Text(
                      '${o.items.length} article(s) - ${o.total.toStringAsFixed(2)} \$',
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _logoutUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Se déconnecter",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Vue avec les onglets "Se connecter" / "S'inscrire"
  Widget _buildAuthTabs() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Onglets
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showLogin = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showLogin
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                  child: const Text("Se connecter"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showLogin = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_showLogin
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                  child: const Text("S'inscrire"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Contenu selon l'onglet choisi
          _showLogin ? _buildLoginForm() : _buildSignupForm(),

          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // revenir à l'accueil en invité
            },
            child: const Text("Continuer en invité"),
          ),
        ],
      ),
    );
  }

  /// Formulaire de connexion (email + mot de passe)
  Widget _buildLoginForm() {
    return Form(
      key: _formKeyLogin,
      child: Column(
        children: [
          const Text(
            "Connexion",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailLoginController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                v != null && v.contains("@") ? null : "Email invalide",
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordLoginController,
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (v) =>
                v != null && v.isNotEmpty ? null : "Entrez le mot de passe",
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loginUser,
              child: const Text("Se connecter"),
            ),
          ),
        ],
      ),
    );
  }

  /// Formulaire d'inscription complet
  Widget _buildSignupForm() {
    return Form(
      key: _formKeySignup,
      child: Column(
        children: [
          const Text(
            "Créer un compte",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Nom complet',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? "Entrez votre nom" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailSignUpController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                v != null && v.contains("@") ? null : "Entrez un email valide",
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Téléphone',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? "Entrez un téléphone" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordSignUpController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Mot de passe',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                v != null && v.length >= 4 ? null : "Minimum 4 caractères",
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _registerUser,
              child: const Text("Créer un compte"),
            ),
          ),
        ],
      ),
    );
  }
}
