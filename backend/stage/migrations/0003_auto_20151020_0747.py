# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('stage', '0002_auto_20151020_0606'),
    ]

    operations = [
        migrations.RenameField(
            model_name='stage',
            old_name='content',
            new_name='info',
        ),
        migrations.AlterField(
            model_name='stage',
            name='stage_id',
            field=models.IntegerField(default=-1),
        ),
    ]
