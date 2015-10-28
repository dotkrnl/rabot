import httplib
from django.test import TestCase
from stage.models import Stage

# The path of example stage.
EXAMPLE_STAGE_PATH = "/home/mato_no1/3_Projects/rabot/stage_data/exampleStage.json"

# Create your tests here.


class StageInfoTest(TestCase):

    def setUp(self):
        example_stage = Stage(stage_id=0, name="Example Stage")
        tmp_file = open(EXAMPLE_STAGE_PATH)

        try:
            tmp_stage_info = tmp_file.read()
        finally:
            example_stage.info = tmp_stage_info
            tmp_file.close()

        example_stage.save()

    def runTest(self):
        cur_stage = Stage.objects.get(stage_id=0)
        self.assertEqual(cur_stage.stage_id, 0)
        #self.assertTrue(cur_stage.stage_id >= 0)
        self.assertEqual(cur_stage.name, "Example Stage")
        #self.assertTrue(len(cur_stage.name) > 0)

        tmp_conn = httplib.HTTPConnection('127.0.0.1', 8000)
        tmp_conn.request(method='GET', url='/backend/stage/0/')

        tmp_response = tmp_conn.getresponse()
        self.assertTrue(tmp_response.status < 400)

# Testing...
if __name__ == "__main__":
    tmp_test = StageInfoTest()
    tmp_test.runTest()
