import re

with open('../mobile_app/lib/features/orders/presentation/widgets/order_card.dart', 'r') as f:
    content = f.read()

old_logic = """    // Status color determination
    // Since status might come exactly as mapped in translation or Arabic
    final bool isActive = order.status == 'جاري' || 
                          order.status.toLowerCase() == 'active' ||
                          order.status == 'orders.status_active'.tr() ||
                          order.status == 'جاري العمل';
                          
    final Color statusBgColor = isActive ? AppColors.primary.withAlpha(25) : Colors.red.withAlpha(25);
    final Color statusTextColor = isActive ? AppColors.primary : Colors.red;"""

new_logic = """    final String lowerRawStatus = order.status.toLowerCase();
    final bool isCompleted = lowerRawStatus == 'completed' || lowerRawStatus == 'done' || lowerRawStatus == 'مكتمل';
    final bool isCancelled = lowerRawStatus == 'cancelled' || lowerRawStatus == 'canceled' || lowerRawStatus == 'ملغي';

    Color statusTextColor;
    Color statusBgColor;

    if (isCompleted) {
      statusTextColor = Colors.green;
      statusBgColor = Colors.green.withAlpha(25);
    } else if (isCancelled) {
      statusTextColor = Colors.red;
      statusBgColor = Colors.red.withAlpha(25);
    } else {
      statusTextColor = Colors.orange.shade700;
      statusBgColor = Colors.orange.withAlpha(25);
    }"""

content = content.replace(old_logic, new_logic)

with open('../mobile_app/lib/features/orders/presentation/widgets/order_card.dart', 'w') as f:
    f.write(content)
