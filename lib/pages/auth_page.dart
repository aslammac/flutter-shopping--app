import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import 'package:flare_flutter/flare_actor.dart';

//providers
import '../provider/auth.dart';
//pages
import '../pages/product_overview_page.dart';

enum AuthMode { Signup, Login, ForgotPassword }

class AuthPage extends StatelessWidget {
  static const routeName = '/auth-page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Container(
          //   color: Color.fromRGBO(255, 255, 255, 0.19),
          // ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  // Color(0xFF455A64),
                  Colors.blueGrey[800],
                  Colors.blueGrey[800],
                  Colors.blueGrey[900]
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Go on.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                AuthCard(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailFocusNode = FocusNode();
  var _authMode = AuthMode.Login;

  AnimationController _controller;
  Animation<double> _fadeAnimation;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeIn, parent: _controller));
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        print('has focus');
      }
      if (!_emailFocusNode.hasFocus) {
        print('no focus');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(() {});
    _emailFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  final _passwordController = TextEditingController();
  Future<void> _submit() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email'], _authData['password']);
        Navigator.of(context)
            .pushReplacementNamed(ProductOverviewPage.routeName);
      } on HttpException catch (e) {
        // print(e.toString());
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            e.toString().replaceAll('_', ' '),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      } catch (e) {
        print(e.toString());

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('An error occured'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } else if (_authMode == AuthMode.Login) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      } on HttpException catch (e) {
        // print(e.toString());
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            e.toString().replaceAll('_', ' '),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      } catch (e) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('An error occured'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    } else if (_authMode == AuthMode.ForgotPassword) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .forgotPassword(_authData['email'])
            .then((value) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              'Check your mail.',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Theme.of(context).primaryColor,
          ));
          setState(() {
            _authMode = AuthMode.Login;
          });
        });
      } on HttpException catch (e) {
        // print(e.toString());
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            e.toString().replaceAll('_', ' '),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      } catch (e) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('An error occured'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ));
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void switchAuthMode([bool forgot = false]) {
    if (forgot == true) {
      setState(() {
        _authMode = AuthMode.ForgotPassword;
      });
    } else if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else if (_authMode == AuthMode.Signup) {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
      height: _authMode == AuthMode.Login
          ? 323
          : _authMode == AuthMode.ForgotPassword
              ? 263
              : 410,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  focusNode: _emailFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.black12,
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.amberAccent,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: Colors.black12,
                        width: 2.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _authData['email'] = newValue;
                  },
                  onFieldSubmitted: _authMode == AuthMode.ForgotPassword
                      ? (_) => _submit()
                      : null,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              if (_authMode != AuthMode.ForgotPassword)
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.security,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.amberAccent,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0.0,
                            ),
                          ),
                        ),
                        textInputAction: _authMode == AuthMode.Signup
                            ? TextInputAction.next
                            : TextInputAction.done,
                        validator: _authMode != AuthMode.ForgotPassword
                            ? (value) {
                                if (value.isEmpty || value.length < 8) {
                                  return 'Password is too short';
                                } else {
                                  return null;
                                }
                              }
                            : (value) => null,
                        onSaved: (newValue) {
                          _authData['password'] = newValue;
                        },
                        onFieldSubmitted: (value) =>
                            _authMode == AuthMode.Signup ? null : _submit(),
                        controller: _passwordController,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (_authMode == AuthMode.Signup)
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: TextFormField(
                                obscureText: true,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(
                                    Icons.security,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Colors.amberAccent,
                                      width: 1.5,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 0.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                                validator: _authMode == AuthMode.Signup
                                    ? (value) {
                                        if (value.isEmpty) {
                                          return 'Password is empty';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Password do not match';
                                        } else
                                          return null;
                                      }
                                    : (value) => null,
                                onFieldSubmitted: (_) => _submit(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () => switchAuthMode(true),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  FlatButton(
                    onPressed: _isLoading ? null : switchAuthMode,
                    child: Text(
                      _authMode == AuthMode.Login ? 'Sign Up' : 'Login',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 35),
                height: 50,
                width: double.infinity,
                child: FlatButton(
                    onPressed: () => _submit(),
                    child: _isLoading
                        ? loadingWidget()
                        //  CircularProgressIndicator(
                        //     // backgroundColor: Colors.white,
                        //     valueColor:
                        //         AlwaysStoppedAnimation<Color>(Colors.white),
                        //   )
                        : Text(
                            _authMode == AuthMode.Signup
                                ? 'Sign Up'
                                : _authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Get Code',
                            style: TextStyle(color: Colors.black),
                          )),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget loadingWidget() {
  return Center(
    child: Container(
      height: 65,
      width: 65,
      child: FlareActor(
        'assets/flare/loading.flr',
        alignment: Alignment.center,
        // fit: BoxFit.scaleDown,
        animation: 'active',
      ),
    ),
  );
}
