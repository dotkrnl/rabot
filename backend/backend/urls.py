"""backend URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.8/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf.urls import include, url
from django.contrib import admin

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    url(r'^backend/stage/$', 'stage.views.all_stages_info_view'),
    url(r'^backend/stage/(?P<sid>\d+)/$', 'stage.views.stage_info_view'),
    url(r'^backend/modifystage/$', 'stage.views.stage_modify'),
    url(r'^backend/login', 'users.views.user_login_view'),
    url(r'^backend/logout', 'users.views.user_logout_view'),
    url(r'^backend/registration', 'users.views.user_registration_view'),
    url(r'^authentication/(?P<uid>\d+)/$', 'users.views.user_authentication_view'),
    url(r'^backend/updateinfo', 'users.views.user_info_update'),
]
