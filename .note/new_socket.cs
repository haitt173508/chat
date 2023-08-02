
        public void LoginSuccess(int userId, int companyId)
        {
            try
            {
                WIO.EmitAsync("Login", userId);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UserDisconnect(int userId)
        {
            try
            {
                WIO.EmitAsync("Logout", userId);
                if (WIO.Connected)
                {
                    WIO.DisconnectAsync();
                }
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void changeAvatarUser(int userId, string avatarUser)
        {
            try
            {
                WIO.EmitAsync("changeAvatarUser", userId, avatarUser);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void changedActive(int userId, int active)
        {
            try
            {
                WIO.EmitAsync("changedActive", userId, active);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateStatus(int userId, string status)
        {
            try
            {
                WIO.EmitAsync("UpdateStatus", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void changedNameCurrentUser(int userId, string nameChanged)
        {
            try
            {
                WIO.EmitAsync("changeName", userId, nameChanged);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void EditMessage(int ConversationId, string MessageId, string Message, int[] listMember)
        {
            try
            {
                Messages messageInfo = new Messages();
                messageInfo.ConversationID = ConversationId;
                messageInfo.MessageID = MessageId;
                messageInfo.Message = Message;

                WIO.EmitAsync("EditMessage", messageInfo, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void sendMessage(Messages messageInfo, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("SendMessage", messageInfo, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void DeleteMessage(int ConversationId, string MessageId, int[] listMember)
        {
            try
            {
                Messages messageInfo = new Messages();
                messageInfo.ConversationID = ConversationId;
                messageInfo.MessageID = MessageId;
                WIO.EmitAsync("DeleteMessage", messageInfo, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void readMessage(int userCurrent, int conversationId, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("ReadMessage", userCurrent, conversationId, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void MarkUnreader(int userCurrent, int conversationId)
        {
            try
            {
                WIO.EmitAsync("MarkUnreader", userCurrent, conversationId);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void AddFriend(int userId, int contactId)
        {
            try
            {
                WIO.EmitAsync("AddFriend", userId, contactId);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }
        public void AcceptRequestAddFriend(int userId, int contactId)
        {
            try
            {
                WIO.EmitAsync("AcceptRequestAddFriend", userId, contactId);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void DecilineRequestAddFriend(int userId, int contactId)
        {
            try
            {
                WIO.EmitAsync("DecilineRequestAddFriend", userId, contactId);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }
        public void changeAvatarGroup(int conversationId, string avatarGroup, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("changeAvatarGroup", conversationId, avatarGroup, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void updateGroup(int conversationId, string info, string action, int[] listMember)
        {
            try
            {
                if (action.Equals("changeName"))
                {
                    WIO.EmitAsync("changeNameGroup", conversationId, info, listMember);
                }
                else if (action.Equals("changeBowserMember"))
                {
                    WIO.EmitAsync("changeBowserMemberGroup", conversationId, Convert.ToInt32(info), listMember);
                }
                else if (action.Equals("shareGroupFromLink"))
                {
                    WIO.EmitAsync("shareGroupFromLink", conversationId, Convert.ToInt32(info), listMember);
                }
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void AddNewConversation(int conversationId, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("AddNewConversation", conversationId, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void AddBrowseMember(int[] browseMember, int conversationId, int userId, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("AddBrowseMember", userId, conversationId, browseMember, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void Typing(int conversationId, int userId, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("Typing", userId, conversationId, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void OutTyping(int conversationId, int userId, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("OutTyping", userId, conversationId, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void DeleteBrowse(int conversationId, int[] listBrowse, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("DeleteBrowse", conversationId, listBrowse, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void AddNewMemberToGroup(int conversationId, int[] listBrowse, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("AddNewMemberToGroup", conversationId, listBrowse, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void OutGroup(int conversationId, int userId, int adminId, int[] listMember)
        {
            try
            {
                WIO.EmitAsync("OutGroup", conversationId, userId, adminId, listMember);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void DeleteContact(int contactId, int userId)
        {
            try
            {
                WIO.EmitAsync("DeleteContact", userId, contactId);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationPayoff(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationPayoff", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationCalendar(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationCalendar", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationReport(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationReport", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationOffer(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationOffer", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationPersionalChange(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationPersionalChange", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationRewardDiscipline(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationRewardDiscipline", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationNewPersonnel(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationNewPersonnel", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationChangeProfile(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationChangeProfile", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }

        public void UpdateNotificationTransferAsset(int userId, int status)
        {
            try
            {
                WIO.EmitAsync("UpdateNotificationTransferAsset", userId, status);
            }
            catch (Exception ex)
            {
                using (WebClient httpClient = new WebClient())
                {
                    httpClient.QueryString.Add("message", ex.ToString());
                    httpClient.QueryString.Add("code", "1");
                    httpClient.UploadValuesAsync(new Uri(Properties.Resources.URL + "Message/InsertError"), "POST", httpClient.QueryString);
                }
            }
        }
    }
}