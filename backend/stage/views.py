from django.shortcuts import render
from rest_framework import status
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.decorators import api_view
from stage.models import Stage
from stage.serializers import StageInfoSerializer

# Create your views here.

#queryset = Stage.objects.all()

@api_view(['GET'])
def stage_view(request, stage_id):

    try:
        target = Stage.objects.get(stage_id=stage_id)
    except target.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = StageInfoSerializer(target)
        return Response(serializer.data)