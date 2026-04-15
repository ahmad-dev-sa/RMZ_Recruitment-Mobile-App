import re

with open('../backend/api/views/orders.py', 'r') as f:
    views_content = f.read()

review_logic = """
    @action(detail=True, methods=['post'], url_path='submit-review')
    def add_review(self, request, pk=None):
        order = self.get_object()
        
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
            
        worker = None
        if hasattr(order, 'daily_booking') and order.daily_booking and order.daily_booking.worker:
            worker = order.daily_booking.worker
            
        from orders.models import OrderReview
        OrderReview.objects.create(
            order=order,
            worker=worker,
            rating=rating,
            worker_rating=worker_rating,
            comment=comment,
            is_approved=False
        )
        
        from rest_framework import status
        from rest_framework.response import Response
        return Response({'success': True}, status=status.HTTP_201_CREATED)

"""

if "url_path='submit-review'" not in views_content:
    target = "    @action(detail=True, methods=['post', 'get'], url_path='requests')"
    replacement = review_logic + target
    views_content = views_content.replace(target, replacement)
    
    with open('../backend/api/views/orders.py', 'w') as f:
        f.write(views_content)
