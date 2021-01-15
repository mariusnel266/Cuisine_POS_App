import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eshop/Helper/Color.dart';
import 'package:eshop/Helper/Session.dart';
import 'package:eshop/Helper/String.dart';
import 'package:eshop/Model/User.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Helper/AppBtn.dart';
import 'Helper/Constant.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateProfile();
}

String lat, long;

class StateProfile extends State<Profile> with TickerProviderStateMixin {
  String name,
      email,
      mobile,
      city,
      area,
      pincode,
      address,
      image,
      cityName,
      areaName,
      curPass,
      newPass,
      confPass,
      loaction;
  List<User> cityList = [];
  List<User> areaList = [];
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameC,
      emailC,
      mobileC,
      pincodeC,
      addressC,
      curPassC,
      newPassC,
      confPassC;
  bool isSelected = false, isArea = true;
  bool _isNetworkAvail = true;
  bool _showPassword = true;
  Animation buttonSqueezeanimation;
  AnimationController buttonController;

  @override
  void initState() {
    super.initState();

    mobileC = new TextEditingController();
    nameC = new TextEditingController();
    emailC = new TextEditingController();
    pincodeC = new TextEditingController();
    addressC = new TextEditingController();
    getUserDetails();
    callApi();
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));
  }

  @override
  void dispose() {
    buttonController.dispose();
    mobileC?.dispose();
    nameC?.dispose();
    addressC.dispose();
    pincodeC?.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  getUserDetails() async {
    CUR_USERID = await getPrefrence(ID);
    mobile = await getPrefrence(MOBILE);
    name = await getPrefrence(USERNAME);
    email = await getPrefrence(EMAIL);
    city = await getPrefrence(CITY);
    area = await getPrefrence(AREA);
    pincode = await getPrefrence(PINCODE);
    address = await getPrefrence(ADDRESS);
    image = await getPrefrence(IMAGE);
    cityName = await getPrefrence(CITYNAME);
    areaName = await getPrefrence(AREANAME);

    mobileC.text = mobile;
    nameC.text = name;
    emailC.text = email;
    pincodeC.text = pincode;
    addressC.text = address;
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: TRY_AGAIN_INT_LBL,
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController.reverse();
                  setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  Future<void> callApi() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getCities();
      if (city != null && city != "") {
        getArea(setState);
      }
    } else {
      setState(() {
        _isNetworkAvail = false;
        _isLoading = false;
      });
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      setUpdateUser();
    } else {
      setState(() {
        _isNetworkAvail = false;
      });
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> setProfilePic(File _image) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      setState(() {
        _isLoading = true;
      });
      try {
        var request =
            http.MultipartRequest("POST", Uri.parse(getUpdateUserApi));
        request.headers.addAll(headers);
        request.fields[USER_ID] = CUR_USERID;
        var pic = await http.MultipartFile.fromPath(IMAGE, _image.path);
        request.files.add(pic);

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          setSnackbar(PROFILE_UPDATE_MSG);
          List data = getdata["data"];
          for (var i in data) {
            image = i[IMAGE];
          }
          setPrefrence(IMAGE, image);

        } else {
          setSnackbar(msg);
        }
        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isNetworkAvail = false;
      });
    }
  }

  Future<void> setUpdateUser() async {
    var data = {USER_ID: CUR_USERID, USERNAME: name, EMAIL: email};
    if (newPass != null && newPass != "") {
      data[NEWPASS] = newPass;
    }
    if (curPass != null && curPass != "") {
      data[OLDPASS] = curPass;
    }
    if (city != null && city != "") {
      data[CITY] = city;
    }
    if (area != null && area != "") {
      data[AREA] = area;
    }
    if (address != null && address != "") {
      data[ADDRESS] = address;
    }
    if (pincode != null && pincode != "") {
      data[PINCODE] = pincode;
    }

    if (lat != null && lat != "") {
      data[LATITUDE] = lat;
    }
    if (long != null && long != "") {
      data[LONGITUDE] = long;
    }

    http.Response response = await http
        .post(getUpdateUserApi, body: data, headers: headers)
        .timeout(Duration(seconds: timeOut));
    if (response.statusCode == 200) {
    var getdata = json.decode(response.body);

    bool error = getdata["error"];
    String msg = getdata["message"];
    await buttonController.reverse();
    if (!error) {
      setSnackbar(USER_UPDATE_MSG);
      var i = getdata["data"][0];

      CUR_USERID = i[ID];
      name = i[USERNAME];
      email = i[EMAIL];
      mobile = i[MOBILE];
      city = i[CITY];
      area = i[AREA];
      address = i[ADDRESS];
      pincode = i[PINCODE];
      lat = i[LATITUDE];
      long = i[LONGITUDE];

      saveUserDetail(CUR_USERID, name, email, mobile, city, area, address,
          pincode, lat, long, image);
      setPrefrence(CITYNAME, cityName);
      setPrefrence(AREANAME, areaName);
    } else {
      setSnackbar(msg);
    }
  }}

  _imgFromGallery() async {
   /* File image = await FilePicker.getFile(type: FileType.image);

    if (image != null) {

      setState(() {
        _isLoading = true;
      });
      setProfilePic(image);
    }*/

    ///for file picker greater version
      FilePickerResult result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File image = File(result.files.single.path);
      if (image != null) {
        print('path**${image.path}');
        setState(() {
          _isLoading = true;
        });
        setProfilePic(image);
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> getCities() async {

    try {
      var response = await http
          .post(getCitiesApi, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      bool error = getdata["error"];
      String msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        cityList =
            (data as List).map((data) => new User.fromJson(data)).toList();
        for (int i = 0; i < cityList.length; i++) {
          if (cityList[i].id == city) {
            setState(() {
              cityName = cityList[i].name;

            });
          }
        }
      } else {
        setSnackbar(msg);
      }
      setState(() {
        _isLoading = false;
      });
    } on TimeoutException catch (_) {
      setSnackbar(somethingMSg);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getArea(StateSetter setState) async {

    try {
      var data = {
        ID: city,
      };

      var response = await http
          .post(getAreaByCityApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));


      var getdata = json.decode(response.body);

      bool error = getdata["error"];
      String msg = getdata["message"];

      if (!error) {
        var data = getdata["data"];

        areaList.clear();
        area = null;

        areaList =
            (data as List).map((data) => new User.fromJson(data)).toList();

        if (areaList.length == 0) {
          areaName = "";
        } else {
          for (int i = 0; i < areaList.length; i++) {

            if (areaList[i].id == area) {
              areaName = areaList[i].name;
            }
          }
        }

      } else {
        setSnackbar(msg);
      }
      setState(() {
        isArea = true;
        _isLoading = false;
      });
    } on TimeoutException catch (_) {
      setSnackbar(somethingMSg);
      setState(() {
        _isLoading = false;
      });
    }
  }

  setSnackbar(String msg) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: primary),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  setUser() {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/username.png', fit: BoxFit.fill),
            Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NAME_LBL,
                      style: Theme.of(this.context).textTheme.caption.copyWith(
                          color: lightBlack2, fontWeight: FontWeight.normal),
                    ),
                    name != "" && name != null
                        ? Text(
                            name,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.bold),
                          )
                        : Container()
                  ],
                )),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 20,
                color: lightBlack,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(0),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                                  child: Text(
                                    ADD_NAME_LBL,
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(color: fontColor),
                                  )),
                              Divider(color: lightBlack),
                              Form(
                                  key: _formKey,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        style: Theme.of(this.context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                        validator: validateUserName,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: nameC,
                                        onChanged: (v) => setState(() {
                                          name = v;
                                        }),
                                      )))
                            ]),
                        actions: <Widget>[
                          new FlatButton(
                              child: const Text(CANCEL,
                                  style: TextStyle(
                                      color: lightBlack,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              }),
                          new FlatButton(
                              child: const Text(SAVE_LBL,
                                  style: TextStyle(
                                      color: fontColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  form.save();
                                  setState(() {
                                    name = nameC.text;
                                    Navigator.pop(context);
                                  });
                                  checkNetwork();
                                }
                              })
                        ],
                      );
                    });
              },
            )
          ],
        ));
  }

  setEmail() {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/email.png', fit: BoxFit.fill),
            Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      EMAILHINT_LBL,
                      style: Theme.of(this.context).textTheme.caption.copyWith(
                          color: lightBlack2, fontWeight: FontWeight.normal),
                    ),
                    email != null && email != ""
                        ? Text(
                            email,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.bold),
                          )
                        : Container()
                  ],
                )),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: 20,
                color: lightBlack,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(0.0),
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                                  child: Text(
                                    ADD_EMAIL_LBL,
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(color: fontColor),
                                  )),
                              Divider(color: lightBlack),
                              Form(
                                  key: _formKey,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        style: Theme.of(this.context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                        validator: validateEmail,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: emailC,
                                        onChanged: (v) => setState(() {
                                          email = v;
                                        }),
                                      )))
                            ]),
                        actions: <Widget>[
                          new FlatButton(
                              child: const Text(CANCEL,
                                  style: TextStyle(
                                      color: lightBlack,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              }),
                          new FlatButton(
                              child: const Text(SAVE_LBL,
                                  style: TextStyle(
                                      color: fontColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  form.save();
                                  setState(() {
                                    email = emailC.text;
                                    Navigator.pop(context);
                                  });
                                  checkNetwork();
                                }
                              })
                        ],
                      );
                    });
              },
            )
          ],
        ));
  }

  setMobileNo() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/mobilenumber.png', fit: BoxFit.fill),
            Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      MOBILEHINT_LBL,
                      style: Theme.of(this.context).textTheme.caption.copyWith(
                          color: lightBlack2, fontWeight: FontWeight.normal),
                    ),
                    mobile != null && mobile != ""
                        ? Text(
                            mobile,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.bold),
                          )
                        : Container()
                  ],
                )),
          ],
        ));
  }

  setLocation() {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/images/location.png', fit: BoxFit.fill),
            Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LOCATION_LBL,
                      style: Theme.of(this.context).textTheme.caption.copyWith(
                          color: lightBlack2, fontWeight: FontWeight.normal),
                    ),
                    areaName != null && areaName != ""
                        ? Text(
                            "$cityName,$areaName",
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "${cityName ?? ''}",
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.bold),
                          )
                  ],
                )),
            Spacer(),
            IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: lightBlack,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setStater) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(0.0),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                                  child: Text(
                                    ADD_LOCATION_LBL,
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color: fontColor,
                                            fontWeight: FontWeight.bold),
                                  )),
                              Divider(color: lightBlack),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                  child: Text(
                                    CITY_LBL,
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color: lightBlack,
                                            fontWeight: FontWeight.bold),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                  child: DropdownButtonFormField(
                                    isDense: true,
                                    iconEnabledColor: fontColor,
                                    hint: new Text(
                                      CITYSELECT_LBL,
                                      style: Theme.of(this.context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              color: fontColor,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    value: city,
                                    onChanged: (newValue) {
                                      setState(() {
                                        city = newValue;
                                        isArea = false;
                                      });

                                      getArea(setStater);
                                    },
                                    items: cityList.map((User user) {
                                      return DropdownMenuItem<String>(
                                        value: user.id,
                                        child: Text(
                                          user.name,
                                          style: Theme.of(this.context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                  color: fontColor,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          setStater(() {
                                            cityName = user.name;

                                          });
                                        },
                                      );
                                    }).toList(),
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                  child: Text(
                                    AREA_LBL,
                                    style: Theme.of(this.context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color: lightBlack,
                                            fontWeight: FontWeight.bold),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                  child: DropdownButtonFormField(
                                    isDense: true,
                                    iconEnabledColor: fontColor,
                                    hint: new Text(
                                      AREASELECT_LBL,
                                      style: Theme.of(this.context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              color: fontColor,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    value: area,
                                    onChanged: isArea
                                        ? (newValue) {
                                            setState(() {
                                              area = newValue;
                                            });

                                          }
                                        : null,
                                    items: areaList.map((User user) {
                                      return DropdownMenuItem<String>(
                                        value: user.id,
                                        child: Text(
                                          user.name,
                                          style: Theme.of(this.context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                  color: fontColor,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          setStater(() {
                                            areaName = user.name;

                                          });
                                        },
                                      );
                                    }).toList(),
                                  )),
                            ],
                          ),
                          actions: <Widget>[
                            new FlatButton(
                                child: const Text(CANCEL,
                                    style: TextStyle(
                                        color: lightBlack,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  setState(() async {
                                    Navigator.pop(context);
                                  });
                                }),
                            new FlatButton(
                                child: const Text(SAVE_LBL,
                                    style: TextStyle(
                                        color: fontColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {

                                  if (areaName != "" &&
                                      areaName != null &&
                                      cityName != null &&
                                      cityName != "") {
                                    setState(() {
                                      Navigator.pop(context);
                                      checkNetwork();
                                    });
                                  }
                                })
                          ],
                        );
                      });
                    },
                  );
                })
          ],
        ));
  }

  changePass() {
    return Container(
        height: 60,
        width: deviceWidth,
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
                child: Text(
                  CHANGE_PASS_LBL,
                  style: Theme.of(this.context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: fontColor, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                _showDialog();
              },
            )));
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                            child: Text(
                              CHANGE_PASS_LBL,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: fontColor),
                            )),
                        Divider(color: lightBlack),
                        Form(
                            key: _formKey,
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      validator: validatePass,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          hintText: CUR_PASS_LBL,
                                          hintStyle: Theme.of(this.context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: lightBlack,
                                                  fontWeight:
                                                      FontWeight.normal),
                                          suffixIcon: IconButton(
                                            icon: Icon(_showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            iconSize: 20,
                                            color: lightBlack,
                                            onPressed: () {
                                              setStater(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                          )),
                                      obscureText: !_showPassword,
                                      controller: curPassC,
                                      onChanged: (v) => setState(() {
                                        curPass = v;
                                      }),
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      validator: validatePass,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: new InputDecoration(
                                          hintText: NEW_PASS_LBL,
                                          hintStyle: Theme.of(this.context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: lightBlack,
                                                  fontWeight:
                                                      FontWeight.normal),
                                          suffixIcon: IconButton(
                                            icon: Icon(_showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            iconSize: 20,
                                            color: lightBlack,
                                            onPressed: () {
                                              setStater(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                          )),
                                      obscureText: !_showPassword,
                                      controller: newPassC,
                                      onChanged: (v) => setState(() {
                                        newPass = v;
                                      }),
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value.length == 0)
                                          return CON_PASS_REQUIRED_MSG;
                                        if (value != newPass) {
                                          return CON_PASS_NOT_MATCH_MSG;
                                        } else {
                                          return null;
                                        }
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: new InputDecoration(
                                          hintText: CONFIRMPASSHINT_LBL,
                                          hintStyle: Theme.of(this.context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: lightBlack,
                                                  fontWeight:
                                                      FontWeight.normal),
                                          suffixIcon: IconButton(
                                            icon: Icon(_showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            iconSize: 20,
                                            color: lightBlack,
                                            onPressed: () {
                                              setStater(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                          )),
                                      obscureText: !_showPassword,
                                      controller: confPassC,
                                      onChanged: (v) => setState(() {
                                        confPass = v;
                                      }),
                                    )),
                              ],
                            ))
                      ])),
              actions: <Widget>[
                new FlatButton(
                    child: Text(
                      CANCEL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: Text(
                      SAVE_LBL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2
                          .copyWith(
                              color: fontColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        setState(() {
                          Navigator.pop(context);
                        });
                        checkNetwork();
                      }
                    })
              ],
            );
          });
        });
  }


  profileImage() {
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Stack(
          children: <Widget>[
            image != null && image != ""
                ? CircleAvatar(
                    radius: 50,
                    backgroundColor: primary,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          image,
                          fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                        )))
                : CircleAvatar(
                    radius: 50,
                    backgroundColor: primary,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: primary)),
                        child: Icon(Icons.person, size: 100)),
                  ),
            Positioned(
                bottom: 3,
                right: 5,
                child: Container(
                  height: 20,
                  width: 20,
                  child: InkWell(
                    child: Icon(
                      Icons.edit,
                      color: white,
                      size: 10,
                    ),
                    onTap: () {
                      setState(() {
                        _imgFromGallery();
                        //_showPicker(context);
                      });
                    },
                  ),
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(color: primary)),
                )),
          ],
        ));
  }

  updateBtn() {
    return AppBtn(
      title: UPDATE_PROFILE_LBL,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () {
        validateAndSubmit();
      },
    );
  }

  _getDivider() {
    return Divider(
      height: 1,
      color: lightBlack,
    );
  }

  _showContent1() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _isNetworkAvail
                ? Column(children: <Widget>[
                    profileImage(),
                    Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 5.0),
                        child: Container(
                            child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Column(
                                  children: <Widget>[
                                    setUser(),
                                    _getDivider(),
                                    setEmail(),
                                    _getDivider(),
                                    setMobileNo(),
                                    _getDivider(),
                                    setLocation(),
                                  ],
                                )))),
                    changePass()
                  ])
                : noInternet(context)));
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      appBar: getAppBar(EDIT_PROFILE_LBL, context),
      body: Stack(
        children: <Widget>[
          _showContent1(),
          showCircularProgress(_isLoading, primary)
        ],
      ),
    );
  }
}
