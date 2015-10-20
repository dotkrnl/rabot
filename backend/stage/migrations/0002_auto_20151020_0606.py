# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('stage', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Stage',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('stage_id', models.CharField(default=b'0', max_length=4)),
                ('content', models.TextField()),
            ],
            options={
                'ordering': ['stage_id'],
                'db_table': 'stage',
            },
        ),
        migrations.DeleteModel(
            name='StageObject',
        ),
    ]
