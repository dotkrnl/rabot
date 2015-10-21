from rest_framework import serializers
from stage.models import Stage


class StageInfoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Stage
        fields = ("stage_id", "info")