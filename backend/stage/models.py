from django.db import models

# Create your models here.


class Stage(models.Model):
    stage_id = models.IntegerField(default=0, unique=True)
    info = models.TextField()

    class Meta:
        db_table = 'stage'
        ordering = ['stage_id']
