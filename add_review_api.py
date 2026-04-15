import re

with open('../backend/api/views/orders.py', 'r') as f:
    content = f.read()

# I need to insert `add_review` at the end of the `OrderViewSet` class.
# Let's search for closing logic or just add it before the end of the file if `OrderViewSet` is the last one.
# Wait, I should just find `def customer_requests(self, request, pk=None):` and add it before it.

review_logic = """
    @action(detail=True, methods=['post'])
    def add_review(self, request, pk=None):
        order = self.get_object()
        
        # Check if already reviewed
        if hasattr(order, 'review'):
            from rest_framework import status
            from rest_framework.response import Response
            return Response({'error': 'تم التقييم مسبقاً'}, status=status.HTTP_400_BAD_REQUEST)
        
        rating = request.data.get('rating')
        worker_rating = request.data.get('worker_rating')
        comment = request.data.get('comment', '')
        
        if not rating or not worker_rating:
            from rest_framework import status
            from rest_framework.response import Response
            return Response({'error': 'تقييم الخدمة والعاملة مطلوب'}, status=status.HTTP_400_BAD_REQUEST)
            
        # Try to infer worker if available
        worker = None
        if hasattr(order, 'daily_booking') and order.daily_booking and order.daily_booking.worker:
            worker = order.daily_booking.worker
        elif hasattr(order, 'rental_details') and order.rental_details and order.rental_details.worker:
            worker = order.rental_details.worker
            
        from orders.models import OrderReview
        OrderReview.objects.create(
            order=order,
            worker=worker,
            rating=rating,
            worker_rating=worker_rating,
            comment=comment
        )
        
        from rest_framework import status
        from rest_framework.response import Response
        return Response({'success': True}, status=status.HTTP_201_CREATED)

    @action(detail=True, methods=['post'])
    def customer_requests(self, request, pk=None):"""

if "def add_review" not in content:
    content = content.replace(
        "    @action(detail=True, methods=['post'])\n    def customer_requests(self, request, pk=None):",
        review_logic
    )

with open('../backend/api/views/orders.py', 'w') as f:
    f.write(content)
