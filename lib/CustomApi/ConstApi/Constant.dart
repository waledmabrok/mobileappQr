class Api {
  ///====================FATHER_OF_API================///

  static const String APURL =
      "https://demos.elboshy.com/attendance/wp-json/attendance/v1/";

  ///===================CHILDREN======================///

  ///LOGIN///

  static const String LOGIN = '${APURL}login';

  //------------------------------------------------------------------------------
  ///PROFILE///Get

  static const String USER_INFO = '${APURL}employee/';

  //------------------------------------------------------------------------------
  //update post
  static const String USER_ON_UPDATE = '${APURL}employee/';

  // ------------------------------------------------------------------------------
  ///Check in
  static const String Check_In = '${APURL}check-in/';

  // ------------------------------------------------------------------------------
  ///Check out
  /////post
  static const String Check_out = '${APURL}check-out/';

  // ------------------------------------------------------------------------------
  ///Calender
  /////Get
  static const String Calender = '${APURL}calendar/';

//------------------------------------------------------------------------------
}
