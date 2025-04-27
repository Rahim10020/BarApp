import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class ModifierBoissonScreen extends StatefulWidget {
  final Boisson boisson;

  const ModifierBoissonScreen({super.key, required this.boisson});

  @override
  State<ModifierBoissonScreen> createState() => _ModifierBoissonScreenState();
}

class _ModifierBoissonScreenState extends State<ModifierBoissonScreen>
    with SingleTickerProviderStateMixin {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  Modele? _modele;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _nomController.text = widget.boisson.nom ?? '';
    _prixController.text = widget.boisson.prix.last.toString();
    _descriptionController.text = widget.boisson.description ?? '';
    _modele = widget.boisson.modele;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _modifierBoisson(BarProvider provider, Boisson boisson) {
    if (_nomController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner le nom",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    } else if (_prixController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner le prix",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    } else {
      boisson.nom = _nomController.text;
      boisson.prix = [double.parse(_prixController.text)];
      boisson.modele = _modele;
      boisson.description = _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null;
      provider.updateBoisson(boisson);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${boisson.nom} modifié avec succès!",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modification de ${widget.boisson.nom ?? 'Boisson'}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nomController,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _prixController,
                      decoration: InputDecoration(
                        labelText: 'Prix',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<Modele>(
                      hint: Text(
                        'Modèle',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      value: _modele,
                      items: Modele.values
                          .map(
                            (modele) => DropdownMenuItem(
                              value: modele,
                              child: Text(
                                modele == Modele.petit ? 'Petit' : 'Grand',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _modele = value),
                      isExpanded: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.update, size: 18),
                      label: const Text('Modifier'),
                      onPressed: () =>
                          _modifierBoisson(provider, widget.boisson),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
