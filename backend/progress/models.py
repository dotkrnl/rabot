from django.db import models
from users.models import UsersDao

# Create your models here.


class Progress(models.Model):
    uid = models.IntegerField(default=0, unique=True)
    info = models.TextField(null=True)

    def __unicode__(self):
        return 'User: #%s;\nProgress Info: \n[PROGRESS BEGIN]\n%s[PROGRESS END]\n;' % (str(self.uid), self.info)

    class Meta:
        db_table = 'progress'
        ordering = ['uid']

class ProgressDao():

    def user_is_valid(self, uid):
        if uid > 0:
            users_dao = UsersDao()
            cur_user = users_dao.get_user_by_uid(uid)
            if cur_user:
                return True
            else:
                return False
        else:
            return False

    def get_all_progess(self):
        return list(Progress.objects.all())

    def get_progress_by_uid(self, uid):
        try:
            cur_user = Progress.objects.get(uid=uid)
        except Progress.DoesNotExist:
            return None
        else:
            return cur_user

    def get_cur_user_progress(self, cur_user):
        return self.get_progress_by_uid(cur_user.uid)

    def create_progress(self, uid, info):
        Progress.objects.create(uid=uid, info=info)

    def update_progress_info(self, cur_progress, info):
        cur_progress.info = info
        cur_progress.save(update_fields=['info'])

    def delete_progress(self, cur_progress):
        cur_progress.delete()
