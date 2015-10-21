from django.db import models

# Create your models here.


class Stage(models.Model):
    stage_id = models.IntegerField(default=0, unique=True)
    name = models.TextField()
    info = models.TextField()
