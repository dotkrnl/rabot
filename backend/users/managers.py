from users.models import UsersDao


class UsersManager():

    def __init__(self):
        self.dao = UsersDao()

    def __valid_passwd(self, passwd):
        if not 4 <= len(passwd) <= 24:
            return False

        for i in passwd:
            if not 32 < ord(i) < 127:
                return False

        return True

    def clear(self):
        all_users = self.dao.get_all_users()
        for user in all_users:
            self.dao.delete_user(user)

    def registration(self, uname, passwd, passwd2, email):
        if passwd != passwd2:
            return 'Repeated password is incorrect.'

        if not self.__valid_passwd(passwd):
            return 'Password is invalid.'

        target = self.dao.get_user_by_uname(uname)
        if target:
            return 'Username is already used.'

        target = self.dao.get_user_by_email(email)
        if target:
            return 'Email is already used.'

        all_users = self.dao.get_all_users()
        if len(all_users) > 0:
            uid = all_users[-1].uid + 1
        else:
            uid = 1

        self.dao.create_user(uid, uname, passwd, email)

        return 'Succeeded, new user\'s uid: #' + str(uid)

    def login(self, uname, passwd):
        cur_user = self.dao.get_user_by_uname(uname)

        if not cur_user:
            return 'User does not exist.'
        elif cur_user.passwd == passwd:
            if self.dao.has_logged_in(cur_user):
                return 'User has already logged in.'
            else:
                self.dao.log_in(cur_user)
                return 'Succeeded. User\'s uid: #' + str(cur_user.uid)
        else:
            return 'Password is incorrect.'

    def logout(self, uid):
        if uid > 0:
            cur_user = self.dao.get_user_by_uid(uid)
            if not cur_user:
                return 'User does not exist.'
            elif self.dao.has_logged_in(cur_user):
                self.dao.log_out(cur_user)
                return 'Succeeded.'
            else:
                return 'User has not logged in.'
        else:
            return 'Succeeded. Nothing is done.'

    def update(self, uid, old_passwd, new_passwd, new_passwd2, new_email):
        cur_user = self.dao.get_user_by_uid(uid)
        if not cur_user:
            return

        if len(old_passwd) > 0:
            if cur_user.passwd == old_passwd:
                if new_passwd != new_passwd2:
                    return 'Repeated password is incorrect.'
                elif not self.__valid_passwd(new_passwd):
                    return 'New password is invalid.'
            else:
                return 'Old password is incorrect.'

        if len(new_email) > 0:
            target = self.dao.get_user_by_email(new_email)
            if target:
                return 'Email is already used.'

        if len(old_passwd) > 0: cur_user.update(passwd=new_passwd)
        if len(new_email) > 0: cur_user.update(email=new_email)
        return 'Succeeded.'
