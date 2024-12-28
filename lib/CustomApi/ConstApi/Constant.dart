class Api {
  ///====================FATHER_OF_API================///

  static const String APURL = "https://demos.elboshy.com/attendance/wp-json/attendance/v1/";

  ///===================CHILDREN======================///

  ///LOGIN///

  static const String LOGIN = '${APURL}login';

  /*///SIGNUP///

  static const String SIGNUP = '${APURL}signup';
*/
  ///CONTACT_INFO_APPLICATION_ADMIN///

  static const String CONTACT_INFO = '${APURL}contact-info';

  ///CART///

  static const String CART = '${APURL}orders/list?per_page=10&page=';

  ///PROFILE///

  static const String USER_INFO = '${APURL}employee/';

  //todo lsaaa
  static const String USER_ON_UPDATE = '${APURL}user/update';

  //postman
  static const String USER_ON_UPDATE_IMAGE =
      '${APURL}user/upload-profile-image';
  static const String Change_PASSWORD = '${APURL}password_reset';
  static const String ADD_NEWPASSWORD = '${APURL}New__password';
  static const String Privacy = '${APURL}privacy';
  static const String LOGOUT = '${APURL}logout';

  ///OTP//

  static const String OTP_REQUEST = '${APURL}request_otp';
  static const String OTP_Verify = '${APURL}verify_otp';

  ///FORGET_PASSOWRD///

  static const String FORGET_PASSWORD = '${APURL}forget-password';

  ///Catogry_MAIN_IN_HOME=====

  static const String MAin_SERVICE = '${APURL}get_servises?parent_id=';

  ///HOME_SERVICE_PARENT=====

  static const String HOME_SERVICE_PARENT = '${APURL}home/categories';
  static const String searchBar = '${APURL}searchBar';

  ///All_Services_Home//

  static const String Single_service_data =
      '${APURL}Serviceinfo?catID=&user_id=';

  // static const String Single_service_Comment = '${APURL}reviews/list?catID=';
  static const String Single_service_ADD_Comment = '${APURL}reviews/add';
  static const String More_Service = '${APURL}get_servises';

  ///BookMarkIcons/////

  static const String BOOKMARK_ICON = '${APURL}bookmarks/toggle';

  ///BOOK_MARK_ALLSERVES_SAVED
  static const String ALL_BOOKMARK_Saved = '${APURL}bookmarks/list';

  ///All_Widget_HOME//////////////
  static const String All_Widget_HOME = '${APURL}home/categories_sections';

  ///REVIEW_IN_HOME
  static const String REVIEW_IN_HOME = '${APURL}home/top-reviews';

  ///SEarch
  static const String Search = '${APURL}search?name=';

  ///TO_ORDER_SCREEN
  static const String TO_ORDER_SCREEN = '${APURL}orders/add';
}