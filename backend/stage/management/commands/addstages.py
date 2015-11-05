from django.core.management.base import BaseCommand, CommandError
from stage.managers import StageManager


class Command(BaseCommand):
    help = 'Add 5 default stages to the database.'

    def add_arguments(self, parser):
        pass

    def handle(self, *args, **options):
        manager = StageManager()
        manager.clear()

        sid = 1
        name = "Level 1 - Basic"
        info = """[
            {"type":"carrot","x":300,"y":50,"radius":40},
            {"type":"rabbit","x":300,"y":370,"angle":0,"radius":40}
          ]"""
        manager.add_stage(sid, name, info)

        sid = 2
        name = "Level 2 - Carrot"
        info = """[
            {"type":"carrot","x":300,"y":50,"radius":40},
            {"type":"carrot","x":300,"y":200,"angle":0,"radius":40},
            {"type":"rabbit","x":300,"y":370,"angle":0,"radius":40}
          ]"""
        manager.add_stage(sid, name, info)

        sid = 3
        name = "Level 3 - River"
        info = """[
            {"type":"river","x":0,"y":150,"width":400,"height":75},
            {"type":"carrot","x":300,"y":50,"radius":40},
            {"type":"rabbit","x":300,"y":370,"angle":0,"radius":40}
          ]"""
        manager.add_stage(sid, name, info)

        sid = 4
        name = "Level 4 - Key&Door"
        info = """[
            {"type":"river","x":0,"y":150,"width":400,"height":75},
            {"type":"river","x":475,"y":150,"width":400,"height":75},
            {"type":"carrot","x":300,"y":50,"radius":40},
            {"type":"rabbit","x":300,"y":370,"angle":0,"radius":40},
            {"type":"key","x":100,"y":400,"keyId":0,"radius":40},
            {"type":"door","x":400,"y":150,"width":75,"height":75,"keyId":0}
          ]"""
        manager.add_stage(sid, name, info)

        sid = 5
        name = "Level 5"
        info = """[
            {"type":"river","x":0,"y":150,"width":400,"height":75},
            {"type":"river","x":475,"y":150,"width":400,"height":75},
            {"type":"carrot","x":300,"y":50,"radius":40},
            {"type":"rabbit","x":300,"y":370,"angle":0,"radius":40},
            {"type":"key","x":100,"y":400,"keyId":0,"radius":40},
            {"type":"door","x":400,"y":150,"width":75,"height":75,"keyId":0},
            {"type":"rotator","x":400,"y":400,"rotation":90,"radius":40}
          ]"""
        manager.add_stage(sid, name, info)
