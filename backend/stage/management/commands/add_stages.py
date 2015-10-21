from django.core.management.base import BaseCommand, CommandError
from stage.models import Stage

class Command(BaseCommand):
    help = 'Add 3 default stages to the databasse.'

    def add_arguments(self, parser):
        pass;

    def handle(self, *args, **options):
        Stage.objects.all().delete()
        stage = Stage(name = "Level 1", info = """[
            {"type":"carrot","x":300,"y":50},
            {"type":"rabbit","x":300,"y":370,"angle":0}
          ]""")
        stage.save();
        stage = Stage(name = "Level 2", info = """[
            {"type":"carrot","x":300,"y":50},
            {"type":"carrot","x":300,"y":200,"angle":0},
            {"type":"rabbit","x":300,"y":370,"angle":0}
          ]""")
        stage.save();
        stage = Stage(name ="Unsolvable", info = """[
            {"type":"carrot","x":300,"y":50}
          ]""")
        stage.save();
