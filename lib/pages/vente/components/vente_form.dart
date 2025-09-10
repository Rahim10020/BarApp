import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/provider/bar_provider.dart';

class VenteForm extends StatefulWidget {
  final BarProvider provider;
  final List<Boisson> boissonsSelectionnees;
  final bool isAdding;
  final Function() onAjouterVente;

  const VenteForm({
    super.key,
    required this.provider,
    required this.boissonsSelectionnees,
    required this.isAdding,
    required this.onAjouterVente,
  });

  @override
  State<VenteForm> createState() => _VenteFormState();
}

class _VenteFormState extends State<VenteForm> {
  @override
  Widget build(BuildContext context) {
    // Limiter les boissons disponibles à celles des réfrigérateurs
    var boissonsDisponibles =
        widget.provider.refrigerateurs.expand((r) => r.boissons ?? []).toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(widget.isAdding ? 20 : 16),
      decoration: BoxDecoration(
        color: widget.isAdding
            ? Colors.green[200]
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black26,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ajouter une vente',
            style: GoogleFonts.montserrat(),
          ),
          const SizedBox(
            height: 24.0,
          ),
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: boissonsDisponibles.length,
              itemBuilder: (context, index) {
                var boisson = boissonsDisponibles[index];
                bool isSelected =
                    widget.boissonsSelectionnees.contains(boisson);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      widget.boissonsSelectionnees.remove(boisson);
                    } else {
                      widget.boissonsSelectionnees.add(boisson);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.only(
                      left: 9,
                      right: 9,
                      top: 6,
                      bottom: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_bar,
                              size: 20,
                              color: Colors.brown[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              boisson.nom ?? 'Sans nom',
                              style: GoogleFonts.montserrat(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          ' (${boisson.getModele()})',
                          style: GoogleFonts.montserrat(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 14.0,
          ),
          ElevatedButton.icon(
            icon: const Icon(
              Icons.local_drink,
              color: Colors.white,
            ),
            label: Text(
              'Enregistrer',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[600]),
            onPressed: widget.boissonsSelectionnees.isNotEmpty
                ? widget.onAjouterVente
                : null,
          ),
        ],
      ),
    );
  }
}
