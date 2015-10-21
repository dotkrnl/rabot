# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='UserInfo',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('user_id', models.IntegerField(default=-1)),
                ('user_name', models.CharField(max_length=24)),
                ('passwd', models.TextField()),
                ('email', models.EmailField(max_length=254, null=True, blank=True)),
            ],
            options={
                'ordering': ['user_id'],
                'db_table': 'user',
            },
        ),
    ]
