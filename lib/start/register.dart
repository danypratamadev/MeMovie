import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:memovie/provider/mainprovider.dart';

class RegisterPage extends StatelessWidget{

  final namacontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final repasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);

    return WillPopScope(
      onWillPop: () => mainProvider.onWillpopRegister(),
      child: Scaffold(
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
                  'Register Account'
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Complete your personal data to start creating \na new account in MeMovie',
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
                                controller: namacontroller,
                                readOnly: value.readOnlyRegister,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: EdgeInsets.all(20.0),
                                ),
                                onChanged: (value) {
                                  mainProvider.setInputValueRegister(type: 10, value: namacontroller.text);
                                },
                                keyboardType: TextInputType.text,
                              ),
                              Divider(height: 0.5, thickness: 0.5,),
                              TextFormField(
                                controller: emailcontroller,
                                readOnly: value.readOnlyRegister,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: EdgeInsets.all(20.0),
                                ),
                                onChanged: (value) {
                                  mainProvider.setInputValueRegister(type: 20, value: emailcontroller.text);
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Divider(height: 0.5, thickness: 0.5,),
                              TextFormField(
                                controller: passwordcontroller,
                                readOnly: value.readOnlyRegister,
                                obscureText: value.obscureTextRegis,
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
                                        value.obscureTextRegis ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                        color: themeApp.iconTheme.color,
                                      ), 
                                      onTap: (){
                                        mainProvider.changeObscureTextRegister(type: 10);
                                      }
                                    ),
                                  )
                                ),
                                onChanged: (value) {
                                  mainProvider.setInputValueRegister(type: 30, value: passwordcontroller.text);
                                },
                                keyboardType: TextInputType.text,
                              ),
                              Divider(height: 0.5, thickness: 0.5,),
                              TextFormField(
                                controller: repasswordcontroller,
                                readOnly: value.readOnlyRegister,
                                obscureText: value.obscureTextConfirmRegis,
                                decoration: InputDecoration(
                                  hintText: 'Confirm Password',
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: EdgeInsets.all(20.0),
                                  suffixIcon: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Icon(
                                        value.obscureTextConfirmRegis ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                        color: themeApp.iconTheme.color,
                                      ), 
                                      onTap: (){
                                        mainProvider.changeObscureTextRegister(type: 20);
                                      }
                                    ),
                                  )
                                ),
                                onChanged: (value) {
                                  mainProvider.setInputValueRegister(type: 40, value: repasswordcontroller.text);
                                },
                                keyboardType: TextInputType.text,
                              ),
                            ]
                          )
                        )
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 58.0,
                        child: FlatButton(
                          onPressed: value.buttonActiveRegister && !value.loadingRegister ? () async {
                            bool result = await mainProvider.registerUser(context: context);
                            if(result){

                              namacontroller.clear();
                              emailcontroller.clear();
                              passwordcontroller.clear();
                              repasswordcontroller.clear();

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Register Success',
                                        style: themeApp.textTheme.headline6.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Text(
                                        'Log in to your account to start searching for your favorite movies in MeMovie.',
                                        style: themeApp.textTheme.bodyText2.copyWith(
                                          height: 1.4,
                                        ),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        'OK',
                                      ),
                                    )
                                  ],
                                )
                              );
                            } else {

                              namacontroller.clear();
                              emailcontroller.clear();
                              passwordcontroller.clear();
                              repasswordcontroller.clear();

                            }

                          } : (){},
                          child: value.loadingRegister ? CupertinoActivityIndicator() : Text(
                            'Create Account'
                          ),
                          color: value.buttonActiveRegister && !value.loadingRegister ? Colors.black : Colors.black26,
                          textColor: value.buttonActiveRegister && !value.loadingRegister ? Colors.white : Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          splashColor: Colors.white10,
                          highlightColor: Colors.white10,
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
      ),
    );
  }

}