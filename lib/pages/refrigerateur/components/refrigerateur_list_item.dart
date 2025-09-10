import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/refrigerateur/ajouter_boisson_refrigerateur_screen.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';

class RefrigerateurListItem extends StatefulWidget {
  final Refrigerateur refrigerateur;
  final BarProvider provider;

  const RefrigerateurListItem({
    super.key,
    required this.refrigerateur,
    required this.provider,
  });

  @override
  State<RefrigerateurListItem> createState() => _RefrigerateurListItemState();
}

class _RefrigerateurListItemState extends State<RefrigerateurListItem> {
  final _nomController = TextEditingController();
  final _tempController = TextEditingController();

  void _modifierRefrigerateur() {
    if (_nomController.text.isEmpty || _nomController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner le nom",
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok", style: GoogleFonts.montserrat()),
            ),
          ],
        ),
      );
    } else if (_tempController.text.isEmpty || _tempController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner la température",
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok", style: GoogleFonts.montserrat()),
            ),
          ],
        ),
      );
    } else {
      widget.refrigerateur.nom = _nomController.text;
      widget.refrigerateur.temperature = double.tryParse(_tempController.text);
      widget.provider.updateRefrigerateur(widget.refrigerateur);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.refrigerateur.nom} modifié avec succès!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  void _resetForm() {
    _nomController.clear();
    _tempController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: ListTile(
        leading: Icon(Icons.kitchen, color: Colors.brown[600]),
        title: Text(widget.refrigerateur.nom),
        subtitle: widget.refrigerateur.temperature != null
            ? Text(
                'Temp : ${widget.refrigerateur.temperature}°C - ${widget.refrigerateur.getBoissonTotal()} boissons',
                style: GoogleFonts.montserrat(),
              )
            : Text(
                '${widget.refrigerateur.getBoissonTotal()} boissons',
                style: GoogleFonts.montserrat(),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AjouterBoissonRefrigerateurScreen(
                    refrigerateur: widget.refrigerateur,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _nomController.text = widget.refrigerateur.nom;
                _tempController.text =
                    widget.refrigerateur.temperature?.toString() ?? '';
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(
                      'Modifier ${widget.refrigerateur.nom}',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nomController,
                            decoration: InputDecoration(
                              labelText: 'Nom',
                              labelStyle: GoogleFonts.montserrat(),
                            ),
                          ),
                          TextField(
                            controller: _tempController,
                            decoration: InputDecoration(
                              labelText: 'Température (°C)',
                              labelStyle: GoogleFonts.montserrat(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _resetForm();
                        },
                        child: Text(
                          'Annuler',
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _modifierRefrigerateur();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Modifier',
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      "Voulez-vous supprimer ${widget.refrigerateur.nom} ?",
                      style: GoogleFonts.montserrat(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Annuler",
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.provider
                              .deleteRefrigerateur(widget.refrigerateur);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.refrigerateur.nom} supprimé avec succès!',
                                style: GoogleFonts.montserrat(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Oui",
                          style: GoogleFonts.montserrat(),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RefrigerateurDetailScreen(
              refrigerateur: widget.refrigerateur,
            ),
          ),
        ),
      ),
    );
  }
}
