from rest_framework import serializers
from . models import employees
from . models import *

class employeeSerializer(serializers.ModelSerializer):
    class Meta:
        model=employees
        fields=('firstname', 'lastname')


class gpxcontentTableSerializer(serializers.ModelSerializer):
    class Meta:
        model=gpxcontentTable
        fields='__all__'


class summaryTableSerializer(serializers.ModelSerializer):
    class Meta:
        model=summaryTable
        # fields='__all__'
        fields=('id_gist','longitude','latitude','altitude','time','Speed','DateTime',
        	'TimeDiff','DistanceCovered','DeltaElev','GeoPointsDist','Angle','fileName')

class gpxJsonSerializer(serializers.ModelSerializer):
    class Meta:
        model=gpxJson
        # fields='__all__'
        fields=('fileName','lineString')