from rest_framework import serializers
from . models import employees
from . models import gpxcontentTable

class employeeSerializer(serializers.ModelSerializer):
    class Meta:
        model=employees
        fields=('firstname', 'lastname')


class gpxcontentTableSerializer(serializers.ModelSerializer):
    class Meta:
        model=gpxcontentTable
        fields='__all__'