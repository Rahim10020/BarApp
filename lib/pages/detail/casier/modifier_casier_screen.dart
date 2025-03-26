import 'package:flutter/material.dart';
import 'package:projet7/components/build_boisson_selector.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class ModifierCasierScreen extends StatefulWidget {
  final Casier casier;

  const ModifierCasierScreen({super.key, required this.casier});

  @override
  State<ModifierCasierScreen> createState() => _ModifierCasierScreenState();
}

class _ModifierCasierScreenState extends State<ModifierCasierScreen> {
  final List<Boisson> _boissonsSelectionnees = [];
  int selectedIndex = 0;
  Boisson? boissonSelectionnee;
  final _boissonTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _boissonTotalController.text = widget.casier.boissonTotal.toString();
    final provider = Provider.of<BarProvider>(context, listen: false);
    for (int i = 0; i < provider.boissons.length; i++) {
      if (widget.casier.boissons[0] == provider.boissons[i]) {
        setState(() {
          selectedIndex = i;
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _boissonTotalController.dispose();
  }

  void _modifierCasier(BarProvider provider, Casier casier) {
    if (_boissonTotalController.text.isEmpty ||
        _boissonTotalController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez préciser le nombre total de boissons"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else {
      for (int i = 0; i < num.tryParse(_boissonTotalController.text)!; i++) {
        _boissonsSelectionnees.add(boissonSelectionnee!);
      }

      casier.boissonTotal =
          int.tryParse(_boissonTotalController.text) ?? casier.boissons.length;
      casier.boissons = _boissonsSelectionnees;
      provider.updateCasier(casier);
      setState(() {
        _boissonsSelectionnees.clear();
        _boissonTotalController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(" Modification de Casier #${widget.casier.id} "),
        backgroundColor: Colors.brown[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: _boissonTotalController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre total de boissons'),
                  keyboardType: TextInputType.number),
              const SizedBox(
                height: 8.0,
              ),
              BuildBoissonSelector(
                itemCount: provider.boissons.length,
                itemBuilder: (context, index) {
                  var boisson = provider.boissons[index];

                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedIndex = index;
                      boissonSelectionnee = boisson;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? Colors.brown[200]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(boisson.nom ?? 'Sans nom'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.update,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'Modifier',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8)),
                onPressed: () {
                  _modifierCasier(provider, widget.casier);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
