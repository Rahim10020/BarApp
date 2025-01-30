import 'package:flutter/material.dart';
import 'package:projet7/components/my_button.dart';
import 'package:projet7/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void register() {}

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
            const SizedBox(height: 16),
            // password textfield
            MyTextfield(
              controller: passwordController,
              hintText: "Mot de passe...",
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // confirm password textfield
            MyTextfield(
              controller: confirmPasswordController,
              hintText: "Confirmer le mot de passe...",
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // boutton pour se connecter
            MyButton(
              onTap: register,
              text: "Creer compte",
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // the text
                Text(
                  "Vous avez deja un compte ?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(width: 9),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Connectez-vous",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
