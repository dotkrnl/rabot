from django.db import models

# Create your models here.


class Users(models.Model):
    uid = models.IntegerField(default=0, unique=True)
    uname = models.CharField(max_length=24, unique=True)
    passwd = models.TextField()
    email = models.EmailField(default='default@rabot', unique=True)
    authenticated = models.BooleanField(default=False)

    def __unicode__(self):
        return self.uname

    def is_authenticated(self):
        return self.authenticated

    class Meta:
        db_table = 'users'
        ordering = ['uid']


class UsersDao():

    def get_all_users(self):
        return list(Users.objects.all())

    def create_user(self, uid, uname, passwd, email):
        Users.objects.create(uid=uid, uname=uname, passwd=passwd, email=email)

    def delete_user(self, uid):
        try:
            target = Users.objects.get(uid=uid)
        except Users.DoesNotExist:
            return None
        else:
            target.delete()

    def update_passwd(self, cur_user, passwd):
        cur_user.update(passwd=passwd)

    def update_email(self, cur_user, email):
        cur_user.update(email=email)

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