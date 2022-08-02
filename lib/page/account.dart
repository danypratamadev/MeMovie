import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:memovie/page/myfavorite.dart';
import 'package:memovie/provider/mainprovider.dart';
import 'package:memovie/start/login.dart';
import 'package:memovie/widget/appbarcollaps.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    var mainProvider = Provider.of<MainProvider>(context, listen: false);

    var mediaApp = MediaQuery.of(context);
    var themeApp = Theme.of(context);

    return Scaffold(
      backgroundColor: themeApp.accentColor,
      body: Consumer<MainProvider>(
        builder: (contextt, value, child) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              pinned: true,
              primary: true,
              forceElevated: innerBoxIsScrolled,
              expandedHeight: 90,
              title: AppBarCollaps(
                child: Text(
                  'My Account'
                ),
              ),
              centerTitle: true,
            )
          ], 
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
              child: Column(
                children: [
                  ClipOval(
                    child: Material(
                      color: themeApp.backgroundColor,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.person_rounded,
                            size: 72.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  Text(
                    '${value.name}',
                    style: themeApp.textTheme.headline5.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text(
                    '${value.email}',
                    style: themeApp.textTheme.bodyText2.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 52.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Material(
                        color: themeApp.backgroundColor,
                        child: Column(
                          children: [
                            ListTile(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyFavoritePage(),));
                              },
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.pink.shade600,
                                  ),
                                  SizedBox(width: 16.0,),
                                  Text(
                                    'My Favorite Movie',
                                    style: themeApp.textTheme.subtitle1.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: themeApp.disabledColor,
                              ),
                            ),
                            Divider(height: 0.5, thickness: 0.5,),
                            ListTile(
                              onTap: (){

                                nameController.text = value.name;
                                mainProvider.setInputValueEdit(value: value.name);

                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.0)
                                    )
                                  ),
                                  backgroundColor: themeApp.backgroundColor,
                                  isScrollControlled: true,
                                  builder: (builder) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: Consumer<MainProvider>(
                                        builder: (context, value, child) => Padding(
                                          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0, bottom: 24.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 40.0,
                                                height: 5.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4.0),
                                                  color: themeApp.dividerColor,
                                                ),
                                              ),
                                              SizedBox(height: 24.0),
                                              TextFormField(
                                                controller: nameController,
                                                readOnly: value.readOnlyEdit,
                                                decoration: InputDecoration(
                                                  labelText: 'Full Name',
                                                ),
                                                onChanged: (value){
                                                  mainProvider.setInputValueEdit(value: nameController.text);
                                                },
                                              ),
                                              SizedBox(height: 40.0),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: CupertinoButton(
                                                  child: Text(
                                                    'Save',
                                                    style: themeApp.textTheme.subtitle1.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: value.buttonActiveEdit ? Colors.grey.shade50 : themeApp.disabledColor
                                                    ),
                                                  ), 
                                                  color: value.buttonActiveEdit ? themeApp.buttonColor : themeApp.dividerColor,
                                                  onPressed: value.buttonActiveEdit ? () async {
                                                    Navigator.pop(context);
                                                    bool result = await mainProvider.updateProfile();
                                                    if(result){
                                                      Fluttertoast.showToast(
                                                        msg: 'Success update your profile',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.SNACKBAR,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.green,
                                                        textColor: Colors.white,
                                                      );
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: 'Failed to update your profile!',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.SNACKBAR,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                      );
                                                    }
                                                  } : (){}
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                );

                              },
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    color: Colors.purple.shade600,
                                  ),
                                  SizedBox(width: 16.0,),
                                  Text(
                                    'Edit Profile',
                                    style: themeApp.textTheme.subtitle1.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: themeApp.disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Material(
                        color: themeApp.backgroundColor,
                        child: ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Logout Account',
                                      style: Theme.of(context).textTheme.headline6.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    Text(
                                      'Are you sure you want to log out of the account?',
                                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        height: 1.4,
                                      ),
                                    )
                                  ],
                                ),
                                actions: [
                                  FlatButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      bool result = await mainProvider.logout();
                                      if(result){
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage(action: 20,),), (Route<dynamic> route) => false,);
                                      }
                                    },
                                    child: Text(
                                      'Yes',
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                    ),
                                  )
                                ],
                              )
                            );
                          },
                          title: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red.shade600,
                              ),
                              SizedBox(width: 16.0,),
                              Text(
                                'Logout Account',
                                style: themeApp.textTheme.subtitle1.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: themeApp.disabledColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mediaApp.size.height * 0.1,)
                ],
              ),
            ),
          ),
        ),
      )
    );

  }

}