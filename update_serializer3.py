import re

file_path = '../backend/api/serializers/accounts.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

old_logic = "        data = super().validate(attrs)"

new_logic = """        try:
            data = super().validate(attrs)
        except Exception as e:
            from rest_framework import exceptions
            raise exceptions.AuthenticationFailed(
                f"DEBUG_FAIL: User Found={user is not None}, is_active={getattr(user, 'is_active', 'None')}, is_deleted={getattr(user, 'is_deleted', 'None')}, pwd_ok={user.check_password(password) if user else False}"
            )"""

updated_content = content.replace(old_logic, new_logic)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(updated_content)

print("Updated serializers.py with debug exception")
