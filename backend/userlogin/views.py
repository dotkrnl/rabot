from django.http import HttpResponse, Http404
from django.views.decorators.csrf import csrf_exempt
from userlogin.auth import AuthBackend
import json

# Create your views here.


@csrf_exempt
def user_login_view(request):
    if request.method == 'GET':
        try:
            user_name = request.session['username']
            passwd = request.session['password']

            tmp_auth = AuthBackend()
            target = tmp_auth.authenticate(user_name, passwd)

            if target is None:
                response_data = {
                    'result': 'failed',
                    'uid': -1,
                }
            else:
                response_data = {
                    'result': 'succeeded',
                    'uid': target.user_id,
                    'username': target.user_name,
                    'email': target.email,
                }
        except KeyError:
            response_data = {
                'result': 'failed',
                'uid': -1,
            }

        return HttpResponse(json.dumps(response_data))

    elif request.method == 'POST':
        data = json.loads(request.body)
        user_name = data['username']
        passwd = data['password']

        tmp_auth = AuthBackend()
        target = tmp_auth.authenticate(user_name, passwd)

        if target is None:
            response_data = {
                'result': 'failed',
                'uid': -1,
            }
        else:
            response_data = {
                'result': 'succeeded',
                'uid': target.user_id,
                'username': target.user_name,
                'email': target.email,
            }

            request.session['username'] = user_name
            request.session['password'] = passwd

        return HttpResponse(json.dumps(response_data))

    else:
        raise Http404
