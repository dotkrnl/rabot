from django.db import models
from django.contrib.auth.hashers import make_password

# Create your models here.


class Users(models.Model):
    uid = models.IntegerField(default=0, unique=True)
    uname = models.CharField(max_length=24, unique=True)
    passwd = models.TextField()
    email = models.EmailField(default='default@rabot', unique=True)
    authenticated = models.BooleanField(default=False)
    admin_authority = models.IntegerField(default=0)

    def __unicode__(self):
        return self.uname + ' (#' + str(self.uid) + ')'

    def to_dict(self):
        return {
            'uid': self.uid,
            'username': self.uname,
            'email': self.email,
        }

    class Meta:
        db_table = 'users'
        ordering = ['uid']


class UsersDao():

    def get_all_users(self):
        return list(Users.objects.all())

    def get_all_active_users(self):
        return list(Users.objects.filter(logged_in=True))

    def get_all_administrators(self):
        return list(Users.objects.filter(admin_auth=1))

    def create_user(self, uid, uname, passwd, email):
        passwd = make_password(passwd)
        Users.objects.create(uid=uid, uname=uname, passwd=passwd, email=email)

    def delete_user(self, cur_user):
        cur_user.delete()

    def authenticate(self, cur_user):
        cur_user.authenticated = True
        cur_user.save(update_fields=['authenticated'])

    def is_authenticated(self, cur_user):
        return cur_user.authenticated

    def update_passwd(self, cur_user, passwd):
        cur_user.passwd = make_password(passwd)
        cur_user.save(update_fields=['passwd'])

    def update_email(self, cur_user, email):
        cur_user.email = email
        cur_user.save(update_fields=['email'])

    def update_admin_auth(self, cur_user, admin_auth):
        cur_user.admin_auth = admin_auth
        cur_user.save(update_fields=['admin_auth'])

    def get_user_by_uid(self, uid):
        try:
            target = Users.objects.get(uid=uid)
        except Users.DoesNotExist:
            return None
        else:
            return target

    def get_user_by_uname(self, uname):
        try:
            target = Users.objects.get(uname=uname)
        except Users.DoesNotExist:
            return None
        else:
            return target

    def get_user_by_email(self, email):
        try:
            target = Users.objects.get(email=email)
        except Users.DoesNotExist:
            return None
        else:
            return target