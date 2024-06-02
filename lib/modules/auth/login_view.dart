import 'package:ark_jots/modules/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // const Center(
          //     child: Text("Por favor, Inicia Sesión",
          //         style: TextStyle(fontSize: 20))),
          Image.asset(
            'assets/logo_transparent.png',
            width: 280,
            height: 280,
          ),
          Flexible(
            child: LoginButton(
              icon: Icons.verified_user,
              text: 'Cuenta de Invitado',
              loginMethod: AuthService().anonLogin,
              color: Colors.deepPurple,
            ),
          ),
          Flexible(
            child: LoginButton(
              icon: Ionicons.logo_google,
              text: 'Iniciar Sesión con Google',
              loginMethod: AuthService().googleLogin,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.color,
      required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(),
        label: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
