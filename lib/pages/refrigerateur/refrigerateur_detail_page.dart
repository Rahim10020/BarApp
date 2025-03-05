import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/detail/components/my_back_button.dart';
import 'package:projet7/pages/refrigerateur/components/refrigerateur_boisson_box.dart';
import 'package:projet7/pages/refrigerateur/components/refrigerateur_box.dart';
import 'package:projet7/provider/refrigerateur_provider.dart';
import 'package:projet7/theme/my_colors.dart';
import 'package:provider/provider.dart';

class RefrigerateurDetailPage extends StatelessWidget {
  final Refrigerateur refrigerateur;

  const RefrigerateurDetailPage({super.key, required this.refrigerateur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.kitchen),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              refrigerateur.id.toString(),
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Voulez-vous vider le réfrigérateur ?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Annuler"),
                        ),
                        TextButton(
                          onPressed: () => refrigerateur.boissons!.clear(),
                          child: const Text("Oui"),
                        ),
                      ],
                    ),
                  ),
              icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: Column(
        children: [
          refrigerateur.boissons == null
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          color: Theme.of(context).colorScheme.primary,
                          size: 120.0,
                        ),
                        const Text(
                          "Aucune boisson disponible",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: MyColors.vert,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: refrigerateur.boissons!.length,
                    itemBuilder: (context, index) {
                      final boisson = refrigerateur.boissons![index];
                      return RefrigerateurBoissonBox(
                        boisson: boisson,
                        onTap: null,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
