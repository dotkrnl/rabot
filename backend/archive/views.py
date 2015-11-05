from django.http import HttpResponse, Http404
from django.views.decorators.csrf import csrf_exempt
from archive.managers import ArchiveManger

# Create your views here.


@csrf_exempt
def save_review(request):
    manager = ArchiveManger()


@csrf_exempt
def load_review(request):
    manager = ArchiveManger()
