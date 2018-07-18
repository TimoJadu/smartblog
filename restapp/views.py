from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from . models import *
from . serializers import *

class employeeList(APIView):

    def get(self,request):
        emp=employees.objects.all()
        serializer=employeeSerializer(emp,many=True)
        return Response(serializer.data)

    def post(self):
        pass


class gpxcontentTableList(APIView):

    def get(self,request):
        gpxC=gpxcontentTable.objects.all()
        serializer=gpxcontentTableSerializer(gpxC,many=True)
        return Response(serializer.data)

    def post(self):
        pass