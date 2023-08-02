class LocalStorageKey {
  static const authToken = 'authToken';

  /// Token sau đăng nhập
  static const token = 'token';

  ///Thông tin thiết bị xin đăng nhập
  static const nameComputer = 'name_computer';
  static const locationComputer = 'location_computer';
  static const timeComputer = 'time_computer';
  static const QRCodeID = 'qr_code_id';

  static const passwordClass = 'password_class';

  ///Refresh token đăng nhập
  static const refresh_token = 'refresh_token';

  ///firebase_token
  static const firebase_token = 'firebase_token';

  /// UserType đã lưu
  static const userType = 'userType';

  /// Thông tin cơ bản
  static const userInfo = 'userInfo';

  static const userId = 'userId';
  static const userId2 = 'userId';

  static const totalConversation = 'totalConversation';

  static const serverDiffTickWithClient = 'serverDiffTickWithClient';

  static const loggedInEmail = 'loggedInEmail';

  static const uuidDevice = 'uuid_device';

  static const idDevice = 'id_device';
  static const nameDevice = 'name_device';
  static const brand = 'brand';

  static const countUnreadNoti = 'countUnreadNoti';

  static const unreadConversations = 'unreadMessage';

  static const appBadger = 'appBadger';

  static const isDeniedContactPermission = 'isDeniedContactPermission';

  /// Các key sẽ bị clear khi logout
  static List<String> get logoutClearKey => [
        authToken,
        firebase_token,
        token,
        userType,
        userInfo,
        totalConversation,
        serverDiffTickWithClient,
        uuidDevice,
        countUnreadNoti,
        unreadConversations,
        appBadger,
        userId,
      ];
}
