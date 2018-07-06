from django.db import models
from django.conf import settings
from django.urls import reverse

def upload_location(instance, filename):
	return "%s/%s" %(instance.id, filename)

# Create your models here.
class Post(models.Model):
	"""docstring for ClassName"""
	user= models.ForeignKey(settings.AUTH_USER_MODEL, default=1,on_delete=models.CASCADE)
	title = models.CharField(max_length=120)
	image = models.ImageField(upload_to=upload_location,
			null=True, blank=True,
			width_field="width_field",
			height_field="height_field")
	height_field = models.IntegerField(default=0)
	width_field = models.IntegerField(default=0)
	content = models.TextField()
	updated = models.DateTimeField(auto_now=True, auto_now_add=False)
	timestamp = models.DateTimeField(auto_now=False, auto_now_add=True)
	latitude = models.FloatField(default=0)
	longitude = models.FloatField(default=0)

	def __unicode__(self):
		return self.title

	def __str__(self):
		return self.title

	def get_absolute_url(self):
		# return "/posts/details/%s/"%(self.id)
		return reverse("posts:detail", kwargs={"id": self.id})

	def get_absolute_url_create(self):
		# return "/posts/details/%s/"%(self.id)
		return reverse("posts:create")

		

		