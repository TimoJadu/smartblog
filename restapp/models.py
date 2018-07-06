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
