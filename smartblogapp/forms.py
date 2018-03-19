from django import forms

from .models import Post

class PostForm(forms.ModelForm):
	"""docstring for ClassName"""
	class Meta:
		model=Post
		fields=[
			"title",
			"content",
			'image',
			"latitude",
			"longitude",
		]
			
