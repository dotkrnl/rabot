from django.http import HttpResponse, Http404
#from userlogin.models import UserInfo
from userlogin.auth import AuthBackend
import json

# Create your views here.


def user_login_view(request):

    if request.method == "POST":
        data = json.loads(request.body)
        user_name = data['name']
        passwd = data['password']

        tmp_auth = AuthBackend()
        target = tmp_auth.authenticate(user_name, passwd)

        return HttpResponse(target)
    else:
        raise Http404
