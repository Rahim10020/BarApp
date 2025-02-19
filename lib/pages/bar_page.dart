import 'package:flutter/material.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/components/boisson_populaire_box.dart';
import 'package:projet7/components/casier_box.dart';

class BarPage extends StatelessWidget {
  const BarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Voir les boissons",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18.0,
                ),
              ),
              GestureDetector(
                onTap: null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    "Voir tout",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: Expanded(
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return const BoissonBox(
                  text: "Fanta",
                  icon: Icons.water_drop_outlined,
                  onTap: null,
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Text(
                "Casiers récemments ajoutés",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Voir tout",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        2 == 1
            ? SizedBox(
                height: 180.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        Icons.inbox,
                        size: 120.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Aucun élément",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const CasierBox(
                      onTap: null,
                    );
                  },
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Boissons populaires",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 18.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: null,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Voir tout",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ),
          ],
        ),
        2 == 1
            ? SizedBox(
                height: 180.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        Icons.inbox,
                        size: 120.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Aucun élément",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const BoissonPopulaireBox(
                      onTap: null,
                    );
                  },
                ),
              ),
      ],
    );
  }
}
