import 'package:flutter/material.dart';

class BoissonPopulairePage extends StatefulWidget {
  const BoissonPopulairePage({super.key});

  @override
  State<BoissonPopulairePage> createState() => _BoissonPopulairePageState();
}

class _BoissonPopulairePageState extends State<BoissonPopulairePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.water_drop_outlined, size: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                "Voulez-vous modifier cette boisson ?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler"),
                              ),
                              const TextButton(
                                onPressed: null,
                                child: Text("Oui"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8.0, top: 16.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 28.0,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                "Voulez-vous supprimer cette boisson ?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler"),
                              ),
                              const TextButton(
                                onPressed: null,
                                child: Text("Oui"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 16.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle),
                        child: Icon(Icons.delete_outlined,
                            size: 28.0, color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 12.0,
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Ajouté le 19/02/2025",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if (2 == 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Row(
                      children: [
                        Text(
                          "Modifié le 20/02/2025",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.remove),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "5",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "500 FCFA",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      if (0 > 1)
                        Text(
                          "600 FCFA",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
                              decorationColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              decorationThickness: 2.0),
                        ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      if (0 > 2)
                        GestureDetector(
                          onTap: null,
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        "Petit",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Boisson douce douce",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Casiers",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4.0),
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "8",
                                  style: TextStyle(
                                      color: Colors.yellow.shade900,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Bouton de décrémentation
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Icon(Icons.remove,
                              size: 20.0,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),

                        // Quantité
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 20.0,
                            child: Center(
                              child: Text("3"),
                            ),
                          ),
                        ),

                        // Bouton d'incrémentation
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Icon(Icons.add,
                              size: 20.0,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                GestureDetector(
                  onTap: null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 64.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    decoration: BoxDecoration(
                        color: 1 > 0
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vendre",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),

                        const SizedBox(
                          width: 20.0,
                        ),

                        // Icon
                        Icon(Icons.sell,
                            color: Theme.of(context).colorScheme.tertiary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only(left: 25.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_rounded)),
            ),
          ),
        ),
      ],
    );
  }
}
