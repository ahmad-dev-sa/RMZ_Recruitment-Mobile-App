import re

with open('../backend/api/views/orders.py', 'r') as f:
    content = f.read()

bad_logic = """
            if getattr(order, 'daily_booking', None) and order.daily_booking.assigned_worker:
                worker = order.daily_booking.assigned_worker
"""
good_logic = """
            try:
                if getattr(order, 'daily_booking', None) and hasattr(order.daily_booking, 'worker') and order.daily_booking.worker:
                    worker = order.daily_booking.worker
                elif getattr(order, 'rental_details', None) and hasattr(order.rental_details, 'worker') and order.rental_details.worker:
                    worker = order.rental_details.worker
                elif getattr(order, 'recruitment_details', None) and hasattr(order.recruitment_details, 'worker') and order.recruitment_details.worker:
                    worker = order.recruitment_details.worker
            except Exception:
                pass
"""
content = content.replace(bad_logic, good_logic)

with open('../backend/api/views/orders.py', 'w') as f:
    f.write(content)
