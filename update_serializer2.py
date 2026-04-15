import re

file_path = '../backend/api/serializers/accounts.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

old_logic = """            # Reactivate account if it was deactivated (soft deleted)
            if getattr(user, 'is_deleted', False) and not getattr(user, 'is_suspended', False):
                if user.check_password(password):
                    user.is_deleted = False
                    user.is_active = True
                    user.save()"""

new_logic = """            # Reactivate account if it was deactivated (soft deleted or just inactive) but not suspended
            if not getattr(user, 'is_active', True) and not getattr(user, 'is_suspended', False):
                if user.check_password(password):
                    user.is_deleted = False
                    user.is_active = True
                    user.save()
            elif getattr(user, 'is_deleted', False) and not getattr(user, 'is_suspended', False):
                if user.check_password(password):
                    user.is_deleted = False
                    user.is_active = True
                    user.save()"""

updated_content = content.replace(old_logic, new_logic)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(updated_content)

print("Updated serializers.py")
