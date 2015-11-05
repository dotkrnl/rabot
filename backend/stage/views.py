from django.http import HttpResponse, Http404
from django.views.decorators.csrf import csrf_exempt
from stage.managers import StageManager
import json

# Create your views here.


@csrf_exempt
def stage_info_view(request, sid):
    manager = StageManager()

    if request.method == 'GET':
        cur_stage = manager.get_stage(sid)
        if cur_stage:
            return HttpResponse(json.dumps({
                'status': 'succeeded',
                'sid': cur_stage.sid,
                'name': cur_stage.name,
                'info': cur_stage.info,
            }))
        else:
            return HttpResponse(json.dumps({
                'status': 'not_exist',
            }))
    else:
        raise Http404


@csrf_exempt
def stage_modify(request):
    manager = StageManager()

    if request.method == 'POST':
        data = json.loads(request.body.decode())
        action = data['action']

        if action == 'add':
            sid = int(data['sid'])
            name = data['name']
            info = data['info']
            result = manager.add_stage(sid, name, info)

        elif action == 'delete':
            sid = int(data['sid'])
            result = manager.delete_stage(sid)

        elif action == 'update':
            sid = int(data['sid'])
            new_name = data['name']
            new_info = data['info']
            result = manager.update_stage(sid, new_name, new_info)

        else:
            result = ''

        if result == '':
            response_data = {}
        elif result[:9] == 'Succeeded':
            response_data = {
                'result': 'succeeded',
            }
        else:
            response_data = {
                'result': 'failed',
                'errorMessage': result,
            }

        return HttpResponse(json.dumps(response_data))

    else:
        raise Http404


@csrf_exempt
def all_stages_info_view(request):
    manager = StageManager()

    if request.method == 'GET':
        all_stages = manager.get_all_stages()
        results = []

        for stage in all_stages:
            cur_stage = {
                'sid': stage.sid,
                'name': stage.name,
                'info': stage.info,
            }
            results.append(cur_stage)

        return HttpResponse(json.dumps(results))

    else:
        raise Http404
