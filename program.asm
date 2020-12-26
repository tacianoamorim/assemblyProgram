.data
	fileNameIn: .asciiz "text.in" 
	fileNameOut: .asciiz "text.out"  
	
	fileWords: .word 
	
.text

	.globl main		# Chama a funcao principal

	main: # Funcao principal do programa

		# Parte para ler o arquivo
		li $v0, 13 #syscall pra abrir o arquivo com as strings pre-definidas
		la $a0,fileNameIn    #nome do arquivo
		li $a1,0 #marca pra leitura
		syscall #abri o arquivo
		move $s0, $v0 #salva a descrição do arquivo

		li $v0, 14 #syscall pra ler do arquivo
		move $a0, $s0 
		la $a1, fileWords
		li $a2, 100
		syscall

		li $v0, 4
		la $a0, fileWords
		syscall 

		li $v0, 16
		move $a0, $s0
		syscall

		# Parte para ler o arquivo
		li $v0, 13 #syscall pra abrir o arquivo com as strings pre-definidas
		la $a0,fileNameOut    #nome do arquivo
		li $a1,0 #marca pra leitura
		syscall #abri o arquivo
		move $s0, $v0 #salva a descrição do arquivo     

		li $v0, 16 #Escreve
		li $s0,10
		move $a0, $s0
		syscall    	


	openReadFile:			# Funcao para abrir o arquivo de leitura 
	
	
	loadReadFile:			# Funcao para Ler o arquivo	


	closeReadFile:			# Funcao para fechar o arquivo de leitura

	
	openWriteFile:			# Funcao para abrir o arquivo de escrita 

	
	loadWriteFile:			# Funcao para Ler o arquivo	


	closeWriteFile:			# Funcao para fechar o arquivo de escrita
