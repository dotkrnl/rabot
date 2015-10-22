from userlogin.models import UserInfo


class AuthBackend(object):

    def authenticate(self, user_name, passwd):
        try:
            target = UserInfo.objects.get(user_name=user_name)
        except UserInfo.DoesNotExist:
            return None

        if target.check_password(passwd):
            return target
        else:
            return None

    def get_user(self, user_name):
        try:
            target = UserInfo.objects.get(user_name=user_name)
        except UserInfo.DoesNotExist:
            return None

        return target
