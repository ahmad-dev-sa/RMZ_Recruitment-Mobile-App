import re

file_path = '../backend/api/serializers/accounts.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I will replace the entire validate method logic.
match = re.search(r'(class CustomTokenObtainPairSerializer\(TokenObtainPairSerializer\):\s+def validate\(self, attrs\):)(.*?)(        data = super\(\)\.validate\(attrs\))', content, re.DOTALL)
if match:
    new_validate = """        username_or_email = attrs.get(self.username_field)
        password = attrs.get('password')

        from django.db.models import Q
        # Allow login with email, username, id_number or mobile
        user = User.objects.filter(
            Q(username=username_or_email) | 
            Q(email=username_or_email) | 
            Q(id_number=username_or_email) |
            Q(mobile=username_or_email)
        ).first()

        if user:
            # Map input to actual username for simplejwt
            attrs[self.username_field] = user.username
            
            # Reactivate account if it was deactivated (soft deleted)
            if getattr(user, 'is_deleted', False):
                if user.check_password(password):
                    user.is_deleted = False
                    user.is_active = True
                    user.save()
"""
    updated_content = content.replace(match.group(2), "\n" + new_validate + "\n")
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    print("Fixed CustomTokenObtainPairSerializer")
else:
    print("Could not match the validate method")
