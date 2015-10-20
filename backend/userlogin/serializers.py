from django.forms import widgets
from rest_framework import serializers
from userlogin.models import UserInfo


class UserInfoSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserInfo
        fields = ("user_id", "user_name", "passwd", "email")
