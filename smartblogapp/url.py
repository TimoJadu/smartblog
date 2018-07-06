from django.conf.urls import include, url
from django.contrib import admin

# from . import views
from .views import(
	post_Create,
	post_home,
	post_Update,
	post_Retrieve,
	post_Delete,
	post_details,
	)

app_name = 'posts'

urlpatterns = [

    url(r'^create/$', post_Create, name="createPost"),
    url(r'^$', post_home, name="list"),	
    url(r'^(?P<id>\d+)/edit/$', post_Update, name="update"),
    url(r'^retrieve/$', post_Retrieve),
    url(r'^(?P<id>\d+)/delete/$', post_Delete, name="delete"),
    url(r'^(?P<id>\d+)/$', post_details, name='detail'),    

]