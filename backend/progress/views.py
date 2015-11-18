from django.http import HttpResponse, Http404
from django.views.decorators.csrf import csrf_exempt
from progress.managers import ProgressManager
import json

# Create your views here.


@csrf_exempt
def progress_info_view(request):
    manager = ProgressManager()

    if request.method == 'POST':
        cur_user = request.session.get('cur_user', {})

        if cur_user:
            uid = cur_user['uid']
            data = json.loads(request.body.decode())
            new_info = data['info']

            if manager.search_progress(uid):
                result = manager.update_progress(uid, new_info)
            else:
                result = manager.add_progress(uid, new_info)

            if result[:9] == 'Succeeded':
                response_data = {
                    'result': 'succeeded',
                }
            else:
                response_data = {
                    'result': 'failed',
                    'errorMessage': result,
                }

        else:
            response_data = {
                'result': 'failed',
                'errorMessage': 'You have not logged in.',
            }

        return HttpResponse(json.dumps(response_data))

    elif request.method == 'GET':
        cur_user = request.session.get('cur_user', {})

        if cur_user:
            uid = cur_user['uid']
            cur_progress = manager.search_progress(uid)

            if cur_progress:
                response_data = {
                    'result': 'succeeded',
                    'uid': uid,
                    'info': cur_progress.info,
                }
            else:
                response_data = {
                    'result': 'succeded',
                    'uid': uid,
                    'info': 'Not exist'
                }
        else:
            response_data = {
                'result': 'failed',
                'errorMessage': 'You have not logged in.',
            }

        return HttpResponse(json.dumps(response_data))

    else:
        raise Http404
