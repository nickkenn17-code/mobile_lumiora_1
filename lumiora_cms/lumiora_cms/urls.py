from django.contrib import admin
from django.urls import path, include
from app import views # 

urlpatterns = [
    path('admin/', admin.site.urls),
    
    path('api/', include('app.urls')), 
    
    path('kitchen/', views.kitchen_display, name='kitchen_display'), 
    
    path('cms/', views.cms_dashboard, name='cms_dashboard'),
]