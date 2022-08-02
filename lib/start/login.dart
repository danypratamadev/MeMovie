import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:memovie/page/home.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:memovie/start/register.dart';

class LoginPage extends StatelessWidget{

  final int action;
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  int limitReq = 0;
  final emailFocusnode = new FocusNode();
  final passFocusnode = new FocusNode();

  LoginPage({Key key, @required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);

    if(limitReq == 0){
      if(action == 20){
        mainProvider.setDefaultValue();
      }
      limitReq++;
    }

    return Scaffold(
      backgroundColor: themeApp.accentColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            pinned: true,
            primary: true,
            forceElevated: innerBoxIsScrolled,
            expandedHeight: mediaApp.size.height * 0.18,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'MeMovie'
              ),
            ),
          )
        ], 
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Consumer<MainProvider>(
              builder: (context, value, child) => Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0,),
                child: Column(
                  children: [
                    Text(
                      'Watch all your favorite movies easily, just log in to your account and start exploring',
                      style: themeApp.textTheme.subtitle1.copyWith(
                        color: Colors.white70,
                        height: 1.4
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 42.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        color: themeApp.backgroundColor,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailcontroller,
                              readOnly: value.readOnlyLogin,
                              focusNode: emailFocusnode,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.all(20.0),
                              ),
                              onChanged: (value) {
                                mainProvider.setInputValueLogin(type: 10, value: emailcontroller.text);
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Divider(height: 0.5, thickness: 0.5,),
                            TextFormField(
                              controller: passwordcontroller,
                              readOnly: value.readOnlyLogin,
                              obscureText: value.obscureTextLogin,
                              focusNode: passFocusnode,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.all(20.0),
                                suffixIcon: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Icon(
                                      value.obscureTextLogin ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                      color: themeApp.iconTheme.color,
                                    ), 
                                    onTap: (){
                                      mainProvider.changeObscureTextLogin();
                                    }
                                  ),
                                )
                              ),
                              onChanged: (value) {
                                mainProvider.setInputValueLogin(type: 20, value: passwordcontroller.text);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 58.0,
                      child: FlatButton(
                        onPressed: value.buttonActiveLoginn && !value.loadingLogin ? () async {
                          int result = await mainProvider.loginUser(context: context,);
                          if(result == 1){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(),));
                          } else if(result == 2) {
                            passwordcontroller.clear();
                            passFocusnode.requestFocus();
                          } else {
                            emailcontroller.clear();
                            passwordcontroller.clear();
                            emailFocusnode.requestFocus();
                          }
                        } : (){},
                        child: value.loadingLogin ? CupertinoActivityIndicator() : Text(
                          'Login Now',
                        ),
                        color: value.buttonActiveLoginn && !value.loadingLogin ? Colors.black : Colors.black26,
                        textColor: value.buttonActiveLoginn && !value.loadingLogin ? Colors.white : Colors.black38,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        splashColor: Colors.white10,
                        highlightColor: Colors.white10,
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1.2,
                            color: Colors.white10,
                          )
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          'OR',
                          style: themeApp.textTheme.bodyText1.copyWith(
                            color: Colors.white54
                          )
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1.2,
                            color: Colors.white10,
                          )
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 58.0,
                      child: FlatButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage(),));
                        },
                        child: Text(
                          'Register Now'
                        ),
                        color: Colors.white12,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaApp.size.height * 0.1,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }

}