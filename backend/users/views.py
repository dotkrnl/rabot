from django.http import HttpResponse, Http404
from django.views.decorators.csrf import csrf_exempt
from users.managers import UsersManager
import json

# Create your views here.


@csrf_exempt
def user_registration_view(request):
    manager = UsersManager()

    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode())
            uname = data['username']
            passwd = data['password']
            passwd2 = data['repeatedPassword']
            email = data['email']
        except KeyError:
            response_data = {
                'result': 'failed',
                'errorMessage': 'KeyError',
            }
        else:
            result = manager.registration(uname, passwd, passwd2, email)

            if result[:9] == 'Succeeded':
                uid = int(result[27:])
                response_data = {
                    'result': 'succeeded',
                    'uid': uid,
                    'username': uname,
                    'password': passwd,
                    'email': email,
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
def user_login_view(request):
    manager = UsersManager()

    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode())
            uname = data['username']
            passwd = data['password']
        except KeyError:
            response_data = {
                'result': "failed",
                'errorMessage': 'KeyError',
            }
        else:
            result = manager.login(uname, passwd)

            if result[:9] == 'Succeeded':
                uid = int(result[23:])
                response_data = {
                    'result': 'succeeded',
                    'uid': uid,
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
def user_info_update(request):
    manager = UsersManager()

    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode())
            uid = data['uid']
            old_passwd = data['oldPassword']
            new_passwd = data['newPassword']
            new_passwd2 = data['repeatedPassword']
            new_email = data['new_email']
        except KeyError:
            response_data = {
                'result': 'failed',
                'errorMessage': 'KeyError',
            }
        else:
            result = manager.update(uid, old_passwd, new_passwd, new_passwd2, new_email)

            if result[:9] == 'Succeeded':
                response_data = {
                    'result': 'succeeded',
                }
            else:
                response_data = {
                    'result': "failed",
                    'errorMessage': result
                }

        return HttpResponse(json.dumps(response_data))

    else:
        raise Http404

