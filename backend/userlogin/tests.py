from django.test import TestCase
from userlogin.models import UserInfo, UserInfoManager

# Create your tests here.


class UserInfoTest(TestCase):

    def setUp(self):
        tmp_manager = UserInfoManager()

        tmp_manager.create_superuser(20120526, 'clevertick', 'clevertick@Orz_Human_Intelligence.net', 'HighestIQ000')

        example_user1 = UserInfo(user_id=1, user_name='mato_no1', email='mato_no1@yeah.net')
        example_user1.set_password('g28h2f0djp4s')
        example_user1.save()

        tmp_manager.create_user(2, 'mato_no2', 'mato_no2@126.com', '49ryf894231uhr89z')

    def runTest(self):
        cur_superuser = UserInfo.objects.get(user_name='clevertick')
        self.assertEqual(cur_superuser.user_id, 20120526)
        self.assertEqual(cur_superuser.user_name, 'clevertick')
        self.assertEqual(cur_superuser.email, 'clevertick@orz_human_intelligence.net')
        self.assertTrue(cur_superuser.check_password('HighestIQ000'))

        cur_user = UserInfo.objects.get(user_name='mato_no1')
        self.assertTrue(cur_user.user_id >= 0)
        self.assertTrue(len(cur_user.user_name) > 0)
        self.assertTrue(len(cur_user.email) > 0)
        self.assertTrue(cur_user.check_password('g28h2f0djp4s'))

        cur_user = UserInfo.objects.get(user_name='mato_no2')
        self.assertTrue(cur_user.user_id >= 0)
        self.assertTrue(len(cur_user.user_name) > 0)
        self.assertTrue(len(cur_user.email) > 0)
        self.assertTrue(cur_user.check_password('49ryf894231uhr89z'))

# Testing...
if __name__ == "__main__":
    tmp_test = UserInfoTest()
    tmp_test.runTest()
