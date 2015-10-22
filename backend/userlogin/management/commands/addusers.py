from django.core.management.base import BaseCommand, CommandError
from userlogin.models import UserInfo, UserInfoManager

class Command(BaseCommand):
    help = 'Add 4 default users to the databasse.'

    def add_arguments(self, parser):
        pass;

    def handle(self, *args, **options):
        UserInfo.objects.all().delete()
        userInfoManager = UserInfoManager()
        userInfoManager.create_user(1001, 'liaoyiyang', 'test1@test.com', 'liaoyiyang')
        userInfoManager.create_user(1002, 'liangzeyu', 'test2@test.com', 'liangzeyu')
        userInfoManager.create_user(1003, 'liujiachang', 'test3@test.com', 'liujiachang')
        userInfoManager.create_user(1004, 'tansinan', 'test4@test.com', 'tansinan')
