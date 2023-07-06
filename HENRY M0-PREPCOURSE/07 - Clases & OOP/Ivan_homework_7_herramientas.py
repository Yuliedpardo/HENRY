class funciones_mod6 ():
    '''
    Clase de herramientas que recibe una lista de enteros como parametro
    '''
    def __init__(self,mi_lista):
        if (type (mi_lista) != list):
            self.mi_lista = []
            raise ValueError ('Se ha creado una lista vacía. Se esperaba una lista de numeros enteros')
        else:
            for i in mi_lista:
                if (type (i) != int):
                    self.mi_lista = []
                    raise ValueError ('Se ha creado una lista vacía. Se esperaba una lista de numeros enteros')
            self.mi_lista = mi_lista
                
    def verifica_primo(self, nro):
        es_primo = True
        for i in range(2, nro):
            if nro % i == 0:
                es_primo = False
                break
        return es_primo
    
    def verifica_primo_lista(self):
        for i in self.mi_lista:
            if self.verifica_primo(i):
                print(i," primo")
            else:
                print(i," NO primo")
    
    def valor_modal(self, menor):
        '''
        Esta función devuelve el valor modal y recibe de parámetros dos valores:
        1-Una lista de números
        2-Verdadero (por defecto) por si se requiere el mínimo de los más repetidos, o Falso si se requiere el máximo
        '''
        lista_unicos = []
        lista_repeticiones = []
        if len(self.mi_lista) == 0:
            return None
        if (menor):
            self.mi_lista.sort()
        else:
            self.mi_lista.sort(reverse=True)
        for elemento in self.mi_lista:
            if elemento in lista_unicos:
                i = lista_unicos.index(elemento)
                lista_repeticiones[i] += 1
            else:
                lista_unicos.append(elemento)
                lista_repeticiones.append(1)
        moda = lista_unicos[0]
        maximo = lista_repeticiones[0]
        for i, elemento in enumerate(lista_unicos):
            if lista_repeticiones[i] > maximo:
                moda = lista_unicos[i]
                maximo = lista_repeticiones[i]
        return moda, maximo
    
    def conversion_grados(self, valor, origen, destino):
        if (origen == 'celsius'):
            if (destino == 'celsius'):
                valor_destino = valor
            elif (destino == 'farenheit'):
                valor_destino = (valor * 9 / 5) + 32
            elif (destino == 'kelvin'):
                valor_destino = valor + 273.15
            else:
                print('Parámetro de Destino incorrecto')
                valor_destino = 'na'
        elif (origen == 'farenheit'):
            if (destino == 'celsius'):
                valor_destino = (valor - 32) * 5 / 9
            elif (destino == 'farenheit'):
                valor_destino = valor
            elif (destino == 'kelvin'):
                valor_destino = ((valor - 32) * 5 / 9) + 273.15
            else:
                print('Parámetro de Destino incorrecto')
                valor_destino = 'na'
        elif (origen == 'kelvin'):
            if (destino == 'celsius'):
                valor_destino = valor - 273.15
            elif (destino == 'farenheit'):
                valor_destino = ((valor - 273.15) * 9 / 5) + 32
            elif (destino == 'kelvin'):
                valor_destino = valor
            else:
                print('Parámetro de Destino incorrecto')
                valor_destino = 'na'
        else:
            print('Parámetro de Origen incorrecto')
            valor_destino = 'na'
        return valor_destino
    
    def conversion_grados_lista (self,ori,dest):
        parametros_ori_dest=['celsius','farenheit','kelvin']
        lista_conversion = []
        if (str(ori) not in parametros_ori_dest) or (str(dest) not in parametros_ori_dest):
            print('los parametros esperados de origen y destino son ', parametros_ori_dest)
            return
        for i in self.mi_lista:
            lista_conversion.append (self.conversion_grados(i,ori,dest))
        print('lista origen\t', self.mi_lista, '\nconversión\t', lista_conversion)
        #return lista_conversion


     
    def factorial (self, numero):
        if(type(numero) != int):
            return 'El numero debe ser un entero'
        if(numero < 0):
            return 'El numero debe ser positivo'
        if (numero > 1):
            numero = numero * self.factorial(numero - 1)
        return numero
    
    def factorial_lista (self):
        for i in self.mi_lista:
            print("factorial de ", i, " --> ", self.factorial(i))