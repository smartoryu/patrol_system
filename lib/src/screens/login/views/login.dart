// ignore_for_file: unnecessary_this, avoid_print

import 'package:nusalima_patrol_system/src/views.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/login-screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  bool isVisible = false;
  String? errorEmail;
  String? errorPass;
  String error = "";
  bool isLoading = false;

  void togglePass() => setState(() => isVisible = !isVisible);
  void requestStart() => setState(() {
        error = "";
        isLoading = true;
      });
  void requestFailed(String e) => setState(() {
        error = e;
        isLoading = false;
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: myAppBarMinimal(),
        backgroundColor: kWhite,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: MediaQuery.of(context).size.height * 0.25,
                  bottom: MediaQuery.of(context).size.height * 0.25,
                ),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: kPrimary,
                          ),
                    ),
                    const SizedBox(height: 60),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) {
                              setState(() => this.email = value);
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              hintText: 'Email',
                              errorText: this.errorEmail,
                            ),
                            validator: (value) {
                              // The validator receives the text that the user has entered.
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              // if (value != "admin@mail.com" &&
                              //     value != "user@mail.com") {
                              //   return 'Hanya admin@mail.com atau user@mail.com';
                              // }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            onChanged: (value) {
                              setState(() => this.password = value);
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Password',
                              errorText: this.errorPass,
                              suffixIcon: GestureDetector(
                                onTap: togglePass,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 12, 0),
                                  child: this.isVisible
                                      ? Icon(Icons.visibility_off,
                                          color: fromRGB("#979797"))
                                      : Icon(Icons.visibility,
                                          color: fromRGB("#979797")),
                                ),
                              ),
                            ),
                            validator: (value) {
                              // The validator receives the text that the user has entered.
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    MyButton(
                      "Login",
                      onTap: () async {
                        try {
                          requestStart();
                          // var result = await _auth.signInAnon();
                          var result = await _auth.signInWithEmailAndPassword(
                            this.email,
                            this.password,
                          );

                          if (result == null) {
                            debugPrint("erorr signing in");
                          } else {
                            debugPrint("signed in");
                            print(result);
                          }

                          _formKey.currentState!.validate();

                          if (this.email == "admin@mail.com") {
                            Navigator.pushNamed(context, HomeAdminScreen.route);
                          } else if (this.email == "user@mail.com") {
                            Navigator.pushNamed(context, HomeUserScreen.route);
                          }
                        } catch (e) {
                          String errMsg = e.toString();
                          print(errMsg);
                          if (errMsg.contains("user-disabled")) {
                            requestFailed("Account Disabled");
                          } else if (errMsg.contains("wrong-password")) {
                            requestFailed("Wrong Password");
                          } else if (errMsg.contains("user-not-found")) {
                            requestFailed("Email not registered");
                          } else {
                            requestFailed("Server Failed");
                          }
                        }
                      },
                      childAlign: MainAxisAlignment.spaceBetween,
                      iconPrefix: const SizedBox(width: 20),
                      iconSuffix: SizedBox(
                        width: 20,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: kWhite,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kDanger, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
