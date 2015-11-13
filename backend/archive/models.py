from django.db import models
from users.models import UsersDao
from stage.models import StageDao

# Create your models here.


class Archive(models.Model):
    arid = models.IntegerField(default=0, unique=True)
    uid = models.IntegerField(default=0)
    sid = models.IntegerField(default=0)
    submit_time = models.DateTimeField(auto_now_add=True)
    src = models.TextField(null=True)
    result = models.TextField(null=True)

    def __unicode__(self):
        return 'User: #%s;\nStage #%s;\nCode: \n[CODE_BEGIN]\n%s[CODE_END]\n;\nResult: %s;\n' % (str(self.uid), str(self.sid), self.src, self.result)

    class Meta:
        db_table = 'archive'
        ordering = ['arid']
        get_latest_by = ['submit_time']


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
        return list(Archive.objects.all().order_by('submit_time'))

    def get_all_archive_by_uid_and_sid(self, uid=0, sid=0):
        if uid > 0 and sid > 0:
            targets = Archive.objects.filter(uid=uid, sid=sid).order_by('submit_time')
        elif uid > 0:
            targets = Archive.objects.filter(uid=uid).order_by('submit_time')
        elif sid > 0:
            targets = Archive.objects.filter(sid=sid).order_by('submit_time')
        else:
            targets = Archive.objects.all().order_by('submit_time')

        return list(targets)

    def get_archive_by_arid(self, arid):
        try:
            target = Archive.objects.get(arid=arid)
        except Archive.DoesNotExist:
            return None
        else:
            return target

    def create_archive(self, arid, uid, sid, src, result):
        Archive.objects.create(arid=arid, uid=uid, sid=sid, src=src, result=result)

    def update_archive_uid(self, cur_archive, uid):
        cur_archive.uid = uid
        cur_archive.save(update_fields=['uid'])

    def update_archive_sid(self, cur_archive, sid):
        cur_archive.sid = sid
        cur_archive.save(update_fields=['sid'])

    def update_archive_src(self, cur_archive, src):
        cur_archive.src = src
        cur_archive.save(update_fields=['src'])

    def update_archive_result(self, cur_archive, result):
        cur_archive.result = result
        cur_archive.save(update_fields=['result'])

    def delete_archive(self, cur_archive):
        cur_archive.delete()
