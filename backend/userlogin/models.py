from django.db import models

# Create your models here.


class UserInfo(models.Model):
    user_id = models.IntegerField(default=-1)
    user_name = models.CharField(max_length=24)
    passwd = models.TextField()
    email = models.EmailField(null=True, blank=True)

    def is_authenticated(self):
        return True

    class Meta:
        db_table = 'user'
        ordering = ['user_id']
