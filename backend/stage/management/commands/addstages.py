from django.core.management.base import BaseCommand, CommandError
from stage.managers import StageManager


class Command(BaseCommand):
    help = 'Add 5 default stages to the database.'

    def add_arguments(self, parser):
        pass

    def handle(self, *args, **options):
        manager = StageManager()
        manager.clear()

        sid = 10
        name = '__meta_all_stage_packages'
        info = """
        [101, 102, 103]
        """
        manager.add_stage(sid, name, info)

        sid = 101
        name = 'Beginner\' s gressland'
        info = """
        {
            "background": "grassland.svg",
            "stages": [1001, 1002, 1003]
        }
        """
        manager.add_stage(sid, name, info)

        sid = 102
        name = 'Branch forest'
        info = """
        {
            "background": "forest.svg",
            "stages": [2001, 2002, 2003, 2004]
        }
        """
        manager.add_stage(sid, name, info)

        sid = 103
        name = 'Loop river'
        info = """
        {
            "background": "river.svg",
            "stages": [3001, 3002, 3003, 3004, 3005]
        }
        """
        manager.add_stage(sid, name, info)

        for i in range(0, 4):
            sid = 1000 * i + 1
            name = "Level 1 - Basic"
            info = """
            [
            	{
            		"type":"carrot",
            		"region":{"radius":40},
            		"image":{"name":"carrot.svg","width":160,"height":160},
            		"x":500,
            		"y":100
            	},
            	{
            		"type":"rabbit",
            		"image":{"name":"rabbit.svg","width":160,"height":160},
            		"x":500,
            		"y":700
            	}
            ]
            """
            manager.add_stage(sid, name, info)

            sid = 1000 * i + 2
            name = "Level 2 - Carrot"
            info = """
            [
            	{
            		"type":"carrot",
            		"region":{"radius":40},
            		"image":{"name":"carrot.svg","width":160,"height":160},
            		"x":500,
            		"y":100
            	},
            	{
            		"type":"carrot",
            		"region":{"radius":40},
            		"image":{"name":"carrot.svg","width":160,"height":160},
            		"x":500,
            		"y":400
            	},
            	{
            		"type":"rabbit",
            		"image":{"name":"rabbit.svg","width":160,"height":160},
            		"x":500,
            		"y":700
            	}
            ]
            """
            manager.add_stage(sid, name, info)

            sid = 1000 * i + 3
            name = "Level 3 - River"
            info = """
            [
            	{
            		"type":"carrot",
            		"region":{"radius":40},
            		"image":{"name":"carrot.svg","width":160,"height":160},
            		"x":500,
            		"y":100
            	},
            	{
            		"type":"staticimage",
            		"image":{"name":"river.svg","x":0,"y":300,"width":1000,"height":200}
            	},
            	{
            		"type":"staticimage",
            		"image":{"name":"bridge.png","x":600,"y":260,"width":280,"height":280}
            	},
            	{
            		"type":"rabbit",
            		"image":{"name":"rabbit.svg","width":160,"height":160},
            		"x":500,
            		"y":700
            	},
            	{
            		"type":"river",
                    "region":{"width":600,"height":200},
            		"x":300,
            		"y":400
            	}
            ]
            """
            manager.add_stage(sid, name, info)

            sid = 1000 * i + 4
            name = "Level 4 - Key&Door"
            info = """
            [
            	{
            		"type":"carrot",
            		"region":{"radius":40},
            		"image":{"name":"carrot.svg","width":160,"height":160},
            		"x":500,
            		"y":100
            	},
            	{
            		"type":"staticimage",
            		"image":{"name":"river.svg","x":0,"y":300,"width":1000,"height":200}
            	},
            	{
            		"type":"staticimage",
            		"image":{"name":"bridge.png","x":600,"y":260,"width":280,"height":280}
            	},
            	{
            		"type":"rabbit",
            		"image":{"name":"rabbit.svg","width":160,"height":160},
            		"x":500,
            		"y":700
            	},
            	{
            		"type":"river",
                    "region":{"width":600,"height":200},
            		"x":300,
            		"y":400
            	},
            	{
            		"type":"key",
                    "image":{"name":"key.svg","width":100,"height":100},
                    "region":{"width":100,"height":100},
            		"x":300,
            		"y":800
            	}
            ]
            """
            '''info = """[
                {"type":"door","x":400,"y":150,"width":75,"height":75,"keyId":0}
              ]"""'''
            manager.add_stage(sid, name, info)

            sid = 1000 * i + 5
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
