# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('userlogin', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('user_id', models.CharField(default=b'0', max_length=6)),
                ('user_name', models.CharField(max_length=24)),
                ('passwd', models.TextField()),
                ('email', models.TextField()),
            ],
            options={
                'ordering': ['user_id'],
                'db_table': 'user',
            },
        ),
        migrations.DeleteModel(
            name='Login',
        ),
    ]
