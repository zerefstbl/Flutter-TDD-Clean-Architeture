import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

import 'components/components.dart';
import '../../components/component.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter!.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter!.mainErrorStream.listen((error) {
            showErrorMessage(context, error);
          });
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                HeadLine1(text: 'Login'),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: Provider(
                              create: (_) => widget.presenter,
                              child: PasswordInput(),
                            ),
                          ),
                          Provider(
                            create: (_) => widget.presenter,
                            child: LoginButton(),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person, color: Colors.black),
                            label: const Text(
                              'Criar conta',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
