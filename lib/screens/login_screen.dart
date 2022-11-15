import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';
import 'package:rastreo_bam/providers/providers.dart'
    show LoginFromProvider, PermissionsProvider;
import 'package:rastreo_bam/screens/home_screen.dart';
import 'package:rastreo_bam/services/permissions_service.dart';
import 'package:rastreo_bam/services/services.dart' show AuthService, LocalAuth;
import 'package:rastreo_bam/themes/app_theme.dart';
import 'package:rastreo_bam/widgets/widgets.dart' show Alert;
import 'package:rastreo_bam/ui/ui.dart' show InputsDecorations;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    validatePermissions();
    setState(() {});
  }

  void validatePermissions() async {
    await PermissionsService.getPermitions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderLogin(),
            ChangeNotifierProvider(
              create: (_) => LoginFromProvider(),
              child: const LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Center(
        child: Image(
          image: AssetImage('assets/logo.png'),
          height: 180,
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFromProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      width: double.infinity,
      child: Form(
        key: loginForm.formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Text(
              'Rastreo App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            InputUsername(loginForm: loginForm),
            InputPassword(loginForm: loginForm),
            Row(
              children: [
                Expanded(child: BtnLogin(loginForm: loginForm)),
                const BtnFinger(),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Version 0.0.1'),
          ],
        ),
      ),
    );
  }
}

class InputUsername extends StatelessWidget {
  const InputUsername({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFromProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        autocorrect: false,
        keyboardType: TextInputType.text,
        decoration:
            InputsDecorations.authInput(hintText: 'Usuario', label: 'Usuario'),
        onChanged: (value) => loginForm.username = value,
        validator: (value) {
          return (value ?? '').isEmpty ? 'Usuario inválido' : null;
        },
      ),
    );
  }
}

class InputPassword extends StatelessWidget {
  const InputPassword({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFromProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        autocorrect: false,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputsDecorations.authInput(
            hintText: 'Contraseña', label: 'Contraseña'),
        onChanged: (value) => loginForm.password = value,
        validator: (value) {
          return (value != null && value.length >= 5)
              ? null
              : 'Contraseña inválida';
        },
      ),
    );
  }
}

class BtnLogin extends StatelessWidget {
  const BtnLogin({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFromProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppTheme.secondary,
          ),
        ),
        onPressed:
            loginForm.isLoading ? null : () => _login(context, loginForm),
        child: Text(
          loginForm.isLoading ? 'Espere...' : 'Iniciar sesión',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class BtnFinger extends StatelessWidget {
  const BtnFinger({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localAuth = Provider.of<LocalAuth>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      width: 60,
      height: 50,
      decoration: BoxDecoration(
          color: AppTheme.secondary, borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        padding: EdgeInsets.zero,
        color: Colors.white,
        icon: const Icon(Icons.fingerprint, size: 40),
        onPressed: localAuth.isAuthenticating
            ? null
            : () => _validateAutoLogin(context, localAuth),
      ),
    );
  }
}

void _login(BuildContext context, LoginFromProvider loginForm) async {
  FocusScope.of(context).unfocus();
  if (!loginForm.isValidForm()) return;

  await EasyLoading.show(
    status: 'Validando credenciales...',
    maskType: EasyLoadingMaskType.black,
  );

  loginForm.isLoading = true;

  await AuthService.login(loginForm.username, loginForm.password).then((value) {
    EasyLoading.dismiss();
    if (value.codigo == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    } else {
      Alert(context, title: 'Error', text: value.mensaje ?? '');
      loginForm.isLoading = false;
    }
  });
}

void _validateAutoLogin(BuildContext context, LocalAuth localAuth) async {
  await AuthService.getStorageKey('usr_token').then((value) {
    if (value == null || value.isEmpty) {
      Alert(context,
          title: 'Información',
          text: 'Debe iniciar sesión por lo menos una vez');
      return;
    } else {
      _autoLogin(context, localAuth);
    }
  });
}

void _autoLogin(BuildContext context, LocalAuth localAuth) async {
  FocusScope.of(context).unfocus();

  localAuth.isAuthenticating = true;

  if (await localAuth.isDeviceSupported()) {
    if (await localAuth.authenticateWithBiometrics()) {
      await EasyLoading.show(
        status: 'Validando credenciales...',
        maskType: EasyLoadingMaskType.black,
      );
      await AuthService.autoLogin().then((value) {
        EasyLoading.dismiss();
        if (value.codigo == 200) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false);
        } else {
          localAuth.isAuthenticating = false;
          Alert(context, title: 'Error', text: value.mensaje ?? '');
        }
      });
    } else {
      localAuth.isAuthenticating = false;
      EasyLoading.showError('No se ha podido verificar su huella');
    }
  } else {
    localAuth.isAuthenticating = false;
    Alert(context, title: 'Error', text: 'Su dispositivo no es compatible.');
  }
}
