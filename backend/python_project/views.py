from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import api_view
from . import database
from rest_framework import status
# Create your views here.

def myapp(request):
    return render(request,'python_project/main.html')
@api_view(['GET', 'POST','PUT','DELETE'])
def getData(request):
    if request.method == 'GET':
        return Response(database.pokedex)

    elif request.method == 'POST':
        data = request.data
        number = data.get('number')

        try:
            parsed_number = int(number)
            pokemon = database.pokedex.get(parsed_number)
            
            if pokemon:
                response_data = {
                    'pokemon': pokemon,
                    'status': 'success'
                }
            else:
                response_data = {
                    'message': 'empty',
                    'status': 'success'
                }

            return Response(response_data, status=status.HTTP_201_CREATED)
    elif request.method == 'PUT':
            data = request.data
            number = data.get('number')
            if not number or int(number) not in database.pokedex:
              return Response({'Message',status=status.HTTP_400_BAD_REQUEST})

            name = pokedex.name
            type = pokedex.type



            try:
                parsed_number = int(number)
                pokemon = database.pokedex.get(parsed_number)

                if pokemon:
                    response_data = {
                        'pokemon': pokemon,
                        'status': 'success'
                    }
                else:
                    response_data = {
                        'message': 'empty',
                        'status': 'success'
                    }

                return Response(response_data, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({
                'error': 'Invalid input',
                'detail': str(e),
                'status': 'fail'
            }, status=status.HTTP_400_BAD_REQUEST)