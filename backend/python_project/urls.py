from django.urls import path
from . import views

urlpatterns = [
    path('', views.myapp),
    path('pokedex/api/', views.getData)

]
