from django.contrib import messages
#from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.http import HttpResponse, HttpResponseRedirect, Http404
from django.shortcuts import render, get_object_or_404, redirect

from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.shortcuts import render

# Create your views here.

# def post_home(request):
# 	return HttpResponse("<h1>Home</h1>")
from .models import Post
from .forms import PostForm
from .gpxContentLoad import *

def post_Create(request):
	if not request.user.is_staff or not request.user.is_superuser:
		raise Http404
	# code to have default validation on POST data
	form=PostForm(request.POST or None, request.FILES or None)
	if form.is_valid():
		instance=form.save(commit=False)
		instance.save()
		# message success
		messages.success(request,"Successfully created")
		return HttpResponseRedirect(instance.get_absolute_url())
	else:
		messages.success(request,"Successfully not created")
	# code to have the post data without validation
	# form=PostForm()
	# if(request.method == "POST"):
	# 	# printing in the console
	# 	print(request.POST) 
	context={
	"form": form,
	}
	# return HttpResponse("<h1>Create</h1>")
	return render(request, "post_form.html", context)

# def post_home(request):
# 	context = {
# 	"title": "Home2"
# 	}
# 	return render(request, "index.html", context)
def post_home(request):

	querySet_list = Post.objects.all().order_by("-timestamp")

	paginator = Paginator(querySet_list, 2) # Show 2 querySet per page
	page_request_var= "page"
	page = request.GET.get(page_request_var)
	try:
		querySet = paginator.page(page)
	except PageNotAnInteger:
		querySet=paginator.page(1)
	except EmptyPage:
		querySet=paginator.page(paginator.num_pages)


	query= request.GET.get("q")
	if (query):
		querySet= querySet_list.filter(title__icontains=query)
	if request.user.is_authenticated:
		context = {
			"object_list": querySet,
			"title": "Welcome",
			"page_request_var": page_request_var
		}
	else:
		context = {
			"object_list": querySet,
			"title":"Home4",
			"page_request_var": page_request_var
		}

	return render(request, "post_list.html", context)





def post_details(request, id=None):
	if(request.GET.get('mybtn')):
		startingPoint(request.GET.get('mytextbox'))

	if(request.GET.get('btnReset')):
		ResetLoadingTable()

	if(request.GET.get('btnSummaryAPILoad')):
		summaryAPILoad()
	instance = get_object_or_404(Post, id=id)

	context = {
	"title": "Details",
	"instance": instance
	}

	return render(request, "post_detail.html", context)


def post_Update(request, id=None):
	if not request.user.is_staff or not request.user.is_superuser:
		raise Http404
	instance = get_object_or_404(Post, id=id)
	form=PostForm(request.POST or None, request.FILES or None, instance=instance)
	if form.is_valid():
		instance=form.save(commit=False)
		instance.save()
		# message success
		messages.success(request,"Successfully saved")
		return HttpResponseRedirect(instance.get_absolute_url())
	# else:
	# 	messages.success(request,"Successfully not saved")
	context = {
	"title": "Details",
	"instance": instance,
	"form": form,
	}
	return render(request, "post_form.html", context)

def post_Retrieve(request):
	return HttpResponse("<h1>Retrieve</h1>")

def post_Delete(request, id=None):
	if not request.user.is_staff or not request.user.is_superuser:
		raise Http404		
	instance = get_object_or_404(Post, id=id)
	instance.delete()
	messages.success(request, "Deleted")
	return redirect("posts:list")


def Import(request):
	if(request.GET.get('mybtn')):
		startingPoint()

def kElbowCurve(request):
	import django
	from sklearn.cluster import KMeans
	from matplotlib import pyplot as plt
	from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

	X = ImageBuilder()
	distorsions = []
	for k in range(1,20):
	    kmeans = KMeans(n_clusters=k)
	    kmeans.fit(X)
	    distorsions.append(kmeans.inertia_)
	
	fig = plt.figure(1, figsize=(10,12))
	plt.plot(range(1,20), distorsions)
	plt.grid(True)
	plt.title('Elbow curve')

	canvas=FigureCanvas(fig)
	response=django.http.HttpResponse(content_type='image/png')
	canvas.print_png(response)
	
	return response


def drawImage(request):
	import random
	import django
	import datetime

	from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
	from matplotlib.figure import Figure
	from matplotlib.dates import DateFormatter

	# fig=Figure()
	# ax=fig.add_subplot(111)
	# x=[]
	# y=[]
	# now=datetime.datetime.now()
	# delta=datetime.timedelta(days=1)
	# for i in range(10):
	# 	x.append(now)
	# 	now+=delta
	# 	y.append(random.randint(0, 1000))
	# ax.plot_date(x, y, '-')
	# ax.xaxis.set_major_formatter(DateFormatter('%Y-%m-%d'))
	# fig.autofmt_xdate()
	# canvas=FigureCanvas(fig)
	# response=django.http.HttpResponse(content_type='image/png')
	# canvas.print_png(response)

	# Kmean Image
	dataSet2Analysis = ImageBuilder()
	pprint(dataSet2Analysis)
	# clusterset = dataSet2Analysis[,-1]
	# km <- kmeans(clusterset, 4,nstart=10)
	# clusk <- km$cluster
	# o <- order(clusk)
	# fig = stars(clusterset[o,],nrow=3, col.stars=clusk[o]+1)

	from sklearn.cluster import KMeans
	import matplotlib.pyplot as plt
	from mpl_toolkits.mplot3d import Axes3D
	import numpy as np
	# %matplotlib inline
	from sklearn import datasets
	#Iris Dataset
	iris = datasets.load_iris()
	# X = iris.data
	# X = dataSet2Analysis[list(dataSet2Analysis.columns.values)[1:]]
	X = dataSet2Analysis
	#KMeans
	km = KMeans(n_clusters=4)
	km.fit(X)
	km.predict(X)
	labels = km.labels_
	#Plotting
	fig = plt.figure(1, figsize=(7,7))
	ax = Axes3D(fig, rect=[0, 0, 0.95, 1], elev=48, azim=134)
	ax.scatter(X.values[:, 0], X.values[:, 1], X.values[:, 2],
		 # X.values[:, 3], X.values[:, 4], X.values[:, 5], X.values[:, 6],
	          c=labels.astype(np.float), edgecolor="k", s=50)
	ax.set_xlabel("X")
	ax.set_ylabel("Y")
	ax.set_zlabel("Z")
	plt.title("K Means", fontsize=14)


	canvas=FigureCanvas(fig)
	response=django.http.HttpResponse(content_type='image/png')
	canvas.print_png(response)
	# Image end
	return response


def local_plot_image(request):
    image_data = open("C://subhajit//projectX//smartblog//smartblogproject//Plots//ClusterPlot.jpg", "rb").read()
    return HttpResponse(image_data, content_type="image/jpeg")

def dendo_plot_image(request):
    image_data = open("C://subhajit//projectX//smartblog//smartblogproject//Plots//DendoPlot.jpg", "rb").read()
    return HttpResponse(image_data, content_type="image/jpeg")