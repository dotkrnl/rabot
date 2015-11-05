from django.db import models

# Create your models here.


class Users(models.Model):
    uid = models.IntegerField(default=0, unique=True)
    uname = models.CharField(max_length=24, unique=True)
    passwd = models.TextField()
    email = models.EmailField(default='default@rabot', unique=True)
    authenticated = models.BooleanField(default=False)
    logged_in = models.BooleanField(default=False)

    def __unicode__(self):
        return self.uname + ' (#' + str(self.uid) + ')'

    def to_dict(self):
        return {
            'uid': self.uid,
            'username': self.uname,
            #'password': self.passwd,
            'email': self.email,
            #'authenticated': self.authenticated,
            #'logged_in': self.logged_in,
        }

    class Meta:
        db_table = 'users'
        ordering = ['uid']


class UsersDao():

    def get_all_users(self):
        return list(Users.objects.all())

    def get_all_active_users(self):
        return list(Users.objects.filter(logged_in=True))

    def create_user(self, uid, uname, passwd, email):
        Users.objects.create(uid=uid, uname=uname, passwd=passwd, email=email)

    def delete_user(self, cur_user):
        cur_user.delete()

    def authenticate(self, cur_user):
        cur_user.authenticated = True
        cur_user.save(update_fields=['authenticated'])

    def log_in(self, cur_user):
        cur_user.logged_in = True
        cur_user.save(update_fields=['logged_in'])

    def log_out(self, cur_user):
        cur_user.logged_in = False
        cur_user.save(update_fields=['logged_in'])

    def is_authenticated(self, cur_user):
        return cur_user.authenticated

    def has_logged_in(self, cur_user):
        return cur_user.logged_in

    def update_passwd(self, cur_user, passwd):
        cur_user.passwd = passwd
        cur_user.save(update_fields=['passwd'])

    def update_email(self, cur_user, email):
        cur_user.email = email
        cur_user.save(update_fields=['email'])

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