from django.http import HttpResponse, Http404
from stage.models import Stage
import json


def stage_info_view(request, stage_id):

    if request.method == 'GET':
        try:
            target = Stage.objects.get(id=stage_id)
        except Stage.DoesNotExist:
            return HttpResponse(json.dumps(
                {'status' : 'not_exist'}
            ))

        return HttpResponse(json.dumps({
                'status' : 'succeeded',
                'name' : target.name,
                'info' : target.info
        }))

    if request.method == 'POST':
        post = request.POST
        new_stage = Stage(stage_id=post['id'], info=post['info'])
        new_stage.save()


def all_stages_info_view(request):

    if request.method == 'GET':
        all_stages = Stage.objects.all()
        results = []

        for stage in all_stages:
            current_stage =  {
                'id' : stage.id,
                'name' : stage.name
            }
            results.append(current_stage)

        return HttpResponse(json.dumps(results))
