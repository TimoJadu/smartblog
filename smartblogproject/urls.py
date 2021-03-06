"""smartblogproject URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.9/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Import the include() function: from django.conf.urls import url, include
    3. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf import settings
from django.conf.urls import include, url
from django.conf.urls.static import static
from django.contrib import admin
from smartblogapp import url as blogapp
from restapp import views

urlpatterns = [
    url(r'^admin/', admin.site.urls, name="admin"),
    url(r'^posts/', include(blogapp), name="posts"),
    url(r'^$', include(blogapp),name="posts"),
    url(r'^api/gpx', views.gpxcontentTableList.as_view(), name="restGPX"),
    url(r'^api/summary', views.summaryTableList.as_view(), name="restGPXSummary"),
    url(r'^api/dataSet2Analysis', views.dataSet2AnalysisList.as_view(), name="dataSet2Analysis"),
    url(r'^api/lineStringJson', views.gpxJsonList.as_view(), name="restGPXLineString"),
]


if settings.DEBUG:
	urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
	urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
