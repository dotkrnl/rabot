from django.http import HttpResponse, Http404
from stage.models import Stage
import json


def stage_info_view(request, stage_id):

    if request.method == 'GET':
        try:
            target = Stage.objects.get(stage_id=stage_id)
        except Stage.DoesNotExist:
            raise Http404

        return HttpResponse(target.info)

    if request.method == 'POST':
        post = request.POST
        new_stage = Stage(stage_id=post['id'], info=post['info'])
        new_stage.save()


def all_stages_info_view(request):

    if request.method == 'GET':
        all_stages = Stage.objects.all()
        current_stage = {}
        results = []

        for i in all_stages:
            current_stage['id'] = i.stage_id
            current_stage['info'] = i.info
            results.append(json.dumps(current_stage))

        return HttpResponse(results)
