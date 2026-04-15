import re

with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_booking_details_card.dart', 'r') as f:
    content = f.read()

old_status_color = """    final Color statusColor = isCancelled 
        ? Colors.red 
        : (booking.status == 'completed' ? Colors.green : AppColors.primary);
        
    final Color statusBgColor = isCancelled 
        ? Colors.red.withOpacity(0.1) 
        : (booking.status == 'completed' ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1));"""

new_status_color = """    final Color statusColor = isCancelled 
        ? Colors.red 
        : (booking.status == 'completed' ? Colors.green : Colors.orange.shade700);
        
    final Color statusBgColor = isCancelled 
        ? Colors.red.withAlpha(25) 
        : (booking.status == 'completed' ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25));"""

content = content.replace(old_status_color, new_status_color)

with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_booking_details_card.dart', 'w') as f:
    f.write(content)
