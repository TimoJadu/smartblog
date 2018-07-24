# Generated by Django 2.0.6 on 2018-07-23 20:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('restapp', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='summaryTable',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('id_gist', models.CharField(max_length=500)),
                ('longitude', models.CharField(max_length=500)),
                ('latitude', models.CharField(max_length=500)),
                ('altitude', models.CharField(max_length=500)),
                ('time', models.CharField(max_length=500)),
                ('Speed', models.CharField(max_length=500)),
                ('DateTime', models.CharField(max_length=500)),
                ('TimeDiff', models.CharField(max_length=500)),
                ('DistanceCovered', models.CharField(max_length=500)),
                ('DeltaElev', models.CharField(max_length=500)),
                ('GeoPointsDist', models.CharField(max_length=500)),
                ('Angle', models.CharField(max_length=500)),
                ('fileName', models.CharField(max_length=500)),
            ],
        ),
    ]