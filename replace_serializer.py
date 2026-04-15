import re

file_path = '../backend/api/serializers/accounts.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I will find UserRegistrationSerializer and replace it entirely!
# Look for class UserRegistrationSerializer(serializers.ModelSerializer): and replace until class CustomTokenObtainPairSerializer

match = re.search(r'(class UserRegistrationSerializer.*?)(?=class CustomTokenObtainPairSerializer)', content, re.DOTALL)
if match:
    old_code = match.group(1)
    
    new_code = """class UserRegistrationSerializer(serializers.ModelSerializer):
    id_number = serializers.CharField(required=True)
    full_name = serializers.CharField(required=True, write_only=True)
    phone_number = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    password = serializers.CharField(write_only=True, required=True, style={'input_type': 'password'})
    confirm_password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = ['id_number', 'full_name', 'phone_number', 'email', 'password', 'confirm_password']

    def validate(self, attrs):
        if attrs['password'] != attrs['confirm_password']:
            raise serializers.ValidationError({"password": "كلمة المرور غير متطابقة."})
        
        # Uniqueness checks
        if User.objects.filter(email=attrs['email']).exists():
            raise serializers.ValidationError({"email": "البريد الإلكتروني مسجل مسبقاً"})
            
        if User.objects.filter(id_number=attrs['id_number']).exists():
            raise serializers.ValidationError({"id_number": "رقم الهوية مسجل مسبقاً"})
            
        if User.objects.filter(mobile=attrs['phone_number']).exists() or User.objects.filter(username=attrs['phone_number']).exists():
            raise serializers.ValidationError({"phone_number": "رقم الجوال مسجل مسبقاً"})
            
        return super().validate(attrs)

    def create(self, validated_data):
        names = validated_data['full_name'].split(' ', 1)
        first_name = names[0]
        last_name = names[1] if len(names) > 1 else ''
        
        user = User.objects.create_user(
            username=validated_data['id_number'],
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=first_name,
            last_name=last_name,
            mobile=validated_data['phone_number'],
            id_number=validated_data['id_number'],
            is_customer=True
        )
        # Ensure profiles and preferences are created
        CustomerProfile.objects.get_or_create(user=user)
        UserNotificationPreference.objects.get_or_create(user=user)
        return user

"""
    updated_content = content.replace(old_code, new_code)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    print("Replaced UserRegistrationSerializer.")
else:
    print("Could not find the serializer block.")

