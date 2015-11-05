from django.db import models

# Create your models here.


class Stage(models.Model):
    sid = models.IntegerField(default=0, unique=True)
    name = models.TextField(null=True)
    info = models.TextField(null=True)

    class Meta:
        db_table = 'stage'
        ordering = ['sid']


class StageDao():

    def get_all_stages(self):
        return list(Stage.objects.all())

    def get_stage_by_sid(self, sid):
        try:
            target = Stage.objects.get(sid=sid)
        except Stage.DoesNotExist:
            return None
        else:
            return target

    def get_stage_by_name(self, name):
        try:
            target = Stage.objects.get(name=name)
        except Stage.DoesNotExist:
            return None
        else:
            return target

    def create_stage(self, sid, name, info):
        Stage.objects.create(sid=sid, name=name, info=info)

    def delete_stage(self, cur_stage):
        cur_stage.delete()

    def update_name(self, cur_stage, name):
        cur_stage.name = name
        cur_stage.save(update_fields=['name'])

    def update_info(self, cur_stage, info):
        cur_stage.info = info
        cur_stage.save(update_fields=['info'])
