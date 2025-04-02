var btnAbrirPopu = document.getElementById('btn-abrir-popu'),
	overla = document.getElementById('overla'),
	popu = document.getElementById('popu'),
	btnCerrarPopu = document.getElementById('btn-cerrar-popu');

    
btnAbrirPopu.addEventListener('click', function(){
	overla.classList.add('active');
	popu.classList.add('active');
});

btnCerrarPopu.addEventListener('click', function(e){
	e.preventDefault();
	overla.classList.remove('active');
	popu.classList.remove('active');
});