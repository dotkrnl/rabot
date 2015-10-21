# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Stage',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('stage_id', models.IntegerField(default=-1)),
                ('info', models.TextField()),
            ],
            options={
                'ordering': ['stage_id'],
                'db_table': 'stage',
            },
        ),
    ]
