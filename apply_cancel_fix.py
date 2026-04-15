import re

with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_booking_details_card.dart', 'r') as f:
    content = f.read()

# Replace status string logic
old_status = """    final String statusStr = booking.status == 'completed' 
        ? 'orders.status_completed'.tr() 
        : (booking.status == 'active' ? 'orders.status_active'.tr() : 'orders.status_processing'.tr());
        
    final Color statusColor = booking.status == 'completed' ? Colors.green : AppColors.primary;
    final Color statusBgColor = booking.status == 'completed' ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1);"""

new_status = """    final bool isCancelled = widget.order.status == 'cancelled' || widget.order.status == 'canceled' || booking.status == 'cancelled';
    final String statusStr = isCancelled 
        ? 'ملغي'
        : (booking.status == 'completed' 
            ? 'orders.status_completed'.tr() 
            : (booking.status == 'active' ? 'orders.status_active'.tr() : 'orders.status_processing'.tr()));
            
    final Color statusColor = isCancelled 
        ? Colors.red 
        : (booking.status == 'completed' ? Colors.green : AppColors.primary);
        
    final Color statusBgColor = isCancelled 
        ? Colors.red.withOpacity(0.1) 
        : (booking.status == 'completed' ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1));"""

content = content.replace(old_status, new_status)

# Replace button logic conditions to exclude cancelled
content = content.replace(
    "if (booking.actualStartTime == null && booking.status != 'completed') ...[",
    "if (booking.actualStartTime == null && booking.status != 'completed' && !isCancelled) ...["
)

content = content.replace(
    "else if (booking.actualStartTime != null && booking.actualEndTime == null && booking.status != 'completed') ...[",
    "else if (booking.actualStartTime != null && booking.actualEndTime == null && booking.status != 'completed' && !isCancelled) ...["
)

# And timeline as well
content = content.replace(
    "if (booking.actualStartTime != null) ...[",
    "if (booking.actualStartTime != null && !isCancelled) ...["
)

with open('../mobile_app/lib/features/orders/presentation/widgets/details/order_booking_details_card.dart', 'w') as f:
    f.write(content)
