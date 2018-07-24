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



class summaryTableList(APIView):
    def get(self,request):
        summary=summaryTable.objects.all()
        filename = self.request.query_params.get('filename', None)
        if filename is not None:
            summary = summary.filter(fileName=filename)
        serializer=summaryTableSerializer(summary,many=True)
        return Response(serializer.data)

    def post(self):
        pass

        # queryset = Purchase.objects.all()
        # username = self.request.query_params.get('username', None)
        # if username is not None:
        #     queryset = queryset.filter(purchaser__username=username)
        # return queryset