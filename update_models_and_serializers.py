import os
import re

# 1. Update models.py
models_path = '../backend/accounts/models.py'
with open(models_path, 'r', encoding='utf-8') as f:
    models_content = f.read()

# Add is_suspended right after is_deleted
if 'is_suspended = models.BooleanField' not in models_content:
    models_content = models_content.replace(
        'is_deleted = models.BooleanField(default=False)',
        "is_deleted = models.BooleanField(default=False)\n    is_suspended = models.BooleanField(_('Suspended by Admin'), default=False)"
    )
    with open(models_path, 'w', encoding='utf-8') as f:
        f.write(models_content)
    print("Updated models.py")

# 2. Update accounts.py (Serializer)
serializers_path = '../backend/api/serializers/accounts.py'
with open(serializers_path, 'r', encoding='utf-8') as f:
    serializers_content = f.read()

if "if getattr(user, 'is_deleted', False) and not getattr(user, 'is_suspended', False):" not in serializers_content:
    serializers_content = serializers_content.replace(
        "if getattr(user, 'is_deleted', False):",
        "if getattr(user, 'is_deleted', False) and not getattr(user, 'is_suspended', False):"
    )
    with open(serializers_path, 'w', encoding='utf-8') as f:
        f.write(serializers_content)
    print("Updated serializers.py")

print("Done")
