from django.db import models

# Create your models here.
class employees(models.Model):
    firstname= models.CharField(max_length=10)
    lastname= models.CharField(max_length=10)
    emp_id=models.IntegerField()

    def __str__(self):
        return self.firstname


class gpxcontentTable(models.Model):
    id =models.IntegerField(primary_key=True)
    fileName=models.CharField(max_length=500)
    longitude = models.CharField(max_length=500)
    latitude = models.CharField(max_length=500)
    altitude = models.CharField(max_length=500)
    time = models.TimeField()
    Speed= models.IntegerField()
    point=models.CharField(max_length=1000, default=None)


class summaryTable(models.Model):
    id =models.IntegerField(primary_key=True, auto_created=True)
    id_gist =models.CharField(max_length=500)    
    longitude = models.CharField(max_length=500)
    latitude = models.CharField(max_length=500)
    altitude = models.CharField(max_length=500)
    time = models.CharField(max_length=500)
    Speed= models.CharField(max_length=500)
    DateTime=models.CharField(max_length=500)
    TimeDiff=models.CharField(max_length=500)
    DistanceCovered=models.CharField(max_length=500)
    DeltaElev=models.CharField(max_length=500)
    GeoPointsDist=models.CharField(max_length=500)
    Angle=models.CharField(max_length=500)
    fileName=models.CharField(max_length=500)

class gpxJson(models.Model):
    id=models.IntegerField(primary_key=True, auto_created=True)
    fileName=models.CharField(max_length=500)
    lineString=models.CharField(max_length=1000000)
