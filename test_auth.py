import os
import django

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
django.setup()

from django.contrib.auth import get_user_model
User = get_user_model()

print("Users with is_deleted=True:")
for u in User.objects.filter(is_deleted=True):
    print(f"ID: {u.id}, Username: {u.username}, ID_Number: {u.id_number}, is_active: {u.is_active}, is_suspended: {u.is_suspended}")

