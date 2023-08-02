class ChatSocketEvent {
  static const String login = 'Login';
  static const String logout = 'Logout';

  // User

  static const String userDisplayNameChanged = 'changeName';
  static const String changeUserName = 'changeName';
  static const String changeAvatarUser = 'changeAvatarUser';
  static const String changePresenceStatus = 'changedActive';
  static const String presenceStatusChanged = 'changedActive';
  static const String changeMoodMessage = 'UpdateStatus';
  static const String moodMessageChanged = 'UpdateStatus';

  // Conversation

  static const String changeGroupName = 'changeNameGroup';
  static const String groupNameChanged = 'changeNameGroup';
  static const String nickNameChanged = 'changeNickName';
  static const String changeNickName = 'changeNickName';

  static const String changeGroupAvatar = 'changeAvatarGroup';

  static const String sendMessage = 'SendMessage';
  static const String messageSent = 'SendMessage';

  static const String editMessage = 'EditMessage';
  static const String messageEdited = 'EditMessage';

  static const String deleteMessage = 'DeleteMessage';
  static const String messageDeleted = 'DeleteMessage';

  static const String typing = 'Typing';
  static const String stopTyping = 'OutTyping';

  static const String createGroup = 'AddNewConversation';
  static const String newConversationAdded = 'AddNewConversation';
  static const String addMemberToGroup = 'AddNewMemberToGroup';
  static const String   newMemberAddedToGroup = 'AddNewMemberToGroup';
  static const String outGroup = 'OutGroup';

  static const String markReadAllMessage = 'ReadMessage';
  static const String messageMarkedRead = 'ReadMessage';

  static const String recievedEmotionMessage = 'EmotionMessage';
  static const String changeReactionMessage = 'EmotionMessage';

  static const String pinMessage = 'PinMessage';
  static const String unPinMessage = 'UnPinMessage';

  static const String changeFavoriteConversationStatus = "AddToFavorite";

  // Friend
  static const String acceptRequestAddFriend = 'AcceptRequestAddFriend';
  static const String declineRequestAddFriend = 'DecilineRequestAddFriend';
  static const String requestAddFriend = 'AddFriend';
  static const String deleteContact = 'DeleteContact';

  // Change Password => LogOut
  static const String logoutAllDevice = 'LogoutAllDevice';
}
