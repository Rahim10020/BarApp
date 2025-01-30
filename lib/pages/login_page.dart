import 'package:flutter/material.dart';
import 'package:projet7/components/my_button.dart';
import 'package:projet7/components/my_textfield.dart';
import 'package:projet7/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    // gerer les authentifications ici

    // naviguer vers la homePage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon d'une boisson
            Icon(
              Icons.shop,
              size: 88,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 10),
            // nom du bar
            Text(
              "Bar la Royaute",
              style: TextStyle(
                fontSize: 19,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 25),
            // username textfield
            MyTextfield(
              controller: usernameController,
              hintText: "Nom d'utilisateur...",
              obscureText: false,
            ),
            const SizedBox(
              height: 16,
            ),
            // password textfield
            MyTextfield(
              controller: passwordController,
              hintText: "Mot de passe...",
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // boutton pour se connecter
            MyButton(
              onTap: login,
              text: "Connecter",
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // the text
                Text(
                  "Vous n'avez pas de compte ?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 9),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Creer un Compte",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
