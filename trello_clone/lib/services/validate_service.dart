
  String? isEmptyField(String value) {
    if (value.isEmpty) {
      return 'Required';
    }
    return null;
  }

  bool validateEmail(String value){
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value)){
      return false;
    }
    return true;
  }

  /*String? validatePassword(String value){
    String isEmpty = isEmptyField(value)!;
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    RegExp regExp = new RegExp(pattern);

    if(isEmpty != null){
      return isEmpty;
    }
    else if(!regExp.hasMatch(value)){
      return "Minimum eight characters, at least one letter and one number";
    }
    return null;
  }*/