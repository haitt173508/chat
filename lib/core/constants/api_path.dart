class ApiPath {
  /// Base URL
  static const String ipDomain = 'http://43.239.223.142:3005/';
  static const String ipDomain2 = 'http://43.239.223.142:9000/api/';

  static const String domainNameBaseUrl = 'https://mess.timviec365.vn/';
  static const String baseUrl = ipDomain;
  static const String ipChatConversation =
      'http://43.239.223.142:3005/' + 'Conversation/';
  static const String authDomain = baseUrl + 'User/';
  static const String chatDomain = baseUrl + 'Conversation/';
  static const String messageDomain = ipDomain + 'Message/';
  static const String notificationDomain = baseUrl + 'Notification/';
  static const String fileDomain = domainNameBaseUrl + 'uploads/';
  static const String avatarUserDomain = baseUrl + 'avatarUser/';
  static const String avatarGroupDomain = baseUrl + 'avatarUser/';
  static const String imageDomain = baseUrl + 'uploads/';

  static const String downloadDomain = ipDomain + 'File/DownloadFile/';

  static const String uploadFileDomain = ipDomain + 'File/';

  // static const String login = ipDomain + 'User/' + 'Login';
  static const String login = ipDomain2 + 'conv/auth/login';
  static const String requestUpdatePassword = authDomain + 'ForgetPassword';
  static const String updatePassword = authDomain + 'UpdatePassword';
  static const String register = authDomain + 'Register';
  static const String signUp = authDomain + 'RegisterSuccess';

  static const String setUpAccount = authDomain + 'RegisterSuccess';
  static const String getUserName = authDomain + 'GetUserName';
  static const String getUserInfo = ipDomain + 'User/' + 'GetInfoUser';

  static const String changePresenceStatus = authDomain + 'ChangeActive';

  static const String resolveChatId = chatDomain + 'CreateNewConversation';

  static const String chatInfo = chatDomain + 'GetConversation';

  static const String chatList = ipChatConversation + 'GetListConversation';
  static const String fastChatList = ipChatConversation + 'GetConversationList';

  static const String changeNickName = chatDomain + 'ChangeNickName';
  static const String changeNickNameGroup = chatDomain + 'ChangeNameGroup';
  static const String changeUserName = authDomain + 'ChangeUserName';

  static const String onlineUserList = authDomain + 'GetAllUserOnline';

  static const String chatDetail = messageDomain + 'GetListMessage';
  static const String chatLibrary = messageDomain + 'GetListLibra';

  static const String listLastMessageOfConversation =
      messageDomain + 'GetListMessage_v2';

  static const String unreadConversation =
      chatDomain + 'GetListUnreaderConversation';

  static const String sendMessage = messageDomain + 'SendMessage';
  static const String sendNewMessage = messageDomain + 'SendNewMessage';
  static const String editMessage = messageDomain + 'EditMessage';
  static const String deleteMessage = messageDomain + 'DeleteMessage';
  static const String getMessage = messageDomain + 'GetMessage';
  static const String pinMessage = chatDomain + 'PinMessage';
  static const String unPinMessage = chatDomain + 'UnPinMessage';

  static const String uploadFile = uploadFileDomain + 'UploadFile';
  static const String uploadNewFile = uploadFileDomain + 'UploadNewFile';
  static const String downloadFile = fileDomain + 'DownloadFile/';

  static const String myContacts = authDomain + 'GetListContact';
  static const String deleteContact = authDomain + 'DeleteContact';
  static const String allContactsInCompany = authDomain + 'GetContactCompany';
  static const String searchContactInCompany =
      authDomain + 'searchByCompanyContactInHomePage';
  static const String searchContact = authDomain + 'searchContactInHomePage';
  static const String searchAll = chatDomain + 'SearchAll';
  static const String searchContactByPhone =
      ipDomain + 'User/' + 'GetListOfferContactByPhone';
  static const String searchConversations =
      ipDomain + 'Conversation/' + 'GetListConversationForward';

  static const String getAddFriendRequestBasicInfo =
      ipDomain + 'User/' + 'GetRequestList';

  static const String createGroupChat = chatDomain + 'AddNewConversation';
  static const String createChat = chatDomain + 'CreateNewConversation';

  static const String toogleFavoriteChat =
      chatDomain + 'AddToFavoriteConversation';

  static const String markAsRead = chatDomain + 'ReadMessage';
  static const String markAsUnread = chatDomain + 'MarkUnreader';

  static const String toogleHiddenChat = chatDomain + 'HiddenConversation';
  static const String deleteChat = chatDomain + 'DeleteConversation';

  static const String changeGroupName = chatDomain + 'ChangeNameGroup';
  static const String addMemberToGroup = chatDomain + 'AddNewMemberToGroup';
  static const String deleteMemberFromGroup = chatDomain + 'OutGroup';

  static const String changeGroupAvatar = fileDomain + 'UploadAvatarGroup';

  static const String changeEmotionMessage =
      messageDomain + 'SetEmotionMessage';

  static const String searchListConversation =
      chatDomain + 'SearchListConversation';

  //Profile
  static const String changePassword = authDomain + 'ChangePassword';
  static const String addFriend = authDomain + 'AddFriend';
  static const String deleteRequestAddFriend =
      authDomain + 'DeleteRequestAddFriend';
  static const String changeAvatarUser = uploadFileDomain + 'UploadNewAvatar';
  static const String changeAvatarGroup =
      uploadFileDomain + 'UploadAvatarGroup';

  // Friend
  static const String listFriendRequest = authDomain + 'GetListRequest';
  static const String acceptRequestAddFriend =
      authDomain + 'AcceptRequestAddFriend';
  static const String decilineRequestAddFriend =
      authDomain + 'DecilineRequestAddFriend';

// list new friends
  static String getListNewFriends(int userId) =>
      ipDomain2 + 'users/listnewfriend/${userId.toString()}';

  // Notification
  static const String getListNotification =
      notificationDomain + 'GetListNotification';
  static const String sendNewNotification_v2 =
      notificationDomain + 'SendNewNotification_v2';

  //SignUp
  static const String signUpUrl = 'https://chamcong.24hpay.vn/';
  static const String service = signUpUrl + 'service/';
  static const String webCc = signUpUrl + 'api_web_cham_cong/';
  static const String signUpEmployee = service + 'register_employee.php';
  static const String signUpCompany = service + 'register_company.php';
  static const String detailCompany = service + 'detail_company.php';

  ///Dung chung cho quen mat khau va xac thuc tai khoan cong ty
  ///
  ///Id type 1: la nhan vien va ca nhan, 2 la cong ty
  static const String sendOtp = service + 'send_otp_chat.php';
  static const String verifyOtp = service + 'verify_otp.php';
  static const String loginEmployee = service + 'login_employee.php';
  static const String loginCompany = service + 'login_company.php';
  static const String addFirstEmployee = service + 'add_employee.php';
  static const String checkNameCompany = service + 'check_name_company.php';
  static const String checkAccount = service + 'check_email_phone_exits.php';
  static const String getListNest = webCc + 'list_nest_dk.php';
  static const String getListGroup = webCc + 'list_nhom_dk.php';

  static const String deleteAccount =
      'http://43.239.223.142:3005/User/DeleteAccount';

  //Chấm công
  static const String scan_face_timekeeping =
      'http://43.239.223.147:5001/face_verify_app';
  static const String timekeeping_configuration =
      service + 'get_config_timekeeping_new.php';
  static const String decode_qr_attendance =
      'https://chamcong.24hpay.vn/service/decode_qr_data.php';
  static const String timekeeping = service + 'add_time_keeping.php';
  static const String timekeepingQR = service + 'add_time_keeping_qr.php';

  //Lấy ca chấm công
  static const String list_shift = service;

//Lấy token
  static const String get_token = signUpUrl + 'api_chat365/get_token.php';

// refresh token
  static const String refresh_token = service + 'refresh_token.php';

//Thông tin ứng viên, NTD site .vn
  static const String get_detail_info =
      'https://timviec365.vn/api_winform/data_user_chat.php';

  ///Login with QR
//decode Qr => Login
  static const String get_info_login = baseUrl + 'User/GetInfoUser';

// QR app => Login PC
  static const String add_group = ipDomain + 'QR/QR365';
  static const String app_login_pc =
      'http://43.239.223.142:3005/User/getInforQRLogin';

  //firebase
  static const String firebaseUrl = "https://timviec365.vn/api_app";
  static const String UPDATE_FIREBASE_TOKEN =
      firebaseUrl + "/update_firebase_token.php";

  //Login History
  static const String list_login_history =
      ipDomain2 + 'users/gethistoryaccess/';

  //List contact
  static const String get_list_contact =
      ipDomain2 + 'conv/auth/takedatatoverifylogin/';

  //confirm Login
  static const String confirm_login = ipDomain2 + 'conv/auth/confirmlogin';
}
