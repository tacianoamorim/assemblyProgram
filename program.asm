#------------------------------------------------------------------------------------
# ALUNOS: Gustavo Tabosa, João Teixeira, 
#	  Maurilio Medeiros, Taciano Amorim
#
#
# $t1 -> Caracter avaliado
# $t2 -> Indice do array do textoOriginal
# $t3 -> Quantidade de caracteres do texto
# $t4 -> Indice do array da palavra
# $t5 -> Quantidade de caracteres da palavra	
# $t6 -> Armazena o codigo do caracter #
#------------------------------------------------------------------------------------
.include "macros.asm"

.data
	arquivoEntrada: .asciiz "C:/fabrica/workspaceUFRPE/assemblyProgram/text.in" 
	arquivoSaida:   .asciiz "C:/fabrica/workspaceUFRPE/assemblyProgram/text.out"  
	
	textoFinal:	.space 71
	textoOriginal:	.space 71
		
.text

	move $t2, $zero # Zera o indice do array do textoOriginal
	li   $t3, 71    # Seta o tamanho de caracteres do textoOriginal
	
	#move $t4, $zero # Zera o indice do array do palavra
	#li   $t5, 10    # Seta o tamanho de caracteres do palavra	
	
	#li   $t6, 35    # Seta o codigo do caracter #

	print_str ("INICIANDO O PROCESSO\n")
		
	jal lerArquivoEntrada	# Le o conteudo do arquivo
			
		
	#----------------------------------------------------------------------------
	# LOOP que varre todo o texto lido, caracter por caracter 
	#----------------------------------------------------------------------------	
	loopTexto:
		# Verifica se o texto foi todo lido
		beq $t2, $t3, gravarArquivoSaida  # if $t2 == $t3
	
		# Recupera o caracter na posicao do indice
		lb $t1, textoOriginal($t2) # Pega o caracter da posicao

		# Verifica se $t1 tem um numero
		sge $s1, $t1, 47  	# IF $t1 > 47
		sle $s2, $t1, 58  	# IF $t1 < 58
		and $s3, $s1, $s2 	# $s3 = $s1 and $s2
		beq $s3, 1, gravarArquivoSaida 	
		
		# Caso $t1 seja uma letra minuscula
		sge $s1, $t1, 64 	# IF $t1 > 64
		sle $s2, $t1, 91  	# IF $t1 < 91 
		and $s3, $s1, $s2 	# $s3 = $s1 and $s2 		
		beq $s3, 1, maiusculo		

		# Caso $t1 seja uma letra maiuscula
		sge $s1, $t1, 96 	# IF $t1 > 96
		sle $s2, $t1, 123  	# IF $t1 < 123  
		and $s3, $s1, $s2 	# $s3 = $s1 and $s2   		
		beq $s3, 1, minusculo
		
		# Caso $t1 seja o caracter ç
		beq $t1, -89, cedilhaMinusculo	# Se $t1 armazena ç
		
		# Caso $t1 seja o caracter ã
		beq $t1, -93, letraAComTil	# Se $t1 armazena ã		
				
		j gravarCaracter # Não é nenhum caracter validado
		

	#----------------------------------------------------------------------------
	# ARMAZENA O CARACTER NA NOVA STRING 
	#----------------------------------------------------------------------------				
	gravarCaracter:
		# Grava o caracter na posicao do indice
		sb $t1, textoFinal($t2) # Grava o caracter na posicao do indice
				
		# Soma mais 1 ao indice
		addi $t2, $t2, 1 # $t2++
		
		j loopTexto
				

	#----------------------------------------------------------------------------
	# RETORNA A LETRA MAIUSCULA 
	#----------------------------------------------------------------------------
	maiusculo:
		add $t1, $t1, 32 # Converte para minusculo
		j gravarCaracter
		
		
	#----------------------------------------------------------------------------
	# RETORNA A LETRA MINUSCULA 
	#----------------------------------------------------------------------------
	minusculo:
		sub $t1, $t1, 32 # Converte para maiusculo
		j gravarCaracter	
	
	#-----------------------------------------------------------------------------
	# RETORNA A LETRA MAIUSCULA DO ç
	#-----------------------------------------------------------------------------	
	cedilhaMinusculo:
		li $t1, -121 # Converte para maiusculo
		j gravarCaracter
		

	#-----------------------------------------------------------------------------
	# RETORNA A LETRA MAIUSCULA DO ã
	#-----------------------------------------------------------------------------				
	letraAComTil:
		li $t1, -125 # Converte para maiusculo
		j gravarCaracter

	
	#----------------------------------------------------------------------------
	# LE CONTEUDO DO ARQRUIVO DE ENTRADA 
	# Retorna valor no registrador $v1
	#----------------------------------------------------------------------------	
	lerArquivoEntrada:	# Funcao para abrir o arquivo de leitura 
		print_str ("LENDO ARQUIVO \n")

		# Abre o arquivo
		li $v0, 13 			# syscall para abrir o arquivo 
		la $a0,arquivoEntrada    	# nome do arquivo
		li $a1,0 			# 0: leitura 1: escrita
		syscall 			
		
		move $s0, $v0 			# salva a descrição do arquivo

		# Ler o arquivo
		move $a0, $s0 
		li $v0, 14 			# syscall para ler do arquivo
		la $a1, textoOriginal		# transfere o buffer para textFile 	
		move $a2, $t3  			# tamanho maximo do buffer
		syscall
		
		move $v1, $a1

		# Fechar o arquivo
		li $v0, 16			# syscall para fechar o arquivo 
		move $a0, $s0
		syscall	
		
		jr $ra				# retorna para a  


	#----------------------------------------------------------------------------
	# GRAVAR CONTEUDO NO ARQRUIVO DE SAIDA 
	#----------------------------------------------------------------------------
	gravarArquivoSaida:		# Funcao para gravar o arquivo de leitura 
		
		print_str ("GRAVANDO ARQUIVO \n")
			
		# Abre o arquivo
		li $v0, 13 			# syscall para abrir o arquivo 
		la $a0,arquivoSaida 		# nome do arquivo
		li $a1,1 			# 0: leitura 1: escrita
		syscall 
		move $s1,$v0			
		
		# Escreve o arquivo
		li $v0, 15 			# syscall para escrever do arquivo
		move $a0,$s1
		
		la $a1, textoFinal		# transfere o buffer para textFile 	
		la $a2, 53  		# tamanho maximo do buffer
		syscall

		# fechar o arquivo
		li $v0, 16			# syscall para fechar o arquivo 
		move $a0, $s1
		syscall	
		
		j encerrarPrograma
	
	#----------------------------------------------------------------------------
	# ENCERRA O PROGRAMA 
	#----------------------------------------------------------------------------
	encerrarPrograma: 

		print_str ("PROCESSAMENTO FINALIZADO \n")
	
		li $v0, 10
		syscall 
