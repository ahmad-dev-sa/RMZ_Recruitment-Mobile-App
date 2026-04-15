import re

file_path = '../backend/api/serializers/accounts.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

old_logic = """        # Soft delete check
        user = User.objects.filter(username=attrs.get(self.username_field)).first()
        if user and user.is_deleted:
            raise serializers.ValidationError("This account has been deactivated.")"""

new_logic = """        # Reactivate account if it was deactivated (soft deleted)
        username = attrs.get(self.username_field)
        user = User.objects.filter(username=username).first()
        if user and getattr(user, 'is_deleted', False):
            # Check password before reactivation to ensure security
            if user.check_password(password):
                user.is_deleted = False
                user.is_active = True
                user.save()"""

updated_content = content.replace(old_logic, new_logic)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(updated_content)

print("Updated successfully")
