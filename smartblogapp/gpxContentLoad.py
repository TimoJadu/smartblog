import psycopg2
from pprint import pprint
from math import sin, cos, radians
import sys
import gpxpy
from pandas import DataFrame
import mplleaflet
import matplotlib.pyplot as plt
import numpy as np
# import seawater as sw
import os
import subprocess


class DatabaseConnection:
	def __init__(self, obj=0):
		try:
			self.connection=psycopg2.connect("dbname='DjangoDB' user='postgres' host='localhost' password='Subha8jit' port='5432'")
			self.connection.autocommit=True
			self.cursor=self.connection.cursor()
			self._obj=obj
		except:
			pprint("Cannot connect to database")

	def drop_table(self):
		drop_table='drop table "gpxcontenttable"'
		self.cursor.execute(drop_table)

	def create_table(self):
			create_table_command="CREATE TABLE gpxcontentTable(id serial PRIMARY KEY, fileName varchar(500), longitude varchar(500), latitude varchar(500), altitude varchar(500), time TIMESTAMP, Speed decimal, Point geometry(Point,4326))"
			self.cursor.execute(create_table_command)

	def insert_new_record(self,new_record):
		#new_record=("-7.058715", "53.142279","65.599998","2017-08-21 11:37:24","7.004792")
		insert_command="INSERT INTO gpxcontentTable (fileName, longitude, latitude, altitude, time, Speed) VALUES ('"+new_record[0]+"','"+new_record[1]+"','"+new_record[2]+"','"+new_record[3]+"','"+new_record[4]+"')"
		pprint(insert_command)
		self.cursor.execute(insert_command)

	def insert_new_record(self):
		#new_record=("-7.058715", "53.142279","65.599998","2017-08-21 11:37:24","7.004792")
		try:
			new_record=self.obj
			insert_command="INSERT INTO gpxcontentTable (fileName, longitude, latitude, altitude, time, Speed) VALUES ('"+str(new_record[0])+"','"+str(new_record[1])+"','"+str(new_record[2])+"','"+str(new_record[3])+"','"+str(new_record[4])+"','"+str(new_record[5])+"')"
			pprint(insert_command)
			self.cursor.execute(insert_command)
		except Exception as ex:
			pprint("exception occured" + ex)

	def add_geom_Point(self):
		try:
			alter_command="ALTER TABLE gpxcontenttable ADD COLUMN Point geometry(Point,4326)"
			self.cursor.execute(alter_command)
		except Exception as ex:
			pprint("exception occured:" + ex)

	def determine_geom_Point(self):
		try:
			update_command="UPDATE gpxcontenttable SET point = ST_SetSRID(ST_MakePoint(longitude::double precision, latitude::double precision), 4326) where latitude <> '' and longitude <> ''"
			self.cursor.execute(update_command)
		except Exception as ex:
			pprint("exception occured:" + ex)

	def postgresql_to_CSV(self, path):
		try:
			exe_command="COPY gpxContent TO 'C:\subhajit\projectX\PyCharm-GPX/gpxContent.csv' DELIMITER ',' CSV HEADER"
			self.cursor.execute(exe_command)
		except Exception as ex:
			pprint("Exception is:"+ ex)
		

	@property
	def obj(self):
		print("Getting value")
		return self._obj

	@obj.setter
	def obj(self, value):
		print("setting value")
		self._obj = value



def loadData(path, gpxFileName):
	gpx = gpxpy.parse(open(path + gpxFileName))

	print("{} track(s)".format(len(gpx.tracks)))
	track = gpx.tracks[0]
	print("{} segment(s)".format(len(track.segments)))
	segment = track.segments[0]

	print("{} point(s)".format(len(segment.points)))

	data = []
	segment_length = segment.length_3d()
	for point_idx, point in enumerate(segment.points):
		data.append([gpxFileName, point.longitude, point.latitude,
					 point.elevation, point.time, segment.get_speed(point_idx)])

	columns = ['FileName','Longitude', 'Latitude', 'Altitude', 'Time', 'Speed']
	df = DataFrame(data, columns=columns)
	df.head()
	print(df.head())

	return df.values

def checkTableExists(dbcon, tablename):
	dbcur = dbcon.cursor()
	dbcur.execute("""
		SELECT COUNT(*)
		FROM information_schema.tables
		WHERE table_name = '{0}'
		""".format(tablename.replace('\'', '\'\'')))
	if (dbcur.fetchone() == None):
		dbcur.close()
		return False
	else:
		dbcur.close()
		return True


def runRCode():
	try:
		command = 'Rscript'
		path2script = 'C:\subhajit\projectX\PyCharm-GPX\R-code.R'
		cmd = [command, path2script]
		x = subprocess.check_output(cmd, universal_newlines=True)
		pprint('The maximum of the numbers is:', x)

	except Exception as ex:
		pprint("Exception is:" + ex)

def startingPoint(path):
	extenstions = ['gpx']
	filesAvl = [fn for fn in os.listdir(path)
				  if any(fn.endswith(ext) for ext in extenstions)]
	#filesAvl= os.listdir(path)
	database_connection=DatabaseConnection()
	if (checkTableExists(database_connection.connection, "gpxcontentTable") == False):
		# database_connection.drop_table()
		database_connection.create_table()
	else:
		database_connection.create_table()
	for j in filesAvl:
		tempDF=loadData(path, j)
		for i in tempDF:
			database_connection.obj=i
			database_connection.insert_new_record()

	# database_connection.add_geom_Point()
	database_connection.determine_geom_Point()
	database_connection.postgresql_to_CSV(path)
	# runRCode()





