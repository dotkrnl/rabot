from django.db import models
from users.models import UsersDao
from stage.models import StageDao

# Create your models here.


class Archive(models.Model):
    arid = models.IntegerField(default=0, unique=True)
    uid = models.IntegerField(default=0)
    sid = models.IntegerField(default=0)
    info = models.TextField(null=True)

    def __unicode__(self):
        return 'User #' + str(self.uid) + ', Stage #' + str(self.sid) + ', content = ' + self.info

    class Meta:
        db_table = 'archive'
        ordering = ['arid']


class ArchiveDao():

    def user_and_stage_is_valid(self, uid, sid):
        if uid > 0 and sid > 0:
            users_dao = UsersDao()
            cur_user = users_dao.get_user_by_uid(uid)
            if cur_user:
                stage_dao = StageDao()
                cur_stage = stage_dao.get_stage_by_sid(sid)
                if cur_stage:
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False

    def get_all_archive(self):
        return list(Archive.objects.all())

    def get_archive_by_arid(self, arid):
        try:
            target = Archive.objects.get(arid=arid)
        except Archive.DoesNotExist:
            return None
        else:
            return target

    def get_archive_by_uid_and_sid(self, uid, sid):
        try:
            target = Archive.objects.get(uid=uid, sid=sid)
        except Archive.DoesNotExist:
            return None
        else:
            return target

    def create_archive(self, arid, uid, sid, info):
        Archive.objects.create(arid=arid, uid=uid, sid=sid, info=info)

    def update_archive_info(self, cur_archive, info):
        cur_archive.info = info
        cur_archive.save(update_fields=['info'])

    def delete_archive(self, cur_archive):
        cur_archive.delete()
