import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/utils/helpers.dart';

class BoissonDetailScreen extends StatelessWidget {
  final Boisson boisson;

  const BoissonDetailScreen({super.key, required this.boisson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          boisson.nom ?? 'Boisson',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6,
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          boisson.estFroid ? Icons.ac_unit : Icons.local_bar,
                          size: 80,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildInfoCard(
                            label: 'Nom',
                            value: boisson.nom ?? 'N/A',
                          ),
                          BuildInfoCard(
                            label: 'Prix',
                            value: Helpers.formatterEnCFA(boisson.prix.last),
                          ),
                          BuildInfoCard(
                            label: 'Froide',
                            value: boisson.estFroid ? 'Oui' : 'Non',
                          ),
                          BuildInfoCard(
                            label: 'Modèle',
                            value: boisson.getModele() ?? 'N/A',
                          ),
                          BuildInfoCard(
                            label: 'Description',
                            value: boisson.description ?? 'Aucune',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
