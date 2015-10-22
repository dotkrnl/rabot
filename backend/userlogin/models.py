from django.contrib.auth.models import BaseUserManager, AbstractBaseUser
from django.db import models

# Create your models here.


class UserInfoManager(BaseUserManager):

    def create_user(self, user_id, user_name, email, password=''):
        new_user = self.model(
            user_id = user_id,
            user_name = user_name,
            email = UserInfoManager.normalize_email(email),
        )
        new_user.set_password(password)

        new_user.save(using=self._db)
        return new_user

    def create_superuser(self, user_id, user_name, email, password=''):

        new_superuser = self.create_user(user_id, user_name, email, password)
        new_superuser.save(using=self._db)
        return new_superuser


class UserInfo(AbstractBaseUser):
    user_id = models.IntegerField(default=0, unique=True)
    user_name = models.CharField(max_length=24, unique=True)
    email = models.EmailField(null=True, blank=True)

    objects = UserInfoManager()
    USERNAME_FIELD = 'user_name'
    REQUIRED_FIELDS = ['user_name']

    def is_authenticated(self):
        return True

    def get_full_name(self):
        return self.USERNAME_FIELD

    def get_short_name(self):
        return self.USERNAME_FIELD

    class Meta:
        db_table = 'user'
        ordering = ['user_id']
